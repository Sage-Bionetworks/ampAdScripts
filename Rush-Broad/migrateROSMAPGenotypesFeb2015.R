require(synapseClient)
synapseLogin()

##query master table for emory files
#rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)



moveGeno <- function(i,a,newFileName,rosmapTable){
  fileType <- strsplit(rosmapTable@values$oldFileName[i],'\\.')[[1]][4]
  newFileName <- paste0(newFileName,'.',fileType)
  cat(newFileName,'\n')
  system(paste('cp ',a[[i]]@filePath,' ',newFileName,sep=''))
}

makeFile <- function(i,a,newEntityName,newFileName,rosmapTable){
  fileType <- strsplit(rosmapTable@values$oldFileName[i],'\\.')[[1]][4]
  newFileName <- paste0(newFileName,'.',fileType)
  b <- File(newFileName,parentId=rosmapTable@values$newParentId[i],name=paste0(newEntityName,'_',fileType))
  dataAnnotation <- list(
    dataType = 'DNA',
    disease = c('Alzheimers Disease','Control'),
    platform = 'Affymetrix Genechip 6.0',
    center = 'Rush-Broad',
    study = 'ROSMAP',
    fileType = 'plink',
    organism = 'human'
  )
  synSetAnnotations(b) <- dataAnnotation
  act <- Activity(name='ROSMAP Genotype Migration',
                  used=list(list(entity=rosmapTable@values$originalSynapseId[i],wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Rush-Broad/migrateROSMAPGenotypesFeb2015.R"))
  act <- storeEntity(act)
  generatedBy(b) <- act
  b <- synStore(b)
  rosmapTable@values$newSynapseId[i] <- b$properties$id
  wind <- is.na(rosmapTable@values$newSynapseId)
  if(sum(wind)>0){
    rosmapTable@values$newSynapseId[wind] <- ''
  }
  rosmapTable@values$newFileName[i] <- b$properties$name
  rosmapTable@values$isMigrated[i] <- TRUE
  rosmapTable@values$hasAnnotation[i] <- TRUE
  rosmapTable@values$hasProvenance[i] <- TRUE
  rosmapTable <- synStore(rosmapTable) 
}

migrateGenotype <- function(){
  rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP Genotypes%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
  synList <- sapply(rosmapTable@values$originalSynapseId,synGet)
  newFileName <- 'AMP-AD_ROSMAP_Rush-Broad_AffymetrixGenechip6'
  newEntityName <- 'ROSMAP_Rush-Broad_AffymetrixGenechip6'
  sapply(1:nrow(rosmapTable),moveGeno,synList,newFileName,rosmapTable)
  sapply(1:nrow(rosmapTable),makeFile,synList,newEntityName,newFileName,rosmapTable)
}
