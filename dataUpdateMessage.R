###function to send data update messages
dataUpdateMessage <- function(users,subject,message){
  require(synapseClient)
  synapseLogin()
  sendMessage(userIdList = users,subject = subject, body = message)
}

#source('http://depot.sagebase.org/CRAN.R')
#pkgInstall("synapseClient")

#library(devtools)
#install_github('Sage-Bionetworks/rSynapseClient', ref='develop')
