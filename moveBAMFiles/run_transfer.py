import synapseclient
import os, sys
from synapseclient import File

syn = synapseclient.login()
localDir = "/mnt/"

alreadyMoved = dict()
results = syn.chunkedQuery(''.join(['select id,name from file where parentId=="',sys.argv[2],'"']))
for result in results:
	alreadyMoved[result['file.name']] = result['file.id']

results = syn.chunkedQuery(''.join(['select id,name from file where parentId=="',sys.argv[1],'"']))
for result in results:
	if result['file.name'] in alreadyMoved: continue
	print result['file.id']
	print os.path.join(localDir, result['file.name'])
	bamEnt = syn.get(result['file.id'], downloadLocation = localDir)
	newEnt = File(path=os.path.join(localDir, result['file.name']),parentId=sys.argv[2])
	newEnt = syn.store(newEnt)
	os.remove(os.path.join(localDir, result['file.name']))

