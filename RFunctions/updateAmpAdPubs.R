## Delete existing wiki subpage before pushing new one

library(synapseClient)
library(knitr)
devtools::source_gist("6117476")

synapseLogin()

parentWikiId <- "71916"
wikiTitle <- "Publications"
ownerId <- 'syn2580853'

owner <- synGet(ownerId)
wikiHeaders <- synGetWikiHeaders(owner)

toDelete <- Filter(function(x) x@parentId == parentWikiId && x@title == wikiTitle, wikiHeaders)[[1]]

synRestDELETE(sprintf("/entity/%s/wiki/%s", ownerId, toDelete@id))

knit2synapse("./ampAdPubs.Rmd", owner=ownerId, 
             parentWikiId=parentWikiId, wikiName=wikiTitle,
             overwrite=TRUE)