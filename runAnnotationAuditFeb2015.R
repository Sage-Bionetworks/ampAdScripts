##migrate old annotations to new annotations

#go through table for all old files
#determine if there exists annotaitons
#move annotations to new file
res <- synTableQuery('select * from syn3163713 where isMigrated=TRUE')
help(synSetAnnotations)

for(i in 1:nrow(res@values)){
  cat('Checking row',i,'\n')
  a <- synGet(res@values$originalSynapseId[i],downloadFile=FALSE)
  b <- synGetAnnotations(a)
  if(length(b)>0){
    cat('Identified missing annotations on public data \n')
    foo <- synGet(res@values$newSynapseId[i],downloadFile=FALSE)
    bar <- synGetAnnotations(foo)      
    print(res@values[i,])
    baz <- c(bar,b)
    synSetAnnotations(foo) <- baz
    foo <-synStore(foo,forceVersion=FALSE)
  }  
}


#synchronize internal and external annotations

resPortal <- synQuery('select id, name from file where projectId=="syn2580853"')
resMigration <- synTableQuery('select * from syn3163713 where isMigrated=TRUE')

wkeep <- which(resPortal$file.id%in%resMigration@values$newSynapseId)

for (i in wkeep){
  newId <- resPortal$file.id[i]
  oldId <- resMigration@values$originalSynapseId[resMigration@values$newSynapseId==newId]
  synNew <- synGet(newId,downloadFile=F)
  for (syn in oldId){
    synOld <- synGet(syn,downloadFile=F)
    newAnnotations <- synGetAnnotations(synNew)
    synSetAnnotations(synOld) <- as.list(newAnnotations)
    synOld <- synStore(synOld,forceVersion=FALSE)
  }
  cat('Finished',i,'of',length(wkeep),'\n')
}


##clinical, covariate, metaData -> fix


##