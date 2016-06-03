library(synapseClient)
synapseLogin()

library(xlsx)
masterFile <- 'syn5475828'

#master file
#list of all RNAseq bams
  #internal
  #external
#list of all WES bams
  #internal
  #external
require(dplyr)
foo <- synGet(masterFile)
masterManifest <- read.xlsx(foo@filePath,sheetName = 'Fnl-Colms',stringsAsFactors=F)
navec <- rowSums(is.na(masterManifest))
masterManifest <- masterManifest[navec<23,]
View(masterManifest)

colnames(masterManifest)

#make clinical file
clinicalFile <- select(masterManifest,BB,PMI,RACE,AOD,CDR,SEX,NP.1,PlaqueMean,bbscore)
colnames(clinicalFile)[1] <- 'individualIdentifier'

write.csv(clinicalFile,file='MSBB_clinical.csv',quote=F,row.names=F)

fooObj1 <- File('MSBB_clinical.csv',parentId='syn6100546')
synSetAnnotations(fooObj1) <- list(fileType='csv',
                                   study='MSBB',
                                   center='MSSM',
                                   dataType='covariates',
                                   consortium='AMP-AD',
                                   organism='HomoSapiens')

fooObj1 <- synStore(fooObj1,
                    used=as.list(c('syn5475828')),
                    executed=as.list('https://github.com/Sage-Bionetworks/ampAdScripts/blob/2cc627e67d63c2c167083a5a1783dfed27977110/Mount-Sinai/cleanUpClinical.R'))


#rnaseq files
fooPublicBam <- synQuery('select name,id from file where projectId==\'syn2580853\' and fileType==\'bam\' and study==\'MSBB\' and assay==\'RNAseq\'')
fooPublicFastq <- synQuery('select name,id from file where projectId==\'syn2580853\' and fileType==\'fastq\' and study==\'MSBB\' and assay==\'RNAseq\'')
fooPrivate <- synQuery('select name,id from file where parentId==\'syn5845477\'')
fooAll <- rbind(fooPublicBam,fooPublicFastq,fooPrivate)

pullOffIdentifier <- function(x){
  return(strsplit(x,'\\.')[[1]][1])
}

fooAll <- mutate(fooAll,sampleIdentifier=sapply(fooAll$file.name,pullOffIdentifier))

oldIdsIdx <- grep('^B',fooAll$sampleIdentifier)
newIdsIdx <- setdiff(1:nrow(fooAll),oldIdsIdx)

pullOffBrodmann <- function(x){
  bar1 <- strsplit(x,'_')[[1]]
  if(bar1[[1]][1]=='B22'){
    return('BM22')
  }else if (bar1[[1]][1]=='hB'){
    return(NA)
  }else{
    bar2 <- paste0(bar1[1],bar1[2])
    return(bar2)
  }
}

fooAll <- mutate(fooAll,BM = sapply(fooAll$sampleIdentifier,pullOffBrodmann))
fooAll[1:20,]
fooAll$newIdentifier <- is.na(fooAll$BM)
#get barcodes
makeBarcode <- function(sampleId,newIdentifier){
  if(newIdentifier){
    return(strsplit(sampleId,'_')[[1]][3])
  }else{
    foo <- strsplit(sampleId,'_')[[1]]
    if(foo[1]=='B22'){
      return(foo[2])
    }else{
      return(foo[3])
    }
  }
}

fooAll <- mutate(fooAll,barcode=mapply(makeBarcode,sampleIdentifier,newIdentifier))

#add file types
bar <- grep('.bam',fooAll$file.name)
length(bar)
fooAll$fileType = rep('fastq',nrow(fooAll))
fooAll$fileType[bar] <- 'bam'

#merge on masterTable to identify which brodman regions are missing for 

#function that gets BB id for each sample

getNewBB <- function(sampleIdentifier,BM,newIdentifier,masterManifest){
  if(newIdentifier){
    testOut <- filter(masterManifest,New...BM.36.Barcode==sampleIdentifier|New...BM.22.Barcode==sampleIdentifier|New...BM.10.Barcode==sampleIdentifier|BM.44.Barcode==sampleIdentifier) %>%
      select(BB) %>%
      as.numeric
    if(length(testOut)>0){
      return(testOut)
    }else{
      return(NA)
    }
  }else{
    if(BM=='BM10'){
      testOut <- filter(masterManifest,Original.BM.10.Barcode==sampleIdentifier) %>%
        select(BB) %>%
        as.numeric     
    if(length(testOut)>0){
        return(testOut)
      }else{
        return(NA)
      }    
    }else if (BM=='BM22'){
      testOut <- filter(masterManifest,Original.BM.22.Barcode==sampleIdentifier) %>%
        select(BB) %>%
        as.numeric       
    if(length(testOut)>0){
        return(testOut)
      }else{
        return(NA)
      }
    }else if (BM=='BM36'){
      testOut<- filter(masterManifest,Original.BM.36.Barcode==sampleIdentifier) %>%
      select(BB) %>%
      as.numeric     
      if(length(testOut)>0){
        return(testOut)
      }else{
        return(NA)
      }
    }
  } 
}

getNewBM <- function(barcode,newIdentifier,masterManifest){
  if(newIdentifier){
    if(sum(masterManifest$New...BM.36.Barcode==barcode,na.rm=T)>0){
      return('BM36')
    }else if (sum(masterManifest$New...BM.10.Barcode==barcode,na.rm=T)>0){
      return('BM10')
    } else if (sum(masterManifest$New...BM.22.Barcode==barcode,na.rm=T)>0){
      return('BM22')
    } else if (sum(masterManifest$BM.44.Barcode==barcode,na.rm=T)>0){
      return("BM44")
    }
  }else{
    return(NA)
  }
}


fooAll <- mutate(fooAll,BB=mapply(getNewBB,barcode,BM,newIdentifier,MoreArgs=list(masterManifest=masterManifest)))
fooAll <- mutate(fooAll,BM2=mapply(getNewBM,barcode,newIdentifier,MoreArgs = list(masterManifest=masterManifest)))
fooAll$BM[fooAll$newIdentifier]<- fooAll$BM2[fooAll$newIdentifier]

fooAll <- select(fooAll,-BM2)

fooAll <- arrange(fooAll,BB)

#integrate RIN and batch

rinObj <- synGet('syn5898489')


library(data.table)
rinBatch <- fread(rinObj@filePath,data.table=F)
grep('B22',fooAll$sampleIdentifier)

b22_substitution <- function(x){
  if(length(grep('B22',x))>0){
    return(gsub('B22','BM_22',x))
  }else{
    return(x)
  }
}

#bar22 <- sapply(fooAll$sampleIdentifier,b22_substitution)

#fix identifiers

fooAll <- mutate(fooAll,sampleIdentifierCorrected=sapply(sampleIdentifier,b22_substitution))

fooAllCombined <- merge(fooAll,rinBatch,by.x='sampleIdentifierCorrected',by.y='LibID',all = T)

bm_preferred_id <- function(x,y,z,bmref){
  #x: brodmann
  #y: barcode
  #z: reference barcode
  if(x==bmref & y%in%z){
    return(TRUE)
  }else {
    return(FALSE)
  }
}

#test11 <- mapply(bm36_preferred_id,fooAllCombined$BM,fooAllCombined$barcode,MoreArgs = list(z=masterManifest$BM36.Fnl))

bm10pref <- mapply(bm_preferred_id,fooAllCombined$BM,fooAllCombined$barcode,MoreArgs = list(z=masterManifest$BM10.Fnl,bmref='BM10'))
bm22pref <- mapply(bm_preferred_id,fooAllCombined$BM,fooAllCombined$barcode,MoreArgs = list(z=masterManifest$BM22.Fnl,bmref='BM22'))
bm36pref <- mapply(bm_preferred_id,fooAllCombined$BM,fooAllCombined$barcode,MoreArgs = list(z=masterManifest$BM36.Fnl,bmref='BM36'))
bm44pref <- fooAllCombined$BM=='BM44'

fooAllCombined$preferredSample <- bm10pref | bm22pref | bm36pref | bm44pref

colnames(fooAllCombined) <- c('sampleIdentifier','fileName','synapseId','sampleIdentifierOld','BrodmannArea','newIdentifier','barcode','fileType','individualIdentifier','batch','newBarcode','RIN','preferredSample')

fooFinal <- select(fooAllCombined,-sampleIdentifierOld,-newIdentifier,-newBarcode)
View(fooFinal)

#write.csv(fooFinal,file='MSBB_RNAseq_covariates.csv',quote=F,row.names=F)
write.csv(fooFinal,file='MSBB_RNAseq_covariates.csv',quote=F,row.names=F)

#fooObj1 <- File('MSBB_RNAseq_covariates.csv',parentId='syn6100546')
fooObj1 <- synGet('syn6100548')
synSetAnnotations(fooObj1) <- list(fileType='csv',
                                   study='MSBB',
                                   center='MSSM',
                                   dataType='covariates',
                                   consortium='AMP-AD',
                                   organism='HomoSapiens')

fooObj1 <- synStore(fooObj1,
                    used=as.list(c('syn5475828','syn5898489')),
                    executed=as.list('https://github.com/Sage-Bionetworks/ampAdScripts/blob/7b9f40eb29b8bb3129194559da384ce6623b93d2/Mount-Sinai/cleanUpClinical.R'))


#issues: 
#duplicated file names
#missing brain bank ids

#protoemics
library(synapseClient)
synapseLogin()
proteomeQuery <- synQuery('select name,id from file where parentId==\'syn6038797\'')

#issues: prtoeomics identifiers do not match, need to verify mapping to brainBank identifiers

#wes

wesQuery1 <- synQuery('select name,id from file where parentId==\'syn5519740\'')
wesQuery2 <- synQuery('select name,id from file where parentId==\'syn5012301\'')
wesQuery3 <- synQuery('select name,id from file where parentId==\'syn5511621\'')

wesQuery <- rbind(wesQuery1,wesQuery2,wesQuery3)
wesQuery <- mutate(wesQuery,sampleIdentifier=sapply(wesQuery$file.name,pullOffIdentifier))

pullOffBarcode <- function(x){
  return(strsplit(x,'_')[[1]][3])
}

wesQuery <- mutate(wesQuery,barcode = sapply(wesQuery$sampleIdentifier,pullOffBarcode))
masterWES <- select(masterManifest,BB,DNA.Barcode,DNA.Region)

wesMatrix <- merge(wesQuery,masterWES,by.x='barcode',by.y='DNA.Barcode',all = TRUE)
wesMatrix <- select(wesMatrix, sampleIdentifier,file.name,file.id,barcode,BB,DNA.Region)
wesMatrix[1:5,]

colnames(wesMatrix) <- c('sampleIdentifier','fileName','synapseId','barcode','individualIdentifier','BrodmannArea')
write.csv(wesMatrix,file='MSBB_WES_covariates.csv',quote=F,row.names=F)

fooObj1 <- File('MSBB_WES_covariates.csv',parentId='syn6100546')
synSetAnnotations(fooObj1) <- list(fileType='csv',
                                   study='MSBB',
                                   center='MSSM',
                                   dataType='covariates',
                                   consortium='AMP-AD',
                                   organism='HomoSapiens')

fooObj1 <- synStore(fooObj1,
                    used=as.list(c('syn5475828')),
                    executed=as.list('https://github.com/Sage-Bionetworks/ampAdScripts/blob/2cc627e67d63c2c167083a5a1783dfed27977110/Mount-Sinai/cleanUpClinical.R'))



#####additional duplication stuff
duplicateFiles <- fooFinal$fileName[duplicated(fooFinal$fileName)]
duplicateMatrix <- filter(fooFinal,fileName%in%duplicateFiles) %>% arrange(fileName)


write.csv(duplicateMatrix,file='MSBB_RNAseq_duplicates.csv',quote=F,row.names=F)

fooObj1 <- File('MSBB_RNAseq_duplicates.csv',parentId='syn6100546')
synSetAnnotations(fooObj1) <- list(fileType='csv',
                                   study='MSBB',
                                   center='MSSM',
                                   dataType='covariates',
                                   consortium='AMP-AD',
                                   organism='HomoSapiens')

fooObj1 <- synStore(fooObj1,
                    used=as.list(c('syn6100548')),
                    executed=as.list('https://github.com/Sage-Bionetworks/ampAdScripts/blob/2cc627e67d63c2c167083a5a1783dfed27977110/Mount-Sinai/cleanUpClinical.R'))


sapply(duplicateMatrix$synapseId[1:4],onWeb)
fooRnaseq <- fread('~/Desktop/MSBB_RNAseq_covariates_May2016.csv',data.table=F)

fooRnaseq <- dplyr::select(fooRnaseq,synapseId,TotalReads,Mapped,rRNA.rate)
fooAllNew <- merge(fooFinal,fooRnaseq,by='synapseId')
fooAllNew <- select(fooAllNew,-preferredSample)
write.csv(fooFinal,file='MSBB_RNAseq_covariates.csv',quote=F,row.names=F)
