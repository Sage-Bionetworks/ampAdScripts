library(synapseClient)
library(plyr)
library(dplyr)
library(reshape2)

synapseLogin()

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

act <- Activity("")
# ## Cannot merge data as such, too large/too many copies of data in R
# ## Did it on belltown using the cmd line

# ## Make merged data
# mergedData <- ddply(resData, .(id), readData)
# mergedData$id <- NULL
# 
# ## sort annotations on probe TargetID
# mergedData <- arrange(mergedData, TargetID)
# 
# ## Write merged data
# 
# study <- "ROSMAP"
# center <- "Rush-Broad"
# platform <- "HumanMethylation450"
# other <- "740_imputed"
# extension <- "tsv"
# 
# newdatafilename <- paste(paste(study, center, platform, other, sep="_"),
#                          extension, sep=".")
