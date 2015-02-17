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
  b <- File(newFileName,parentId=rosmapTable@values$newParentId[i],name=newEntityName)
  dataAnnotation <- list(
    dataType = 'DNA',
    disease = c('Alzheimers Disease','Control')
    platform = 'Affymetrix Genechip 6.0',
    center = 'Rush-Broad',
    study = 'ROSMAP',
    fileType = 'plink',
    organism = 'human'
  )
  synSetAnnotations(b) <- dataAnnotation
  act <- Activity(name='ROSMAP Genotype Migration',
                  used=list(list(entity=rosmapTable@values$originalSynapseId[i],wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
  act <- storeEntity(act)
  generatedBy(b) <- act
  b <- synStore(b)
}
updateTable <- function(){}

migrateGenotype <- function(){
  rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP Genotypes%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
  synList <- sapply(rosmapTable@values$originalSynapseId,synGet)
  newFileName <- 'AMP-AD_ROSMAP_Rush-Broad_AffymetrixGenechip6'
  newEntityName <- 'ROSMAP_Rush-Broad_AffymetrixGenechip6'
  sapply(1:nrow(rosmapTable),moveGeno,synList,newFileName,rosmapTable)
  sapply(1:nrow(rosmapTable),makeFile,synList,newEntityName,newFileName,rosmapTable)
  updateTable(rosmapTable,newFileName)
}




#fileOrganization <- unique(rosmapTable@values$data)

#syn3157275 (Methylation)
#syn3157322 (Clinical)
#syn3157325 (genotype)
#syn3157329 (imputed genotype)

#rosmapTable@values$newParentId[rosmapTable@values$data=='ROSMAP Methylation'] <- 'syn3157275'
#rosmapTable@values$toBeMigrated[rosmapTable@values$data=='ROSMAP Methylation'] <- TRUE
#rosmapTable@values$newParentId[rosmapTable@values$data=='ROSMAP Clinical'] <- 'syn3157322'
#rosmapTable@values$toBeMigrated[rosmapTable@values$data=='ROSMAP Clinical'] <- TRUE
#rosmapTable@values$newParentId[rosmapTable@values$data=='ROSMAP Genotypes'] <- 'syn3157325'
#rosmapTable@values$toBeMigrated[rosmapTable@values$data=='ROSMAP Genotypes'] <- TRUE

#rosmapTable@values$newParentId[rosmapTable@values$data=='ROSMAP Imputed Genotypes'] <- 'syn3157329'
#rosmapTable@values$toBeMigrated[rosmapTable@values$data=='ROSMAP Imputed Genotypes'] <- TRUE

#rosmapTable@values$newParentId[rosmapTable@values$data=='ROSMAP Imputed Genotypes CHOP'] <- 'syn3157329'
#rosmapTable@values$toBeMigrated[rosmapTable@values$data=='ROSMAP Imputed Genotypes CHOP'] <- FALSE
#rosmapTable@values$newSynapseId <- 'syn3157329'

#rosmapTable <- synStore(rosmapTable)

