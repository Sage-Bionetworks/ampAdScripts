library(synapseUtilities)

crawledBroadRush <- synapseUtilities::crawlProject('syn2910268')

synapseUtilities::auditProject(crawledBroadRush,'syn5478487','syn2397881',auditName = 'AMP AD Audit Broad Rush')

synapseUtilities::auditSummaryByFolder(crawledBroadRush,'syn5577642','syn2397881',summaryName = 'AMP AD Broad Rush Summary')


#grab table
require(synapseClient)
synapseLogin()
broadAudit <- synapseClient::synTableQuery('select * from syn5580335')
broadAudit@values[1:5,]

#syn3607432 - MDMi FPKM
require(dplyr)


auditValues <- dplyr::filter(broadAudit@values,synapseID=='syn3607432') %>% 
                dplyr::select(hasconsortium,hascenter,hasstudy,hasassay,hasfileType,hasmodelSystem,hastissueType,hasorganism)
synapseUtilities::updateAnnotations('syn3607432',c('fileType','modelSystem','tissueType','organism','assay','normalizationType','summaryLevel','dataType'),c('fpkm','TRUE','peripheralBloodMononuclearCells','HomoSapiens','RNAseq','FPKM','gene','mRNA'))
auditV<-synapseUtilities::auditSingleFile('syn3607432','syn5478487')

synId='syn3607433'
synapseUtilities::updateAnnotations(synId,c('fileType','modelSystem','tissueType','organism','assay','normalizationType','summaryLevel','dataType'),c('fpkm','TRUE','peripheralBloodMononuclearCells','HomoSapiens','RNAseq','FPKM','transcript','mRNA'))
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')


synId='syn3607402'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
synapseUtilities::updateAnnotations(synId,c('dataType','fileType','modelSystem','tissueType','organism','assay','normalizationType','summaryLevel'),c('mRNA','fpkm','TRUE','inducedPluripotentStemCells','HomoSapiens','RNAseq','FPKM','gene'))

synId='syn3607403'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
synapseUtilities::updateAnnotations(synId,c('dataType','fileType','modelSystem','tissueType','organism','assay','normalizationType','summaryLevel'),c('mRNA','fpkm','TRUE','inducedPluripotentStemCells','HomoSapiens','RNAseq','FPKM','transcript'))

synId=c('syn3221153','syn3221155','syn3221157')
auditV<-lapply(synId,synapseUtilities::auditSingleFile,'syn5478487')
auditV
synapseUtilities::updateAnnotations('syn3221153',c('consortium','assay','modelSystem'),c('AMP-AD','SNPgenotypes','FALSE'),'disease')
synapseUtilities::updateAnnotations('syn3221155',c('consortium','assay','modelSystem'),c('AMP-AD','SNPgenotypes','FALSE'),'disease')
synapseUtilities::updateAnnotations('syn3221157',c('consortium','assay','modelSystem'),c('AMP-AD','SNPgenotypes','FALSE'),'disease')

#rosmap clinical
synId = 'syn3191087'
auditV<-lapply(synId,synapseUtilities::auditSingleFile,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem'),c('AMP-AD','FALSE'),'disease')

#rosmap codebook
synId = 'syn3191090'
auditV<-lapply(synId,synapseUtilities::auditSingleFile,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem'),c('AMP-AD','FALSE'),'disease')


synId = 'syn3382527'
auditV<-lapply(synId,synapseUtilities::auditSingleFile,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem'),c('AMP-AD','FALSE'))

#imputed genotype data
synId=crawledBroadRush$adjList[['syn3157329']]
synIdfam <- synId[1:6]
synIdgeno <- synId[-c(1:6)]
auditV<-lapply(synId[1],synapseUtilities::auditSingleFile,'syn5478487')
auditV
lapply(synIdfam,synapseUtilities::updateAnnotations,c('consortium','modelSystem','assay','dataSubType','fileType','imputationReference'),c('AMP-AD','FALSE','SNPgenotypes','imputedGenotype','plink','1000genomes'),'disease')
lapply(synIdgeno,synapseUtilities::updateAnnotations,c('consortium','modelSystem','assay','dataSubType','fileType','imputationReference'),c('AMP-AD','FALSE','SNPgenotypes','imputedGenotype','dosage','1000genomes'),'disease')
auditV<-lapply(synId,synapseUtilities::auditSingleFile,'syn5478487')


synId='syn3387327'
auditV<-lapply(synId,synapseUtilities::auditSingleFile,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('assay','fileType','modelSystem'),c('arraymiRNA','gct','FALSE'))


#rnaseq files
synId=crawledBroadRush$adjList[['syn3388564']]
#crawledBroadRush$type[crawledBroadRush$id%in%synId]
auditV<-lapply(synId[3],synapseUtilities::auditSingleFile,'syn5478487')
auditV
#synapseUtilities::updateAnnotations(synId[1],c('assay','fileType','modelSystem','normalizationStatus','normalizationType','summaryLevel'),c('RNAseq','tsv','FALSE','TRUE','FPKM','gene'))
#synapseUtilities::updateAnnotations(synId[2],c('assay','fileType','modelSystem','normalizationStatus','normalizationType','summaryLevel'),c('RNAseq','tsv','FALSE','TRUE','FPKM','gene'))
#synapseUtilities::updateAnnotations(synId[3],c('assay','fileType','modelSystem','normalizationStatus','normalizationType','summaryLevel'),c('RNAseq','tsv','FALSE','FALSE','FPKM','gene'))
synapseUtilities::updateAnnotations(synId[4],c('assay','fileType','modelSystem','normalizationStatus','normalizationType','summaryLevel'),c('RNAseq','tsv','FALSE','TRUE','FPKM','transcript'))
synapseUtilities::updateAnnotations(synId[5],c('assay','fileType','modelSystem','normalizationStatus','normalizationType','summaryLevel'),c('RNAseq','tsv','FALSE','TRUE','FPKM','transcript'))
synapseUtilities::updateAnnotations(synId[6],c('assay','fileType','modelSystem','normalizationStatus','normalizationType','summaryLevel'),c('RNAseq','tsv','FALSE','FALSE','FPKM','transcript'))

synId=crawledBroadRush$adjList[['syn4299317']]
auditV<-lapply(synId,synapseUtilities::auditSingleFile,'syn5478487')
auditV
lapply(synId[1:8],synapseUtilities::updateAnnotations,c('assay','fileType','modelSystem'),c('RNAseq','csv','FALSE'))
lapply(synId[9],synapseUtilities::updateAnnotations,c('assay','fileType','modelSystem'),c('RNAseq','tsv','FALSE'))

synId=crawledBroadRush$adjList[['syn4228560']]
auditV<-lapply(synId,synapseUtilities::auditSingleFile,'syn5478487')
auditV
lapply(synId,synapseUtilities::updateAnnotations,c('tissueType'),c('peripheralBloodMononuclearCells'))


crawledBroadRush2 <- synapseUtilities::crawlProject('syn2910268')

synapseUtilities::auditProject(crawledBroadRush2,'syn5478487','syn2397881',auditName = 'AMP AD Audit Broad Rush V2')

synapseUtilities::auditSummaryByFolder(crawledBroadRush2,'syn5581337','syn2397881',summaryName = 'AMP AD Broad Rush Summary V2')

###########Mayo
synId='syn4921575'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
synapseUtilities::updateAnnotations(synId,c('consortium','center','study','assay','fileType','modelSystem','organism','dataType','platform'),c('AMP-AD','UFL-Mayo-ISB','MayoLOADGwas','SNPgenotypes','csv','FALSE','HomoSapiens','metaData','SequenomMultiplex'))

synId='syn4885786'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
synapseUtilities::updateAnnotations(synId,c('consortium','assay','modelSystem','platform'),c('AMP-AD','SNPgenotypes','FALSE','SequenomMultiplex'),'disease')

synId='syn4885784'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
synapseUtilities::updateAnnotations(synId,c('consortium','assay','modelSystem','platform'),c('AMP-AD','SNPgenotypes','FALSE','SequenomMultiplex'),'disease')

synId='syn3205829'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
synapseUtilities::updateAnnotations(synId,c('consortium','assay','modelSystem','platform'),c('AMP-AD','SNPgenotypes','FALSE','SequenomMultiplex'),'disease')

synId='syn3205832'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
synapseUtilities::updateAnnotations(synId,c('consortium','assay','modelSystem','platform'),c('AMP-AD','SNPgenotypes','FALSE','SequenomMultiplex'),'disease')

synId='syn3205834'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
synapseUtilities::updateAnnotations(synId,c('consortium','assay','modelSystem','platform'),c('AMP-AD','SNPgenotypes','FALSE','SequenomMultiplex'),'disease')



#mayo rna seq
synId='syn5223705'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','center','study','assay','fileType','modelSystem','tissueType','organism','dataType','tissueTypeAbrv','platform'),c('AMP-AD','UFL-Mayo-ISB','MayoRNAseq','RNAseq','csv','FALSE','cerebellum','HomoSapiens','metaData','CBE','IlluminaHiSeq2000'))

synId='syn5201007'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('study','assay','modelSystem','tissueTypeAbrv','normalizationStatus','normalizationType'),c('MayoRNAseq','RNAseq','FALSE','CBE','TRUE','CPM'))

synId='syn5201012'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('assay','modelSystem','tissueTypeAbrv','normalizationStatus'),c('RNAseq','FALSE','CBE','FALSE'))

synId='syn3205821'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','assay','modelSystem'),c('AMP-AD','SNPgenotypes','FALSE'))

synId='syn3205812'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','assay','modelSystem'),c('AMP-AD','SNPgenotypes','FALSE'),'disease')

synId='syn3205814'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','assay','modelSystem'),c('AMP-AD','SNPgenotypes','FALSE'),'disease')

synId='syn3205816'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','assay','modelSystem'),c('AMP-AD','SNPgenotypes','FALSE'),'disease')

#######mayo egwas analytical results
synId='syn3207163'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType','disease','dataSubType'),c('AMP-AD','FALSE','analysis','eQTL','AlzheimersDisease','genotype'))

synId='syn3207165'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType','dataSubType'),c('AMP-AD','FALSE','analysis','eQTL','genotype'),'disease')

synId='syn3207167'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType','dataSubType'),c('AMP-AD','FALSE','analysis','eQTL','genotype'))


synId='syn3207169'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType','dataSubType','disease'),c('AMP-AD','FALSE','analysis','eQTL','genotype','AlzheimersDisease'))

#######
synId='syn3207169'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType','dataSubType'),c('AMP-AD','FALSE','analysis','eQTL','genotype'))

synId='syn3207173'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType','dataSubType'),c('AMP-AD','FALSE','analysis','eQTL','genotype'),'disease')

synId='syn3207175'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType','dataSubType','disease'),c('AMP-AD','FALSE','analysis','eQTL','genotype','control'))

synId='syn3207177'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType'),c('AMP-AD','FALSE','analysis','eQTL'))

synId='syn3207179'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType'),c('AMP-AD','FALSE','analysis','eQTL'),'disease')

synId='syn3207181'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType'),c('AMP-AD','FALSE','analysis','eQTL'))

synId='syn3207183'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType'),c('AMP-AD','FALSE','analysis','eQTL'))

synId='syn3207185'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType'),c('AMP-AD','FALSE','analysis','eQTL'),'disease')

synId='syn3207187'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType'),c('AMP-AD','FALSE','analysis','eQTL'))

synId='syn3607497'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('consortium','modelSystem','dataType','analysisType'),c('AMP-AD','FALSE','analysis','eQTL'))

synId<-crawledMayo$adjList[['syn3157268']][-c(1:2)]

auditV<-lapply(synId,synapseUtilities::auditSingleFile,'syn5478487')
auditV
lapply(synId,synapseUtilities::updateAnnotations,c('consortium','modelSystem','assay'),c('AMP-AD','FALSE','RNAseq'))


synId<-crawledMayo$adjList[['syn3163039']][1:5]

auditV<-lapply(synId,synapseUtilities::auditSingleFile,'syn5478487')
auditV
lapply(synId,synapseUtilities::updateAnnotations,c('consortium','modelSystem','assay'),c('AMP-AD','FALSE','RNAseq'))


######################restart Mayo######################
crawledMayoLoadGwas <- synapseUtilities::crawlProject('syn5591675')
crawledMayoRNAseq <- synapseUtilities::crawlProject('syn5550404')


synapseUtilities::auditProject(crawledMayoLoadGwas,'syn5478487','syn2397881',auditName = 'AMP AD Audit Mayo LOAD GWAS')
synapseUtilities::auditSummaryByFolder(crawledMayoLoadGwas,'syn5594710','syn2397881',summaryName = 'AMP AD Mayo LOAD GWAS Summary')

synapseUtilities::auditProject(crawledMayoRNAseq,'syn5478487','syn2397881',auditName = 'AMP AD Audit Mayo RNAseq')
synapseUtilities::auditSummaryByFolder(crawledMayoRNAseq,'syn5594853','syn2397881',summaryName = 'AMP AD Mayo LOAD RNAseq Summary')

synId='syn3256501'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('assay','modelSystem'),c('arrayExpression','FALSE'),'disease')

synId='syn3256502'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('assay','modelSystem'),c('arrayExpression','FALSE'),'disease')

synId='syn3256507'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('assay','modelSystem'),c('arrayExpression','FALSE'),'disease')

synId='syn3256508'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('assay','modelSystem'),c('arrayExpression','FALSE'),'disease')

synId='syn3617056'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('assay','modelSystem'),c('arrayExpression','FALSE'),'disease')

synId='syn3617054'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV
synapseUtilities::updateAnnotations(synId,c('assay','modelSystem'),c('arrayExpression','FALSE'),'disease')

synId='syn5223705'
auditV<-synapseUtilities::auditSingleFile(synId,'syn5478487')
auditV

foo <- synapseUtilities::longQueries('select name,id from file where projectId==\'syn2580853\' and tissueType!=\'\'')
