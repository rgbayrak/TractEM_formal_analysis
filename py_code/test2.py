import subprocess
import os
import glob
import numpy as np
import nibabel as nib
from threading import Timer
import time
import eventlet
def skip_timeout(args, timeout):
    p = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE,shell=True)
    timer = Timer(timeout, lambda process: process.kill(), [p])
    try:
        timer.start()
        stdout, stderr = p.communicate()
        return_code = p.returncode
        return (stdout, stderr, return_code)
    finally:
        timer.cancel()

program='/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=//nfs/masi/bayrakrg/tractem_data/original/complete_BLSA_subjects/1881_Christa/1881_tal_fib.gz  --fiber_count=100000 --threshold_index=nqa --fa_threshold=0.1 --seed=/nfs/masi/bayrakrg/tractem_data/original/complete_BLSA_subjects/1881_Christa/pontine_crossing_tract/pct_R_seed1.nii.gz --roi=/nfs/masi/bayrakrg/tractem_data/original/complete_BLSA_subjects/1881_Christa/pontine_crossing_tract/pct_R_ROI.nii.gz --seed2=/nfs/masi/bayrakrg/tractem_data/original/complete_BLSA_subjects/1881_Christa/pontine_crossing_tract/pct_L_seed1.nii.gz --roi2=/nfs/masi/bayrakrg/tractem_data/original/complete_BLSA_subjects/1881_Christa/pontine_crossing_tract/pct_L_ROI.nii.gz --roa=/nfs/masi/wangx41/original_tract/BLSA/1881_Christa/pontine_crossing_tract/pct_ROA1.nii.gz --output=/nfs/masi/wangx41/original_tract/BLSA/1881_Christa/pontine_crossing_tract/pct_tract.trk.gz --export=tdi'
def skip_timeout(program,timeout):
     eventlet.monkey_patch()
     with eventlet.Timeout(timeout,False):
         time.sleep(4)
         subprocess.call(program,shell=True)
print(1)