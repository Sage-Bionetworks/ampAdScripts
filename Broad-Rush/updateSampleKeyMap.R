###script to update the sample key files


######migrate new data file
require(gdata)

require(synapseClient)
synapseLogin()
foo <- synGet('syn5218321')

bar <- read.xls(foo@filePath)
bar$age_first_ad_dx[bar$age_first_ad_dx>=90] <- '90+'
bar$age_death[bar$age_death>=90] <- '90+'
bar$age_at_visit_max[bar$age_at_visit_max>=90] <- '90+'

write.csv(bar,file='AMP-AD_ROSMAP_Rush-Broad_Clinical.csv',quote=F)
foo <- synGet('syn3191087',downloadFile=F)
foo@filePath='./AMP-AD_ROSMAP_Rush-Broad_Clinical.csv'
foo <- synStore(foo,
                used=as.list('syn5218321'),
                executed=as.list('https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Broad-Rush/updateSampleKeyMap.R'))
#news

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
rest2 <- rest[-1,]
rest2 <- cbind(rest2[,1],rest2[,1])
rest2[1:5,]
colnames(rest2) <- c('projid','rest_id')
rest2[1:5,]

updatedKey <- merge(updatedKey,rest2,by='projid',all=T)
updatedKey[is.na(updatedKey)] <- ''
updatedKey$chipseq_data = as.numeric(updatedKey$chipseq_id!='')
updatedKey$rest_data = as.numeric(updatedKey$rest_id!='')

myersDataObj <- synGet('syn4009614')
require(data.table)
myersData <- fread(myersDataObj@filePath,data.table=F)
dim(myersData)
fxn1 <- function(x){
  return(strsplit(x,'_')[[1]][2])
}
myers_id <- colnames(myersData)[-c(1:3)]
myers_projid <- sapply(myers_id,fxn1) %>% as.integer
myersData <- data.frame(projid=myers_projid,niagas_id=myers_id,stringsAsFactors = F)

fullUpdatedKey <- merge(updatedKey,myersData,by='projid',all=T)
fullUpdatedKey[is.na(fullUpdatedKey)] <- ''
fullUpdatedKey$niagas_data = as.numeric(fullUpdatedKey$niagas_id!='')

fullUpdatedKey[1:5,]
fullUpdatedKey[which(duplicated(fullUpdatedKey$projid)),]
fullUpdatedKey <- dplyr::select(fullUpdatedKey,projid,gwas_id,mwas_id,mrna_id,niagas_id,mirna_id,chipseq_id,rest_id,clinical_data,gwas_data,mwas_data,mrna_data,niagas_data,mirna_data,chipseq_data,rest_data)
write.csv(fullUpdatedKey,'AMP-AD_ROSMAP_Rush-Broad_IDKey.csv',quote=F)

currentKeyObj <- synGet('syn3382527',downloadFile=F)
currentKeyObj@filePath <- './AMP-AD_ROSMAP_Rush-Broad_IDKey.csv'
currentKeyObj <- synStore(currentKeyObj,
                          used=as.list(c('syn3382527','syn4009614','syn5060666','syn3382527','syn5218321')),
                          executed=as.list('https://github.com/Sage-Bionetworks/ampAdScripts/blob/master/Broad-Rush/updateSampleKeyMap.R'))
