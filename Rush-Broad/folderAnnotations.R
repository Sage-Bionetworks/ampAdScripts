#add annotations to folders
require(synapseClient)
synapseLogin()
#Methylation
folder <- synGet('syn3157275',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = 'Methylation',
  disease = c('Alzheimers Disease','Control'),
  tissueType = 'Dorsolateral Prefrontal Cortex',
  tissueTypeAbrv = 'PFC',
  platform= 'IlluminaHumanMethylation450',
  center = 'Broad-Rush',
  study = 'ROSMAP',
  organism = 'Homo sapiens',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)

folder <- synGet('syn3157329',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = 'DNA',
  dataSubType = 'Imputed Genotypes',
  disease = c('Alzheimers Disease','Control'),
  platform= 'AffymetrixGenechip6.0',
  center = 'Broad-Rush',
  study = 'ROSMAP',
  organism = 'Homo sapiens',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)

folder <- synGet('syn3157325',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = 'DNA',
  disease = c('Alzheimers Disease','Control'),
  platform= 'AffymetrixGenechip6.0',
  center = 'Broad-Rush',
  study = 'ROSMAP',
  organism = 'Homo sapiens',
  display = TRUE
)

synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)

folder <- synGet('syn3157322',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = 'Covariates',
  disease = c('Alzheimers Disease','Control'),
  center = 'Broad-Rush',
  study = 'ROSMAP',
  organism = 'Homo sapiens',
  display = TRUE
)

synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)
