#!/bin/bash

consortium="AMP-AD"
study="ROSMAP"
center="Rush-Broad"
platform="IlluminaHumanMethylation450"
other="740_imputed"
extension="tsv"
organism="human"
dataType="Methylation"

OUTPUTFILE=${consortium}_${study}_${center}_${platform}_${other}.${extension}
LISTINGFILE=ill450kMeth_inputfiles.txt

# # Get the file/synapse id listing sorted by numerical chromosome
# synapse query "select id,name from file where parentId=='syn2701448'" | grep ill450kMeth | sed "s/ill450kMeth_chr//" | sort -h | cut -f 2 > ${LISTINGFILE}

# # Concatenate the data files
# cat ${LISTINGFILE} | xargs -n 1 -I{} synapse cat {} >> ${OUTPUTFILE}

# # # synapse cat needs fixing because it prints extra newlines
# # # Using branch fixsynapsecat until it gets merged into devel, but this would work too
# # sed -i -e "/^$/d" ${OUTPUTFILE}

# # synapse cat can't use tail, so we get extra headers. Remove them now.
# sed -i -e '2,${/^TargetID/d;}' ${OUTPUTFILE}

# # Compress it
# gzip ${OUTPUTFILE}

# Now, store the file, add annotations and provenance
NAME="${consortium}_${study}_${center}_${platform}_${other}"
NEWPARENTID=syn3157275
usedIds=`cat ${LISTINGFILE} | xargs`
annotations="'{\"consortium\": \"${consortium}\", \"platform\" : \"${platform}\", \"study\": \"${study}\", \"center\": \"${center}\", \"dataType\": \"${dataType}\", \"organism\": \"${organism}\"}'"

# Current path to commit
# Not really correct b/c I can't commit and then change...
thisScript="https://github.com/Sage-Bionetworks/ampAdScripts/blob/ab8327eb8f8d28309979b0186be73a216e5bf612/Rush-Broad/mergeROSMAPMethylationData.sh"

# the synapse command does not work properly when run inside the script
# it may need to be run manually
echo synapse --debug store ${OUTPUTFILE}.gz --parentId ${NEWPARENTID} --name \"${NAME}\" --used ${usedIds} --executed ${thisScript} --annotations ${annotations}
