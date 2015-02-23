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

##clinical, covariate, metaData -> fix


##