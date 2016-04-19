require(synapseClient)
synapseLogin()


foo <- synQuery('select * from file where projectId==\'syn2580853\' and study==\'ROSMAP\'',blockSize = 100)
bar <- foo$collectAll()
require(dplyr)



#bar2 <- select(bar,file.id,file.name,file.versionNumber)

queryString <- paste0('/entity/',bar$file.id,'/version/',bar2$file.versionNumber,'/doi')
fun1 <- function(x){
  res <-NA;
  try(res <- synRestGET(x),silent=T)
  return(is.na(res))
}

doiExists <- sapply(queryString,fun1)
doiExists <- sapply(doiExists,sum)
bar$doi <- paste0('doi:10.7303/',bar2$file.id,'.',bar2$file.versionNumber)
bar$doi[which(doiExists==1)] <- NA
#format: ids, DOI, filenames, center, consortium, platform, dataType, fileType, assay, tissueOfOrigin, study, organism, modelSystem, tissueType, dataSubType, analysisType, disease, normalizationStatus
bar2 <- select(bar,file.id,doi,file.name,file.center,file.consortium,file.platform,file.dataType,file.fileType,file.assay,file.tissueOfOrigin,file.study,file.organism,file.modelSystem,file.tissueOfOrigin,file.dataSubType,file.disease,file.normalizationStatus)




