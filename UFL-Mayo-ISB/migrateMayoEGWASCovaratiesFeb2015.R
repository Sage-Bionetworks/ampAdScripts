#Cer 'clinical' syn3162960
#TCX 'clinical' syn3162961
#Cer 'technical syn3161029
#TCX 'technical syn3161032

require(synapseClient)
synapseLogin()

mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'Mayo%Clinical\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)

#Cerebellum (row 1, 5)
#grab data
clinical <- synGet(mayoTable@values$originalSynapseId[1])
technical <- synGet(mayoTable@values$originalSynapseId[5])

clin <- read.table(clinical@filePath,header=T)
tech <- read.table(technical@filePath,header=T)

combinedData <- data.frame(clin[,c(1,3,6,8)],tech[,-1])

newFileName <- 'AMP-AD_MayoEGWAS_UFL-Mayo-ISB_IlluminaWholeGenomeDASL_Covariates.csv'
newEntityName <- 'MayoLOADGWAS_UFL-Mayo-ISB_IlluminaWholeGenomeDASL_Covariates'
write.csv(combinedData,file=newFileName,row.names=F)
i <- 1
b <- File(newFileName,parentId=mayoTable@values$newParentId[i],name=newEntityName)
dataAnnotation <- list(
  dataType = 'metaData',
  tissueType = 'Cerebellum',
  disease = c('Alzheimers Disease','Control'),
  center = 'UFL-Mayo-ISB',
  study = 'MayoEGWAS',
  fileType = 'csv',
  organism = 'human'
)
synSetAnnotations(b) <- dataAnnotation
act <- Activity(name='MayoLOADGWAS Covariate Data Migration',
                used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateMayoLOADGWASCovariatesFeb2015.R"))
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



#collate
#add annotation
#add provenance
#update migration table


#Temporal Cortex (row 2, 6)