require(synapseClient)
synapseLogin()

#load data
load('mayoEGWASdata.rda')



cat('read in cerebellum filtered genotype data for chromosome 22\n')
mayo_geno_cere_22 <- read.table('cerebellumGenotypes/AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum_22.raw',header=T,stringsAsFactors = F)

reorderGenotypes <- function(x,y){
  ind2 <- 1:length(y)
  names(ind2)<-y
  return(ind2[x])
}

cat('synchronize sample ids in genotype data \n')
mayo_geno_cere_22 <- mayo_geno_cere_22[reorderGenotypes(cere_cov$IID,mayo_geno_cere_22$IID),]



