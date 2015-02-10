
require(synapseClient)
synapseLogin()

##query master table for emory files
rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP%\'',loadResult = TRUE)
fileOrganization <- unique(rosmapTable@values$data)

#syn3157275 (Methylation)
#syn3157322 (Clinical)
#syn3157325 (genotype)
#syn3157329 (imputed genotype)

rosmapTable@values$newParentId[rosmapTable@values$data=='ROSMAP Methylation'] <- 'syn3157275'
rosmapTable@values$toBeMigrated[rosmapTable@values$data=='ROSMAP Methylation'] <- TRUE
rosmapTable@values$newParentId[rosmapTable@values$data=='ROSMAP Clinical'] <- 'syn3157322'
rosmapTable@values$toBeMigrated[rosmapTable@values$data=='ROSMAP Clinical'] <- TRUE
rosmapTable@values$newParentId[rosmapTable@values$data=='ROSMAP Genotypes'] <- 'syn3157325'
rosmapTable@values$toBeMigrated[rosmapTable@values$data=='ROSMAP Genotypes'] <- TRUE

rosmapTable@values$newParentId[rosmapTable@values$data=='ROSMAP Imputed Genotypes'] <- 'syn3157329'
rosmapTable@values$toBeMigrated[rosmapTable@values$data=='ROSMAP Imputed Genotypes'] <- TRUE

rosmapTable@values$newParentId[rosmapTable@values$data=='ROSMAP Imputed Genotypes CHOP'] <- 'syn3157329'
rosmapTable@values$toBeMigrated[rosmapTable@values$data=='ROSMAP Imputed Genotypes CHOP'] <- FALSE
rosmapTable@values$newSynapseId <- 'syn3157329'

rosmapTable <- synStore(rosmapTable)

#for (i in fileOrganization){
#  rosmapTable@values$newParentId[rosmapTable@values$data==i] <
#}

#wclin <- grep('.xls',rosmapTable@values$oldFileName)


#scratch
rosmapClinical <- synGet(rosmapTable@values$originalSynapseId[wclin])
rosmapClinicalFP <- gsub(' ','',rosmapClinical@filePath)
rosmapClinicalFP <- gsub(' ','\\\\ ',rosmapClinical@filePath)
rosmapClinical@filePath
str <- paste('cp ',rosmapClinicalFP,' ~/',sep='')
cat(str,'\n')
system(str)

rosmapClinical <- read.csv('~/Scratch/GWASAutopsyCases07-2014.csv')

cleanRosmapClinical <- function(){
  #make AD case status (name: neuropathology)
  #msex: sex, values {Male, Female, NA}
  #apoe, values:{E2E2,E2E3,E3E3,E3E4,E4E4}
}