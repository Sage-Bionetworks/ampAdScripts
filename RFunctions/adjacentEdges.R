adjacentEdges <- function(synId){
  str <- paste('SELECT id, name, concreteType FROM entity WHERE parentId=="',synId,'"',sep='')
  foo <- synQuery(str,blockSize = 300)
  res <- foo$collectAll()
  if(ncol(res)==0){
    return(NULL)
  }else{
    return(res)
  }
}