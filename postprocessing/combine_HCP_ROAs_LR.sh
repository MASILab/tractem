#!/bin/sh
# 
# Some HCP cases have multiple ROAs that need to be combined.

# Structure directory and structure short name from command line
STRUCTDIR="${1}"
STRUCT="${2}"

# Get FSL setup
source combine_setup.sh

# Get to our directory
echo "${STRUCTDIR}"
cd "${STRUCTDIR}"

# Bail if the proposed output <struct>_ROA.nii.gz already exists
OUTROA="${STRUCT}"_L_ROA.nii.gz
if [ -f "${OUTROA}" ] ; then
	echo "WARNING - skipping because of existing file ${OUTROA} in ${STRUCTDIR}"
	exit 0
fi

# Combine all ROA files
#fslmerge -t "${OUTROA}" "${STRUCT}"_L_ROA?.nii.gz
fslmerge -t mergetmp.nii.gz "${STRUCT}"_L_ROA?.nii.gz
fslmaths mergetmp.nii.gz -Tmax "${OUTROA}"
rm mergetmp.nii.gz

# Repeat for R hemisphere
OUTROA="${STRUCT}"_R_ROA.nii.gz
if [ -f "${OUTROA}" ] ; then
	echo "WARNING - skipping because of existing file ${OUTROA} in ${STRUCTDIR}"
	exit 0
fi
fslmerge -t mergetmp.nii.gz "${STRUCT}"_R_ROA?.nii.gz
fslmaths mergetmp.nii.gz -Tmax "${OUTROA}"
rm mergetmp.nii.gz

