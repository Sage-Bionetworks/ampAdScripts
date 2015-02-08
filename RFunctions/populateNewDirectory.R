###Function to take a crawled synapse object and populate a new directory with the identified structure.  
###Make new folders
###Move files in a given folder
###Replace old files with Links
populateNewDirectory <- function(synId,G,Q=NULL,topId){
  ######Run a depth first search
  if(is.null(Q)){
    Q <- list();
    Q$adj <- G$adj;
    Q$adj[1:length(Q$adj)] <- 0;
    Q$id <- G$id;
    Q$id[1] <- topId;
    G$id[1] <- topId;
    rownames(G$adj) <- G$id;
    colnames(G$adj) <- G$id;
    rownames(Q$adj) <- G$id;
    colnames(Q$adj) <- G$id;
    names(G$type) <- G$id;
    names(G$name) <- G$id;    
    Q$newid <- Q$id;
    names(Q$newid) <- Q$id;
    synId <- topId;

  }
  e <- names(which(G$adj[synId,]==1))
  if(length(e)>0){
    
    for(i in 1:length(e)){
      #print(e)
      #print(Q$adj)
      if(Q$adj[synId,e[i]]==0){
        #print(e)
        Q$adj[synId,e[i]]<- 1;
        if(G$type[e[i]]=='org.sagebionetworks.repo.model.Folder'){
          #check if folder already exists
          Q$newid[e[i]] <- makeNewFolder(synId,e[i],Q,G);
          Q <- populateNewDirectory(e[i],G,Q,topId);
        }else if (G$type[e[i]]=='org.sagebionetworks.repo.model.FileEntity'){
          moveFile(e[i],Q$newid[synId]);
          makeLink(G$name[e[i]],e[i],synId)
          #makeLink(fileName,fileId,parentId);
          #return(Q)
        } else{
          stop('Object type not recognized\n')
        }
      } else {
        return(Q);
      }
    }
  }else{
    return(Q)
  }
  return(Q)
}