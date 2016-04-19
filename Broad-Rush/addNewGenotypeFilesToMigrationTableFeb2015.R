#first remove old files from external project
#genotypes
rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP Genotypes%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)

for (i in 1:2){
  deleteEntity(rosmapTable@values$newSynapseId[i])
  deleteEntity(rosmapTable@values$originalSynapseId[i])
}

#imputed genotypes
rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP Imputed Genotypes%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
for (i in 1:nrow(rosmapTable@values)){
  deleteEntity(rosmapTable@values$newSynapseId[i])
  deleteEntity(rosmapTable@values$originalSynapseId[i])
}


#update migration table
rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP Genotypes%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)

res <- synQuery('SELECT id, name, concreteType FROM entity WHERE parentId=="syn2425357"')

#genotypes
rosmapTable@values$originalSynapseId <- res$entity.id;
rosmapTable@values$oldFileName <- res$entity.name
rosmapTable@values$newSynapseId <- ''
rosmapTable@values$newFileName <- ''
rosmapTable@values$isMigrated <- FALSE
rosmapTable@values$hasAnnotation <- FALSE
rosmapTable@values$hasProvenance <- FALSE
rosmapTable <- synStore(rosmapTable)

#imputed genotypes
rosmapTable <- synTableQuery('SELECT * FROM syn3163713 where data like \'ROSMAP Imputed Genotypes%\' and migrator=\'Ben\' and toBeMigrated=TRUE',loadResult = TRUE)
res <- synQuery('SELECT id, name, concreteType FROM entity WHERE parentId=="syn3200241"')

rosmapTable@values$originalSynapseId <- res$entity.id;
rosmapTable@values$originalParentId  <- "syn3200241";
rosmapTable@values$oldFileName <- res$entity.name
rosmapTable@values$newSynapseId <- ''
rosmapTable@values$newFileName <- ''
rosmapTable@values$isMigrated <- FALSE
rosmapTable@values$hasAnnotation <- FALSE
rosmapTable@values$hasProvenance <- FALSE
rosmapTable <- synStore(rosmapTable)


#last remove old files from internal project