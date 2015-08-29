###testing script

require(synapseClient)
synapseLogin()

#make a new project
foo <- Project(name='Synapse Functionality Testing')
foo <- synStore(foo)
synGetProperty(foo,'name')

bar <- Folder(name='Data Set 1',parentId = synGetProperty(foo,'id'))
bar <- synStore(bar)
bar2 <- Folder(name='Sub folder A',parentId = synGetProperty(bar,'id'))
bar2 <- synStore(bar2)

baz <- Folder(name='Data Set 2',parentId = synGetProperty(foo,'id'))
baz <- synStore(baz)
baz2 <- Folder(name='Sub folder B',parentId = synGetProperty(baz,'id'))
baz2 <- synStore(baz2)

#onWeb(synGetProperty(foo,'id'))

require(dplyr,quietly = T,warn.conflicts = F)
data1 <- data.frame(a=rnorm(10),b=rexp(10))
data2 <- data.frame(a=rnorm(10),b=rexp(10))

write.csv(data1,file='data1.csv',quote=F,row.names=F)
write.csv(data2,file='data2.csv',quote=F,row.names=F)

a <- File('data1.csv',parentId=synGetProperty(bar2,'id'))
b <- File('data2.csv',parentId=synGetProperty(baz2,'id'))

a <- synStore(a)
b <- synStore(b)

#onWeb(synGetProperty(bar,'id'))

#foo_acl <- synGetEntityACL(synGetProperty(foo,'id'))
#str(foo_acl)

source('RFunctions/populateNewDirectory2.R')
source('RFunctions/makeNewFolder.R')
source('RFunctions/makeLink.R')
source('RFunctions/moveFile.R')
source('RFunctions/crawlSynapseObject.R')
source('RFunctions/makeHeadFolder.R')
source('RFunctions/adjacentEdges.R')
source('RFunctions/moveSingleFile.R')
source('Rfunctions/moveFolder2.R')

moveSingleFile(synGetProperty(a,'id'),synGetProperty(baz,'id'))
moveSingleFile(synGetProperty(b,'id'),synGetProperty(bar,'id'))

#synDelete(synGetProperty(foo,'id'))
folderA <- 'syn4913728'
folderB <- 'syn4913729'
moveFolder2(folderA,folderB)
folderC <- 'syn4913727'
synObj <- crawlSynapseObject(folderA)
synObj <- makeHeadFolder(synObj,folderA)
synLinks <- populateNewDirectory2(folderC,synObj,topId=folderC)

#test reverse link
source('RFunctions/reverseLink.R')
reverseLink('syn4913741')

