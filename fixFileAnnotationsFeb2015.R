require(synapseClient)
synapseLogin()
res <- synQuery('select name, dataType, dataSubType, study, modifiedOn, platform, tissueType, organism, disease from file where center=="Rush-Broad" and projectId=="syn2580853"')

for (i in 1:nrow(res)){
  a <- synGet(res$file.id[i],downloadFile=FALSE)
  annotValue(a,'center') <- 'Broad-Rush'
  a <- synStore(a)
}

res <- synQuery('select name, dataType, dataSubType, study, modifiedOn, platform, tissueType, organism, disease from file where organism=="human" and projectId=="syn2580853"')

for (i in 1:nrow(res)){
  a <- synGet(res$file.id[i],downloadFile=FALSE)
  annotValue(a,'organism') <- 'Homo sapiens'
  cat(i,res$file.name[i],'\n')
  a <- synStore(a)
}

res <- synQuery('select name, dataType, dataSubType, study, modifiedOn, platform, tissueType, organism, disease from file where organism=="mouse" and projectId=="syn2580853"')

for (i in 1:nrow(res)){
  a <- synGet(res$file.id[i],downloadFile=FALSE)
  annotValue(a,'organism') <- 'Mus musculus'
  a <- synStore(a)
}
