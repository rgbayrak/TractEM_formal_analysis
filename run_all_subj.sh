#!/bin/bash

# This script runs the specified shell script for every subject under a folder
# usage: bash run_all_subj.sh /path/to/folder

start=$(date +%s.%N)

for file in ${1}/* ; do
	echo $file
	#bash seed1_LR_roa1s_roi1.sh $file/tal_fib.gz /home/local/VANDERBILT/bayrakrg/Desktop/regions/*.nii.gz anterior_corona_radiata acr
	#bash seed2_bilat_roa1_roi0.sh $file/tal_fib.gz /home/local/VANDERBILT/bayrakrg/Desktop/regions/*.nii.gz anterior_commissure ac
	#bash seed1_LR_roa1s_roi0.sh $file/tal_fib.gz /home/local/VANDERBILT/bayrakrg/Desktop/regions/*.nii.gz anterior_limb_internal_capsule aic
	#bash seed1_bilat_roa1_roi0.sh $file/tal_fib.gz /home/local/VANDERBILT/bayrakrg/Desktop/regions/*.nii.gz body_corpus_callosum bcc
	#bash seed1_LR_roa1s_roi0.sh $file/tal_fib.gz /home/local/VANDERBILT/bayrakrg/Desktop/regions/*.nii.gz cerebral_peduncle cp
	bash seed2_LR_roa1s_roi0.sh $file/tal_fib.gz /home/local/VANDERBILT/bayrakrg/Desktop/regions/*.nii.gz cingulum_cingulate_gyrus cgc
done

dur=$(echo "$(date +%s.%N) - $start" | bc)
printf "Execution time: %.6f seconds " $dur

