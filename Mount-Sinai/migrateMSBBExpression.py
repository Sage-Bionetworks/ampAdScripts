import os
import synapseclient
from synapseclient import File
import synapseHelpers
syn = synapseclient.Synapse(skip_checks=True)
syn.login(silent=True)

OLDPARENTID='syn3163721'
NEWPARENTID='syn3157699'


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
for i in range(1,df.shape[0]):
    row =  df.ix[i, :]
    ent = syn.get(row.id)
    fStudy, fTissue, fPlatform, fDatatype,  fRest = ent.name.split('_')
    name = 'AMP-AD_MSBB_MSSM_%s_%s_%s' % (PLATFORM_MAP[fPlatform],   
                                          TISSUEABRMAP[fTissue][0], fRest)
    print name
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
    f.dataSubType = 'geneExp'
    f.fileType =  'genomicMatrix'
    f.organism =  'human'
    f = syn.store(f, used = [ent], executed=['https://github.com/Sage-Bionetworks/ampAdScripts/blob/4d7d6b78b1e73058483354a1a18bff7422966a4b/Mount-Sinai/migrateMSBBExpression.py'], activityName='Data migration')
    

