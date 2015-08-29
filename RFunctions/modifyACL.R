modifyACL <- function(synId,userlist,permissions){
  require(synapseClient)
  synapseLogin()

  synGetEntityACL('syn2397885')
  
}