

auditProject <- function(){
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
  
  load('ampAdCrawled2015-12-17.rda')
  
  dictionaryObj <- synTableQuery('SELECT * FROM syn5478487')
  #onWeb('syn5478487')
  ##make dictionary into a list
  uniqueFields <- unique(dictionaryObj@values$field)
  
  listify <- function(x,y,z){
    return(unique(y[which(z==x)]))
  }
  
  dictionary <- lapply(uniqueFields,listify,dictionaryObj@values$value,dictionaryObj@values$field)
  
  names(dictionary) <- uniqueFields
  
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
  schema<-TableSchema(name="AMP AD Audit Full Table Ver 2", parent=projectId, columns=cols)
  table<-Table(schema, fileHandleId)
  table<-synStore(table, retrieveData=TRUE)
  
  write.csv(annotationAuditDataFrame,file='annotationAuditDecember2015ver2.csv',quote=F,row.names=F)
  require(dplyr)
  annotationAuditFolderSummary <- dplyr::filter(annotationAuditDataFrame,entityType=='Folder') %>%
    dplyr::select(synapseID)
  
  annotationAuditFolderSummary$meanChildFilehasAnnotation <- rep(NA,nrow(annotationAuditFolderSummary))
  annotationAuditFolderSummary$totalChildFilehasAnnotation <- rep(NA,nrow(annotationAuditFolderSummary))
  annotationAuditFolderSummary$meanhasMinimumNecessaryAnnotations <- rep(NA,nrow(annotationAuditFolderSummary))
  annotationAuditFolderSummary$totalhasMinimumNecessaryAnnotations <- rep(NA,nrow(annotationAuditFolderSummary))
  annotationAuditFolderSummary$meanDictionaryErrors <- rep(NA,nrow(annotationAuditFolderSummary))
  annotationAuditFolderSummary$totalDictionaryErrors <- rep(NA,nrow(annotationAuditFolderSummary))
  
  #minimum necessary
  #Consortium
  #Center
  #Study
  #Disease
  #Assay
  #File Type
  #Model System
  #Tissue Type
  #Organism
  
  
  rownames(annotationAuditDataFrame) <- annotationAuditDataFrame$synapseID
  for (i in 1:nrow(annotationAuditFolderSummary)){
    children <- foo$adjList[[annotationAuditFolderSummary$synapseID[i]]]
    if(length(children)>0){
      entityTypes <- foo$type[foo$id%in%children] 
      w1 <- which(entityTypes=='org.sagebionetworks.repo.model.FileEntity')
      if(length(w1)>0){
        #print(children[w1])
        #print(annotationAuditDataFrame[children[w1],3])
        annotationAuditFolderSummary$meanChildFilehasAnnotation[i] <- mean(annotationAuditDataFrame[children[w1],3])
        annotationAuditFolderSummary$totalChildFilehasAnnotation[i] <- sum(annotationAuditDataFrame[children[w1],3])
        annotationAuditFolderSummary$meanhasMinimumNecessaryAnnotations[i] <- annotationAuditDataFrame[children[w1],] %>% dplyr::select(hasconsortium,hascenter,hasstudy,hasdisease,hasassay,hasfileType,hasmodelSystem,hastissueType,hasorganism) %>%as.matrix %>% mean(na.rm=T)
        
        #annotationAuditDataFrame[children[w1],] %>% dplyr::select(hasconsortium,hascenter,hasstudy,hasdisease,hasassay,hasfileType,hasmodelSystem,hastissueType,hasorganism) %>% print
        annotationAuditFolderSummary$totalhasMinimumNecessaryAnnotations[i] <- annotationAuditDataFrame[children[w1],] %>% dplyr::select(hasconsortium,hascenter,hasstudy,hasdisease,hasassay,hasfileType,hasmodelSystem,hastissueType,hasorganism) %>%as.matrix %>% sum(na.rm=T)
        annotationAuditFolderSummary$meanDictionaryErrors[i] <- (!annotationAuditDataFrame[children[w1],25:43]) %>%as.matrix %>% mean(na.rm=T)
        annotationAuditFolderSummary$totalDictionaryErrors[i] <- (!annotationAuditDataFrame[children[w1],25:43]) %>%as.matrix %>% sum(na.rm=T)      
      }
    }
  }
  
  annotationAuditFolderSummary <- dplyr::filter(annotationAuditFolderSummary,!is.na(meanChildFilehasAnnotation))
  
  
  tcresult<-as.tableColumns(annotationAuditFolderSummary)
  cols<-tcresult$tableColumns
  fileHandleId<-tcresult$fileHandleId
  projectId<-"syn2397881"
  schema<-TableSchema(name="AMP AD Audit Folder Summaries Ver 2", parent=projectId, columns=cols)
  table<-Table(schema, fileHandleId)
  table<-synStore(table, retrieveData=TRUE)
}
