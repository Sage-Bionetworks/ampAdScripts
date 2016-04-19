require(synapseClient)
synapseLogin()
parentId <- 'syn3163708'


files <- read.csv('~/Documents/AMPADScratch/ampAdMigrationTable.csv')

tcresult<-as.tableColumns(files)
cols<-tcresult$tableColumns

cols[[4]]@columnType <- "ENTITYID"
cols[[5]]@columnType <- "ENTITYID"
cols[[8]]@columnType <- "BOOLEAN"
cols[[1]]@maximumSize <- as.integer(100)
cols[[6]]@maximumSize <- as.integer(100)
cols[[7]]@maximumSize <- as.integer(100)
fileHandleId<-tcresult$fileHandleId

projectId<-parentId
schema<-TableSchema(name="ampAdDataFeb2015", parent=projectId, columns=cols)
table<-Table(schema, fileHandleId)
table<-synStore(table, retrieveData=TRUE)
