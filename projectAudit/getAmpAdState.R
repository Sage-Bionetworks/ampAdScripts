###scrape annotations 
getAmpAdState <- function(foo=NULL){
  require(synapseClient)
  synapseLogin()
  #setwd('projectAudit/')
  source('../RFunctions/crawlSynapseObjectList.R')
  ##get files
  synGetNoDownload <- function(x){
    foo <- synGet(x,downloadFile = F)
    return(foo)
  }
  
  ###crawl amp ad (December 9, 2015)
  if(is.null(foo)){
    foo <- crawlSynapseObjectList('syn2580853',G=NULL)
  }
  #foo <- crawlSynapseObjectList('syn3273961',G=NULL)
  bar <- lapply(foo$id,synGetNoDownload)
  anno <- lapply(bar,synGetAnnotations)
  save(foo,bar,anno,file=paste0('ampAdCrawled',Sys.Date(),'.rda'))
}
