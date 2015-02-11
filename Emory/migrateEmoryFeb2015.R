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

require(synapseClient)
synapseLogin()

##query master table for emory files
emoryTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'Emory%\'',loadResult = TRUE)

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


migrateData <- function(i,emoryTable,fileTypes){
    require(gdata)
    a <- synGet(emoryTable@values$originalSynapseId[i])
    if(fileTypes[i]=='xlsx'){
      
      b <- read.xls(a@filePath)
      colnames(b) <- as.character(as.matrix(b)[1,])
      b <- b[-1,]
      b <- b[-nrow(b),]
      b <- cleanEmoryClinical(b)
      write.csv(b,file='~/AMP-AD_Emory_Emory_Clinical.csv',row.names=FALSE)
      b <- File('~/AMP-AD_Emory_Emory_Clinical.csv',parentId=emoryTable@values$newParentId[i],name='Emory_Emory_Clinical')
      
      clinicalAnnotation <- list(
        dataType = 'metaData',
        tissueType = 'Medial Frontal Gyrus',
        center = 'Emory',
        study = 'Emory',
        fileType = 'csv',
        organism = 'human'
      )
      synSetAnnotations(b) <- clinicalAnnotation
      act <- Activity(name='Emory Clinical Reprocessing',used=list(list(entity=emoryTable@values$originalSynapseId[i],wasExecuted=F)),executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
      act <- storeEntity(act)
      generatedBy(b) <- act
      b <- synStore(b)
      
      #add provenance
      #add annotations
      #update migration table
      emoryTable@values$newSynapseId[i] <- b$properties$id
      emoryTable@values$newFileName[i] <- b$properties$name
      emoryTable@values$isMigrated[i] <- TRUE
      emoryTable@values$hasAnnotation[i] <- TRUE
      emoryTable@values$hasProvenance[i] <- TRUE
      emoryTable <- synStore(emoryTable)
      
    }else if (fileTypes[i]=='7z'){
      poolType <- strsplit(strsplit(emoryTable@values$oldFileName[i],'Emory')[[1]][2],'Pools')[[1]][1]
      newFileName <- 'AMP-AD_Emory_Emory_LTQOrbitrapXL_'
      newFileName<-paste(newFileName,poolType,'.7z',sep='')
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
      system(paste('cp ',a@filePath,' ~/',newFileName,sep=''))
      b <- File(paste('~/',newFileName,sep=''),parentId=emoryTable@values$newParentId[i])
      rawAnnotation <- list(
        dataType = 'metaData',
        disease = diseaseType,
        platform = 'LTQOrbitrapXL'
        tissueType = 'Medial Frontal Gyrus',
        center = 'Emory',
        study = 'Emory',
        fileType = '7z'
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
      emoryTable@values$newFileName[i] <- b$properties$name
      emoryTable@values$isMigrated[i] <- TRUE
      emoryTable@values$hasAnnotation[i] <- TRUE
      emoryTable@values$hasProvenance[i] <- TRUE
      emoryTable <- synStore(emoryTable)  
      #add annotations
      #add provenance
      #update table
    }else if (fileTypes[i]=='txt'){
      
    }else if (fileTypes[i]=='fasta'){
      
    } else{
      
    }
}
fileTypes <- extractFileType(emoryTable@values$oldFileName)
for (i in 1:nrow(emoryTable@values)){
  #
  
}


#download the data
#grabAllEmoryData <- sapply(as.character(emoryTable@values$originalSynapseId),synGet)

#define new names for each new file


#define annotations for each file
#define provenance for each file
#create new file
#upload file to new location with provenance
#update progress table with new parentid, new name, provenance, etc...

####SCRATCH
#clinical <- synGet(emoryTable@values$originalSynapseId[12])
#str <- paste('cp ',clinical@filePath,' ~/')
#system(str)

#clean up clinical file done
  #write function to clean up clinical file done
    #rename columns done
    #fix NAs done
    #split race and sex column into two columns done
    #fill in neuropath information done
    #replace '/' with E in apoe done
    #remove spaces from caseNumber and proteomicsMS done


  
emoryClinicalClean <- cleanEmoryClinical()
write.csv(emoryClinicalClean,file='Emory//processedEmoryPreliminaryClinical.csv',row.names=FALSE,quote=FALSE)

#move clinical to Table in staging

#tcresult<-as.tableColumns(emoryClinicalClean)
#cols<-tcresult$tableColumns
#fileHandleId<-tcresult$fileHandleId

#projectId<-'syn2580853'
#need to add appropriate acl!
#schema<-TableSchema(name="AMPAD_Emory_Emory_Clinical", parent=projectId, columns=cols)
#table<-Table(schema, fileHandleId)
#table<-synStore(table, retrieveData=TRUE)


  #change file name
  #add provenance
  #add annotations

#move clinical to csv in staging


####move raw count files


####move refseq mapped files


####move reference genome file

