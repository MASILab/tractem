#!/bin/sh
#
# Usage: sh <this_script> /fully/qualified/path/to/fibfile.fib.gz
#
# Lots of assumptions being made here about how files are named and stored 
# after the manual part of the protocol.

# Structure names, long and short form
STRUCTURE=anterior_commissure
STRUCT=ac

# Get DSI Studio binary location, and tractography options. Then initialize 
# file and directory names.
source ../dsi_studio_setup.sh
source ../get_dir_names.sh "${1}" "${STRUCTURE}"

# For a few tracts, e.g. anterior commissure, we need to combine multiple seed 
# images
SEED="${OUTDIR}"/"${STRUCT}"_LR_seed.nii.gz
fslmaths "${STRUCTDIR}"/"${STRUCT}"_L_seed1.nii.gz \
	-add "${STRUCTDIR}"/"${STRUCT}"_R_seed1.nii.gz \
	-bin "${SEED}"

# Compute tracts and export density map. This command line is structure-specific in terms of ROIs etc.
$DSI_STUDIO \
	--action=trk \
	--source=$FIB \
	--roa="${STRUCTDIR}"/"${STRUCT}"_ROA1.nii.gz \
	--seed="${SEED}" \
	${DSI_OPTION_STRING} \
	--output="${OUTDIR}"/"${STRUCT}"_tract.trk.gz \
	--export=tdi \
	> "${LOGFILE}" 2>&1

# Give the density map output a clearer filename
mv "${OUTDIR}"/"${STRUCT}"_tract.trk.gz.tdi.nii.gz \
	"${OUTDIR}"/"${STRUCT}"_density.nii.gz \
	>> "${LOGFILE}" 2>&1


