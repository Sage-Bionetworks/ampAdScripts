#!/bin/bash
#Script to download MayoLOAD GWAS genotypes, MayoEGWAS gene expression data, and covariates for each data-set
#In addition, this script synchronizes the sample ids between all the data frames so that they are standard
#Author: Benjamin A Logsdon (ben.logsdon@sagebase.org)

#REQUIREMENTS:
#Synapse R client (https://www.synapse.org/#!Synapse:syn1834618)
#Synapse account (https://www.synapse.org/#!RegisterAccount:0)
#Data access approval to MayoLOADGWAS data (https://www.synapse.org/#!Synapse:syn2954402)
#Data access approval to MayoEGWAS data (https://www.synapse.org/#!Synapse:syn2910255)

echo "Download data from Synapse"
Rscript grabMayoEGWASdata.R
echo "Move to MayoEGWASanalysis directory"
cd MayoEGWASanalyses
echo "Make directories for subsetted additive encoding of Mayo genotypes"
mkdir temporalCortexGenotypes
mkdir cerebellumGenotypes
echo "Extract individuals with expression data from genotypes and produce chromosomal additive output"
../extractIndividuals.sh
