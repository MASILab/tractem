#!/bin/sh
#
# Given a .fib file, run all tract reconstructions.
#
# Usage:
#    sh run_all.sh /full/path/to/fib.nii.gz

FIB="${1}"

for STRUCT in \
	anterior_commissure \
	anterior_corona_radiata \
	body_corpus_callosum \
	; do
		
	sh ${STRUCT}.sh "${FIB}"

done
