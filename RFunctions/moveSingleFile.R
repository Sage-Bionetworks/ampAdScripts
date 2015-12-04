moveSingleFile <- function(synId,newParentId){
  #function to move a single file (synId) and place a link where it was given a new parentId (newParentId)
  foo <- synGet(synId,downloadFile=F)
  oldParentId <- synGetProperties(foo)$parentId
  fileName <- synGetProperties(foo)$name
  moveFile(synId,newParentId)
  makeLink(synId,oldParentId,linkName=fileName)
}