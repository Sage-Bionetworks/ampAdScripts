library(synapseUtilities)

crawledBroadRush <- synapseUtilities::crawlProject('syn2910268')

synapseUtilities::auditProject(crawledBroadRush,'syn5478487','syn2397881',auditName = 'AMP AD Audit Broad Rush')

synapseUtilities::auditSummaryByFolder(crawledBroadRush,'syn5577642','syn2397881',summaryName = 'AMP AD Broad Rush Summary')

synIdAudit <- 'syn5577642'
foo <- synapseClient::synTableQuery(paste0('select * from ',synIdAudit))
hasInd <- grep('has',colnames(foo@values))
valueInd <- grep('ValueIn',colnames(foo@values))
annotationAuditDataFrame <- foo@values


annotationAuditFolderSummary <- dplyr::filter(annotationAuditDataFrame,entityType=='Folder') %>%
  dplyr::select(synapseID)

annotationAuditFolderSummary$meanChildFilehasAnnotation <- rep(NA,nrow(annotationAuditFolderSummary))
annotationAuditFolderSummary$totalChildFilehasAnnotation <- rep(NA,nrow(annotationAuditFolderSummary))
annotationAuditFolderSummary$meanhasMinimumNecessaryAnnotations <- rep(NA,nrow(annotationAuditFolderSummary))
annotationAuditFolderSummary$totalhasMinimumNecessaryAnnotations <- rep(NA,nrow(annotationAuditFolderSummary))
annotationAuditFolderSummary$meanDictionaryErrors <- rep(NA,nrow(annotationAuditFolderSummary))
annotationAuditFolderSummary$totalDictionaryErrors <- rep(NA,nrow(annotationAuditFolderSummary))


rownames(annotationAuditDataFrame) <- annotationAuditDataFrame$synapseID
for (i in 1:nrow(annotationAuditFolderSummary)){
  children <- crawledProject$adjList[[annotationAuditFolderSummary$synapseID[i]]]
  if(length(children)>0){
    entityTypes <- crawledProject$type[crawledProject$id%in%children]
    w1 <- which(entityTypes=='org.sagebionetworks.repo.model.FileEntity')
    if(length(w1)>0){
      #print(children[w1])
      #print(annotationAuditDataFrame[children[w1],3])
      annotationAuditFolderSummary$meanChildFilehasAnnotation[i] <- mean(annotationAuditDataFrame[children[w1],3])
      annotationAuditFolderSummary$totalChildFilehasAnnotation[i] <- sum(annotationAuditDataFrame[children[w1],3])
      annotationAuditFolderSummary$meanhasMinimumNecessaryAnnotations[i] <- annotationAuditDataFrame[children[w1],] %>% dplyr::select(hasconsortium,hascenter,hasstudy,hasdisease,hasassay,hasfileType,hasmodelSystem,hastissueType,hasorganism) %>%as.matrix %>% mean(na.rm=T)
      
      #annotationAuditDataFrame[children[w1],] %>% dplyr::select(hasconsortium,hascenter,hasstudy,hasdisease,hasassay,hasfileType,hasmodelSystem,hastissueType,hasorganism) %>% print
      annotationAuditFolderSummary$totalhasMinimumNecessaryAnnotations[i] <- annotationAuditDataFrame[children[w1],] %>% dplyr::select(hasconsortium,hascenter,hasstudy,hasdisease,hasassay,hasfileType,hasmodelSystem,hastissueType,hasorganism) %>%as.matrix %>% sum(na.rm=T)
      annotationAuditFolderSummary$meanDictionaryErrors[i] <- (!apply(annotationAuditDataFrame[children[w1],valueInd],2,as.logical)) %>%as.matrix %>% mean(na.rm=T)
      annotationAuditFolderSummary$totalDictionaryErrors[i] <- (!apply(annotationAuditDataFrame[children[w1],valueInd],2,as.logical)) %>%as.matrix %>% sum(na.rm=T)
    }
  }
}
