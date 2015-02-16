require(synapseClient)
synapseLogin()
migrateMayoRNAseq <- function(i,newFileName,newEntityName,other,disease){
  mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'Mayo%RNAseq\' and migrator=\'Ben\' and toBeMigrated=TRUE and isMigrated=FALSE',loadResult = TRUE)
  normalized <- synGet(mayoTable@values$originalSynapseId[i])
  system(paste('cp ',normalized@filePath,' ',newFileName,sep=''))

  b <- File(newFileName,parentId=mayoTable@values$newParentId[i],name=newEntityName)
  dataAnnotation <- list(
    dataType = 'mRNA',
    disease = disease,
    tissueType = 'Temporal Cortex',
    platform= 'IlluminaHiSeq2000',
    center = 'UFL-Mayo-ISB',
    study = 'MayoPilot',
    fileType = 'tsv',
    organism = 'human',
    other = other
  )
  synSetAnnotations(b) <- dataAnnotation
  act <- Activity(name='Mayo Pilot RNAseq Data Migration',
                  used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateMayoPilotRNAseqFeb2015.R"))
  act <- storeEntity(act)
  generatedBy(b) <- act
  b <- synStore(b)
  mayoTable@values$newSynapseId[i] <- b$properties$id
  wind <- is.na(mayoTable@values$newSynapseId)
  if(sum(wind)>0){
    mayoTable@values$newSynapseId[wind] <- ''
  }
  mayoTable@values$newFileName[i] <- newFileName
  mayoTable@values$isMigrated[i] <- TRUE
  mayoTable@values$hasAnnotation[i] <- TRUE
  mayoTable@values$hasProvenance[i] <- TRUE
  mayoTable <- synStore(mayoTable)
  system(paste0('rm ',newFileName))
}

migrateMayoRNAseq(1,'AMP-AD_MayoPilot_UFL-Mayo-ISB_IlluminaHiSeq2000_TemporalCortex_Alzheimer_GeneCounts.txt.gz','MayoPilot_UFL-Mayo-ISB_IlluminaHiSeq2000_TemporalCortex_Alzheimer_GeneCounts',other=c('geneCounts','Unnormalized'),disease = 'Alzheimers Disease')


migrateMayoRNAseq(2,'AMP-AD_MayoPilot_UFL-Mayo-ISB_IlluminaHiSeq2000_TemporalCortex_Alzheimer_TranscriptCounts.txt.gz','MayoPilot_UFL-Mayo-ISB_IlluminaHiSeq2000_TemporalCortex_Alzheimer_TranscriptCounts',other=c('geneCounts','Unnormalized'))
migrateMayoRNAseq(3,'AMP-AD_UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts.txt.gz','UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts',other=c('transcriptCounts','Unnormalized'))
migrateMayoRNAseq(4,'AMP-AD_UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_GeneCounts_Normalized.txt.gz','UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_GeneCounts_Normalized',other=c('geneCounts','Normalized'))
migrateMayoRNAseq(5,'AMP-AD_UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_GeneCounts_Transposed.txt.gz','UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_GeneCounts_Transposed',other=c('geneCounts','Unnormalized','Transposed'))
migrateMayoRNAseq(6,'AMP-AD_UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Normalized.txt.gz','UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Normalized',other=c('geneCounts','Normalized'))
migrateMayoRNAseq(7,'AMP-AD_UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed.txt.gz','UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed',other=c('geneCounts','Unnormalized','Transposed'))
migrateMayoRNAseq(8,'AMP-AD_UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed.txt.gz','UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed',other=c('geneCounts','Unnormalized','Transposed'))
migrateMayoRNAseq(9,'AMP-AD_UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed.txt.gz','UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed',other=c('geneCounts','Unnormalized','Transposed'))
migrateMayoRNAseq(10,'AMP-AD_UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed.txt.gz','UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed',other=c('geneCounts','Unnormalized','Transposed'))
migrateMayoRNAseq(11,'AMP-AD_UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed.txt.gz','UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed',other=c('geneCounts','Unnormalized','Transposed'))
migrateMayoRNAseq(12,'AMP-AD_UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed.txt.gz','UFL_UFL-Mayo-ISB_IlluminaHiSeq2000_Tau_TranscriptCounts_Transposed',other=c('geneCounts','Unnormalized','Transposed'))
