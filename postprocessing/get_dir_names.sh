#!/bin/sh
#
# Compute directory names for a specific case, specific tract. Encodes some of 
# our assumptions about how things are named and stored:
#
#     Seed and ROA images from the manual part of the protocol are in the 
#     STRUCTURE subdirectory below the directory that the .fib file is in
#
#     Output is stored in the postproc/STRUCTURE subdirectory below the 
#     directory that the .fib file is in
#
# Usage: source get_dir_names.sh /full/path/to/fibfile.fib.gz structure_name

FIB="${1}"
STRUCTURE="${2}"
export FIBDIR=`dirname "${FIB}"`
export STRUCTDIR="${FIBDIR}"/"${STRUCTURE}"
export OUTDIR="${FIBDIR}"/postproc/"${STRUCTURE}"
if [ ! -e "${OUTDIR}" ] ; then
	mkdir -p "${OUTDIR}"
fi
export LOGFILE="${OUTDIR}"/tracts_"${STRUCTURE}".log
