import synapseclient
from  synapseclient.utils import humanizeBytes
import argparse
import os, sys, time
from synapseclient import File

LOCAL_DIR = '/mnt/'
LOCAL_DIR = '.'
QUERY = 'select id,name from file where parentId=="%s"'

def getFileMetadata(synId, returnAlways=False):
	fileHandles = syn.restGET('/entity/%s/filehandles' %synId)
	for fh in fileHandles['list']:
		if fh['concreteType']=='org.sagebionetworks.repo.model.file.S3FileHandle':
			if ((('storageLocationId' not in fh) or (fh['storageLocationId']==1)) 
			    and returnAlways==False):
				return None, None, None
			return fh['fileName'], fh['contentMd5'], fh['contentSize']
		

syn = synapseclient.Synapse(debug=True)
syn.login()


#Look for 'storageLocationId'
ids = [x['file.id'] for x in syn.chunkedQuery(QUERY  %sys.argv[1])]
for synId in ids:
	print synId
	filename, md5, fileSize = getFileMetadata(synId)
	if filename is None: 
		continue

	#Fetch the file
	sys.stderr.write('STARTING DOWNLOAD OF %s, %s of size %s \n' %(synId, filename, humanizeBytes(fileSize)))
	startTime = time.time()
 	bamEnt = syn.get(synId, downloadLocation = LOCAL_DIR)
	assert os.stat(bamEnt.path).st_size==fileSize

	endTime = time.time()
	dt = endTime - startTime
	print('\t'.join(['Download metrics', synId, str(fileSize), str(dt),  str(fileSize/dt)]))
	print('FINISHED DOWNLOADING %s in %is at %s/s \n' %(synId, endTime-startTime, humanizeBytes(fileSize/dt)))
	sys.stderr.write('\t'.join(['Download metrics', synId, str(fileSize), str(dt),  str(fileSize/dt)])+'\n')
	sys.stderr.write('FINISHED DOWNLOADING %s in %is at %s/s \n' %(synId, endTime-startTime, humanizeBytes(fileSize/dt)))
	#Touch the file
	time.sleep(2)
	os.utime(bamEnt.path, None)
	#Upload the file again
	sys.stderr.write('STARTING UPLOAD OF %s, %s of size %s \n' %(synId, filename, humanizeBytes(fileSize)))
	startTime = time.time()
	bameEnt = syn.store(bamEnt)
	endTime = time.time()
	dt = endTime - startTime
	print ('FINISHED UPLOADING %s in %is at %s/s \n' %(synId, endTime-startTime, humanizeBytes(fileSize/dt)))
	print('\t'.join(['Upload metrics', synId, str(fileSize), str(dt),  str(fileSize/dt)]))
	sys.stderr.write('\t'.join(['Upload metrics', synId, str(fileSize), str(dt),  str(fileSize/dt)])+'\n')
	sys.stderr.write('FINISHED UPLOADING %s in %is at %s/s \n' %(synId, endTime-startTime, humanizeBytes(fileSize/dt)))
	
	#Check fileMetadata of New file
	new_filename, new_md5, new_fileSize = getFileMetadata(synId, returnAlways=True)
	assert new_fileSize==fileSize
	assert new_filename==filename
	os.remove(bamEnt.path)




# for result in results:
# 	print result['file.id']
# 	print os.path.join(LOCAL_DIR, result['file.name'])
# 	newEnt = File(path=os.path.join(localDir, result['file.name']),parentId=sys.argv[2])
# 	newEnt = syn.store(newEnt)
# 	os.remove(os.path.join(localDir, result['file.name']))

