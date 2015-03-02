require(synapseClient)
synapseLogin()

#load data
load('mayoEGWASdata.rda')



#read in cerebellum filtered genotype data for chromosome 22
mayo_geno_cere_22 <- read.table('cerebellumGenotypes/AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum_22.raw',header=T)

#run simple trans eQTL analyses



