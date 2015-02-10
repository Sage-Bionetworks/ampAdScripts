#!/bin/bash

consortium="AMP-AD"
study="ROSMAP"
center="Rush-Broad"
platform="IlluminaHumanMethylation450"
other="740_imputed"
extension="tsv"
tissueType="Dorsolateral Prefrontal Cortex"
tissueTypeAbrv="PFC"
organism="human"
dataType="Methylation"

OUTPUTFILE=${consortium}_${study}_${center}_${platform}_${other}.${extension}
LISTINGFILE=ill450kMeth_inputfiles.txt

# Get the file/synapse id listing sorted by numerical chromosome
synapse query "select id,name from file where parentId=='syn2701448'" | grep ill450kMeth | sed "s/ill450kMeth_chr//" | sort -h | cut -f 2 > ${LISTINGFILE}

# Concatenate the data files
cat ${LISTINGFILE} | xargs -n 1 -I{} synapse cat {} >> ${OUTPUTFILE}

# # synapse cat needs fixing because it prints extra newlines
# # Using branch fixsynapsecat until it gets merged into devel, but this would work too
# sed -i -e "/^$/d" ${OUTPUTFILE}

# synapse cat can't use tail, so we get extra headers. Remove them now.
sed -i -e '2,${/^TargetID/d;}' ${OUTPUTFILE}

# Compress it
gzip ${OUTPUTFILE}

# Now, store the file, add annotations and provenance
NAME="${consortium} ${study} ${center} ${platform} ${other}"
NEWPARENTID=syn3157275
usedIds=`cat ${LISTINGFILE} | xargs`
annotations="'{\"consortium\": \"${consortium}\", \"platform\" : \"${platform}\", \"study\": \"${study}\", \"center\": \"${center}\", \"dataType\": \"${dataType}\", \"organism\": \"${organism}\", \"tissueType\": \"${tissueType}\", \"tissueTypeAbrv\": \"${tissueTypeAbrv}\"}'"

synapse store ${OUTPUTFILE}.gz --parentId ${NEWPARENTID} --name \"${NAME}\" --used ${usedIds} --annotations ${annotations}
