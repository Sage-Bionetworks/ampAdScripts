require(synapseClient)
synapseLogin()

##query master table for emory files
#mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'mayo%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)



moveGeno <- function(i,a,newFileName,mayoTable){
  fileType <- strsplit(mayoTable@values$oldFileName[i],'\\.')[[1]][4]
  newFileName <- paste0(newFileName,'.',fileType)
  cat(newFileName,'\n')
  system(paste('cp ',a[[i]]@filePath,' ',newFileName,sep=''))
}

makeFile <- function(i,a,newEntityName,newFileName,mayoTable){
  mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'mayo Genotypes%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
  fileType <- strsplit(mayoTable@values$oldFileName[i],'\\.')[[1]][4]
  newFileName <- paste0(newFileName,'.',fileType)
  b <- File(newFileName,parentId=mayoTable@values$newParentId[i],name=paste0(newEntityName,'_',fileType))
  dataAnnotation <- list(
    dataType = 'DNA',
    disease = c('Alzheimers Disease','Control'),
    platform = 'Affymetrix Genechip 6.0',
    center = 'Rush-Broad',
    study = 'mayo',
    fileType = 'plink',
    organism = 'human'
  )
  synSetAnnotations(b) <- dataAnnotation
  act <- Activity(name='mayo Genotype Migration',
                  used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Rush-Broad/migratemayoGenotypesFeb2015.R"))
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
}

migrateGenotype <- function(){
  mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'mayo Genotypes%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
  synList <- sapply(mayoTable@values$originalSynapseId,synGet)
  newFileName <- 'AMP-AD_mayo_Rush-Broad_AffymetrixGenechip6'
  newEntityName <- 'mayo_Rush-Broad_AffymetrixGenechip6'
  sapply(1:nrow(mayoTable@values),moveGeno,synList,newFileName,mayoTable)
  sapply(1:nrow(mayoTable@values),makeFile,synList,newEntityName,newFileName,mayoTable)
}
migrateGenotype()
