#!/bin/bash

#extract individuals with expression data for cerebellum and temporal cortex
plink --bfile AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300 --keep cerebellumIds.txt --make-bed --out AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum
plink --bfile AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300 --keep temporalcortexIds.txt --make-bed --out AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_TemporalCortex
#do additive recoding

for i in {1..22}
do
  echo $i
  plink --bfile AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum --recodeA --out cerebellumGenotypes/AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum_$i --chr $i
  plink --bfile AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_TemporalCortex --recodeA --out temporalCortexGenotypes/AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_TemporalCortex_$i --chr $i
done



