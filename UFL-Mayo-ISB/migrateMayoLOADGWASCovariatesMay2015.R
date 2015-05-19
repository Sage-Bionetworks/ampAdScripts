require(synapseClient)
synapseLogin()
#mayoTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'MayoCC GWAS Clinical%\'')

clinical <- synGet('syn3025476',downloadFile = T)
clinical2 <- synGet('syn3205821',downloadFile=F)
#clinical2 <- File(clinical@filePath,parentId='syn3157238')
clinical2@filePath <- clinical@filePath

#newFileName <- 'AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Covariates.csv'
act <- Activity(name='MayoLOADGWAS Covariate Data Migration',
                used=list(list(entity='syn3025476',wasExecuted=F)),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/UFL-Mayo-ISB/migrateMayoLOADGWASCovariatesMay2015.R"))
act <- storeEntity(act)
generatedBy(clinical2) <- act
clinical2 <- synStore(clinical2)
