adjacentEdges <- function(synId){
  str <- paste('SELECT id, name, concreteType FROM entity WHERE parentId=="',synId,'"',sep='')
  return(synQuery(str))
}