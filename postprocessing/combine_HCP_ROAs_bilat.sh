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

# Skip if there's no ROA2 file
if [ ! -f "${STRUCT}"_ROA2.nii.gz ] ; then
	echo "     - SKIPPING because no ROA2 file in ${STRUCTDIR}"
	exit 0
fi

# Move existing ROA files to subdirectory
mkdir original_ROAs
mv "${STRUCT}"_ROA?.nii.gz original_ROAs
sleep 5

# Combine all ROA files
ls original_ROAs/"${STRUCT}"_ROA?.nii.gz
fslmerge -t \
	mergetmp.nii.gz \
	original_ROAs/"${STRUCT}"_ROA?.nii.gz
fslmaths mergetmp.nii.gz -Tmax -bin "${STRUCT}"_ROA1.nii.gz
rm mergetmp.nii.gz

