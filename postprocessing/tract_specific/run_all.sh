#!/bin/sh
#
# Given a .fib file, run all tract reconstructions.
#
# Usage:
#    sh run_all.sh /full/path/to/fib.nii.gz /path/to/label.nii.gz

FIB="${1}"
LABEL="${2}"

# Left and right tracts, 1 seed each, single shared ROA
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      anterior_limb_internal_capsule aic
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      cerebral_peduncle cp
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      medial_lemniscus ml
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      olfactory_radiation olfr
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      posterior_corona_radiata pcr
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      posterior_limb_internal_capsule pic
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      sagittal_stratum ss
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      superior_corona_radiata scr
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      superior_longitudinal_fasciculus slf
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      uncinate_fasciculus unc

# Left and right tracts, 1 seed each, 1 ROI each, single shared ROA
sh seed1_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      anterior_corona_radiata acr
sh seed1_LR_roa1s_roi1.sh "${FIB}" "${LABEL}"      corticospinal_tract cst
sh seed1_LR_roa1s_roi1.sh "${FIB}" "${LABEL}"      fornix_stria_terminalis fxst
sh seed1_LR_roa1s_roi1.sh "${FIB}" "${LABEL}"      inferior_cerebellar_peduncle icp
sh seed1_LR_roa1s_roi1.sh "${FIB}" "${LABEL}"      pontine_crossing_tract pct
sh seed1_LR_roa1s_roi1.sh "${FIB}" "${LABEL}"      superior_fronto_occipital_fasciculus sfo

# Left and right tracts, 1 seed each, 2 ROIs each, single shared ROA
sh seed1_LR_roa1s_roi2.sh "${FIB}" "${LABEL}"      cingulum_hippocampal cgh
sh seed1_LR_roa1s_roi2.sh "${FIB}" "${LABEL}"      inferior_fronto_occipital_fasciculus ifo
sh seed1_LR_roa1s_roi2.sh "${FIB}" "${LABEL}"      inferior_longitudinal_fasciculus ilf

# Left and right tracts, 1 seed each, single shared ROI, single shared ROA
sh seed1_LR_roa1s_roi1s.sh "${FIB}" "${LABEL}"     fornix fx

# Left and right tracts, 1 seed each, 1 ROA each, 2 ends each
sh seed1_LR_roa1_roi0_end2.sh "${FIB}" "${LABEL}"  frontal_lobe fl
sh seed1_LR_roa1_roi0_end2.sh "${FIB}" "${LABEL}"  occipital_lobe ol
sh seed1_LR_roa1_roi0_end2.sh "${FIB}" "${LABEL}"  parietal_lobe pl

# Left and right tracts, 1 seed each, 1 shared ROA, 2 ends each
sh seed1_LR_roa1s_roi0_end2.sh "${FIB}" "${LABEL}" temporal_lobe tl

# Left and right tracts, 2 seeds each, single shared ROA
sh seed2_LR_roa1s_roi0.sh "${FIB}" "${LABEL}"      cingulum_cingulate_gyrus cgc

# Left and right tracts, 2 seeds each, 1 ROI each, single shared ROA
sh seed2_LR_roa1s_roi1.sh "${FIB}" "${LABEL}"      posterior_thalamic_radiation ptr

# Single bilateral tract, 1 seed, 1 ROA
sh seed1_bilat_roa1_roi0.sh "${FIB}" "${LABEL}"    body_corpus_callosum bcc
sh seed1_bilat_roa1_roi0.sh "${FIB}" "${LABEL}"    genu_corpus_callosum gcc
sh seed1_bilat_roa1_roi0.sh "${FIB}" "${LABEL}"    midbrain m
sh seed1_bilat_roa1_roi0.sh "${FIB}" "${LABEL}"    splenium_corpus_callosum scc

# Single bilateral tract, 2 seeds, 1 ROABEL}"
sh seed2_bilat_roa1_roi0.sh "${FIB}" "${LABEL}"    anterior_commissure ac
sh seed2_bilat_roa1_roi0.sh "${FIB}" "${LABEL}"    middle_cerebellar_peduncle mcp
sh seed2_bilat_roa1_roi0.sh "${FIB}" "${LABEL}"    tapetum_corpus_callosum tap
sh seed2_bilat_roa1_roi0.sh "${FIB}" "${LABEL}"    optic_tract opt

# Single bilateral tract, 2 seeds, 1 ROA, 2 ROIs
sh seed2_bilat_roa1_roi2.sh "${FIB}" "${LABEL}"    superior_cerebellar_peduncle scp
