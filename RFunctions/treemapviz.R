library('dplyr')
library('reshape')
library('tidyr')
library('treemap')
library('d3treeR')

queryString <- "select study,center,platform,dataType,fileType,tissueType from file where projectId=='syn2580853'"
library('synapseClient')
synapseLogin()


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
              type="value")

d3tree2(tm, rootname = "All Centers")
