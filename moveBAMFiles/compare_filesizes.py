#! /usr/bin/env python
# KKD for Sage Bionetworks
# January 13, 2016

import synapseclient, sys
syn = synapseclient.login()

newFolder = dict()
results = syn.chunkedQuery(''.join(['select id,name from file where parentId=="', sys.argv[1], '"']))
for result in results:
	ent = syn.get(result['file.id'], downloadFile = False)
	newFolder[result['file.name']] = ent.fileSize
	

results = syn.chunkedQuery(''.join(['select id,name from file where parentId=="', sys.argv[2], '"']))
for result in results:
	ent = syn.get(result['file.id'], downloadFile = False)
	if not ent.fileSize == newFolder[result['file.name']]:
		print result['file.name']
