###fix fields and annotations


load("projectAudit/ampAdCrawledDecember102015.rda")
dictionaryObj <- synTableQuery('SELECT * FROM syn5478487')
uniqueFields <- unique(dictionaryObj@values$field)

listify <- function(x,y,z){
  return(unique(y[which(z==x)]))
}

dictionary <- lapply(uniqueFields,listify,dictionaryObj@values$value,dictionaryObj@values$field)

names(dictionary) <- uniqueFields

require(dplyr)
#get all unique fields
#uniqueFields <- unique(c(unlist(lapply(anno,names))))
uniqueFields <- anno %>% 
  lapply(names) %>% 
  unlist %>%
  c %>%
  unique

toFix <- !uniqueFields%in%names(dictionary)
toFix[1] <- FALSE
uniqueFields <- data.frame(uniqueFields=uniqueFields,toFix=toFix,stringsAsFactors=F)
uniqueFields$fixFieldState <- rep(NA,nrow(uniqueFields))
uniqueFields$fixFieldState[uniqueFields$toFix==TRUE] <- ''
uniqueFields$fixFieldState[uniqueFields$uniqueFields=='Study'] <- 'study'
uniqueFields$fixFieldState[uniqueFields$uniqueFields=='Center'] <- 'center'
uniqueFields$fixFieldState[uniqueFields$uniqueFields=='centercenter'] <- 'center'
uniqueFields$fixFieldState[uniqueFields$uniqueFields=='normalization'] <- 'normalizationStatus'
uniqueFields$fixFieldState[uniqueFields$uniqueFields=='tissue'] <- 'cellType'
uniqueFields$fixFieldState[uniqueFields$uniqueFields=='platfrom'] <- 'platform'



#uniqueFieldsAll <- anno %>% lapply(names)
#normalizationTest <- sapply(uniqueFieldsAll,function(x,y){return(y%in%x)},'normalization')
#centercenterTest <- sapply(uniqueFieldsAll,function(x,y){return(y%in%x)},'centercenter')
#tissueTest <- sapply(uniqueFieldsAll,function(x,y){return(y%in%x)},'tissue')
#anno[which(normalizationTest)]
#sapply(anno[which(tissueTest)],function(x){return(x[['tissue']])})





#get all unique values
uniqueValues <-anno %>%
  unlist %>%
  c %>%
  unique

dictionaryValues <- dictionary %>%
  unlist %>%
  c %>%
  unique


toFix <- !uniqueValues%in%dictionaryValues

uniqueValues <- data.frame(uniqueValues=uniqueValues,
                           toFix=toFix,
                           stringsAsFactors = F)

uniqueValues$fixValueState <- rep(NA,nrow(uniqueValues))
uniqueValues$fixValueState[uniqueValues$toFix==TRUE] <- ''
uniqueValues$fixValueState[uniqueValues$uniqueValues=='RNA-Seq'] <- 'RNAseq'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='BroadRush'] <- 'Broad-Rush'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Methylation'] <- 'methylation'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Dorsolateral Prefrontal Cortex'] <- 'dorsolateralPrefrontalCortex'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Alzheimers Disease'] <- 'AlzheimersDisease'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Control'] <- 'control'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Homo sapiens'] <- 'HomoSapiens'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='ConfocalImaging'] <- 'confocalImaging'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Protein'] <- 'protein'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Prefrontal Cortex'] <- 'prefrontalCortex'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Dorsolateral Prefrontal'] <- 'dorsolateralPrefrontalCortex'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='UFL_Mayo-ISB'] <- 'UFL-Mayo-ISB'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='SampleSwap'] <- 'sampleSwap'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='  Homo sapiens'] <- 'HomoSapiens'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Array Expression'] <- 'arrayExpression'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Covariates'] <- 'covariates'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Imputed Genotypes'] <- 'imputedGenotypes'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Dorsolateral prefrontal cortex'] <- 'dorsolateralPrefrontalCortex'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Rush-Broad'] <- 'Broad-Rush'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Mild Cognitive Impairment'] <- 'mildCognitiveImpairment'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='FASLE'] <- 'FALSE'
uniqueValues$fixValueState[uniqueValues$uniqueValues==' Ensembl'] <- 'Ensembl'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='DPC'] <- 'DLPFC'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Alzheimer'] <- 'AlzheimersDisease'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Homo Sapiens'] <- 'HomoSapiens'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Clinical'] <- 'clinical'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Affymetrix Genechip 6.0'] <- 'AffymetrixGenechip6.0'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Imputed Genotype'] <- 'imputedGenotype'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Parkinsons Disease'] <- 'ParkinsonsDisease'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Amyotrophic Lateral Sclerosis'] <- 'amyotrophicLateralSclerosis'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Corticobasal Degeneration'] <- 'corticobasalDegeneration'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Autosomal Dominant Parkinsons Disease'] <- 'autosomalDominantParkinsonsDisease'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Parkinsonâ\u0080\u0099s Disease'] <- 'ParkinsonsDisease'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Frontotemporal Dementia'] <- 'frontotemporalDementia'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='RAW'] <- 'raw'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Precuneus'] <- 'precuneus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='human'] <- 'HomoSapiens'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='ALS'] <- 'amyotrophicLateralSclerosis'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Alzheimer Disease'] <- 'AlzheimersDisease'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='PD'] <- 'ParkinsonsDisease'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Normal'] <- 'control'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Frontal Cortex'] <- 'frontalCortex'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Microglia'] <- 'microglia'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Mouse musculus'] <- 'MusMusculus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Mus musculus'] <- 'MusMusculus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Drosophila melangoaster'] <- 'DrosophilaMelanogaster'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Dentate Gyrus'] <- 'dentateGyrus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Enthorinal Cortex'] <- 'entorhinalCortex'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Alzheimer\'s Disease'] <- 'AlzheimersDisease'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Frontal Pole'] <- 'frontalPole'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Superior Temporal Gyrus'] <- 'superiorTemporalGyrus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Parahippocampal Gyrus'] <- 'parahippocampalGyrus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Occipital Visual Cortex'] <- 'occipitalVisualCortex'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Inferior Temporal Gyrus'] <- 'inferiorTemporalGyrus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Middle Temporal Gyrus'] <- 'middleTeporalGyrus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Posterior Cingulate Cortex'] <- 'posteriorCingulateCortex'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Anterior Cingulate'] <- 'anteriorCingulate'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Temporal Pole'] <- 'temporalPole'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Precentral Gyrus'] <- 'precentralGyrus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Inferior Frontal Gyrus'] <- 'inferiorFrontalGyrus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Superior Parietal Lobule'] <- 'superiorParietalLobule'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Amygdala'] <- 'amygdala'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Caudate Nucleus'] <- 'caudateNucleus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Hippocampus'] <- 'hippocampus'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Nucleus Accumbens'] <- 'nucleusAccumbens'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Putamen'] <- 'putamen'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='AffymetrixHG-U133Plus2.0'] <- 'AffymetrixU133Plus2'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='AffymetrixHG-U133A'] <- 'AffymetrixU133AB'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='AffymetrixHG-U133B'] <- 'AffymetrixU133AB'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Drosophila melanogaster'] <- 'DrosophilaMelanogaster'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Entorhinal Cortex'] <- 'entorhinalCortex'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Cerebellum'] <- 'cerebellum'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Temporal Cortex'] <- 'temporalCortex'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='CER'] <- 'CBE'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Progressive Supranuclear Palsy'] <- 'progressiveSupranuclearPalsy'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='imputedGenotypes'] <- 'imputedGenotype'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='MayoLOADGWAS'] <- 'MayoLOADGwas'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='spinal cord'] <- 'spinalCord'
uniqueValues$fixValueState[uniqueValues$uniqueValues=='Alzheimers'] <- 'AlzheimersDisease'


applyFieldFix <- function(x,uniqueFields){
  new_x <- x
  fieldsToDelete <- uniqueFields$uniqueFields[uniqueFields$toFix==TRUE & uniqueFields$fixFieldState=='']
  #print(fieldsToDelete)
  if(length(new_x)>0){
  if(sum(names(new_x)%in%fieldsToDelete)>0){
    #cat('there\n')
    new_x <- new_x[which(!names(new_x)%in%fieldsToDelete)]
    
  }
  typosToChange <- uniqueFields$fixFieldState[uniqueFields$toFix==TRUE & uniqueFields$fixFieldState!='']
  names(typosToChange) <- uniqueFields$uniqueFields[uniqueFields$toFix==TRUE & uniqueFields$fixFieldState!='']
  
  if(sum(names(new_x)%in%names(typosToChange))>0){
    w1 <- which(names(new_x)%in%names(typosToChange))
    names(new_x)[w1] <- typosToChange[names(new_x)[w1]]
  }
  }
  return(as.list(new_x))
}

testFieldFix <- function(x,uniqueFields){
  new_x <- x
  fieldsToDelete <- uniqueFields$uniqueFields[uniqueFields$toFix==TRUE & uniqueFields$fixFieldState=='']
  #print(fieldsToDelete)
  changed<-FALSE
  if(length(new_x)>0){
  if(sum(names(new_x)%in%fieldsToDelete)>0){
    new_x <- new_x[which(!names(new_x)%in%fieldsToDelete)]
    changed<-TRUE
  }
  typosToChange <- uniqueFields$fixFieldState[uniqueFields$toFix==TRUE & uniqueFields$fixFieldState!='']
  names(typosToChange) <- uniqueFields$uniqueFields[uniqueFields$toFix==TRUE & uniqueFields$fixFieldState!='']
  
  if(sum(names(new_x)%in%names(typosToChange))>0){
    w1 <- which(names(new_x)%in%names(typosToChange))
    names(new_x)[w1] <- typosToChange[names(new_x)[w1]]
    changed<-TRUE
  }
  }
  return(changed)
}

annosNeedingFieldFixes <- sapply(anno,testFieldFix,uniqueFields)


internalFxn <- function(x,y){
  fob <- FALSE
  if(sum(x%in%y)>0){
    fob <- TRUE
  }
  return(fob)
}
applyValueFix <- function(x,uniqueValues){
  new_x <- x
  typosToChange <- uniqueValues$fixValueState[uniqueValues$toFix==TRUE & uniqueValues$fixValueState!='']
  names(typosToChange) <- uniqueValues$uniqueValues[uniqueValues$toFix==TRUE & uniqueValues$fixValueState!='']
  if(length(x)>0){
  if(sum(sapply(new_x,internalFxn,names(typosToChange)))>0){
    #cat('here\n')
    w1 <- which(sapply(new_x,internalFxn,names(typosToChange)))
    for (i in 1:length(w1)){
      #cat('old',new_x[w1[i]],'\n')
      for (j in 1:length(new_x[[w1[i]]])){  
        #print(new_x[[w1[i]]])
        if(new_x[[w1[i]]][j]%in%names(typosToChange)){
          new_x[[w1[i]]][j] <- typosToChange[new_x[[w1[i]]][j]]
        }
      }
      #cat('new',new_x[w1[i]],'\n')
    }
  }
  }
  return(as.list(new_x))
}

testValueFix <- function(x,uniqueValues){
  new_x <- x
  typosToChange <- uniqueValues$fixValueState[uniqueValues$toFix==TRUE & uniqueValues$fixValueState!='']
  names(typosToChange) <- uniqueValues$uniqueValues[uniqueValues$toFix==TRUE & uniqueValues$fixValueState!='']
  changed=FALSE
  #print(sapply(new_x,internalFxn,names(typosToChange)))
  if(length(x)>0){
  if(sum(sapply(new_x,internalFxn,names(typosToChange)))>0){
    #cat('here\n')
    changed=TRUE
    w1 <- which(sapply(new_x,internalFxn,names(typosToChange)))
    for (i in 1:length(w1)){
      #cat('old',new_x[w1[i]],'\n')
      for (j in 1:length(new_x[[w1[i]]])){  
        #print(new_x[[w1[i]]])
        new_x[[w1[i]]][j] <- typosToChange[new_x[[w1[i]]][j]]
      }
      #cat('new',new_x[w1[i]],'\n')
    }
  }
  }
  return(changed)
}

numberOfChangedAnnos <- sapply(anno,testValueFix,uniqueValues)

annosToUpdate <- numberOfChangedAnnos|annosNeedingFieldFixes

updatedAnno <- lapply(anno,applyFieldFix,uniqueFields)
updatedAnno <- lapply(updatedAnno,applyValueFix,uniqueValues)
test_annos <- rep(0,length(anno))
for (i in 1:length(anno)){
  test_annos[i] <- sum(!unlist(synGetAnnotations(bar[[i]]))==unlist(anno[[i]]))
}


for(i in which(annosToUpdate)[4453:4553]){
  print(i)

  synSetAnnotations(bar[[i]]) <- updatedAnno[[i]]
  bar[[i]] <- synStore(bar[[i]],forceVersion=F)
}


