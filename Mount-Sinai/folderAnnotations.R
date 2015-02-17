#add annotations to folders
require(synapseClient)
synapseLogin()
#HBTRC
folder <- synGet('syn3159435',downloadFile = FALSE)
dataAnnotation <- list(
  consortium = 'AMP-AD',
  dataType = c('mRNA','DNA','Covariates'),
  disease = c('Alzheimers Disease','Control'),
  tissueType = 'Dorsolateral Prefrontal Cortex',
  tissueTypeAbrv = 'PFC',
  platform= c('Agilent44Karray','IlluminaHumanHap650Y','Perlegen300Karray'),
  center = 'MSSM',
  study = 'HBTRC',
  organism = 'Homo sapiens',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)


#MSBB array data

folder <- synGet('syn3219494',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = 'mRNA',
  consortium = 'AMP-AD',
  disease = c('Alzheimers Disease','Control'),
  tissueType = c('Frontal Pole', 'Occipital Visual Cortex', 'Inferior Temporal Gyrus', 'Middle Temporal Gyrus', 'Superior Temporal Gyrus', 'Posterior Cingulate Cortex', 'Anterior Cingulate', 'Parahippocampal Gyrus', 'Temporal Pole', 'Precentral Gyrus', 'Inferior Frontal Gyrus', 'Dorsolateral Prefrontal Cortex', 'Superior Parietal Lobule', 'Prefrontal Cortex', 'Amygdala', 'Caudate Nucleus', 'Hippocampus', 'Nucleus Accumbens', 'Putamen'),
  platform= 'AffymetrixU133AB',
  center = 'MSSM',
  study = 'MSBB',
  organism = 'Homo sapiens',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)

#MSBB rnaseq data

folder <- synGet('syn3157743',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = c('mRNA','Covariates'),
  consortium = 'AMP-AD',
  disease = c('Alzheimers Disease','Control'),
  tissueType = c('Frontal Pole','Superior Temporal Gyrus','Parahippocampal Gyrus'),
  platform= 'IlluminaHiSeq2500',
  center = 'MSSM',
  study = 'MSBB',
  organism = 'Homo sapiens',
  display = TRUE
)

synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)

#MSBB coexpression networks:

folder <- synGet('syn3157700',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = 'mRNA',
  consortium = 'AMP-AD',
  dataSubType ='CoExpression',
  disease = c('Alzheimers Disease','Control'),
  tissueType = c('Frontal Pole', 'Occipital Visual Cortex', 'Inferior Temporal Gyrus', 'Middle Temporal Gyrus', 'Superior Temporal Gyrus', 'Posterior Cingulate Cortex', 'Anterior Cingulate', 'Parahippocampal Gyrus', 'Temporal Pole', 'Precentral Gyrus', 'Inferior Frontal Gyrus', 'Dorsolateral Prefrontal Cortex', 'Superior Parietal Lobule', 'Prefrontal Cortex', 'Amygdala', 'Caudate Nucleus', 'Hippocampus', 'Nucleus Accumbens', 'Putamen'),
  platform= 'AffymetrixU133AB',
  center = 'MSSM',
  study = 'MSBB',
  organism = 'Homo sapiens',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)
