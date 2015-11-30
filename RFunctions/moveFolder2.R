moveFolder2 <- function(folderId,newParentId){
  foo <- synGet(folderId,downloadFile = F)
  oldParentId <- synGetProperty(foo,'parentId')
  synSetProperty(foo,'parentId') <- newParentId
  foo <- synStore(foo,forceVersion=F)
}