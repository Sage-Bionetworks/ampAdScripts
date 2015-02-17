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

wQEx <- synGetWiki(parent=owner, id="89677")

wQExNew <- knit2synapse("./ampAdQueryEx.Rmd", owner=ownerId, 
                        parentWikiId="71905", wikiName="Querying the AMP-AD data",
                        overwrite=TRUE, store=FALSE)

wQEx@properties$markdown <- wQExNew@properties$markdown
wQEx <- synStore(wQEx)
