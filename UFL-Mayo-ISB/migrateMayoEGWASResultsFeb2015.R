require(synapseClient)
synapseLogin()

##query master table for emory files
#mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'mayo%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)

moveGeno <- function(i,a,newFileName,mayoTable){
  fileType <- strsplit(mayoTable@values$oldFileName[i],'\\.')[[1]][1]
  newFileName <- paste0(newFileName,'_',fileType,'.gz')
  cat(newFileName,'\n')
  system(paste('cp ',a[[i]]@filePath,' ',newFileName,sep=''))
}

makeFile <- function(i,a,newEntityName,newFileName,mayoTable){
  mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'MayoCC Genotype%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
  fileType <- strsplit(mayoTable@values$oldFileName[i],'\\.')[[1]][1]
  newFileName <- paste0(newFileName,'_',fileType,'.gz')
  b <- File(newFileName,parentId=mayoTable@values$newParentId[i],name=paste0(newEntityName,'_',fileType))
  foo <- strsplit(mayoTable@values$oldFileName[i],'_')[[1]]
  if(foo[1]=='HapMap2'){
    dataSubType <- 'imputedGenotypes'
  } else {
    dataSubType <- 'Genotypes'
  }
  if (foo[2]=='CER'){
    tissueType <- 'Cerebellum'
  } else{
    tissueType <- 'Temporal Cortex'
  }
  if (foo[3]=='AD.txt.gz'){
    disease <- 'Alzheimers Disease'
  } else if (foo[3]=='Control.txt.gz'){
    disease <- 'Control'
  } else {
    disease <- c('Alzheimers Disease', 'Control')
  }
  
  dataAnnotation <- list(
    dataType = 'Analysis',
    disease = disease,
    dataSubType = dataSubType,
    tissueType = tissueType,
    center = 'UFL-Mayo-ISB',
    study = 'MayoEGWAS',
    fileType = 'tsv',
    organism = 'human'
  )
  synSetAnnotations(b) <- dataAnnotation
  act <- Activity(name='Mayo EGWAS Results Migration',
                  used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateMayoEGWASResultsFeb2015.R"))
  act <- storeEntity(act)
  generatedBy(b) <- act
  b <- synStore(b)
  mayoTable@values$newSynapseId[i] <- b$properties$id
  wind <- is.na(mayoTable@values$newSynapseId)
  if(sum(wind)>0){
    mayoTable@values$newSynapseId[wind] <- ''
  }
  mayoTable@values$newFileName[i] <- newFileName
  mayoTable@values$isMigrated[i] <- TRUE
  mayoTable@values$hasAnnotation[i] <- TRUE
  mayoTable@values$hasProvenance[i] <- TRUE
  mayoTable <- synStore(mayoTable) 
  system(paste0('rm ',newFileName))
}

migrateEGWASResults <- function(){
  mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'MayoCC Expression GWAS%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
  synList <- sapply(mayoTable@values$originalSynapseId,synGet)
  newFileName <- 'AMP-AD_MayoEGWAS_UFL-Mayo-ISB_Results'
  newEntityName <- 'MayoEGWAS_UFL-Mayo-ISB_Results'
  sapply(1:12,moveGeno,synList,newFileName,mayoTable)
  sapply(1:12,makeFile,synList,newEntityName,newFileName,mayoTable)
}
migrateEGWASResults()



