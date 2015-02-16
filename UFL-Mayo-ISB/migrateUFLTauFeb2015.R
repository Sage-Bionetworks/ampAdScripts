#Cer 'clinical' syn3162960
#TCX 'clinical' syn3162961
#Cer 'technical syn3161029
#TCX 'technical syn3161032

require(synapseClient)
synapseLogin()

mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'UFL%Nanostring%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)

i <- 1
normalized <- synGet(mayoTable@values$originalSynapseId[i])
normalizedData <- read.table(normalized@filePath,header=T)

newFileName <- 'AMP-AD_UFL_UFL-Mayo-ISB_Nanostring_APP_IL10_Normalized.csv'
newEntityName <- 'UFL_UFL-Mayo-ISB_Nanostring_APP_IL10_Normalized'
write.csv(normalizedData,file=newFileName,row.names=F)

b <- File(newFileName,parentId=mayoTable@values$newParentId[i],name=newEntityName)
dataAnnotation <- list(
  dataType = 'mRNA',
  disease = c('Alzheimers'),
  mouseModel = 'APP',
  center = 'UFL-Mayo-ISB',
  study = 'UFL',
  fileType = 'csv',
  organism = 'mouse',
  other = 'Normalized'
)
synSetAnnotations(b) <- dataAnnotation
act <- Activity(name='UFL Nanostring Data Migration',
                used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateUFLnanostringFeb2015.R"))
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


#raw data
mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'UFL%Nanostring%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)

i <- 2
normalized <- synGet(mayoTable@values$originalSynapseId[i])
normalizedData <- read.table(normalized@filePath,header=T)

newFileName <- 'AMP-AD_UFL_UFL-Mayo-ISB_Nanostring_APP_IL10_Unnormalized.csv'
newEntityName <- 'UFL_UFL-Mayo-ISB_Nanostring_APP_IL10_Unnormalized'
write.csv(normalizedData,file=newFileName,row.names=F)

b <- File(newFileName,parentId=mayoTable@values$newParentId[i],name=newEntityName)
dataAnnotation <- list(
  dataType = 'mRNA',
  disease = c('Alzheimers'),
  mouseModel = 'APP',
  center = 'UFL-Mayo-ISB',
  study = 'UFL',
  fileType = 'csv',
  organism = 'mouse',
  other = 'Unnormalized'
)
synSetAnnotations(b) <- dataAnnotation
act <- Activity(name='UFL Nanostring Data Migration',
                used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateUFLnanostringFeb2015.R"))
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

##covariates

mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'UFL%Nanostring%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)

i <- 3
normalized <- synGet(mayoTable@values$originalSynapseId[i])
normalizedData <- read.table(normalized@filePath,header=T)

newFileName <- 'AMP-AD_UFL_UFL-Mayo-ISB_Nanostring_APP_IL10_Covariates.csv'
newEntityName <- 'UFL_UFL-Mayo-ISB_Nanostring_APP_IL10_Covariates'
write.csv(normalizedData,file=newFileName,row.names=F)

b <- File(newFileName,parentId=mayoTable@values$newParentId[i],name=newEntityName)
dataAnnotation <- list(
  dataType = 'metaData',
  disease = c('Alzheimers'),
  mouseModel = 'APP',
  center = 'UFL-Mayo-ISB',
  study = 'UFL',
  fileType = 'csv',
  organism = 'mouse'
)
synSetAnnotations(b) <- dataAnnotation
act <- Activity(name='UFL Nanostring Data Migration',
                used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateUFLnanostringFeb2015.R"))
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
