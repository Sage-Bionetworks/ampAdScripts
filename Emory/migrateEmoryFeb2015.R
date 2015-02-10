#script to migrate emory preliminary data for February Results

#add annotations
#add provenance
#change file name to fit format:

#consortium_study_center_platform_other.extension

#consortium = AMP-AD
#study = Emory
#center = Emory
#platform = LTQOrbitrapXL
#extension = 7z, txt, fasta

require(synapseClient)
synapseLogin()

##query master table for emory files
emoryTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'Emory%\'',loadResult = TRUE)

#download the data
#grabAllEmoryData <- sapply(as.character(emoryTable@values$originalSynapseId),synGet)

#define new names for each new file


#define annotations for each file
#define provenance for each file
#create new file
#upload file to new location with provenance
#update progress table with new parentid, new name, provenance, etc...

####SCRATCH
#clinical <- synGet(emoryTable@values$originalSynapseId[12])
#str <- paste('cp ',clinical@filePath,' ~/')
#system(str)

#clean up clinical file done
  #write function to clean up clinical file done
    #rename columns done
    #fix NAs done
    #split race and sex column into two columns done
    #fill in neuropath information done
    #replace '/' with E in apoe done
    #remove spaces from caseNumber and proteomicsMS done


cleanEmoryClinical <- function(x){
  emoryClinical <- read.csv(x)
  colnames(emoryClinical) <- c('neuropathology','caseNumber','PMI','ageOfOnset','ageAtDeath','durationYr','apoe','race_sex','proteomicsMS')
  emoryClinical$PMI[grep("NA",emoryClinical$PMI)] <- NA
  race_sex <- emoryClinical$race_sex;
  race <- rep(NA,nrow(emoryClinical));
  sex <- rep(NA,nrow(emoryClinical));
  race[grep('a',race_sex)] <- 'Asian'
  race[grep('b',race_sex)] <- 'AfricanAmerican'
  race[grep('w',race_sex)] <- 'Caucasian'
  race[grep('h',race_sex)] <- 'Hispanic'
  sex[grep('w',race_sex)] <- 'Female'
  sex[grep('m',race_sex)] <- 'Male'
  emoryClinical <- data.frame(emoryClinical,race,sex)
  emoryClinical <- emoryClinical[,-8]
  emoryClinical$caseNumber <- gsub(' ','',emoryClinical$caseNumber)
  emoryClinical$proteomicsMS <- gsub(' ','',emoryClinical$proteomicsMS)
  emoryClinical$apoe <- gsub('/','E',emoryClinical$apoe)
  emoryClinical$neuropathology[grep('AD',emoryClinical$caseNumber)] <- 'AD'
  emoryClinical$neuropathology[grep('ADPD',emoryClinical$caseNumber)] <- 'ADPD'
  emoryClinical$neuropathology[grep('ALS',emoryClinical$caseNumber)] <- 'ALS'
  emoryClinical$neuropathology[grep('CBD',emoryClinical$caseNumber)] <- 'CBD'
  emoryClinical$neuropathology[grep('CONTROL',emoryClinical$caseNumber)] <- 'Control'
  emoryClinical$neuropathology[grep('FTDU',emoryClinical$caseNumber)] <- 'FTDU'
  emoryClinical$neuropathology[grep('MCI',emoryClinical$caseNumber)] <- 'MCI'
  emoryClinical$neuropathology[grep('PD',emoryClinical$caseNumber)] <- 'PD'
  return(emoryClinical)
}
  
emoryClinicalClean <- cleanEmoryClinical()
write.csv(emoryClinicalClean,file='Emory//processedEmoryPreliminaryClinical.csv',row.names=FALSE,quote=FALSE)

#move clinical to Table in staging

#tcresult<-as.tableColumns(emoryClinicalClean)
#cols<-tcresult$tableColumns
#fileHandleId<-tcresult$fileHandleId

#projectId<-'syn2580853'
#need to add appropriate acl!
#schema<-TableSchema(name="AMPAD_Emory_Emory_Clinical", parent=projectId, columns=cols)
#table<-Table(schema, fileHandleId)
#table<-synStore(table, retrieveData=TRUE)


  #change file name
  #add provenance
  #add annotations

#move clinical to csv in staging


####move raw count files


####move refseq mapped files


####move reference genome file

