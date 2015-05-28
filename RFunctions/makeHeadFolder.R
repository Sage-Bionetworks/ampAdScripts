makeHeadFolder <- function(synObj,synid){
  synObj$adj[1,1] <- 1
  synObj$type[1] <- 'org.sagebionetworks.repo.model.Folder'
  synObj2 <- synGet(synid,downloadFile=F)
  synObj$name[1] <- synObj2@properties$name
  return(synObj)  
}