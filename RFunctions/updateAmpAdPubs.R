## Delete existing wiki subpage before pushing new one

library(synapseClient)
library(knitr)

# Kenny's knit2synapse
devtools::source_gist("2866ef5c0aeb64d265ed")

synapseLogin()
# # Testing
# ownerId <- "syn2775243"

# REAL
ownerId <- "syn2580853"

owner <- synGet(ownerId)

wPubs <- synGetWiki(parent=owner, id="89645")

wPubsNew <- knit2synapse("./ampAdPubs.Rmd", owner=ownerId, 
                         parentWikiId="71916", wikiName="Publications",
                         overwrite=TRUE, store=FALSE)

wPubs@properties$markdown <- wPubsNew@properties$markdown
wPubs <- synStore(wPubs)

