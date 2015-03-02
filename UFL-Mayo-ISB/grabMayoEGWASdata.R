require(synapseClient)
synapseLogin()

cat("Making Directory for Analyses: MayoEGWASanalyses/\n")
dir.create('MayoEGWASanalyses/')
cat("Changing to Directory MayoEGWASanalyses/\n")
setwd('MayoEGWASanalyses')

cat("Downloading Mayo LOAD GWAS genotypes bed file\n")
gwas_bed<-synGet('syn3205812',downloadLocation = './')
cat("Downloading Mayo LOAD GWAS genotypes bim file\n")
gwas_bim <- synGet('syn3205814',downloadLocation = './')
cat("Downloading Mayo LOAD GWAS genotypes fam file\n")
gwas_fam <- synGet('syn3205816',downloadLocation= './')
cat("Downloading Mayo LOAD GWAS covariates file\n")
gwas_cov <- synGet('syn3205821',downloadLocation='./')
cat("Downloading Mayo EGWAS Cerebellum expression data\n")
egwas_cere <- synGet('syn3256501',downloadLocation='./')
cat("Downloading Mayo EGWAS Cerebellum expression data covariates\n")
egwas_cere_cov<-synGet('syn3256502',downloadLocation='./')
cat("Downloading Mayo EGWAS Temporal Cortex expression data\n")
egwas_tcx <- synGet('syn3256507',downloadLocation='./')
cat("Downloading Mayo EGWAS Temporal Cortex expression data covariates\n")
egwas_tcx_cov <- synGet('syn3256508',downloadLocation='./')

#read in covariate files
cere_cov <- read.csv(egwas_cere_cov@filePath,header=T)
tcx_cov <- read.csv(egwas_tcx_cov@filePath,header=T)
gwas_cov <- read.csv(gwas_cov@filePath,header=T)


#write ids
write.table(cere_cov[,1:2],file='cerebellumIds.txt',sep=' ',quote=F,row.names=F,col.names=F)
write.table(tcx_cov[,1:2],file='temporalcortexIds.txt',sep=' ',quote=F,row.names=F,col.names=F)

save.image(file='mayoEGWASdata.rda')

#run plink command to filter genotypes based on shared ids
#system('../extractIndividuals.sh')

#read in genotypes into R

#