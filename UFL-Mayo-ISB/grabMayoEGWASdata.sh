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

