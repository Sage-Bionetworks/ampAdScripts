library(stringr)
library(plyr)
library(XML)

# Pull AMP-AD related publications from PubMed
# Adapted from https://gist.github.com/Vessy/4383737

getPubList <- function(searchUrl) {

  #   #For more details about Pubmed queries see: http://www.ncbi.nlm.nih.gov/books/NBK25500/
  #Data record download - basic URL
  eDDownload <- "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id="
  
  hlpURL <- getURL(searchUrl)
  #The result is in form of XML document - you can paste the searchUrl in the browser to see/download it
  doc <- xmlTreeParse(hlpURL, asText = TRUE)     
  
  idlist <- xmlChildren(doc$doc$children$eSearchResult[['IdList']])
  idlist2 <- llply(idlist, xmlValue)
  Idlist <- as.character(unlist(idlist2))
  
  finalTable <- data.frame(PMID=c(), Authors=c(), Title=c(), Journal=c(), VIP=c(), Date=c())

  for (i in 1:length(Idlist)){
    hlp1 <- paste(eDDownload, paste(Idlist[i], collapse = ",", sep = ""), sep = "")
    # hlp2 <- paste(hlp1, "&rettype=abstract", sep = "")
    hlp2 <- paste(hlp1, "&rettype=xml", sep = "")
    
    hlpURL <- getURL(hlp2)
    # hlpURL
    
    testDoc <-  xmlParse(hlpURL)
    
    # Get the list of authors
    lastName.data <- xmlToDataFrame(getNodeSet(testDoc, "//Author//LastName"))
    foreName.data <- xmlToDataFrame(getNodeSet(testDoc, "//Author//ForeName"))
    
    auth.names <- paste(sprintf("%s %s", lastName.data$text, foreName.data$text),
                        collapse=",")
    
    # Get the publication title
    article.data <- as.character(xmlToDataFrame(getNodeSet(testDoc, "//ArticleTitle"))[1,1])
    
    # Get the journal info
    journal.data <- as.character(xmlToDataFrame(getNodeSet(testDoc, "//Journal//Title"))[1,1], homogeneous=FALSE)
    
    # Get volume, issue, and pagination info (some publications may be missing one or another)
    volume.data <- as.character(xmlToDataFrame(getNodeSet(testDoc, "//Volume"))[1,1], homogeneous=FALSE)
    volume.data <- ifelse(length(volume.data) > 0, volume.data, "")
    
    issue.data <- as.character(xmlToDataFrame(getNodeSet(testDoc, "//Issue"))[[1]])
    issue.data <- ifelse(length(issue.data) > 0, issue.data, "")
    
    # There was an issue with some pagination annotation in xml (e.g., node marked as <MedlinePgn/> )
    # page.info <- as.character(xmlToDataFrame(getNodeSet(testDoc, "//Pagination//MedlinePgn"))[1,1])
    # some may be empty!!!!!
    #vip <- paste(issue.data, "(", volume.data, "):", page.info, sep="")
    vip <- paste(issue.data, "(", volume.data, ")", sep="")
        
    # Get the publication dates
    year.data <- as.character(xmlToDataFrame(getNodeSet(testDoc , "//PubDate//Year"))[1,1])
    month.data <- as.character(xmlToDataFrame(getNodeSet(testDoc , "//PubDate//Month"))[1,1])
    day.data <- as.character(xmlToDataFrame(getNodeSet(testDoc , "//PubDate//Day"))[1,1])
    pubDate <- paste(month.data, day.data, year.data, sep="/")
        
    finalTable <- rbind(finalTable, data.frame(PMID=Idlist[i],
                                               Authors=auth.names, Title=article.data, 
                                               Journal=journal.data, VIP=vip, 
                                               Date=pubDate))
  }
  
  finalTable

}


#   #Text search - basic URL
#   eSearch <- "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term="
# pubmedQueryString <- "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=(De+Jager[Author+-+Last]+OR+Bennett[Author+-+Last]+AND+AG046152[Grant+Number])+OR+AG046170[Grant+Number]+OR+AG046139[Grant+Number]"

q <- "(De+Jager[Author+-+Last]+OR+Bennett[Author+-+Last]+AND+AG046152[Grant+Number])+OR+AG046170[Grant+Number]+OR+AG046139[Grant+Number]"
pubmedQueryString <- "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=(De+Jager[Author+-+Last]+OR+Bennett[Author+-+Last]+AND+AG046152[Grant+Number])+OR+AG046170[Grant+Number]+OR+AG046139[Grant+Number]"

doc <- getPubList(pubmedQueryString)
