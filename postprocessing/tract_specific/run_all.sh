#!/bin/sh
#
# Given a .fib file, run all tract reconstructions.
#
# Usage:
#    sh run_all.sh /full/path/to/fib.nii.gz

FIB="${1}"

sh seed1_LR_roa1_roi0.sh "${FIB}" anterior_corona_radiata acr
sh seed2_bilat_roa1_roi0.sh "${FIB}" anterior_commissure ac
sh seed1_bilat_roa1_roi0.sh "${FIB}" body_corpus_callosum bcc
