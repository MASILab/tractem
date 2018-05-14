#!/bin/sh
#
# Usage: sh seed2_bilat_roa1_roi2.sh /path/to/fib.gz anterior_commissure ac
#
# Lots of assumptions being made here about how files are named and stored 
# after the manual part of the protocol.

# seed2: L and R seeds will be combined
# bilat: single tract across both hemispheres
# roa1: single ROA
# roi2: 2 ROIs

# Structure names, long and short form from command line
STRUCTURE="${2}"
STRUCT="${3}"

# Get DSI Studio binary location, and tractography options. Then initialize 
# file and directory names.
source ../dsi_studio_setup.sh
source ../get_dir_names.sh "${1}" "${STRUCTURE}"

# Combine multiple seed images
SEED="${OUTDIR}"/"${STRUCT}"_LR_seed.nii.gz
fslmaths "${STRUCTDIR}"/"${STRUCT}"_L_seed1.nii.gz \
	-add "${STRUCTDIR}"/"${STRUCT}"_R_seed1.nii.gz \
	-bin "${SEED}" \
	> "${LOGFILE}" 2>&1

# Compute tracts and export density map
$DSI_STUDIO \
	--action=trk \
	--source=$FIB \
	--roa="${STRUCTDIR}"/"${STRUCT}"_ROA1.nii.gz \
	--roi="${STRUCTDIR}"/"${STRUCT}"_L_ROI1.nii.gz \
	--roi2="${STRUCTDIR}"/"${STRUCT}"_R_ROI1.nii.gz \
	--seed="${SEED}" \
	${DSI_OPTION_STRING} \
	--output="${OUTDIR}"/"${STRUCT}"_tract.trk.gz \
	--export=tdi \
	>> "${LOGFILE}" 2>&1

# Give the density map output a clearer filename
mv "${OUTDIR}"/"${STRUCT}"_tract.trk.gz.tdi.nii.gz \
	"${OUTDIR}"/"${STRUCT}"_density.nii.gz \
	>> "${LOGFILE}" 2>&1


