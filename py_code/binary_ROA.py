import numpy as np
import glob
import os
import nibabel as nib
#import matplotlib.pyplot as plt



def binary_data(in_path,threshold):
    image = nib.load(in_path)
    image_data = image.get_data()
    image_affine=image.affine
    new_loc=image_data>=threshold
    x[:,:,:]=new_loc[0:157,0:189,0:156]
    #print(x.max())
    return x
    
    
def write_data(in_path,out_path,threshold,ROAnumberlist,short_list):
    list_ROA=os.listdir(in_path)
    for ROA in list_ROA:
        x=np.zeros((157,189,156))
        b=ROA.split('_')
        short_name=b[0]
        ROAnumber=ROAnumberlist[short_list.index(short_name)]
        image = nib.load(os.path.join(in_path,ROA))
        image_data = image.get_data()
        #print(image_data.max())
        new=image_data /ROAnumber
        print(new.max())
        image_affine=image.affine
        new_loc=new>threshold
       # print(ROAnumber)
        x[:,:,:]=new_loc[0:157,0:189,0:156]
        new_image = nib.Nifti1Image(x, image_affine)
        nib.save(new_image, out_path+'/'+ROA.replace('sum','average'))
ROAnumberlist=[59,60,60,59,60,59,57,60,59,50,60,60,53,59,60,60,60,59,59,59,60,60,59, 60,60,60,60,57,59,60,60]#60,59,60,60]
short_list=['ac','acr','aic','bcc','cp','cgc','cgh','cst','fx','fxst','gcc','icp','ifo','ilf','ml','m','mcp','olfr','opt','pct','pcr','pic','ptr','ss','scc', 'scp','scr','sfo','slf','tap','unc']
path='/nfs/masi/wangx41/sum_average/1578/sum_density_0.0'
output_path='/nfs/masi/wangx41/sum_average/1578/average_0.0/average_0.3'
data=write_data(path,output_path,0.3,ROAnumberlist,short_list)




