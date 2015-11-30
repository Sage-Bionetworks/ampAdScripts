import os
import synapseclient
from synapseclient import File
import synapseHelpers
syn = synapseclient.Synapse(skip_checks=True)
syn.login(silent=True)

OLDPARENTID='syn2731328'
NEWPARENTID='syn3157700'
EXPRFILE_PARENTID = 'syn3157699'


TISSUEABRMAP={'BM10-FP': 	['Frontal Pole', 'FP'],
              'BM17-OVC':	['Occipital Visual Cortex', 'OVC'],
              'BM20-ITG':	['Inferior Temporal Gyrus', 'ITG'],
              'BM21-MTG':	['Middle Temporal Gyrus', 'MTG'],
              'BM22-STG':	['Superior Temporal Gyrus', 'STG'],
              'BM23-PCC':	['Posterior Cingulate Cortex', 'PCC'],
              'BM32-AC':	['Anterior Cingulate', 'AC'],
              'BM36-PHG':	['Parahippocampal Gyrus', 'PHG'],
              'BM38-TP':	['Temporal Pole', 'TP'],
              'BM4-PCG':	['Precentral Gyrus', 'PCG'],
              'BM44-IFG':	['Inferior Frontal Gyrus', 'IFG'],
              'BM46-PFC':	['Dorsolateral Prefrontal Cortex', 'PFC'],
              'BM7-SPL':	['Superior Parietal Lobule', 'SPL'],
              'BM8-FC': 	['Prefrontal Cortex', 'FC'],
              'BMa-AMYG':	['Amygdala','AMYG'],
              'BMb-CD': 	['Caudate Nucleus','CD'],
              'BMc-HIPP':	['Hippocampus', 'HIPP'],
              'BMd-NAc':	['Nucleus Accumbens','NAc'],
              'Bme-PT': 	['Putamen','PT']}

PLATFORM_MAP = {'133AB': 'AffymetrixU133AB', 
                'Plus2': 'AffymetrixU133Plus2'}
	
query = 'select id, name from entity where parentId=="%s"' %OLDPARENTID
df = synapseHelpers.query2df(syn.chunkedQuery(query))
for i in range(0,1):#df.shape[0]):
    row =  df.ix[i, :]
    ent = syn.get(row.id)

    # fStudy, fTissue, fPlatform, fDatatype, fProcess,  fRest = ent.name.split('_')
    # name = 'AMP-AD_MSBB_MSSM_%s_%s_%s' % (PLATFORM_MAP[fPlatform],   
    #                                       TISSUEABRMAP[fTissue][0], fRest
    fStudy, fTissue, fPlatform, fDatatype,  fProcess, fRest = ent.name.split('_')
    name = 'AMP-AD_MSBB_MSSM_%s_%s_%s_%s' % (PLATFORM_MAP[fPlatform],   
                                             TISSUEABRMAP[fTissue][0], 
                                             fProcess, 
                                             fRest)
    print name
    used =  syn.query('select id from file where parentId=="%s" and tissueType=="%s" ' %(EXPRFILE_PARENTID, TISSUEABRMAP[fTissue][0]))['results'][0].values()[0]
    os.rename(ent.path, name)

    f = File(name, parentId=NEWPARENTID, name=name[7:])
    f.consortium = 'AMP-AD'
    f.study = 'MSBB'
    f.center = 'MSSM'
    f.dataType =  'mRNA'
    f.disease = 'Alzheimers Disease'
    f.platfrom = PLATFORM_MAP[fPlatform]
    f.tissueTypeAbrv = TISSUEABRMAP[fTissue][1]
    f.tissueType = TISSUEABRMAP[fTissue][0]
    f.dataSubType = 'CoExpression'
    f.fileType =  'genomicMatrix'
    f.organism =  'human'
    f = syn.store(f, used = [used], executed=['syn2731322'], 
                  activityName='Weighted coexpression network modules using Coexpp v 0.1.0')
    

