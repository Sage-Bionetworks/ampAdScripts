makeNewFolder <- function(parentId,folderId,Q,G){
  folderName <- G$name[folderId];
  folderParentId <- Q$newid[parentId];
  myFolder <- Folder(name=folderName,parentId=folderParentId);
  myFolder <- synStore(myFolder);
  return(myFolder$properties$id);
}