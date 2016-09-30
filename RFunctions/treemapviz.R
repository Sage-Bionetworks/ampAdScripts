library('plyr')
library('dplyr')
library('reshape')
library('tidyr')
library('ggplot2')
library('treemap')
library('d3treeR')

queryString <- "select study,center,platform,dataType,fileType,tissueType from file where projectId=='syn2580853'"

request <- synQuery(queryString, blockSize=250)
queryResults <- request$collectAll()

d <- queryResults %>% 
  filter(file.dataType %in% c("mRNA", "miRNA", "DNA", "protein")) %>% 
  count(file.center, file.dataType, sort = TRUE)
