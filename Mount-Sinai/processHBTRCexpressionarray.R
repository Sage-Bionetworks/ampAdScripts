library(synapseClient)
library(plyr)
library(dplyr)
library(reshape2)

library(rGithubClient)

synapseLogin()

## Get this script
thisRepo <- getRepo("Sage-Bionetworks/ampAdScripts")
thisScript <- getPermlink(thisRepo, "Mount-Sinai/processHBTRCexpressionarray.R")

## Get files
alzfile <- synGet("syn2706445")
normfile <- synGet("syn2706448")
metafile <- synGet("syn3157400")

## Load files
alzdata <- read.delim(alzfile@filePath, check.names=FALSE)
normdata <- read.delim(normfile@filePath, check.names=FALSE)
metadata <- read.delim(metafile@filePath)

## Get meta cols
## I know by manual inspection that they are the first 10 cols
alzmetacolnames <- colnames(alzdata)[1:10]
normmetacolnames <- colnames(normdata)[1:10]

# Check that they're the same
all(alzmetacolnames == normmetacolnames)

# And check that they're in the same order based on reporterid
all(alzdata$reporterid == normdata$reporterid)

## Get sample cols - the rest of the columns
alzsamplecolnames <- colnames(alzdata)[11:ncol(alzdata)]
normsamplecolnames <- colnames(normdata)[11:ncol(normdata)]

## Update metadata with disease state
##### After doing this, there are a number of samples not in the alz or normal files
##### They all have has.expression == FALSE, but some have genotyped == TRUE
metadata <- transform(metadata, DiseaseStatus=NA)
metadata$DiseaseStatus[match(alzsamplecolnames, metadata$TID)] <- "Alzheimer's"
metadata$DiseaseStatus[match(normsamplecolnames, metadata$TID)] <- "Control"
metadata <- transform(metadata, DiseaseStatus=factor(DiseaseStatus))

mergeddata <- cbind(alzdata[, alzmetacolnames],
                    alzdata[, alzsamplecolnames],
                    normdata[, normsamplecolnames])
colnames(mergeddata) <- gsub("^X", "", colnames(mergeddata))

study <- "HBTRC"
center <- "MSSM"
platform <- "Agilent44Karray"
other <- "PFC_AgeCorrected_all"
extension <- "tsv"

## write data
newdatafilename <- paste(paste(study, center, platform, other, sep="_"),
                         "tsv", sep=".")

write.table(mergeddata, file=newdatafilename, sep="\t", row.names=FALSE, quote=FALSE)

syndatafile <- File(newdatafilename, parentId="syn3157688",
                name=paste(study, center, platform, other))

act <- Activity(name="Merge files", used=list(alzfile, normfile), executed=thisScript)
generatedBy(syndatafile) <- act

o <- synStore(syndatafile)

## write metadata
dataType <- "metaData"
extension <- "tsv"

newmetafilename <- paste(paste(study, center, dataType, sep="_"),
                         "tsv", sep=".")

write.table(metadata, file=newmetafilename, sep="\t", row.names=FALSE, quote=FALSE)

synmetafile <- File(newmetafilename, parentId="syn3157688",
                name=paste(study, center, platform, dataType))

act <- Activity(name="Merge files", used=list(metafile), executed=list(thisScript))
generatedBy(synmetafile) <- act

o <- synStore(synmetafile)
