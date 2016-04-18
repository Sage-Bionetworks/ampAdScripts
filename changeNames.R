##script to rename mayo files
require(synapseClient)
synapseLogin()


mayoRnaseqV2 <- read.csv('UFL-Mayo-ISB/mayoRenameRnaseqVersion2.csv',stringsAsFactors=F)
foo <- sapply(mayoRnaseqV2$ids,synGet,downloadFile=F)
rnaseqEntityTypes <- sapply(foo,synGetProperty,which='entityType')
mayoRnaseqV2b<-mayoRnaseqV2[grep('FileEntity',rnaseqEntityTypes),]
foob <- foo[grep('FileEntity',rnaseqEntityTypes)]
entityNames <- sapply(foob,synGetProperty,which='name')
for (i in 1:nrow(mayoRnaseqV2b)){
  foob[[i]]@properties$name <- mayoRnaseqV2b$proposedNewFileNames[i]
  foob[[i]]@properties$fileNameOverride <- mayoRnaseqV2b$proposedNewFileNames[i]
}
sapply(foob[-c(7,8)],synStore,forceVersion=F)


mayoLoadGwas <- read.csv('UFL-Mayo-ISB/mayoLoadGwasRenameVersion3.csv',stringsAsFactors=F)
foo <- sapply(mayoLoadGwas$ids,synGet,downloadFile=F)
rnaseqEntityTypes <- sapply(foo,synGetProperty,which='entityType')
mayoLoadGwas<-mayoLoadGwas[grep('FileEntity',rnaseqEntityTypes),]
foob <- foo[grep('FileEntity',rnaseqEntityTypes)]
entityNames <- sapply(foob,synGetProperty,which='name')
keep <- which(mayoLoadGwas$proposedNewFileNames!='DEPRECATED')
foob <- foob[keep]
mayoLoadGwas <- mayoLoadGwas[keep,]
for (i in 1:nrow(mayoLoadGwas)){
  foob[[i]]@properties$name <- mayoLoadGwas$proposedNewFileNames[i]
  foob[[i]]@properties$fileNameOverride <- mayoLoadGwas$proposedNewFileNames[i]
}
sapply(foob,synStore,forceVersion=F)
