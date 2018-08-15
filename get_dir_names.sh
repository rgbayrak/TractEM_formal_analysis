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
# Usage: source get_dir_names.sh /full/path/to/fibfile.fib.gz /full/path/to/label.nii.gz structure_name

FIB="${1}"
LABEL="${2}"
STRUCTURE="${3}"
export FIBDIR=`dirname "${FIB}"`
export LABELDIR=`dirname "${LABEL}"`
export STRUCTDIR="${LABELDIR}"/"${STRUCTURE}"
export OUTDIR="${FIBDIR}"/"${STRUCTURE}"
if [ ! -e "${OUTDIR}" ] ; then
        mkdir -p "${OUTDIR}"
fi
export LOGFILE="${OUTDIR}"/tracts_"${STRUCTURE}".log

