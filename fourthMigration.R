source('RFunctions/populateNewDirectory2.R')
source('RFunctions/makeNewFolder.R')
source('RFunctions/makeLink.R')
source('RFunctions/moveFile.R')
source('RFunctions/crawlSynapseObject.R')
source('RFunctions/makeHeadFolder.R')
source('RFunctions/adjacentEdges.R')
source('RFunctions/moveSingleFile.R')
source('Rfunctions/moveFolder2.R')
source('Rfunctions/reverseLink.R')
require(synapseClient)


###Emory Data

#Emory samples
#analysis folder: syn5297557
#raw file folder: syn5224100
#destination folder: syn3218563

internalFolder <- 'syn5297557'
internalParentFolder <- 'syn5297555'
publicFolder <- 'syn3218563'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

internalFolder <- 'syn5224100'
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

#UPenn samples
#analysis folder: syn5297563
#raw file folder: syn5269001
#destination folder: syn5477237

internalFolder <- 'syn5297563'
internalParentFolder <- 'syn5297560'
publicFolder <- 'syn5477237'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

internalFolder <- 'syn5269001'
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

toBeMadePublic<- c('syn5297557','syn5224100','syn5297563','syn5269001')
sapply(toBeMadePublic,onWeb)


###Broad-Rush
#######chip-seq
#raw data: syn4896408
#sample file: syn5218321
#need to merge chipseq/rest samples into combined sample file


internalFolder <- 'syn4896408'
internalParentFolder <- 'syn2700793'
publicFolder <- 'syn3219045'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)



#REST data
fileId <- 'syn5060666'
newFolderId <- 'syn5477198'
onWeb(fileId)
onWeb(newFolderId)
moveSingleFile(fileId,newFolderId)


###Mount Sinai School of Medicine
#WES BAMs/Reads: syn5012301
#MSMM: syn5053455
#MSDM BAMs: syn5012222, syn5012145
#MSSM samples sequenced at Mayo: syn3537577

#mouse data
internalFolder <- 'syn5053455'
internalParentFolder <- 'syn4560807'
publicFolder <- 'syn5477220'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)


#drosophila data
internalFolder <- 'syn5012145'
internalParentFolder <- 'syn4915888'
publicFolder <- 'syn4636321'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)


internalFolder <- 'syn5012222'
internalParentFolder <- 'syn4915885'
publicFolder <- 'syn4636364'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

#syn5012301
#syn4913873
#syn4645334

internalFolder <- 'syn5012301'
internalParentFolder <- 'syn4913873'
publicFolder <- 'syn4645334'
onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

#syn5203272
#syn2924460
#syn3157743
internalFolder <- 'syn5203272'
internalParentFolder <- 'syn2924460'
publicFolder <- 'syn3157743'
onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)


fileId <- 'syn4737112'
newFolderId <- 'syn5512003'
onWeb(fileId)
onWeb(newFolderId)
moveSingleFile(fileId,newFolderId)


####HOLD
fileId <- 'syn5475828'
newFolderId <- 'syn5512003'
onWeb(fileId)
onWeb(newFolderId)
moveSingleFile(fileId,newFolderId)

fileId <- 'syn4737058'
newFolderId <- 'syn5512003'
onWeb(fileId)
onWeb(newFolderId)
moveSingleFile(fileId,newFolderId)


fileId <- 'syn5475826'
newFolderId <- 'syn3157743'
onWeb(fileId)
onWeb(newFolderId)
moveSingleFile(fileId,newFolderId)



#missing: new samples RNAseq/WES,merged clinical file.

###UFL-Mayo-ISB
#Mayo RNA-seq, Cerebellum: syn5049298
#Mayo samples sequenced at MSSM: syn5203272



internalFolder <- 'syn5049298'
internalParentFolder <- 'syn2924460'
publicFolder <- 'syn2910255'
onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

internalFolder <- 'syn3537578'
internalParentFolder <- 'syn2924460'
publicFolder <- 'syn2910255'
onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

###Lilly
#mouse microglial data: syn4883033

#bam data syn5053443
#meta data syn5053445
#count file syn5509955

internalFolder <- 'syn5053443'
internalParentFolder <- 'syn4883033'
publicFolder <- 'syn5478323'
onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)


internalFolder <- 'syn5053445'
internalParentFolder <- 'syn4883033'
publicFolder <- 'syn5478323'
onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)
moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)


fileId <- 'syn5509955'
newFolderId <- 'syn5478323'
onWeb(fileId)
onWeb(newFolderId)
moveSingleFile(fileId,newFolderId)
