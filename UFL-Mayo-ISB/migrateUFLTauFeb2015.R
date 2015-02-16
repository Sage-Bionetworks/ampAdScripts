require(synapseClient)
synapseLogin()
migrateTau <- function(i,newFileName,newEntityName,other){
  mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'UFL%RNAseq%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
  normalized <- synGet(mayoTable@values$originalSynapseId[i])
  system(paste('cp ',normalized@filePath,' ',newFileName,sep=''))

  b <- File(newFileName,parentId=mayoTable@values$newParentId[i],name=newEntityName)
  dataAnnotation <- list(
    dataType = 'mRNA',
    disease = c('Alzheimers'),
    platform= 'IlluminaHiSeq2000',
    mouseModel = 'Tau',
    center = 'UFL-Mayo-ISB',
    study = 'TAUAPPms',
    fileType = 'tsv',
    organism = 'mouse',
    other = other
  )
  synSetAnnotations(b) <- dataAnnotation
  act <- Activity(name='UFL Tau RNAseq Data Migration',
                  used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateUFLTauFeb2015.R"))
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

migrateTau(2,'AMP-AD_TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_GeneCounts.txt.gz','TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_GeneCounts',other=c('geneCounts','Unnormalized'))
migrateTau(3,'AMP-AD_TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts.txt.gz','TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts',other=c('transcriptCounts','Unnormalized'))
migrateTau(4,'AMP-AD_TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_GeneCounts_Normalized.txt.gz','TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_GeneCounts_Normalized',other=c('geneCounts','Normalized'))
migrateTau(5,'AMP-AD_TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_GeneCounts_Transposed.txt.gz','TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_GeneCounts_Transposed',other=c('geneCounts','Unnormalized','Transposed'))
migrateTau(6,'AMP-AD_TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Normalized.txt.gz','TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Normalized',other=c('geneCounts','Normalized'))
migrateTau(7,'AMP-AD_TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed.txt.gz','TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed',other=c('geneCounts','Unnormalized','Transposed'))


#covariates

mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'UFL%RNAseq%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
i <- 1
normalized <- synGet(mayoTable@values$originalSynapseId[i])
normalizedData <- read.table(normalized@filePath,header=T)

newFileName <- 'AMP-AD_TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_Covariates.csv'
newEntityName <- 'TAUAPPms_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_Covariates'
write.csv(normalizedData,file=newFileName,row.names=F)

b <- File(newFileName,parentId=mayoTable@values$newParentId[i],name=newEntityName)
dataAnnotation <- list(
  dataType = 'metaData',
  disease = c('Alzheimers'),
  mouseModel = 'Tau',
  center = 'UFL-Mayo-ISB',
  study = 'TAUAPPms',
  fileType = 'csv',
  organism = 'mouse'
)
synSetAnnotations(b) <- dataAnnotation
act <- Activity(name='UFL Tau RNAseq Data Migration',
                used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateUFLTauFeb2015.R"))
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



