moveFile <- function(fileId,parentId){
  myFile <- synGet(fileId,downloadFile = FALSE);
  myFile$properties$parentId <- parentId;
  myFile <- synStore(myFile,forceVersion=F);
}