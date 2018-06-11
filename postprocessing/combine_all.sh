#!/bin/sh

# Specific subject directory
SDIR="${1}"

# Left and Right ROAs
sh combine_HCP_ROAs_LR.sh "${SDIR}"/frontal_lobe fl
sh combine_HCP_ROAs_LR.sh "${SDIR}"/occipital_lobe ol
sh combine_HCP_ROAs_LR.sh "${SDIR}"/parietal_lobe pl

# Single bilateral ROA
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/anterior_corona_radiata acr
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/anterior_limb_internal_capsule aic
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/cerebral_peduncle cp
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/medial_lemniscus ml
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/olfactory_radiation olfr
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/posterior_corona_radiata pcr
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/posterior_limb_internal_capsule pic
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/sagittal_stratum ss
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/superior_corona_radiata scr
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/superior_longitudinal_fasciculus slf
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/uncinate_fasciculus unc
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/corticospinal_tract cst
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/fornix_stria_terminalis fxst
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/inferior_cerebellar_peduncle icp
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/pontine_crossing_tract pct
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/superior_fronto_occipital_fasciculus sfo
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/cingulum_hippocampal cgh
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/inferior_fronto_occipital_fasciculus ifo
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/inferior_longitudinal_fasciculus ilf
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/fornix fx
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/temporal_lobe tl
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/cingulum_cingulate_gyrus cgc
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/posterior_thalamic_radiation ptr
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/body_corpus_callosum bcc
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/genu_corpus_callosum gcc
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/midbrain m
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/splenium_corpus_callosum scc
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/anterior_commissure ac
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/middle_cerebellar_peduncle mcp
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/tapetum_corpus_callosum tap
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/optic_tract opt
sh combine_HCP_ROAs_bilat.sh "${SDIR}"/superior_cerebellar_peduncle scp
