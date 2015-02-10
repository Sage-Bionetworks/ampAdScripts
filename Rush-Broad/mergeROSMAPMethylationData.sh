#!/bin/bash

OUTPUTFILE=ROSMAP_Rush-Broad_IlluminaHumanMethylation450_740_imputed.tsv
LISTINGFILE=ill450kMeth_inputfiles.txt
NEWPARENTID=syn3157275

# Get the file/synapse id listing sorted by numerical chromosome
synapse query "select id,name from file where parentId=='syn2701448'" | grep ill450kMeth | sed "s/ill450kMeth_chr//" | sort -h | cut -f 2 > ${LISTINGFILE}

# Concatenate the data files
cat ${LISTINGFILE} | xargs -n 1 -I{} synapse cat {} >> ${OUTPUTFILE}

# # synapse cat needs fixing because it prints extra newlines
# # Using branch fixsynapsecat until it gets merged into devel, but this would work too
# sed -i -e "/^$/d" ${OUTPUTFILE}

# synapse cat can't use tail, so we get extra headers. Remove them now.
sed -i -e '2,${/^TargetID/d;}' ${OUTPUTFILE}

# Now, store the file, add annotations and provenance
synapse store ${OUTPUTFILE} --parentId ${NEWPARENTID} --used `cat ${LISTINGSFILE} | xargs` --annotations '{}'