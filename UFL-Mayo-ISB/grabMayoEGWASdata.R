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
gwas_cov_syn <- synGet('syn3205821',downloadLocation='./')
cat("Downloading Mayo EGWAS Cerebellum expression data\n")
egwas_cere <- synGet('syn3256501',downloadLocation='./')
cat("Downloading Mayo EGWAS Cerebellum expression data covariates\n")
egwas_cere_cov<-synGet('syn3256502',downloadLocation='./')
cat("Downloading Mayo EGWAS Temporal Cortex expression data\n")
egwas_tcx <- synGet('syn3256507',downloadLocation='./')
cat("Downloading Mayo EGWAS Temporal Cortex expression data covariates\n")
egwas_tcx_cov <- synGet('syn3256508',downloadLocation='./')

#read in covariate files
cere_cov <- read.csv(egwas_cere_cov@filePath,header=T,stringsAsFactors=F)
tcx_cov <- read.csv(egwas_tcx_cov@filePath,header=T,stringsAsFactors=F)
gwas_cov <- read.csv(gwas_cov_syn@filePath,header=T,stringsAsFactors=F)
cere_keep <- cere_cov$IID%in%gwas_cov$IID
tcx_keep <- tcx_cov$IID%in%gwas_cov$IID

#read in expression data for cerebellum
mayo_egwas_cere_data <- read.csv(egwas_cere@filePath,header=T)
mayo_egwas_cere_data <- mayo_egwas_cere_data[cere_keep,]

mayo_egwas_tcx_data <- read.csv(egwas_tcx@filePath,header=T)
mayo_egwas_tcx_data <- mayo_egwas_tcx_data[tcx_keep,]

cere_cov <- cere_cov[cere_keep,]
tcx_cov <- tcx_cov[tcx_keep,]

ind1 <- 1:nrow(gwas_cov);
names(ind1) <- as.character(gwas_cov$IID)

ind2 <- 1:nrow(cere_cov)
names(ind2) <- as.character(cere_cov$IID)

ind3 <- 1:nrow(tcx_cov)
names(ind3) <- as.character(tcx_cov$IID)

cereSamples <- intersect(as.character(cere_cov$IID),as.character(gwas_cov$IID))
tcxSamples <- intersect(as.character(tcx_cov$IID),as.character(gwas_cov$IID))

gwas_tcx_cov <- gwas_cov[ind1[tcxSamples],]
gwas_cere_cov <- gwas_cov[ind1[cereSamples],]

cere_cov <- cere_cov[ind2[cereSamples],]
tcx_cov <- tcx_cov[ind3[tcxSamples],]

mayo_egwas_cere_data <- mayo_egwas_cere_data[ind2[cereSamples],]
mayo_egwas_tcx_data <- mayo_egwas_tcx_data[ind3[tcxSamples],]

#write ids
write.table(cere_cov[,1:2],file='cerebellumIds.txt',sep=' ',quote=F,row.names=F,col.names=F)
write.table(tcx_cov[,1:2],file='temporalcortexIds.txt',sep=' ',quote=F,row.names=F,col.names=F)

keepObj <- c('gwas_tcx_cov','gwas_cere_cov','cere_cov','tcx_cov','mayo_egwas_cere_data','mayo_egwas_tcx_data')

#remove non-essential data frames
rm(list=ls()[!ls()%in%keepObj])
gc()

#save data
save.image(file='mayoEGWASdata.rda')

#run plink command to filter genotypes based on shared ids
#system('../extractIndividuals.sh')

#read in genotypes into R

#