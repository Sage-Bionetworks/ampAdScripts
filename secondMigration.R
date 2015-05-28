#leave some breadcrumbs...

#mayo rnaseq
source('RFunctions/populateNewDirectory2.R')
source('RFunctions/makeNewFolder.R')
source('RFunctions/makeLink.R')
source('RFunctions/crawlSynapseObject.R')
source('RFunctions/makeHeadFolder.R')
source('RFunctions/adjacentEdges.R')

##RNASEQ Mayo
synObj <- crawlSynapseObject('syn3163039')
synObj <- makeHeadFolder(synObj,'syn3163039')
synLinks <- populateNewDirectory2('syn2924460',synObj,topId='syn2924460')

##RNASEQ UFL App
synObj <- crawlSynapseObject('syn3435792')
synObj <- makeHeadFolder(synObj,'syn3435792')
synLinks <- populateNewDirectory2('syn2924458',synObj,topId='syn2924458')

##Emory
synObj <- crawlSynapseObject('syn3606086')
synObj <- makeHeadFolder(synObj,'syn3606086')
synLinks <- populateNewDirectory2('syn2920322',synObj,topId='syn2920322')

##Myers Data
synObj <- crawlSynapseObject('syn3800853')
synObj <- makeHeadFolder(synObj,'syn3800853')
synLinks <- populateNewDirectory2('syn2700793',synObj,topId='syn2700793')
