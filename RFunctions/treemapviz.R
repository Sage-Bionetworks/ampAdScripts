library('dplyr')
library('reshape')
library('tidyr')
library('treemap')
library('d3treeR')

library('synapseClient')
synapseLogin()

queryString <- "select center,assay,dataType,fileType from file where projectId=='syn2580853'"

request <- synQuery(queryString, blockSize=250)
queryResults <- request$collectAll()

d <- queryResults %>% 
  filter(!is.na(file.assay),
         file.dataType %in% c("mRNA", "miRNA", "DNA", "protein")) %>% 
  count(file.center, file.assay, sort = TRUE) %>% 
  dplyr::rename(center=file.center, assay=file.assay)

tm <- treemap(d,
              index=c("center", "assay"),
              vSize="n",
              vColor=c("center"),
              type="index", draw = FALSE)

d3tree2(tm, rootname = "All Centers", width='800', height='600')
