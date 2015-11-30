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

#UPenn samples
#analysis folder: syn5297560
#raw file folder: syn5269001

###Broad-Rush
#######chip-seq
#raw data: syn4896408
#sample file: syn5218321
#need to merge chipseq/rest samples into combined sample file

###Mount Sinai School of Medicine
#WES BAMs/Reads: syn5012301
#MSMM: syn5053455
#MSDM BAMs: syn5012222, syn5012145
#MSSM samples sequenced at Mayo: syn3537577
#missing: new samples RNAseq/WES,merged clinical file.

###UFL-Mayo-ISB
#Mayo RNA-seq, Cerebellum: syn5049298
#Mayo samples sequenced at MSSM: syn5203272

###Harvard-MIT
#ROSMAP REST samples: syn4988746

###Lilly
#mouse microglial data: syn4883033



######Mount Sinai
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

#######Mount Sinai Drosophila Melanogaster
internalFolder <- 'syn4587607'
internalParentFolder <- 'syn3104334'
publicFolder <- 'syn2910257'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)

moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

#######Emory BLSA raw data
internalFolder <- 'syn4624471'
internalParentFolder <- 'syn4240350'
publicFolder <- 'syn3606087'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)

moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

######Emory Case Analysis

fileId <- 'syn4886804'
newFolderId <- 'syn3607470'
onWeb(fileId)
onWeb(newFolderId)
moveSingleFile(fileId,newFolderId)

#######Mayo UFL-ISB RNA-seq TCX

#first move outdated files to a separate folder

require(synapseClient)
synapseLogin()

foo <- Folder(name='Archived May Release Count Data',parentId='syn4239736')
foo <- synStore(foo)
filesToMove <- c('syn4239742','syn4239744','syn4239746','syn4239748')
temp<-sapply(filesToMove,moveFile,synGetProperty(foo,'id'))

#unlink i.e. a reverse migration
temp<-sapply(filesToMove,reverseLink)

#Now move BAMs
internalFolder <- 'syn4894912'
internalParentFolder <- 'syn4239736'
publicFolder <- 'syn3163039'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)

moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

#now move specific files
tcxFilesToMove <- c('syn4650257','syn4650265','syn4650258','syn4650430')
newFolderId <- 'syn3163039'

temp <- sapply(tcxFilesToMove,moveSingleFile,newFolderId)
onWeb(newFolderId)


######ROSMAP samples sequenced at Mayo

foo <- Folder(name='Archived May Release Count Data',parentId='syn3537579')
foo <- synStore(foo)
filesToMove <- c('syn3801377','syn3801548','syn3801636','syn3801467')
temp<-sapply(filesToMove,moveFile,synGetProperty(foo,'id'))


internalFolder <- 'syn3537579'
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

#delete archive data dummy internal folder with links
synDelete('syn4919310')

#delete count file link
synDelete('syn4919326')


#Mayo Pilot AD BAMS
internalFolder <- 'syn4518517'
internalParentFolder <- 'syn3578036'
publicFolder <- 'syn3157268'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)

moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)


#Mayo Pilot PSP BAMS
internalFolder <- 'syn4518661'
internalParentFolder <- 'syn3578037'
publicFolder <- 'syn3157268'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)

moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

#UFL APPms BAMs
internalFolder <- 'syn4486837'
internalParentFolder <- 'syn4240090'
publicFolder <- 'syn3435792'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)

moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

#UFL Taums Data
internalFolder <- 'syn4486995'
internalParentFolder <- 'syn2875335'
publicFolder <- 'syn3157183'

onWeb(internalFolder)
onWeb(internalParentFolder)
onWeb(publicFolder)

moveFolder2(internalFolder,publicFolder)
onWeb(publicFolder)
synObj <- crawlSynapseObject(internalFolder)
synObj <- makeHeadFolder(synObj,internalFolder)
synLinks <- populateNewDirectory2(internalParentFolder,synObj,topId=internalParentFolder)
onWeb(internalParentFolder)

#Mayo TLR4/5 data, 2015 data
tlrFilesToMove <- c('syn4921575','syn4885786','syn4885784')
newFolderId <- 'syn3157242'

temp <- sapply(tlrFilesToMove,moveFile,newFolderId)
onWeb(newFolderId)
