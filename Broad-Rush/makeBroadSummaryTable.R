require(synapseClient)
synapseLogin()


foo <- synQuery('select * from file where projectId==\'syn2580853\' and study==\'ROSMAP\'',blockSize = 100)
bar <- foo$collectAll()
