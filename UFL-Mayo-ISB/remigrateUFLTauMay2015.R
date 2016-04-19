require(synapseClient)
synapseLogin()

pushUpdatedTauFile <- function(i,partnerId,metaId,isCovariate=NULL){
  uflTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'UFL%RNAseq\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
  synPartnerObj <- synGet(partnerId)
  if(!is.null(isCovariate)){
    #add outlier column
    synData <- read.delim(synPartnerObj@filePath,sep=',')
    outlier <- c(rep(FALSE,55),TRUE,rep(FALSE,4))
    synData <- cbind(synData,outlier)
    write.csv(synData,file=synPartnerObj@fileHandle$fileName,quote=F,row.names=F)
    synNewObj <- File(synPartnerObj@fileHandle$fileName,parentId=uflTable@values$newParentId[i])
  }else{
    synNewObj <- File(synPartnerObj@filePath,parentId=uflTable@values$newParentId[i])
  }
  
  synMetaId <- synGet(metaId,downloadFile = F)
  annotations2 <- synGetAnnotations(synMetaId)
  #provenance <- synGetActivity(synMetaId)
  #make new provenance
  
  act <- Activity(name='UFL Tau Data Migration',
                  used=list(list(entity=partnerId,wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/remigrateUFLTauMay2015.R"))
  act <- storeEntity(act)
  generatedBy(synNewObj) <- act
  synSetAnnotations(synNewObj) <- as.list(annotations2)
  synNewObj <- synStore(synNewObj)

  #update table.

  wind <- is.na(uflTable@values$newSynapseId)
  if(sum(wind)>0){
    uflTable@values$newSynapseId[wind] <- ''
  }
  uflTable@values$newFileName[i] <- synNewObj@fileHandle$fileName
  uflTable@values$isMigrated[i] <- TRUE
  uflTable@values$hasAnnotation[i] <- TRUE
  uflTable@values$hasProvenance[i] <- TRUE
  uflTable <- synStore(uflTable)
  
}
partnerIdVec <- c('syn3909702','syn3910122','syn3910325','syn3910523','syn3910665')
metaIdVec <- c('syn3219041','syn3219026','syn3219030','syn3219028','syn3219034')
  
for(i in 1:5){
  if(i==1){
    pushUpdatedTauFile(i,partnerIdVec[i],metaIdVec[i],isCovariate=TRUE)
  }else{
    pushUpdatedTauFile(i,partnerIdVec[i],metaIdVec[i],isCovariate=NULL)
  }
}
