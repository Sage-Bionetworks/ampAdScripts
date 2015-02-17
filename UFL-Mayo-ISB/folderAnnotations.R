#add annotations to folders
require(synapseClient)
synapseLogin()

#array expression
folder <- synGet('syn3157225',downloadFile = FALSE)
dataAnnotation <- list(
  consortium = 'AMP-AD',
  dataType = c('mRNA','Covariates'),
  disease = c('Alzheimers Disease','Control'),
  tissueType = c('Cerebellum','Temporal Cortex'),
  tissueTypeAbrv = c('CER','TCX'),
  platform= c('IlluminaWholeGenomeDASL'),
  center = 'UFL-Mayo-ISB',
  study = 'MayoEGWAS',
  organism = 'Homo sapiens',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)


#MayoPilot RNAseq

folder <- synGet('syn3157268',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = c('mRNA','Covariates'),
  consortium = 'AMP-AD',
  disease = c('Alzheimers Disease','Progressive Supranuclear Palsy'),
  tissueType = c('Temporal Cortex'),
  platform= 'IlluminaHiSeq2000',
  center = 'UFL-Mayo-ISB',
  study = 'MayoPilot',
  organism = 'Homo sapiens',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)

#MayoLOADGWAS genotypes
folder <- synGet('syn3157238',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = c('DNA','Covariates'),
  consortium = 'AMP-AD',
  disease = c('Alzheimers Disease','Control'),
  platform= 'IlluminaHumanHap300',
  center = 'UFL-Mayo-ISB',
  study = 'MayoLOADGWAS',
  organism = 'Homo sapiens',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)

#MayoLOADGWAS genotypes
folder <- synGet('syn3157242',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = c('DNA','Covariates'),
  consortium = 'AMP-AD',
  disease = c('Alzheimers Disease','Control'),
  platform= 'TaqMan',
  center = 'UFL-Mayo-ISB',
  study = 'MayoLOADGWAS',
  organism = 'Homo sapiens',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)

#il10
folder <- synGet('syn3157175',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = c('mRNA','Covariates'),
  disease = 'Alzheimers Disease',
  consortium = 'AMP-AD',
  mouseModel = 'APP',
  platform= 'Nanostring',
  center = 'UFL-Mayo-ISB',
  study = 'IL10',
  organism = 'Mus musculus',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)

#il10
folder <- synGet('syn3157182',downloadFile = FALSE)
dataAnnotation <- list(
  dataType = c('mRNA','Covariates'),
  disease = 'Alzheimers Disease',
  consortium = 'AMP-AD',
  mouseModel = c('Tau'),
  platform= 'IlluminaHiSeq2000',
  center = 'UFL-Mayo-ISB',
  study = 'TAUAPPms',
  organism = 'Mus musculus',
  display = TRUE
)
synSetAnnotations(folder) <- dataAnnotation
folder <- synStore(folder)

