import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt


def read_data(path):
    image = nib.load(path)
    image_data=image.get_data()
    image_header=image.header
    print(image_header)
    return image_data


def show_img(ori_img):
    plt.imshow(ori_img[:, :, 85], cmap='gray')  # channel_last
    plt.show()

def write_data(path1,path2):
    image1 = nib.load(path1)
    image2 = nib.load(path2)
    image_data = image1.get_data()
    print(image_data.shape)
    image_affine = image2.affine
    new_data = np.asarray(image_data,dtype=np.int16)
    new_image = nib.Nifti1Image(new_data, image_affine)
    nib.save(new_image,'/home/local/VANDERBILT/bayrakrg/Desktop/region/ml_L_seed1_test_overlap.nii.gz')


#path = r'E:\course\thesis\reg1043\output\m_seed1_overlap.nii.gz'
path1='/home/local/VANDERBILT/bayrakrg/Desktop/region/ml_L_seed1.nii.gz'
path2='/home/local/VANDERBILT/bayrakrg/Desktop/region/wcrmBLSA_1134_16-0_10_MPRAGE.nii'
#data = read_data(path)
write_data(path1,path2)
#show_img(data)


#fslorient -forceneurological /home/local/VANDERBILT/bayrakrg/Desktop/region/ml_L_seed1_test_overlap.nii.gz
