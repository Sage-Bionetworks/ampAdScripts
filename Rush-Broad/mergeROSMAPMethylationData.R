library(synapseClient)
library(plyr)
library(dplyr)
library(reshape2)
library(rGithubClient)

synapseLogin()

## Get this script
thisRepo <- getRepo("Sage-Bionetworks/ampAdScripts")
thisScript <- getPermlink(thisRepo, "Rush-Broad/mergeROSMAPMethylationData.R")

# Function to get all files from Synapse
readData <- function(x) {
  o <- synGet(x$id)
  read.delim(o@filePath)
}

## Data in this folder
folderId <- "syn2701448"
q <- sprintf("select id,name from file where parentId=='%s'", folderId)
res <- tbl_df(synapseQuery(q))
colnames(res) <- gsub(".*\\.", "", colnames(res))

## Get list of annotation files
resAnnot <- filter(res, grepl("^ill450kAnno", name))

## Make merged annotation
mergedAnnot <- ddply(resAnnot, .(id), readData)
mergedAnnot$id <- NULL

## sort annotations on chromosome and probe TargetID
mergedAnnot <- arrange(mergedAnnot, CHR, TargetID)

## Write merged annotation
consortium <- "AMP-AD"
study <- "ROSMAP"
center <- "Rush-Broad"
platform <- "IlluminaHumanMethylation450"
other <- "metaData"
extension <- "tsv"
tissueType <- "Dorsolateral Prefrontal Cortex"
tissueTypeAbrv <- "PFC"
organism <- "human"

newannotfilename <- paste(paste(consortium, study, center, platform, other, sep="_"),
                          "tsv", sep=".")

write.table(mergedAnnot, file=newannotfilename, sep="\t", row.names=FALSE, quote=FALSE)

synannotfile <- File(newannotfilename, parentId="",
	             name=paste(consortium, study, center, platform, other, sep="_"))

act <- Activity("Merge files", used=list(c(mergedAnnot$id)), executed=list(thisScript))

generatedBy(synannotfile) <- act
synSetAnnotations(synannotfile) <- list(consortium=consortium, study=study, center=center, platform=platform, 
                                        dataType="metaData", tissueType=tissueType, tissueTypeAbrv=tissueTypeAbrv,
                                        organism=organism)
synannotobj <- synStore(synannotfile)
