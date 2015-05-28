source('populateNewDirectory2.R')
source('makeNewFolder.R')
source('makeLink.R')
source('crawlSynapseObject.R')
source('makeHeadFolder.R')
#crawl folderA in projectD
synObj <- crawlSynapseObject('syn3157162')
synObj <- makeHeadFolder(synObj,'syn3157162')
populateNewDirectory2('syn3157160',synObj,topId = 'syn3157160')

