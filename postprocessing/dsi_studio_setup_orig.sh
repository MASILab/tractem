#!/bin/sh

# DSI Studio command line binary
export DSI_STUDIO=/Applications/dsi_studio.app/Contents/MacOS/dsi_studio

# Options for tractography
export DSI_OPTION_STRING="--method=0 --fiber_count=100000 --threshold_index=nqa --fa_threshold=0.1 --initial_dir=0 --step_size=0 --smoothing=1 --min_length=30 --max_length=300 --random_seed=0 --seed_plan=0 --interpolation=0"

# FSL configuration
FSLDIR=/usr/local/fsl
PATH=${FSLDIR}/bin:${PATH}
source ${FSLDIR}/etc/fslconf/fsl.sh
export FSLDIR PATH
