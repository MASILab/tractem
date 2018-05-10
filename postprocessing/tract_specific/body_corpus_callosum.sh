#!/bin/sh
#
# Usage: sh body_corpus_callosum.sh /fully/qualified/path/to/fibfile.fib.gz
#
# Lots of assumptions being made here about how files are named and stored 
# after the manual part of the protocol.

# Structure names, long and short form
STRUCTURE=body_corpus_callosum
STRUCT=bcc

# Get DSI Studio binary location, and tractography options. Then initialize 
# file and directory names.
source ../dsi_studio_setup.sh
source ../get_dir_names.sh "${1}" "${STRUCTURE}"

# Compute tracts and export density map. This command line is structure-specific in terms of ROIs etc.
$DSI_STUDIO \
	--action=trk \
	--source=$FIB \
	--roa="${STRUCTDIR}"/"${STRUCT}"_ROA1.nii.gz \
	--seed="${STRUCTDIR}"/"${STRUCT}"_seed1.nii.gz \
	${DSI_OPTION_STRING} \
	--output="${OUTDIR}"/"${STRUCT}"_tract.trk.gz \
	--export=tdi \
	> "${LOGFILE}" 2>&1

# Give the density map output a clearer filename
mv "${OUTDIR}"/"${STRUCT}"_tract.trk.gz.tdi.nii.gz \
	"${OUTDIR}"/"${STRUCT}"_density.nii.gz \
	>> "${LOGFILE}" 2>&1

