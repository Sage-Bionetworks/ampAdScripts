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

##Broad MDMi data
synObj <- crawlSynapseObject('syn3607404')
synObj <- makeHeadFolder(synObj,'syn3607404')
mdmiF <- synGet('syn3607404',downloadFile=F)
anno <- synGetAnnotations(mdmiF)
mdmi <- synGet('syn3607432',downloadFile=F)
synSetAnnotations(mdmi)<- as.list(anno)
mdmi <- synStore(mdmi,forceVersion=F)
mdmi <- synGet('syn3607433',downloadFile=F)
synSetAnnotations(mdmi)<- as.list(anno)
mdmi <- synStore(mdmi,forceVersion=F)

synLinks <- populateNewDirectory2('syn2397884',synObj,topId='syn2397884')

##Broad iPSC data
synObj <- crawlSynapseObject('syn3607401')
synObj <- makeHeadFolder(synObj,'syn3607401')

mdmiF <- synGet('syn3607401',downloadFile=F)
anno <- synGetAnnotations(mdmiF)
mdmi <- synGet('syn3607402',downloadFile=F)
synSetAnnotations(mdmi)<- as.list(anno)
mdmi <- synStore(mdmi,forceVersion=F)
mdmi <- synGet('syn3607403',downloadFile=F)
synSetAnnotations(mdmi)<- as.list(anno)
mdmi <- synStore(mdmi,forceVersion=F)

synLinks <- populateNewDirectory2('syn2397884',synObj,topId='syn2397884')

##Broad miRNA data
mirnaf <- synGet('syn3387325',downloadFile=F)
anno <- synGetAnnotations(mirnaf)
mirna <- synGet('syn3387327',downloadFile=F)
synSetAnnotations(mirna) <- as.list(anno)
mirna <- synStore(mirna,forceVersion=F)

synObj <- crawlSynapseObject('syn3387325')
synObj <- makeHeadFolder(synObj,'syn3387325')
synLinks <- populateNewDirectory2('syn2700793',synObj,topId='syn2700793')

##HBTRC imputed genotype data
synObj <- crawlSynapseObject('syn3981980')
synObj <- makeHeadFolder(synObj,'syn3981980')
synLinks <- populateNewDirectory2('syn3104310',synObj,topId='syn3104310')

##move apoe genotypes
#move broad-rush covariates
synObj <- File('~/Desktop//AMP-AD_ROSMAP_Myers-RUSH-NIAGADS_Covariates.csv',parentId='syn3800853')
anno <- list(center='Myers-NIAGADS',
             dataType='Covariates',
             consortium='AMP-AD',
             fileType='csv',
             study='ROSMAP',
             disease='Alzheimers Disease, Control',
             organism='Homo Sapiens')

synSetAnnotations(synObj) <- anno
synObj <- synStore(synObj)

#move .bam files

synObj <- crawlSynapseObject('syn4055270')
synObj <- makeHeadFolder(synObj,'syn4055270')
synLinks <- populateNewDirectory2('syn3104300',synObj,topId='syn3104310')