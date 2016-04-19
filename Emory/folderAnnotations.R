#add annotations to folders
require(synapseClient)
synapseLogin()

#array expression
folder <- synGet('syn3218563',downloadFile = FALSE)
dataAnnotation <- list(
  consortium = 'AMP-AD',
  dataType = c('Protein','Covariates'),
  disease = c('Alzheimers Disease', 'Parkinsons Disease', 'Mild Cognitive Impairment', 'Amyotrophic Lateral Sclerosis', 'Corticobasal Degeneration', 'Autosomal Dominant Parkinsons Disease', 'Parkinson’s Disease', 'Frontotemporal Dementia'),
  tissueType = c('Medial Frontal Gyrus'),
  tissueTypeAbrv = c('MFG'),
  platform= c('LTQOrbitrapXL'),
  center = 'Emory',
  study = 'Emory',
  organism = 'Homo sapiens',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)


