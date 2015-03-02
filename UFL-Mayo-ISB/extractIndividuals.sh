#!/bin/sh

#Requirements:
#synapse command line client (link)
#plink (link)
plink --bfile AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300 --keep cerebellumIds.txt --make-bed --out AMP-AD_MayoLOADGWAS_UFL-Mayo-ISB_IlluminaHumanHap300_Cerebellum
