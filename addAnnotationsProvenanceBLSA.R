####R script to add annotations and provenance to BLSA files.

library(devtools)
install_github('Sage-Bionetworks/rSynapseClient',ref='develop')

require(synapseClient)
synapseLogin()

#files in Analysis sub folder
#Analysis folder has syn ID:
parentId <- 'syn3607470'

#this sql query grabs all the files that are present in the analysis folder:
files <- synQuery(paste0('select name,id from file where parentId==\'',parentId,'\''))

#we define annotations, please update these as necessary to indicate the various aspects of the data
baseAnnotation<- list(
  dataType = 'Protein',
  disease = c('Alzheimers Disease','Control'),
  platform = 'QEPLUS',
  tissueType = 'Medial Frontal Gyrus',
  center = 'Emory',
  study = 'BLSA',
  fileType = 'tsv',
  organism = 'Homo sapiens'
)

#next we set the annotations to reflect each file
#to do so we first grab the file, but do not download it

synFile <- synGet(files$file.id[1],downloadFile = F)


#next, we set the annotations we defined above to the file:
synSetAnnotations(synFile) <- baseAnnotations

#finally, we push the metadata about the file back to Synapse
synFile <- synStore(synFile)

#this should be repeated for all the files as necessary, except you may need to change certain annotations e.g. 

#baseAnnotation$fileType <- 'fasta'


#Next, we can set the provenance of a file.  First we need to grab all the raw data files:

parentId <- 'syn3606087'
rawfiles <- synQuery(paste0('select name,id from file where parentId==\'',parentId,'\''))

act <- Activity(name='Produce Processed Count File',
                used=as.list(rawfiles$file.id),
                executed=list("https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Emory/migrateEmoryFeb2015.R"))
act <- storeEntity(act)
generatedBy(b) <- act
b <- synStore(b)




#files in Methods sub folder
#one can easily do this for files in the Methods folder as well:

parentId <- 'syn3607471'
files <- synQuery(paste0('select name,id from file where parentId==\'',parentId,'\''))

#files in Rawfiles sub folder
#or the Rawfiles folder
parentId <- 'syn3606087'
files <- synQuery(paste0('select name,id from file where parentId==\'',parentId,'\''))



