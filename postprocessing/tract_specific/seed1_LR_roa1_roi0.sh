#!/bin/sh
#
# Usage: sh seed1_LR_roa1_roi0.sh /path/to/fib.gz anterior_corona_radiata acr
#
# Lots of assumptions being made here about how files are named and stored 
# after the manual part of the protocol.

# seed1: single seed
# LR: hemispheres treated separately
# roa1: single ROA
# roi0: No ROIs

# Structure names, long and short form from command line
STRUCTURE="${2}"
STRUCT="${3}"

# Get DSI Studio binary location, and tractography options. Then initialize 
# file and directory names.
source ../dsi_studio_setup.sh
source ../get_dir_names.sh "${1}" "${STRUCTURE}"

# Compute tracts and export density map. This command line is structure-specific in terms of ROIs etc.
if [ -e "${LOGFILE}" ] ; then rm "${LOGFILE}" ; fi
for H in L R ; do

	$DSI_STUDIO \
		--action=trk \
		--source=$FIB \
		--roa="${STRUCTDIR}"/"${STRUCT}"_ROA1.nii.gz \
		--seed="${STRUCTDIR}"/"${STRUCT}"_${H}_seed1.nii.gz \
		${DSI_OPTION_STRING} \
		--output="${OUTDIR}"/"${STRUCT}"_${H}_tract.trk.gz \
		--export=tdi \
		>> "${LOGFILE}" 2>&1

	mv "${OUTDIR}"/"${STRUCT}"_${H}_tract.trk.gz.tdi.nii.gz \
		"${OUTDIR}"/"${STRUCT}"_${H}_density.nii.gz \
		>> "${LOGFILE}" 2>&1

done