#!/bin/sh

# FSL configuration
FSLDIR=/usr/local/fsl
PATH=${FSLDIR}/bin:${PATH}
source ${FSLDIR}/etc/fslconf/fsl.sh
export FSLDIR PATH
