#!/bin/sh
#
# Compute directory names for a specific case, specific tract. Encodes some of 
# our assumptions about how things are named when saved during the manual part 
# of the protocol.
#
# Usage: source get_dir_names.sh /fully/qualified/path/to/fibfile.fib.gz

FIB="${1}"
STRUCTURE="${2}"
export FIBDIR=`dirname "${FIB}"`
export STRUCTDIR="${FIBDIR}"/"${STRUCTURE}"
export OUTDIR="${FIBDIR}"/postproc/"${STRUCTURE}"
if [ ! -e "${OUTDIR}" ] ; then
	mkdir -p "${OUTDIR}"
fi
export LOGFILE="${OUTDIR}"/tracts_"${STRUCTURE}".log
