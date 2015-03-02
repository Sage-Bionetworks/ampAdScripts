require(synapseClient)
synapseLogin()

#load data
load('mayoEGWASdata.rda')

#read in filtered genotype data
mayo_geno_cere <- read.table('AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum.raw',header=T,row.names=F)
