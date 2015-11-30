#reverse link function
reverseLink <- function(synId){
  foo <- synGet(synId,downloadFile = F)
  fooProperties <- synGetProperties(foo)
  targetId <- fooProperties$linksTo$targetId
  parentId <- fooProperties$parentId
  synDelete(synId)
  moveFile(targetId,parentId)
  #synDelete()
}