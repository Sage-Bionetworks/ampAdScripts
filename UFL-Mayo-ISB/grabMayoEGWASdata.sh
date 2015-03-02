#!/bin/bash

Rscript grabMayoEGWASdata.R
cd MayoEGWASanalyses
mkdir temporalCortexGenotypes
mkdir cerebellumGenotypes
../extractIndividuals.sh
#Rscript ../loadEGWASdata.R