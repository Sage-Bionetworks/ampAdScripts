require(synapseClient)
synapseLogin()
imputedFiles <- synQuery('select name,id from file where parentId==\'syn3300529\'')

parseFileName <- function(x){
  y <- unlist(strsplit(x,'-'))
  z <- unlist(strsplit(y,'\\.'))
  return(z[c(1,2,4)])
}

parsedNames <- t(sapply(imputedFiles[,1],parseFileName))

generateNewName <- function(parsedNames){
  internal <- function(x){
    return(paste0('AMP-AD_HBTRC_MSSM_IlluminaHumanHap650Y_',x[1],'_',x[2],'_',x[3],'.gz'))
  }
  return(apply(parsedNames,1,internal))
}

generateAnnotations <- function(parsedNames){
  internal <- function(x){
    annotation <- list(center='MSSM',
                       consortium='AMP-AD',
                       platform=c('IlluminaHumanHap650Y,Perlegen300Karray'),
                       fileType=x[3],
                       dataType='DNA',
                       study='HBTRC',
                       disease=c('Alzheimers Disease','Control'),
                       organism='Homo sapiens',
                       dataSubType='Imputed Genotype')
    return(annotation)
  }
  res <- apply(parsedNames,1,internal)
  return(res)
}


Activity(name='UFL Tau RNAseq Data Migration',
         used=list(list(entity=mayoTable@values$originalSynapseId[i],wasExecuted=F)),
         executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateUFLTauFeb2015.R"))

generateProvenance <- function(){
  require(synapseClient)
  act <- Activity(name='HBTRC Genotype Imputation',
                  used=list(list(entity='syn3169561',wasExecuted=F),list(entity='syn3169563',wasExecuted=F),list(entity='syn3169565',wasExecuted=F)),
                  executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/"))
}


newNames <- generateNewName(parsedNames)
newAnnotations <- generateAnnotations(parsedNames)
  


