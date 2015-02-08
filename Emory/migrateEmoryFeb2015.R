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
#synList <- vector('list',nrow(emoryTable@values))
#grabAllEmoryData <- sapply(as.character(emoryTable@values$originalSynapseId),synGet)

#download the data

#define new names for each new file
#define parentid for each new file
#define annotations for each file
#define provenance for each file
#create new file
#upload file to new location with provenance
#update progress table with new parentid, new name, provenance, etc...

####SCRATCH
clinical <- synGet(emoryTable@values$originalSynapseId[12])
str <- paste('mv ',clinical@filePath,' ~/')
system(str)

