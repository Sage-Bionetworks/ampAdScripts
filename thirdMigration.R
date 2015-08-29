#leave some breadcrumbs...

#mayo rnaseq
source('RFunctions/populateNewDirectory2.R')
source('RFunctions/makeNewFolder.R')
source('RFunctions/makeLink.R')
source('RFunctions/moveFile.R')
source('RFunctions/crawlSynapseObject.R')
source('RFunctions/makeHeadFolder.R')
source('RFunctions/adjacentEdges.R')
source('RFunctions/moveSingleFile.R')
source('Rfunctions/moveFolder2.R')


require(synapseClient)
######Mount Sinai RNA-seq Human
##count file
fileId <- 'syn4615144'
newFolderId <- 'syn3157743'
onWeb(fileId)
onWeb(newFolderId)
moveSingleFile(fileId,newFolderId)

##BAM files
internalFolder <- 'syn4883087'
internalParentFolder <- 'syn3104300'
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

######Mount Sinai RNA-seq Drosophila Data


######Mount Sinai MSBB WES Data
internalFolder <- 'syn4645334'
internalParentFolder <- 'syn3159428'
publicFolder <- 'syn3159438'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)

moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

#######Mount Sinai ROSMAP RNAseq data
internalFolder <- 'syn3537580'
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

#######Mount Sinai ROSMAP CEL Files
internalFolder <- 'syn4552659'
internalParentFolder <- 'syn3163721'
publicFolder <- 'syn3219494'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)

moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)


######Mount Sinai MSBB APOE
##count file
fileId <- 'syn4566005'
newFolderId <- 'syn3157743'
onWeb(fileId)
onWeb(newFolderId)
moveSingleFile(fileId,newFolderId)
