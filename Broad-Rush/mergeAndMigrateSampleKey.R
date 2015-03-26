require(synapseClient)
synapseLogin()

#put file in Rush-Broad directory
internalParentId <- 'syn2700793'
sampIdFile <- File('Broad-Rush/AMP-AD_ROSMAP_Rush-Broad_IDKey.txt',parentId=internalParentId)
sampIdFile <- synStore(sampIdFile)

rosmapTable <- synTableQuery('select * from syn3163713 where data like \'ROSMAP Sample%\'')








