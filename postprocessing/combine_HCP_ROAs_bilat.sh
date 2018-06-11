#!/bin/sh
# 
# Some HCP cases have multiple ROAs that need to be combined.

# Structure directory and structure short name from command line
STRUCTDIR="${2}"
STRUCT="${3}"

# Get FSL setup
source ../combine_setup.sh

# Get to our directory
cd "${STRUCTDIR}"

# Bail if the proposed output <struct>_ROA.nii.gz already exists
OUTROA="${STRUCT}"_ROA.nii.gz
if [ -e "${OUTROA}" ]
	echo 'WARNING - skipping because of existing file "${OUTROA}" in "${STRUCTDIR}"'
	exit 0
fi

# Combine all ROA files
fslmerge -t "${OUTROA}" "${STRUCT}"_ROA?.nii.gz

# Return
cd -
