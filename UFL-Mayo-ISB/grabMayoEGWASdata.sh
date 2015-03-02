#!/bin/sh

#Requirements:
#synapse command line client (link)
#plink (link)

echo "Making Directory for Analyses: MayoEGWASanalyses/"
mkdir MayoEGWASanalyses
echo "Changing to Directory MayoEGWASanalyses/"
cd MayoEGWASanalyses

echo "Downloading Mayo LOAD GWAS genotypes bed file"
synapse get syn3205812
echo "Downloading Mayo LOAD GWAS genotypes bim file"
synapse get syn3205814
echo "Downloading Mayo LOAD GWAS genotypes fam file"
synapse get syn3205816
echo "Downloading Mayo LOAD GWAS covariates file"
synapse get syn3205821
echo "Downloading Mayo EGWAS Cerebellum expression data"
synapse get syn3256501
echo "Downloading Mayo EGWAS Cerebellum expression data covariates"
synapse get syn3256502
echo "Downloading Mayo EGWAS Temporal Cortex expression data"
synapse get syn3256507
echo "Downloading Mayo EGWAS Temporal Cortex expression data covariates"
synapse get syn3256508
