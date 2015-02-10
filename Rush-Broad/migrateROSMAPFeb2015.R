
require(synapseClient)
synapseLogin()

##query master table for emory files
rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP%\'',loadResult = TRUE)
wclin <- grep('.xls',rosmapTable@values$oldFileName)


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