#!/bin/bash

#extract individuals with expression data for cerebellum and temporal cortex
echo "Extracting cerebellum sample ids from GWAS data"
plink --bfile AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300 --keep cerebellumIds.txt --make-bed --out AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum --silent --noweb
echo "Extracting temporal cortex sample ids from GWAS data"
plink --bfile AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300 --keep temporalcortexIds.txt --make-bed --out AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_TemporalCortex --silent --noweb
#do additive recoding


for i in {1..22}
do
  echo 'Do additive recoding of genotype data split by chromosome for chromosome' $i
  plink --bfile AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum --recodeA --out cerebellumGenotypes/AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum_$i --chr $i --silent --noweb
  plink --bfile AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_TemporalCortex --recodeA --out temporalCortexGenotypes/AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_TemporalCortex_$i --chr $i --silent --noweb
done



