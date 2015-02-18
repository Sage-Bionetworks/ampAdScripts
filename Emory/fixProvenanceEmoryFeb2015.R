require(synapseClient)
synapseLogin()

#clinical

emoryTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'Emory%\'',loadResult = TRUE)


for (i in 1:12){
  b <- synGet(emoryTable@values$newSynapseId[i],downloadFile = FALSE)
  if(i ==1){
   act <- Activity(name='Emory Clinical Reprocessing',used=list(list(entity=emoryTable@values$originalSynapseId[i],wasExecuted=F)),executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
} else if (i > 1 & i < 10){
  act <- Activity(name='Emory Raw Data Migration',
                  used=list(list(entity=emoryTable@values$originalSynapseId[i],wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
} else if (i == 10){
  act <- Activity(name='Emory Processed Data Migration',
                  used=as.list(c(emoryTable@values$originalSynapseId[i],(emoryTable@values$originalSynapseId[grep('7z',emoryTable@values$oldFileName)]),(emoryTable@values$originalSynapseId[grep('fasta',emoryTable@values$oldFileName)]))),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
  
} else if (i ==11){
  act <- Activity(name='Emory Processed Data Migration',
                  used=as.list(c(emoryTable@values$originalSynapseId[i],(emoryTable@values$originalSynapseId[grep('7z',emoryTable@values$oldFileName)]),(emoryTable@values$originalSynapseId[grep('fasta',emoryTable@values$oldFileName)]))),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
  
  
} else if (i == 12){
  act <- Activity(name='Emory Reference Data Migration',
                  used=list(list(entity=emoryTable@values$originalSynapseId[i],wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
}

act <- storeEntity(act)
generatedBy(b) <- act
b <- synStore(b)

}
