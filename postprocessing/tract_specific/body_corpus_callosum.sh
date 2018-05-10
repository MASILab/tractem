#!/bin/sh
#
# Usage: sh body_corpus_callosum.sh <fib_file_with_fully_qualified_pathspec>

# General init
source ../dsi_studio_setup.sh
FIB="${1}"
FIBDIR=`dirname "${FIB}"`

# Structure-specific
STRUCTURE=body_corpus_callosum
STRUCT=bcc
SEED="${FIBDIR}"/"${STRUCTURE}"/"${STRUCT}"_seed1.nii.gz
ROA="${FIBDIR}"/"${STRUCTURE}"/"${STRUCT}"_ROA1.nii.gz

# More general init
OUTDIR="${FIBDIR}"/postproc/"${STRUCTURE}"

if [ ! -e "${OUTDIR}" ] ; then
	mkdir -p "${OUTDIR}"
fi

# Compute tracts (also structure-specific in lists of ROIs etc)
$DSI_STUDIO \
	--action=trk \
	--source=$FIB \
	--roa=$ROA \
	--seed=$SEED \
	${DSI_OPTION_STRING} \
	--output="${OUTDIR}"/"${STRUCT}".trk.gz

# Export density map. General
$DSI_STUDIO \
	--action=ana \
	--source=$FIB \
	--tract="${OUTDIR}"/"${STRUCT}".trk.gz \
	--export=tdi \
	--output="${OUTDIR}"/"${STRUCT}".trk.gz

# Give the density map output a clearer filename. General
mv "${OUTDIR}"/"${STRUCT}".trk.gz.tdi.nii.gz \
	"${OUTDIR}"/"${STRUCT}"_density_tdi.nii.gz

