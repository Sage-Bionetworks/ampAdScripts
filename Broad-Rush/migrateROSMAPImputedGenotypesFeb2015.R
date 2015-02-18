require(synapseClient)
synapseLogin()

moveGeno <- function(i,a,newFileName,rosmapTable){
  foo <- strsplit(rosmapTable@values$oldFileName[i],'\\.')[[1]]
  fileType <- foo[length(foo)]
  if (fileType=='gz'){
    newFileName <- paste0(newFileName,'_',foo[1],'_Group',foo[3],'.',fileType)
    cat(newFileName,'\n')
    system(paste('cp ',a[[i]]@filePath,' ',newFileName,sep=''))    
  } else if (fileType=='fam'){
    newFileName <- paste0(newFileName,'_Group',strsplit(foo[[1]],'list')[[1]][2],'.',fileType)
    cat(newFileName,'\n')
    system(paste('cp ',a[[i]]@filePath,' ',newFileName,sep=''))    
  } else if (fileType=='backup'){
    newFileName <- paste0(newFileName,'.fam')
    cat(newFileName,'\n')
    system(paste('cp ',a[[i]]@filePath,' ',newFileName,sep=''))    
  }
}

makeFile <- function(i,newEntityName,newFileName,rosmapTable){
  rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP Imputed Genotypes%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
  foo <- strsplit(rosmapTable@values$oldFileName[i],'\\.')[[1]]
  fileType <- foo[length(foo)]
  if(fileType == 'gz'){
    newFileName <- paste0(newFileName,'_',foo[1],'_Group',foo[3],'.',fileType)
    b <- File(newFileName,parentId=rosmapTable@values$newParentId[i],name=paste0(newEntityName,'_',foo[1],'_Group',foo[3],'_',fileType))
    dataAnnotation <- list(
      dataType = 'DNA',
      dataSubType = 'Imputed Genotype'
      disease = c('Alzheimers Disease','Control'),
      platform = 'Affymetrix Genechip 6.0',
      center = 'Broad-Rush',
      study = 'ROSMAP',
      fileType = 'tsv',
      organism = 'human',
      imputationReference = 'HapMap3'
    )
    synSetAnnotations(b) <- dataAnnotation
    act <- Activity(name='ROSMAP Imputed Genotype Migration',
                    used=list(list(entity=rosmapTable@values$originalSynapseId[i],wasExecuted=F)),
                    executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Broad-Rush/migrateROSMAPImputedGenotypesFeb2015.R"))
    act <- storeEntity(act)
    generatedBy(b) <- act
    b <- synStore(b)
    rosmapTable@values$newSynapseId[i] <- b$properties$id
    wind <- is.na(rosmapTable@values$newSynapseId)
    if(sum(wind)>0){
      rosmapTable@values$newSynapseId[wind] <- ''
    }
    rosmapTable@values$newFileName[i] <- newFileName
    rosmapTable@values$isMigrated[i] <- TRUE
    rosmapTable@values$hasAnnotation[i] <- TRUE
    rosmapTable@values$hasProvenance[i] <- TRUE
    rosmapTable <- synStore(rosmapTable)   
    system(paste0('rm ',newFileName))
  }else if (fileType=='backup'){
    newFileName <- paste0(newFileName,'.fam')
    b <- File(newFileName,parentId=rosmapTable@values$newParentId[i],name=paste0(newEntityName,'_fam'))
    dataAnnotation <- list(
      dataType = 'DNA',
      disease = c('Alzheimers Disease','Control'),
      platform = 'Affymetrix Genechip 6.0',
      center = 'Rush-Broad',
      study = 'ROSMAP',
      fileType = 'fam',
      organism = 'human',
      dataSubType = 'imputedGenotypes',
      imputationReference = 'HapMap3'      
    )
    synSetAnnotations(b) <- dataAnnotation
    act <- Activity(name='ROSMAP Imputed Genotype Migration',
                    used=list(list(entity=rosmapTable@values$originalSynapseId[i],wasExecuted=F)),
                    executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Rush-Broad/migrateROSMAPImputedGenotypesFeb2015.R"))
    act <- storeEntity(act)
    generatedBy(b) <- act
    b <- synStore(b)
    rosmapTable@values$newSynapseId[i] <- b$properties$id
    wind <- is.na(rosmapTable@values$newSynapseId)
    if(sum(wind)>0){
      rosmapTable@values$newSynapseId[wind] <- ''
    }
    rosmapTable@values$newFileName[i] <- newFileName
    rosmapTable@values$isMigrated[i] <- TRUE
    rosmapTable@values$hasAnnotation[i] <- TRUE
    rosmapTable@values$hasProvenance[i] <- TRUE
    rosmapTable <- synStore(rosmapTable)    
    system(paste0('rm ',newFileName))
  }else if (fileType=='fam'){
    newFileName <- paste0(newFileName,'_Group',strsplit(foo[[1]],'list')[[1]][2],'.',fileType)
    b <- File(newFileName,parentId=rosmapTable@values$newParentId[i],name=paste0(newEntityName,'_Group',strsplit(foo[[1]],'list')[[1]][2],'_',fileType))
    dataAnnotation <- list(
      dataType = 'DNA',
      disease = c('Alzheimers Disease','Control'),
      platform = 'Affymetrix Genechip 6.0',
      center = 'Rush-Broad',
      study = 'ROSMAP',
      fileType = 'fam',
      organism = 'human',
      dataSubType = 'imputedGenotypes',
      imputationReference = 'HapMap3'      
    )
    synSetAnnotations(b) <- dataAnnotation
    act <- Activity(name='ROSMAP Imputed Genotype Migration',
                    used=list(list(entity=rosmapTable@values$originalSynapseId[i],wasExecuted=F)),
                    executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Rush-Broad/migrateROSMAPImputedGenotypesFeb2015.R"))
    act <- storeEntity(act)
    generatedBy(b) <- act
    b <- synStore(b)
    rosmapTable@values$newSynapseId[i] <- b$properties$id
    wind <- is.na(rosmapTable@values$newSynapseId)
    if(sum(wind)>0){
      rosmapTable@values$newSynapseId[wind] <- ''
    }
    rosmapTable@values$newFileName[i] <- newFileName
    rosmapTable@values$isMigrated[i] <- TRUE
    rosmapTable@values$hasAnnotation[i] <- TRUE
    rosmapTable@values$hasProvenance[i] <- TRUE
    rosmapTable <- synStore(rosmapTable)
    system(paste0('rm ',newFileName))
  }

}

robustBatchSynGet <- function(syn){
  res <- NA
  try(res <- synGet(syn),silent = TRUE)
  return(res)
}

migrateImputedGenotype <- function(){
  rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP Imputed Genotypes%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
  synList <- sapply(rosmapTable@values$originalSynapseId,robustBatchSynGet)
  getFalse <- sapply(synList,function(x) is.na(x));
  while(sum(getFalse)>0){
    wf <- which(getFalse)
    for (i in 1:length(wf)){
      synList[[wf[i]]] <- robustBatchSynGet(rosmapTable@values$originalSynapseId[wf[i]])
    }
    getFalse <- sapply(synList,function(x) is.na(x))
  }
  
  newFileName <- 'AMP-AD_ROSMAP_Rush-Broad_AffymetrixGenechip6_Imputed'
  newEntityName <- 'ROSMAP_Rush-Broad_AffymetrixGenechip6_Imputed'
  sapply(1:nrow(rosmapTable@values),moveGeno,synList,newFileName,rosmapTable)
  sapply(1:nrow(rosmapTable@values),makeFile,newEntityName,newFileName,rosmapTable)
}
migrateImputedGenotype()
