#!/bin/sh
#
# Usage: sh <this_script> /fully/qualified/path/to/fibfile.fib.gz
#
# Lots of assumptions being made here about how files are named and stored 
# after the manual part of the protocol.

# Structure names, long and short form
STRUCTURE=anterior_corona_radiata
STRUCT=acr

# Get DSI Studio binary location, and tractography options. Then initialize 
# file and directory names.
source ../dsi_studio_setup.sh
source ../get_dir_names.sh "${1}" "${STRUCTURE}"

# Compute tracts and export density map. This command line is structure-specific in terms of ROIs etc.
for H in L R ; do

	$DSI_STUDIO \
		--action=trk \
		--source=$FIB \
		--roa="${STRUCTDIR}"/"${STRUCT}"_ROA1.nii.gz \
		--roi="${STRUCTDIR}"/"${STRUCT}"_${H}_ROI1.nii.gz \
		--seed="${STRUCTDIR}"/"${STRUCT}"_${H}_seed1.nii.gz \
		${DSI_OPTION_STRING} \
		--output="${OUTDIR}"/"${STRUCT}"_${H}.trk.gz \
		--export=tdi \
		> "${LOGFILE}" 2>&1

	mv "${OUTDIR}"/"${STRUCT}"_${H}.trk.gz.tdi.nii.gz \
		"${OUTDIR}"/"${STRUCT}"_${H}_density_tdi.nii.gz \
		>> "${LOGFILE}" 2>&1

done