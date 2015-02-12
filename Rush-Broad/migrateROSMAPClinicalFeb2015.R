###script to migrate ROSMAP clinical data

require(synapseClient)
synapseLogin()
rosmapTable <- synTableQuery('select * from syn3163713 where data like \'ROSMAP Clinical%\'')
