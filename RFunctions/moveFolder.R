moveFolder <- function(folderId,originalParentId,newParentId){
  #login to Synapse
  require(synapseClient)
  synapseLogin()
  folderId <- synGet(folderId,downloadFile=F)
  synObj <- crawlSynapseObject(folderId)
  
  
  
}