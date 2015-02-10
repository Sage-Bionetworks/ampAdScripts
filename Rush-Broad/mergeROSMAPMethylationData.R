library(synapseClient)
library(plyr)
library(dplyr)
library(reshape2)

synapseLogin()

## Get this script
thisRepo <- getRepo("Sage-Bionetworks/ampAdScripts")
thisScript <- getPermlink(thisRepo, "Rush-Broad/mergeROSMAPMethylationData.R")

# Function to get all files from Synapse
readData <- function(x) {
  o <- synGet(x$id)
  # read.delim(o@filePath)
}

## Data in this folder
folderId <- "syn2701448"
q <- sprintf("select id,name from file where parentId=='%s'", folderId)
res <- tbl_df(synapseQuery(q))
colnames(res) <- gsub(".*\\.", "", colnames(res))

## Get list of annotation files
resAnnot <- filter(res, grepl("^ill450kAnno", name))

## Get list of data files
resData <- filter(res, grepl("^ill450kMeth", name))

## Make merged annotation
mergedAnnot <- ddply(resAnnot, .(id), readData)
mergedAnnot$id <- NULL

## sort annotations on probe TargetID
mergedAnnot <- arrange(mergedAnnot, TargetID)

## Write merged annotation
study <- "ROSMAP"
center <- "Rush-Broad"
platform <- "HumanMethylation450"
other <- "metaData"
extension <- "tsv"

newannotfilename <- paste(paste(study, center, platform, other, sep="_"),
                          "tsv", sep=".")

write.table(mergedAnnot, file=newannotfilename, sep="\t", row.names=FALSE, quote=FALSE)

synannotfile <- File(newannotfilename, parentId="",
	             name=paste(study, center, platform, other))

act <- Activity("Merge files", used=list(c(mergedAnnot$id)), executed=list(thisScript))

generatedBy(synannotfile) <- act

synannotobj <- synStore(synannotfile)
