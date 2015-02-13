###script to migrate ROSMAP clinical data

require(synapseClient)
synapseLogin()
rosmapTable <- synTableQuery('select * from syn3163713 where data like \'ROSMAP Clinical%\'')

clinical <- synGet(rosmapTable@values$originalSynapseId[grep('xlsx',rosmapTable@values$oldFileName)])
require(gdata)
clinicalXls <- read.xls(clinical@filePath)

newFileName <- 'AMP-AD_ROSMAP_Rush-Broad_Clinical.csv'
newEntityName <- 'ROSMAP_Rush-Broad_Clinical'
write.csv(clinicalXls,file=newFileName,row.names=F)
i <- grep('xlsx',rosmapTable@values$oldFileName);
b <- File(newFileName,parentId=rosmapTable@values$newParentId[i],name=newEntityName)
dataAnnotation <- list(
  dataType = 'metaData',
  disease = c('Alzheimers Disease','Control'),
  center = 'Rush-Broad',
  study = 'ROSMAP',
  fileType = 'csv',
  organism = 'human'
)
synSetAnnotations(b) <- dataAnnotation
act <- Activity(name='ROSMAP Clinical Data Migration',
                used=list(list(entity=rosmapTable@values$originalSynapseId[i],wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Rush-Broad/migrateROSMAPClinicalFeb2015.R"))
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

rosmapTable <- synTableQuery('select * from syn3163713 where data like \'ROSMAP Clinical%\'')
i <- grep('pdf',rosmapTable@values$oldFileName)
clinical <- synGet(rosmapTable@values$originalSynapseId[i])

#require(gdata)
#clinicalXls <- read.xls(clinical@filePath)
sub1 <- gsub(' ','\\\\ ',clinical@filePath)
newFileName <- 'AMP-AD_ROSMAP_Rush-Broad_Clinical_Codebook.pdf'
newEntityName <- 'ROSMAP_Rush-Broad_Clinical_Codebook'
system(paste0('cp ',sub1,' ',newFileName))
#i <- grep('xlsx',rosmapTable@values$oldFileName);
b <- File(newFileName,parentId=rosmapTable@values$newParentId[i],name=newEntityName)
dataAnnotation <- list(
  dataType = 'metaData',
  disease = c('Alzheimers Disease','Control'),
  center = 'Rush-Broad',
  study = 'ROSMAP',
  fileType = 'csv',
  organism = 'human'
)
synSetAnnotations(b) <- dataAnnotation
act <- Activity(name='ROSMAP Clinical Data Migration',
                used=list(list(entity=rosmapTable@values$originalSynapseId[i],wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Rush-Broad/migrateROSMAPClinicalFeb2015.R"))
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

