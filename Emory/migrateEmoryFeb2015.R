#script to migrate emory preliminary data for February Results

#add annotations
#add provenance
#change file name to fit format:

#consortium_study_center_platform_other.extension

#consortium = AMP-AD
#study = Emory
#center = Emory
#platform = LTQOrbitrapXL
#extension = 7z, txt, fasta



extractFileType <- function(x){
  return(sapply(strsplit(x,'\\.'), function(x) x)[2,])
}


cleanEmoryClinical <- function(emoryClinical){
  #emoryClinical <- read.csv(x)
  colnames(emoryClinical) <- c('neuropathology','caseNumber','PMI','ageOfOnset','ageAtDeath','durationYr','apoe','race_sex','proteomicsMS')
  emoryClinical$PMI[grep("NA",emoryClinical$PMI)] <- NA
  race_sex <- emoryClinical$race_sex;
  race <- rep(NA,nrow(emoryClinical));
  sex <- rep(NA,nrow(emoryClinical));
  race[grep('a',race_sex)] <- 'Asian'
  race[grep('b',race_sex)] <- 'AfricanAmerican'
  race[grep('w',race_sex)] <- 'Caucasian'
  race[grep('h',race_sex)] <- 'Hispanic'
  sex[grep('w',race_sex)] <- 'Female'
  sex[grep('m',race_sex)] <- 'Male'
  emoryClinical <- data.frame(emoryClinical,race,sex)
  emoryClinical <- emoryClinical[,-8]
  emoryClinical$caseNumber <- gsub(' ','',emoryClinical$caseNumber)
  emoryClinical$proteomicsMS <- gsub(' ','',emoryClinical$proteomicsMS)
  emoryClinical$apoe <- gsub('/','E',emoryClinical$apoe)
  emoryClinical$neuropathology[grep('AD',emoryClinical$caseNumber)] <- 'AD'
  emoryClinical$neuropathology[grep('ADPD',emoryClinical$caseNumber)] <- 'ADPD'
  emoryClinical$neuropathology[grep('ALS',emoryClinical$caseNumber)] <- 'ALS'
  emoryClinical$neuropathology[grep('CBD',emoryClinical$caseNumber)] <- 'CBD'
  emoryClinical$neuropathology[grep('CONTROL',emoryClinical$caseNumber)] <- 'Control'
  emoryClinical$neuropathology[grep('FTDU',emoryClinical$caseNumber)] <- 'FTDU'
  emoryClinical$neuropathology[grep('MCI',emoryClinical$caseNumber)] <- 'MCI'
  emoryClinical$neuropathology[grep('PD',emoryClinical$caseNumber)] <- 'PD'
  return(emoryClinical)
}

cleanSpectralData <- function(a,newFileName){
  str <- paste('sed "s/;/,/g" ',a@filePath,' > ',newFileName,sep='')
  system(str)
}

migrateData <- function(i,emoryTable,fileTypes){
    require(gdata)
    a <- synGet(emoryTable@values$originalSynapseId[i])
    if(fileTypes[i]=='xlsx'){
      
      b <- read.xls(a@filePath)
      colnames(b) <- as.character(as.matrix(b)[1,])
      b <- b[-1,]
      b <- b[-nrow(b),]
      b <- cleanEmoryClinical(b)
      write.csv(b,file='AMP-AD_Emory_Emory_Covariates.csv',row.names=FALSE)
      b <- File('AMP-AD_Emory_Emory_Covariates.csv',parentId=emoryTable@values$newParentId[i],name='Emory_Emory_Covariates')
      
      clinicalAnnotation <- list(
        dataType = 'Covariates',
        tissueType = 'Medial Frontal Gyrus',
        center = 'Emory',
        study = 'Emory',
        fileType = 'csv',
        organism = 'human'
      )
      synSetAnnotations(b) <- clinicalAnnotation
      act <- Activity(name='Emory Covariate Reprocessing',used=list(list(entity=emoryTable@values$originalSynapseId[i],wasExecuted=F)),executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
      act <- storeEntity(act)
      generatedBy(b) <- act
      b <- synStore(b)
      
      #add provenance
      #add annotations
      #update migration table
      emoryTable@values$newSynapseId[i] <- b$properties$id
      wind <- is.na(emoryTable@values$newSynapseId)
      if(sum(wind)>0){
        emoryTable@values$newSynapseId[wind] <- ''
      }
      emoryTable@values$newFileName[i] <- b$properties$name
      emoryTable@values$isMigrated[i] <- TRUE
      emoryTable@values$hasAnnotation[i] <- TRUE
      emoryTable@values$hasProvenance[i] <- TRUE
      emoryTable <- synStore(emoryTable)
      
    }else if (fileTypes[i]=='7z'){
      poolType <- strsplit(strsplit(emoryTable@values$oldFileName[i],'Emory')[[1]][2],'Pools')[[1]][1]
      newFileName <- 'AMP-AD_Emory_Emory_LTQOrbitrapXL_'
      newFileName<-paste(newFileName,poolType,'.7z',sep='')
      newEntityName <- paste('Emory_Emory_LTQOrbitrapXL_',poolType,sep='')
      if (poolType == 'ADPD'){
       diseaseType <- 'Autosomal Dominant Parkinsons Disease'
      }else if (poolType == 'AD'){
        diseaseType <- 'Alzheimers Disease'
      }else if (poolType == 'ALS'){
        diseaseType <- 'Amyotrophic Lateral Sclerosis'
      }else if (poolType == 'CBD'){
        diseaseType <- 'Corticobasal Degeneration'
      }else if (poolType == 'CTL'){
        diseaseType <- 'Control'
      }else if (poolType == 'FTDU'){
        diseaseType <- 'Frontotemporal Dementia'        
      }else if (poolType == 'MCI'){
        diseaseType <- 'Mild Cognitive Impairment'
      }else if (poolType == 'PD'){
        diseaseType <- 'Parkinsons Disease'
      }
      
      #copy file to ??
      system(paste('cp ',a@filePath,' ',newFileName,sep=''))
      b <- File(paste('',newFileName,sep=''),parentId=emoryTable@values$newParentId[i],name=newEntityName)
      rawAnnotation <- list(
        dataType = 'Protein',
        disease = diseaseType,
        platform = 'LTQOrbitrapXL',
        tissueType = 'Medial Frontal Gyrus',
        center = 'Emory',
        study = 'Emory',
        fileType = '7z',
        organism = 'human'
      )
      synSetAnnotations(b) <- rawAnnotation
      act <- Activity(name='Emory Raw Data Migration',
                      used=list(list(entity=emoryTable@values$originalSynapseId[i],wasExecuted=F)),
                      executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
      act <- storeEntity(act)
      generatedBy(b) <- act
      b <- synStore(b)
      emoryTable@values$newSynapseId[i] <- b$properties$id
      wind <- is.na(emoryTable@values$newSynapseId)
      if(sum(wind)>0){
        emoryTable@values$newSynapseId[wind] <- ''
      }
      emoryTable@values$newFileName[i] <- b$properties$name
      emoryTable@values$isMigrated[i] <- TRUE
      emoryTable@values$hasAnnotation[i] <- TRUE
      emoryTable@values$hasProvenance[i] <- TRUE
      emoryTable <- synStore(emoryTable)  
      #add annotations
      #add provenance
      #update table
    }else if (fileTypes[i]=='txt'){
      if(length(grep('Protein',a@filePath))==1){
        newFileName <- 'AMP-AD_Emory_Emory_Protein.tsv'
        newEntityName <- 'Emory_Emory_Protein'
        system(paste('cp ',a@filePath,' ',newFileName,sep=''))
        b <- File(paste('',newFileName,sep=''),parentId=emoryTable@values$newParentId[i],name=newEntityName)
        processedAnnotation <- list(
          dataType = 'Protein',
          disease = c('Autosomal Dominant Parkinsons Disease','Alzheimers Disease','Amyotrophic Lateral Sclerosis','Corticobasal Degeneration','Control','Frontotemporal Dementia','Mild Cognitive Impairment','Parkinsons Disease'),
          platform = 'LTQOrbitrapXL',
          tissueType = 'Medial Frontal Gyrus',
          center = 'Emory',
          study = 'Emory',
          fileType = 'tsv',
          organism = 'human'
        )
        synSetAnnotations(b) <- processedAnnotation
        act <- Activity(name='Emory Processed Data Migration',
                        used=as.list(c(emoryTable@values$originalSynapseId[i],(emoryTable@values$originalSynapseId[grep('7z',emoryTable@values$oldFileName)]),(emoryTable@values$originalSynapseId[grep('fasta',emoryTable@values$oldFileName)]))),
                        executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
        act <- storeEntity(act)
        generatedBy(b) <- act
        b <- synStore(b)
        emoryTable@values$newSynapseId[i] <- b$properties$id
        wind <- is.na(emoryTable@values$newSynapseId)
        if(sum(wind)>0){
          emoryTable@values$newSynapseId[wind] <- ''
        }
        emoryTable@values$newFileName[i] <- b$properties$name
        emoryTable@values$isMigrated[i] <- TRUE
        emoryTable@values$hasAnnotation[i] <- TRUE
        emoryTable@values$hasProvenance[i] <- TRUE
        emoryTable <- synStore(emoryTable)  
      }else if (length(grep('Spectral',a@filePath))==1){
        newFileName <- 'AMP-AD_Emory_Emory_SpectralIdentification.csv'
        newEntityName <- 'Emory_Emory_SpectralIdentification'
        cleanSpectralData(a,newFileName)
        b <- File(paste('',newFileName,sep=''),parentId=emoryTable@values$newParentId[i],name=newEntityName)
        processedAnnotation <- list(
          dataType = 'Protein',
          disease = c('Autosomal Dominant Parkinsons Disease','Alzheimers Disease','Amyotrophic Lateral Sclerosis','Corticobasal Degeneration','Control','Frontotemporal Dementia','Mild Cognitive Impairment','Parkinsons Disease'),
          platform = 'LTQOrbitrapXL',
          tissueType = 'Medial Frontal Gyrus',
          center = 'Emory',
          study = 'Emory',
          fileType = 'csv',
          organism = 'human'
        )
        synSetAnnotations(b) <- processedAnnotation
        act <- Activity(name='Emory Processed Data Migration',
                        used=as.list(c(emoryTable@values$originalSynapseId[i],(emoryTable@values$originalSynapseId[grep('7z',emoryTable@values$oldFileName)]),(emoryTable@values$originalSynapseId[grep('fasta',emoryTable@values$oldFileName)]))),
                        executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
        act <- storeEntity(act)
        generatedBy(b) <- act
        b <- synStore(b)
        emoryTable@values$newSynapseId[i] <- b$properties$id
        emoryTable@values$newFileName[i] <- b$properties$name
        emoryTable@values$isMigrated[i] <- TRUE
        emoryTable@values$hasAnnotation[i] <- TRUE
        emoryTable@values$hasProvenance[i] <- TRUE
        emoryTable <- synStore(emoryTable)  
      } else {
        stop('error\n')
      }
      
    }else if (fileTypes[i]=='fasta'){
      newFileName <- 'AMP-AD_Emory_Emory_RefSeq.fasta'
      newEntityName <- 'Emory_Emory_RefSeq'
      system(paste('cp ',a@filePath,' ',newFileName,sep=''))
      b <- File(paste('',newFileName,sep=''),parentId=emoryTable@values$newParentId[i],name=newEntityName)
      refAnnotation <- list(
        dataType = 'referenceData',
        fileType = 'fasta',
        organism = 'human'
      )
      synSetAnnotations(b) <- refAnnotation
      act <- Activity(name='Emory Reference Data Migration',
                      used=list(list(entity=emoryTable@values$originalSynapseId[i],wasExecuted=F)),
                      executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
      act <- storeEntity(act)
      generatedBy(b) <- act
      b <- synStore(b)
      emoryTable@values$newSynapseId[i] <- b$properties$id
      wind <- is.na(emoryTable@values$newSynapseId)
      if(sum(wind)>0){
        emoryTable@values$newSynapseId[wind] <- ''
      }
      emoryTable@values$newFileName[i] <- b$properties$name
      emoryTable@values$isMigrated[i] <- TRUE
      emoryTable@values$hasAnnotation[i] <- TRUE
      emoryTable@values$hasProvenance[i] <- TRUE
      emoryTable <- synStore(emoryTable)  
    } else{
      stop('error\n')
    }
}

require(synapseClient)
synapseLogin()
emoryTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'Emory%\'',loadResult = TRUE)
fileTypes <- extractFileType(emoryTable@values$oldFileName)

for (i in 1:nrow(emoryTable@values)){
  migrateData(i,emoryTable,fileTypes)
  emoryTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'Emory%\'',loadResult = TRUE)
}
#i <- 1
#migrateData(i,emoryTable,fileTypes)
#emoryTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'Emory%\'',loadResult = TRUE)


