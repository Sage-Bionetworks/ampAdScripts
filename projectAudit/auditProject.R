###scrape annotations 
require(synapseClient)
synapseLogin()
setwd('projectAudit/')
source('../RFunctions/populateNewDirectory2.R')
source('../RFunctions/makeNewFolder.R')
source('../RFunctions/makeLink.R')
source('../RFunctions/moveFile.R')
source('../RFunctions/crawlSynapseObject.R')
source('../RFunctions/makeHeadFolder.R')
source('../RFunctions/adjacentEdges.R')
source('../RFunctions/moveSingleFile.R')
source('../Rfunctions/moveFolder2.R')
source('../Rfunctions/reverseLink.R')

##crawl directory

#foo <- crawlSynapseObject('syn2580853',G=NULL)
foo <- crawlSynapseObject('syn3273961',G=NULL)

##get files
synGetNoDownload <- function(x){
  foo <- synGet(x,downloadFile = F)
  return(foo)
}

bar <- lapply(foo$id,synGetNoDownload)
anno <- lapply(bar,synGetAnnotations)

##get dictionary
dictionaryObj <- synTableQuery('SELECT * FROM syn5478487')

##make dictionary into a list
uniqueFields <- unique(dictionaryObj@values$field)

listify <- function(x,y,z){
  return(unique(y[which(z==x)]))
}

dictionary <- lapply(uniqueFields,listify,dictionaryObj@values$value,dictionaryObj@values$field)

names(dictionary) <- uniqueFields


##cross reference annotations with dictionary
##return errors for cases where annotations and dictionary are inconsistent