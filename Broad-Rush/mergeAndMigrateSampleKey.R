require(synapseClient)
synapseLogin()

#put file in Rush-Broad directory
internalParentId <- 'syn2700793'
sampIdFile <- File('Broad-Rush/AMP-AD_ROSMAP_Rush-Broad_IDKey.txt',parentId=internalParentId)
sampIdFile <- synStore(sampIdFile)

rosmapTable <- synTableQuery('select * from syn3163713 where data like \'ROSMAP Sample%\'')

dataAnnotation <- list(
  dataType = 'metaData',
  center = 'Rush-Broad',
  study = 'ROSMAP',
  fileType = 'csv',
  organism = 'Homo sapiens'
)

df <- read.table('Broad-Rush/AMP-AD_ROSMAP_Rush-Broad_IDKey.txt',header=T,stringsAsFactors = F,sep='\t')
write.csv(df,file='Broad-Rush/AMP-AD_ROSMAP_Rush-Broad_IDKey.csv',quote=F,row.names=F)

i <- 1
newFileName <- 'Broad-Rush/AMP-AD_ROSMAP_Rush-Broad_IDKey.csv'
newEntityName <- 'ROSMAP_Rush-Broad_IDKey'
b <- File(newFileName,parentId=rosmapTable@values$newParentId[i],name=newEntityName)
synSetAnnotations(b) <- dataAnnotation;


act <- Activity(name='ROSMAP Sample ID Key Migration',
                used=list(list(entity=rosmapTable@values$originalSynapseId[i],wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Broad-Rush/mergeAndMigrateSampleKey.R"))

act <- storeEntity(act)
generatedBy(b) <- act
b <- synStore(b)
rosmapTable@values$newSynapseId[i] <- b$properties$id


rosmapTable@values$newFileName[i] <- 'AMP-AD_ROSMAP_Rush-Broad-IDKey.csv'
rosmapTable@values$isMigrated[i] <- TRUE
rosmapTable@values$hasAnnotation[i] <- TRUE
rosmapTable@values$hasProvenance[i] <- TRUE
rosmapTable <- synStore(rosmapTable)




