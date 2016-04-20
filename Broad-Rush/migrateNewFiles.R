library(synapseClient)
synapseLogin()

#migrate raw methlyathion data.
library(rSynapseUtilities)

#update annotations
#update filename
#push to appropriate folder in portal

fileId <- 'syn5850422'
foo <- synGet(fileId,downloadFile=F)
annotations(foo)
annotations(foo) <- list(center='Broad-Rush',
                         consortium='AMP-AD',
                         platform='IlluminaHumanMethlation450',
                         fileType='raw',
                         dataType='methylation',
                         assay='arrayMethylation',
                         tissueOfOrigin='dorsolateralPrefrontalCortex',
                         tissueTypeAbrv='DLPFC',
                         study='ROSMAP',
                         organism='HomoSapiens',
                         modelSystem='FALSE')

synSetProperty(foo,'name') <- 'ROSMAP_arrayMethylation_raw.gz'
synSetProperty(foo,'fileNameOverride') <- 'ROSMAP_arrayMethylation_raw.gz'
synStore(foo,forceVersion=F)
#synSetProperty(foo,'parentId') <- 'syn3157275'

newFolderId <- 'syn3157275'
onWeb(fileId)
onWeb(newFolderId)
rSynapseUtilities::moveSingleFile(fileId,newFolderId)


fileId <- 'syn5843544'
onWeb(fileId)
foo <- synGet(fileId,downloadFile=F)
annotations(foo) <- list(center='Broad-Rush',
                         consortium='AMP-AD',
                         platform='IlluminaHumanMethlation450',
                         fileType='tsv',
                         dataType='covariates',
                         assay='arrayMethylation',
                         tissueOfOrigin='dorsolateralPrefrontalCortex',
                         tissueTypeAbrv='DLPFC',
                         study='ROSMAP',
                         organism='HomoSapiens',
                         modelSystem='FALSE')

synSetProperty(foo,'name') <- 'ROSMAP_arrayMethylation_covariates.tsv'
synSetProperty(foo,'fileNameOverride') <- 'ROSMAP_arrayMethylation_covariates.tsv'
synStore(foo,forceVersion=F)

newFolderId <- 'syn3157275'
onWeb(fileId)
onWeb(newFolderId)
rSynapseUtilities::moveSingleFile(fileId,newFolderId)




#move all bam files to the following folder:

chipSeqBamDF <- synQuery('select name,id from file where parentId==\'syn4896408\' and fileType==\'bam\'') 
  
foobar<-sapply(chipSeqBamDF$file.id,rSynapseUtilities::moveFile,'syn5958425')


onWeb('syn5958425')


fileId <- 'syn5706552'
onWeb(fileId)

library(xlsx)
foo <- synGet(fileId)
bar <- read.xlsx(foo@filePath,sheetName = 'Samples')
colnames(bar) <- c('SampleID','TotalReads','MappedReads','MappedReadsPercentage','UniquelyMappedReads','UniquelyMappedReadsPercentage','UniquelyMappedUniqueReads','UniquelyMappedUniqueReadsPercentage','NonRedundantFraction','CrossCorrelation','FragmentSize','Pool')
write.csv(bar,file='ROSMAP_ChIPseq_metaData.csv',quote=F,row.names=F)

foobar <- File('ROSMAP_ChIPseq_metaData.csv',parentId='syn4896408')
annotations(foobar) <- list(center='Broad-Rush',
                            consortium='AMP-AD',
                            fileType='csv',
                            dataType='metaData',
                            assay='ChIPseq',
                            tissueOfOrigin='dorsolateralPrefrontalCortex',
                            tissueTypeAbrv='DLPFC',
                            study='ROSMAP',
                            organism='HomoSapiens',
                            modelSystem='FALSE')

annotations(foobar)
