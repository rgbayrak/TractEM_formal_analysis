import numpy as np
import glob
import os
import nibabel as nib

def inverse_ROA(density_file):
    x=np.ones((157,189,156))
    image_affine = nib.load(density_file).affine
    image_data = nib.load(density_file).get_data()
    new_ROA=x-image_data
    new_roa = nib.Nifti1Image(new_ROA, image_affine)
    return new_roa

def create_file(density_path,out_path):
    list_density = os.listdir(density_path)
    for density_file in list_density:
        if os.path.isfile(os.path.join(density_path,density_file)):
           print(density_file)
           x=np.ones((157,189,156))
           image_affine = nib.load(os.path.join(density_path,density_file)).affine
           image_data = nib.load(os.path.join(density_path,density_file)).get_data()
           new_ROA=x-image_data
           new_roa = nib.Nifti1Image(new_ROA, image_affine)
           out=os.path.join(out_path,density_file.replace('density_average','ROA'))
           nib.save(new_roa, out)
density_path='/nfs/masi/wangx41/sum_average/1578/average_0.0/average_0.7'
out_path='/nfs/masi/wangx41/sum_average/1578/average_0.0/average_0.7/ROA'

create_file(density_path,out_path)

