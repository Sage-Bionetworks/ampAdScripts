library(synapseClient)
synapseLogin()

queryString <- sprintf("select id,consortium,study,center,platform,dataType,fileType,name from file where projectId=='%s'", 
                       projectId)

queryResults <- synQuery(queryString)

missingFields <- subset(queryResults, (is.na(file.consortium) | file.consortium == "") | 
                          (is.na(file.study) | file.study == "") |
                          (is.na(file.center) | file.center == "") |
                          (is.na(file.dataType) | file.dataType == "") |
                          (is.na(file.fileType) | file.fileType == "") |
                          (is.na(file.platform) | file.platform == ""))


write.csv(missingFields, file="~/Projects/AMP-AD/missingFields.csv")

fl <- File(path = "~/Projects/AMP-AD/missingFields.csv", parentId="syn3163708",
           description="Missing fields (consortium, study, center, dataType, fileType, platform)")

o <- synStore(fl)
