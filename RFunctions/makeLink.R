makeLink <- function(fileName,fileId,parentId){
  require(rPython)
  python.exec('import synapseclient');
  python.exec('import json');
  python.exec('syn = synapseclient.login()')
  command <- paste("x = syn.restPOST(\'/entity\', json.dumps({\'name\':u\'",fileName,"\',\'linksTo\':{u\'targetId\': u\'",fileId,"\'},\'entityType\':u\'org.sagebionetworks.repo.model.Link\',\'linksToClassName\':u\'org.sagebionetworks.repo.model.FileEntity\',\'concreteType\':u\'org.sagebionetworks.repo.model.Link\',\'parentId\':u\'",parentId,"\'}))",sep='')
  python.exec(command)
}
#syn3155374
#syn3155376