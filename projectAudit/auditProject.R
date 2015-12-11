###scrape annotations 
require(synapseClient)
synapseLogin()
setwd('projectAudit/')
source('../RFunctions/populateNewDirectory2.R')
source('../RFunctions/makeNewFolder.R')
source('../RFunctions/makeLink.R')
source('../RFunctions/moveFile.R')
source('../RFunctions/crawlSynapseObjectList.R')
source('../RFunctions/makeHeadFolder.R')
source('../RFunctions/adjacentEdges.R')
source('../RFunctions/moveSingleFile.R')
source('../Rfunctions/moveFolder2.R')
source('../Rfunctions/reverseLink.R')

##crawl directory


##get files
synGetNoDownload <- function(x){
  foo <- synGet(x,downloadFile = F)
  return(foo)
}

###crawl amp ad (December 9, 2015)
foo <- crawlSynapseObjectList('syn2580853',G=NULL)
#foo <- crawlSynapseObjectList('syn3273961',G=NULL)
bar <- lapply(foo$id,synGetNoDownload)
anno <- lapply(bar,synGetAnnotations)
save(foo,bar,anno,file='ampAdCrawledDecember102015.rda')


require(synapseClient)
synapseLogin()
##get dictionary
dictionaryObj <- synTableQuery('SELECT * FROM syn5478487')
onWeb('syn5478487')
##make dictionary into a list
uniqueFields <- unique(dictionaryObj@values$field)

listify <- function(x,y,z){
  return(unique(y[which(z==x)]))
}

dictionary <- lapply(uniqueFields,listify,dictionaryObj@values$value,dictionaryObj@values$field)

names(dictionary) <- uniqueFields


#Consortium
#Center
#Study
#Disease
#Assay
#File Type
#Model System
#Tissue Type
#Organism

#checks: are there annotations YES/NO
annoExist <- sapply(anno,function(x){return(length(x)>0)})

fxn1 <- function(x){
  return(strsplit(x,'\\.')[[1]][5])
}
entityType <- sapply(foo$type,fxn1)
entityType[1] <- 'Project'
entityType[2] <- 'Table'

annotationAuditDataFrame <- data.frame(synId=foo$id,
                                       entityType=entityType,
                                       hasAnnotation=annoExist,
                                       stringsAsFactors = F)

#anno2 <- lapply(anno,function(x){return(x[[1]])})
fxn2 <- function(x){
  bar <- NULL
  try(bar <- names(x),silent=T)
  return(bar)
}
fieldsAudit <- lapply(anno,fxn2)
n1 <- names(dictionary)
library(Hmisc)
fieldAuditNew <- sapply(fieldsAudit,function(x,y){return(y%in%x)},n1)
fieldAuditNew <- t(fieldAuditNew)
colnames(fieldAuditNew) <- paste0('has',n1)

annotationAuditDataFrame <- cbind(annotationAuditDataFrame,fieldAuditNew)

#assayTargetValueInDictionary
valueAuditNew <- fieldAuditNew
colnames(valueAuditNew) <- paste0(n1,'ValueInDictionary')
fxn3 <- function(x,n1,dictionary,i){
  foobaz <- FALSE
  try(foobaz <- x[[n1[i]]] %in% dictionary[[n1[i]]],silent=T)
  if(length(foobaz)>0){
    if(is.na(foobaz)){
      foobaz <- FALSE
    }
  }else {
    foobaz <- FALSE
  }
  return(foobaz[1])
}

for (i in 1:ncol(valueAuditNew)){
  valueAuditNew[,i] <- sapply(anno,fxn3,n1,dictionary,i)
}

annotationAuditDataFrame <- cbind(annotationAuditDataFrame,valueAuditNew)
colnames(annotationAuditDataFrame)[1] <- 'synapseID'
tcresult<-as.tableColumns(annotationAuditDataFrame)
cols<-tcresult$tableColumns
fileHandleId<-tcresult$fileHandleId
projectId<-"syn2397881"
schema<-TableSchema(name="AMP AD Audit Full Table", parent=projectId, columns=cols)
table<-Table(schema, fileHandleId)
table<-synStore(table, retrieveData=TRUE)

write.csv(annotationAuditDataFrame,file='annotationAuditDecember2015.csv',quote=F,row.names=F)

##cross reference annotations with dictionary
##return errors for cases where annotations and dictionary are inconsistent