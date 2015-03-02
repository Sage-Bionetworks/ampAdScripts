require(synapseClient)
synapseLogin()

#load data
load('mayoEGWASdata.rda')

#read in expression data for cerebellum
mayo_egwas_cere_data <- read.csv(egwas_cere@filePath,header=T)
mayo_egwas_cere_data <- mayo_egwas_cere_data[cere_keep,]

#read in cerebellum filtered genotype data for chromosome 22
mayo_geno_cere_22 <- read.table('cerebellumGenotypes/AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum_22.raw',header=T)

#run simple trans eQTL analyses



