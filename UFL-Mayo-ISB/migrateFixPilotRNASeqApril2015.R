###script to update migration table for errors in Mayo data
require(synapseClient)
synapseLogin()


migrateMayoRNAseqUpdate <- function(i){
  mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'Mayo%RNAseq\' and migrator=\'Ben\' and toBeMigrated=TRUE and isMigrated=FALSE',loadResult = TRUE)
  testSyn <- synGet(mayoTable@values$originalSynapseId[i])
  synName <- synGetProperties(testSyn)$name
  
  #define disease
  if(length(grep('Progressive',synName))>0){
    disease <- 'Progressive Supranuclear Palsy'
  }else{
    disease <- 'Alzheimers Disease'
  }
  
  #rename if transposed
  if(length(grep('Transposed',synName))>0){
    synName <- gsub('Transposed_','',synName)  
  }
  
  #define other and fileType
  if(length(grep('Covariates',synName))>0){
    fileType='csv'
    dataType='Covariates'
    other=NULL
    
  }else{
    dataType='mRNA'
    fileType='tsv'
    if(length(grep('gene',synName,ignore.case=T))>0){
      if(length(grep('gene_id_counts',synName))>0){
        synName <- gsub('gene_id_counts','GeneCounts',synName)
      }
      if(length(grep('normalized',synName,ignore.case=T))>0){
        if(length(grep('normalized',synName))>0){
          synName <- gsub('normalized','Normalized',synName)
        }
        other=c('geneCounts','Normalized')
      }else{
        other=c('geneCounts','Unnormalized')
      }
      
    }else{
      if(length(grep('transcript_id_counts',synName))>0){
        synName <- gsub('transcript_id_counts','TranscriptCounts',synName)
      }
      if(length(grep('normalized',synName,ignore.case=T))>0){
        other=c('transcriptCounts','Normalized')
      }else{
        other=c('transcriptCounts','Unnormalized')
      }      
    }
  }
  
  dataAnnotation <- list(
    dataType = dataType,
    disease = disease,
    tissueType = 'Temporal Cortex',
    platform= 'IlluminaHiSeq2000',
    center = 'UFL-Mayo-ISB',
    study = 'MayoPilot',
    fileType = fileType,
    organism = 'Homo sapiens',
    other = other
  )
  
  fileName <- synName;
  entityName <- strsplit(fileName,'\\.')[[1]][1]
  
  print(dataAnnotation)
  print(fileName)
  print(entityName)
  
  system(paste('cp ',testSyn@filePath,' ',fileName,sep=''))
  
  b <- File(fileName,parentId=mayoTable@values$newParentId[i],name=entityName)
  synSetAnnotations(b) <- dataAnnotation
  
  act <- Activity(name='Mayo Pilot RNAseq Data Migration',
                  used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateFixPilotRNASeqApril2015.R"))
  act <- storeEntity(act)
  generatedBy(b) <- act
  b <- synStore(b)
  
  mayoTable@values$newSynapseId[i] <- b$properties$id
  wind <- is.na(mayoTable@values$newSynapseId)
  if(sum(wind)>0){
    mayoTable@values$newSynapseId[wind] <- ''
  }
  mayoTable@values$newFileName[i] <- ''
  #mayoTable@values$isMigrated[i] <- TRUE
  mayoTable@values$hasAnnotation[i] <- TRUE
  mayoTable@values$hasProvenance[i] <- TRUE
  mayoTable <- synStore(mayoTable)
  system(paste0('rm ',fileName))  
  
}

require(dplyr)

sapply(1:10,migrateMayoRNAseqUpdate)