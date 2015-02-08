postProcessDirectory <- function(G){
  names(G$name) <- G$id
  names(G$type) <- G$id
  return(G)
}