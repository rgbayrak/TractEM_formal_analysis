#!/bin/bash
#
# Usage: bash <script> /path/to/fib.gz /path/to/label.nii.gz anterior_corona_radiata acr
# example: bash seed1_LR_roa1_roi1s.sh /home-local/bayrakrg/BLSA/BLSA_7759/tal_fib.gz /home/local/VANDERBILT/bayrakrg/Desktop/regions/*.nii.gz anterior_corona_radiata acr
# corticospinal_tract cst
# fornix_stria_terminalis fxst
# 
# Lots of assumptions being made here about how files are named and stored 
# after the manual part of the protocol.

# Structure names, long and short form from command line
STRUCTURE="${3}"
STRUCT="${4}"

# Get DSI Studio binary location, and tractography options. Then initialize 
# file and directory names.
source ../dsi_studio_setup_orig.sh
source ../get_dir_names.sh "${1}" "${2}" "${STRUCTURE}"

# Compute tracts and export density map
if [ -e "${LOGFILE}" ] ; then rm "${LOGFILE}" ; fi

# calculate execution time
start=$(date +%s.%N)

# do tracking
for H in L R ; do
	$DSI \
		--action=trk \
		--source=$FIB \
		--roi="${STRUCTDIR}"/"${STRUCT}"_${H}_ROI1.nii.gz \
		--roa="${STRUCTDIR}"/"${STRUCT}"_ROA1.nii.gz \
		--seed="${STRUCTDIR}"/"${STRUCT}"_${H}_seed1.nii.gz \
		${DSI_OPTION_STRING} \
		--output="${OUTDIR}"/"${STRUCT}"_${H}_tract.trk.gz \
		--export=tdi \
		>> "${LOGFILE}" 2>&1

	mv "${OUTDIR}"/"${STRUCT}"_${H}_tract.trk.gz.tdi.nii.gz \
		"${OUTDIR}"/"${STRUCT}"_${H}_density.nii.gz \
		>> "${LOGFILE}" 2>&1

done

dur=$(echo "$(date +%s.%N) - $start" | bc)
printf "Execution time: %.6f seconds " $dur
