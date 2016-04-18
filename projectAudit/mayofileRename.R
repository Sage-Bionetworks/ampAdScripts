#mayoFileRename script

crawledMayoLoadGwas <- synapseUtilities::crawlProject('syn5591675')

keepVec <- rep(TRUE,length(crawledMayoLoadGwas$name))
whichBam <- grep('bam',crawledMayoLoadGwas$anno)
keepVec[whichBam] <- FALSE
annos <- crawledMayoLoadGwas$anno[which(keepVec)]
fileNames <- crawledMayoLoadGwas$name[which(keepVec)]
ids <- crawledMayoLoadGwas$id[which(keepVec)]
ids <- ids[which(crawledMayoLoadGwas$type[which(keepVec)]=='org.sagebionetworks.repo.model.FileEntity')]
fileNames <- fileNames[which(crawledMayoLoadGwas$type[which(keepVec)]=='org.sagebionetworks.repo.model.FileEntity')]
annos <- annos[which(crawledMayoLoadGwas$type[which(keepVec)]=='org.sagebionetworks.repo.model.FileEntity')]
annos <- annos[1:52]
allfields <- unique(unlist(lapply(annos,names)))
#foobar <- plyr::ddply(.data=annos,.variables=allfields,.inform=TRUE)

fileNames <- fileNames[1:52]
ids <- ids[1:52]

matrixX <- matrix('',52,length(allfields))
rownames(matrixX) <- ids
colnames(matrixX) <- allfields
for(i in 1:52){
  matrixX[i,names(annos[[i]])] <- annos[[i]]
}
write.csv(matrixX,'~/Desktop/mayoloadgwasannotations.csv',quote=F)
write.csv(cbind(ids,fileNames),file='~/Desktop/mayoRename.csv',quote=F,row.names=FALSE)

crawledMayoRNAseq <- synapseUtilities::crawlProject('syn5550404')
keepVec <- rep(TRUE,length(crawledMayoRNAseq$name))
whichBam <- grep('bam',crawledMayoRNAseq$anno)
keepVec[whichBam] <- FALSE
annos <- crawledMayoRNAseq$anno[which(keepVec)]
fileNames <- crawledMayoRNAseq$name[which(keepVec)]
ids <- crawledMayoRNAseq$id[which(keepVec)]
ids <- ids[which(crawledMayoRNAseq$type[which(keepVec)]=='org.sagebionetworks.repo.model.FileEntity')]
fileNames <- fileNames[which(crawledMayoRNAseq$type[which(keepVec)]=='org.sagebionetworks.repo.model.FileEntity')]
annos <- annos[which(crawledMayoRNAseq$type[which(keepVec)]=='org.sagebionetworks.repo.model.FileEntity')]
allfields <- unique(unlist(lapply(annos,names)))
matrixX <- matrix('',8,length(allfields))
rownames(matrixX) <- ids
colnames(matrixX) <- allfields
for(i in 1:8){
  matrixX[i,names(annos[[i]])] <- annos[[i]]
}
write.csv(matrixX,'~/Desktop/mayornaseqannotations.csv',quote=F)
write.csv(cbind(ids,fileNames),file='~/Desktop/mayoRenameRnaseq.csv',quote=F,row.names=FALSE)


