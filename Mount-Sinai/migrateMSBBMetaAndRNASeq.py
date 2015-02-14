import os
import synapseclient
from synapseclient import File
syn = synapseclient.Synapse(skip_checks=True)
syn.login(silent=True)

consortium = 'AMP-AD'
study = 'MSBB'
center = 'MSSM'
disease = 'Alzheimers Disease'
fileType = 'genomicMatrix'
organism = 'human'

toMove = {
    'syn3157412':{'parentId' : 'syn3157740', #'traits_for_RNA-seq_age_censored.tsv'
                  'dataType': 'metaData',
                  'tissueType':['Frontal Pole', 'Superior Temporal Gyrus','Parahippocampal Gyrus'],
                  'tissueTypeAbrv': ['FP', 'STG', 'PHG'],
                  'platform': '',
                  'fileType':'genomicMatrix',
                  'name': 'AMP-AD_MSBB_MSSM_metaData_mRNA_IlluminaHiSeq2500_age_censored.tsv'},
    'syn3157409':{'parentId': 'syn3157740',  #'traits_for_array_data_age_censored.tsv'
                  'platform': '',
                  'dataType': 'metaData',                  
                  'name' :'AMP-AD_MSBB_MSSM_metaData_mRNA_AffymetrixU133AB_age_censored.tsv'},
    'syn3159434':{'parentId' :'syn3157743',  #mssmad3_rawCounts.tsv',
                  'dataType': 'mRNA',
                  'platform': 'IlluminaHiSeq2500',
                  'tissueType':['Frontal Pole', 'Superior Temporal Gyrus','Parahippocampal Gyrus'],
                  'tissueTypeAbrv': ['FP', 'STG', 'PHG'],
                  'name' :'AMP-AD_MSBB_MSSM_IlluminaHiSeq2500_mRNA_rawCounts.tsv'},
    'syn2920161':{'parentId' :'syn3157743',  #'normalized.sex_race_age_RIN_PMI_batch_site.corrected.csv'
                  'dataType': 'mRNA',                  
                  'platform': 'IlluminaHiSeq2500',
                  'tissueType':['Frontal Pole', 'Superior Temporal Gyrus','Parahippocampal Gyrus'],
                  'tissueTypeAbrv': ['FP', 'STG', 'PHG'],
                  'name' :'AMP-AD_MSBB_MSSM_IlluminaHiSeq2500_mRNA_normalized-sex-race-age-RIN-PMI-batch-site.corrected.csv'},
    }


for id, v in toMove.items():
    ent = syn.get(id)
    print v['name']
    #os.rename(ent.path, v['name'])

    f = File(v['name'], parentId=v['parentId'], name=v['name'][7:-4])
    print f.name
    f.consortium, f.study, f.center, f.disease = consortium, study, center, disease
    f.dataType =  v['dataType']
    f.platfrom = v['platform']
    f.tissueTypeAbrv = v['tissueTypeAbrv']
    f.tissueType = v['tissueType']
    f.fileType =  fileType
    f.organism =  organism
    f = syn.store(f, used = [k], executed=['https://github.com/Sage-Bionetworks/ampAdScripts/blob/618c55908606d1afaef65bf79243040071e91440/Mount-Sinai/migrateMSBBMetaAndRNASeq.py'], 
                  activityName='Data migration')
    

