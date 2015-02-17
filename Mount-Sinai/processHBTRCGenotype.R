# Move HBTRC genotype files
# These have a wiki that links to some other files
# This updates the provenance to link to the folder containing those files
# Then, copy the files to their new location, and link them via provenance

library(synapseClient)
library(plyr)
library(dplyr)
library(rGithubClient)
library(tools)
synapseLogin()

## Get this script
thisRepo <- getRepo("Sage-Bionetworks/ampAdScripts")
thisScript <- getPermlink(thisRepo, "Mount-Sinai/processHBTRCGenotype.R")

masterTable <- synGet("syn3163713")

# Query for the genotype files
q <- sprintf("SELECT * FROM %s WHERE data='HBTRC Genotype' AND originalParentId='syn3104310'", 
             masterTable@properties$id)

res <- synTableQuery(q)

# Get the files
synobjs <- dlply(res@values, .(originalSynapseId), function(x) synGet(x$originalSynapseId))

# The wiki for the original parentId has a description saying that the files at syn2231002 were used
# Update the provenance for these three to point to that directory

updateUsedProv <- function(x, usedId) {
  act <- Activity(name="Used", used=list(usedId))
  generatedBy(x) <- act
  x <- synStore(x)
  x
}

filePath <- function(x) x@filePath

usedId <- "syn2231002"
synobjs <- llply(synobjs, updateUsedProv, usedId=usedId)

## Now, copy the files to their new location with new names
newParentId <- "syn3157694"

consortium <- "AMP-AD"
study <- "HBTRC"
center <- "MSSM"

# Has two potential platforms; using one for filename, but annotating with both
platform_for_name <- "IlluminaHumanHap650Y"
platform <- c("IlluminaHumanHap650Y", "Perlegen300Karray")

disease <- c("Alzheimer's Disease", "Control")
organism <- "human"
dataType <- "DNA"

## write data
newName <- paste(consortium, study, center, platform_for_name, sep="_")
newAnnotations <- list(consortium=consortium, study=study, center=center, platform=platform, 
                       dataType=dataType, organism=organism, disease=disease)

copyFile <- function(o, newParentId, newName, newAnnotations) {
  extension  <- file_ext(o@filePath)
  newFilename <- paste(newName, extension, sep=".")
  newFilePath <- paste("/tmp/", newFilename, sep="")
  file.copy(o@filePath, newFilePath)
  newo <- File(newFilePath, name=newFilename, parentId=newParentId)
  
  act <- Activity(name="Migrate", used=list(o@properties$id), executed=list(thisScript))
  generatedBy(newo) <- act
  
  synSetAnnotations(newo) <- list(consortium=consortium, study=study, center=center, platform=platform, 
                                  dataType=dataType, organism=organism, disease=disease, fileType=extension)
  
  newo <- synStore(newo)
}

newobjs <- llply(synobjs, copyFile, newParentId=newParentId, newName=newName, newAnnotations=newAnnotations)

res@values$newParentId <- newParentId
res@values$isMigrated <- TRUE
res@values$hasAnnotation <- TRUE
res@values$hasProvenance <- TRUE

res@values$newSynapseId <- laply(newobjs, function(x) x@properties$id)
res@values$newFileName <- laply(newobjs, function(x) basename(x@filePath))

synStore(res)
