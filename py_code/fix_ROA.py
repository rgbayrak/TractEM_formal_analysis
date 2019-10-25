import numpy as np
import glob
import os
import nibabel as nib
#import matplotlib.pyplot as plt

def read_data(path):
    image = nib.load(path)
    image_data=image.get_data()
    image_header=image.header
    return image_data


def show_img(ori_img):
    plt.imshow(ori_img[:, :, 85], cmap='gray')  # channel_last
    plt.show()
#data =read_data('ol_R_ROA1.nii.gz')
#show_img(data)

def write_data(in_path,out_path):
    image = nib.load(in_path)
    basename=os.path.basename(in_path)
    b=basename.split('_')
    image_data = image.get_data()
    image_affine=image.affine
    a=np.ones((157,156))
    c=np.ones((157,189))
    L=np.zeros((157,189,156))
    R=np.zeros((157,189,156))
    R[0:78,:,:]=image_data[0:78,:,:]
    L[79:157,:,:]=image_data[79:157,:,:]
    for j in range(0,156):
        if sum(sum(L[:,:,j]==c))>=5000:
          L[:,:,j]=c
          R[:,:,j]=c
    for i in  range(0,189):
        if sum(sum(L[:,i,:]==a))>=5000:
          L[:,i,:]=a
          R[:,i,:]=a
    L_new_file=nib.Nifti1Image(L, image_affine)
    R_new_file = nib.Nifti1Image(R, image_affine)
    nib.save(R_new_file, os.path.join(out_path, b[0] + '_R_' + b[1]))
    nib.save(L_new_file, os.path.join(out_path, b[0] + '_L_' + b[1]))
in_path='/share4/wangx41/regions/BLSA/1127_Aviral/parietal_lobe/pl_ROA1.nii.gz'
out_path='/share4/wangx41/regions/BLSA/1127_Aviral/parietal_lobe'
write_data(in_path,out_path)