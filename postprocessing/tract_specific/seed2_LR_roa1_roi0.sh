#!/bin/sh
#
# Usage: sh seed2_LR_roa1_roi0.sh /path/to/fib.gz cingulum_cingulate_gyrus cgc
#
# Lots of assumptions being made here about how files are named and stored 
# after the manual part of the protocol.

# seed2: two seeds (per hemisphere in this case)
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

if [ -e "${LOGFILE}" ] ; then rm "${LOGFILE}" ; fi

for H in L R ; do

	# Combine multiple seed images
	SEED="${OUTDIR}"/"${STRUCT}"_${H}_seed12.nii.gz
	fslmaths "${STRUCTDIR}"/"${STRUCT}"_${H}_seed1.nii.gz \
		-add "${STRUCTDIR}"/"${STRUCT}"_${H}_seed2.nii.gz \
		-bin "${SEED}" \
		>> "${LOGFILE}" 2>&1
		
	# Compute tracts and export density map
	$DSI_STUDIO \
		--action=trk \
		--source=$FIB \
		--roa="${STRUCTDIR}"/"${STRUCT}"_ROA1.nii.gz \
		--seed="${SEED}" \
		${DSI_OPTION_STRING} \
		--output="${OUTDIR}"/"${STRUCT}"_${H}_tract.trk.gz \
		--export=tdi \
		>> "${LOGFILE}" 2>&1

	mv "${OUTDIR}"/"${STRUCT}"_${H}_tract.trk.gz.tdi.nii.gz \
		"${OUTDIR}"/"${STRUCT}"_${H}_density.nii.gz \
		>> "${LOGFILE}" 2>&1

done