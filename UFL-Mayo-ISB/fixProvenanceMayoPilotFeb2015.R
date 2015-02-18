#source('RFunctions/crawlSynapseObject.R')
#source('RFunctions/adjacentEdges.R')
require(synapseClient)
synapseLogin()
res <- synQuery('SELECT id, name, concreteType FROM entity WHERE parentId=="syn3157268"')

for(i in 1:nrow(res)){
  b <- synGet(res$entity.id[i],downloadFile = FALSE)
  str <- paste0('select * from syn3163713 where newSynapseId=\'',res$entity.id[i],'\'')
  a <- synTableQuery(str)
  #a@values$newParentId <- 'syn3157268'
  
  if(nrow(a@values)>1){
    act <- Activity(name='Mayo Pilot Data Migration',
                  used=as.list(c(a@values$originalSynapseId)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateMayoPilotCovariatesFeb2015.R"))
  }else{
    act <- Activity(name='Mayo Pilot RNAseq Data Migration',
                    used=list(list(entity=a@values$originalSynapseId,wasExecuted=F)),
                    executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateMayoPilotRNAseqFeb2015.R"))    
  }
  act <- storeEntity(act)
  generatedBy(b) <- act
  b <- synStore(b)  
}

#for (i in 1:12){
#  str <- paste0('select * from syn3163713 where newSynapseId=\'',res$entity.id[1],'\'')
#  a <- synTableQuery(str)
#  a@values$newParentId <- 'syn3157268'
#  a <- synStore(a)
#}

res <- synQuery('SELECT id, name, concreteType FROM entity WHERE parentId=="syn3157238"')

for (i in 1:nrow(res)){
  b <- synGet(res$entity.id[i],downloadFile = FALSE)
  str <- paste0('select * from syn3163713 where newSynapseId=\'',res$entity.id[i],'\'')
  a <- synTableQuery(str)
  if (i==1){
    act <- Activity(name='Mayo GWAS Covariate Data Migration',
                    used=list(list(entity=a@values$originalSynapseId[i],wasExecuted=F)),
                    executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateMayoLOADGWASCovariatesFeb2015.R"))    
  }else{
    act <- Activity(name='Mayo GWAS Genotype Migration',
                    used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
                    executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateMayoGenotypesFeb2015.R"))    
  }
  
  act <- storeEntity(act)
  generatedBy(b) <- act
  b <- synStore(b)    
  
}

res <- synQuery('SELECT id, name, concreteType FROM entity WHERE parentId=="syn3157242"')

for (i in 1:nrow(res)){
  
  b <- synGet(res$entity.id[i],downloadFile = FALSE)
  str <- paste0('select * from syn3163713 where newSynapseId=\'',res$entity.id[i],'\'')
  a <- synTableQuery(str)
  
  act <- Activity(name='Mayo TLR Genotype Migration',
                used=list(list(entity=a@values$originalSynapseId,wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateMayoTLRGenotypesFeb2015.R"))
  act <- storeEntity(act)
  generatedBy(b) <- act
  b <- synStore(b)   
}

