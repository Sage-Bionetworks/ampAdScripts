require(synapseClient)
synapseLogin()
mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'MayoCC GWAS Clinical%\'')

clinical <- synGet(mayoTable@values$originalSynapseId[grep('xlsx',mayoTable@values$oldFileName)])
require(gdata)
clinicalXls <- read.xls(clinical@filePath,sheet=2)

newFileName <- 'AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Covariates.csv'
newEntityName <- 'MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Covariates'
write.csv(clinicalXls,file=newFileName,row.names=F)
i <- grep('xlsx',mayoTable@values$oldFileName);
b <- File(newFileName,parentId=mayoTable@values$newParentId[i],name=newEntityName)
dataAnnotation <- list(
  dataType = 'metaData',
  disease = c('Alzheimers Disease','Control','Progressive Supranuclear Palsy'),
  center = 'UFL-Mayo-ISB',
  study = 'MayoLOADGWAS',
  fileType = 'csv',
  organism = 'human'
)
synSetAnnotations(b) <- dataAnnotation
act <- Activity(name='MayoLOADGWAS Covariate Data Migration',
                used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Rush-Broad/migrateMayoLOADGWASCovariatesFeb2015.R"))
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
