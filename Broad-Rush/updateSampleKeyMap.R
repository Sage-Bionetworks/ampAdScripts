###script to update the sample key files


######migrate new data file
require(gdata)

require(synapseClient)
synapseLogin()
foo <- synGet('syn5218321')

bar <- read.xls(foo@filePath)
bar[1:5,]

#get current sample Key
currentKeyObj <- synGet('syn3382527')

currentKey <- read.csv(currentKeyObj@filePath,header=T,stringsAsFactors = F)
currentKey[1:5,]

#add in chip seq ids
chipSeqNames <- synQuery('select name,id from file where parentId==\'syn4896408\'')
chipSeqNames[1:5,]

convertToProjid <- function(x){
  foo <- strsplit(x,'\\.')[[1]][1]
  return(foo)
}

require(dplyr)

projidChipSeq <- sapply(chipSeqNames$file.name,convertToProjid) %>% as.integer
chipSeqNames <- cbind(chipSeqNames,projidChipSeq)

chipSeqNames <- dplyr::filter(chipSeqNames, !is.na(projidChipSeq))
chipSeqNames <- dplyr::select(chipSeqNames,file.name,projidChipSeq)

colnames(currentKey)
colnames(chipSeqNames) <- c('chipseq_id','projid')
chipSeqNames[1:5,]

updatedKey <- merge(currentKey,chipSeqNames,by='projid',all=T)
updatedKey[1:5,]
dim(updatedKey)
dim(currentKey)

###add in REST ids
restObj <- synGet('syn5060666')
rest <- read.csv(restObj@filePath,header=T,stringsAsFactors = F)
setdiff(rest[,1],updatedKey$projid)

####NEED TO MIGRATE NEW CLINICAL FILE AND SYNC WITH CURRENT SAMPLE KEY 