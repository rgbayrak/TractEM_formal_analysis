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

def binary_data(in_path,out_path):
    image = nib.load(in_path)
    image_data = image.get_data()
    image_affine=image.affine
    data_max=image_data.max()
    x=image_data/data_max
    new_loc=x>=0.05
    x[:,:,:]=new_loc[0:157,0:189,0:156]
    #print(x.max())
    new_image = nib.Nifti1Image(x, image_affine)
    nib.save(new_image, out_path)
class write_data():
    def __init__(self, path,output_path):
        self.dir = []
        for i in os.listdir(path):
            for j in os.listdir(os.path.join(path, i)):
                for k in os.listdir(os.path.join(path, i,j)):
                    if not os.listdir(os.path.join(path, i, j,k)):
                         os.rmdir(os.path.join(path, i, j,k))
                    else:
                         self.dir.append(os.path.join(path, i, j,k))

        #self.dir = self.dir[::2]
        #del self.dir[0]
        #print( self.dir[0])
        self.output_path=output_path
        #print(self.output_path)
        #print(len(self.dir))
        #self.sample_size = len(self.dir)

    def __getitem__(self, index):
        image_path = self.dir[index]
        #print(image_path)
        b=image_path.split('/')
        #print(b)
        #print(os.path.join(self.output_path,b[4]))
        if not os.path.exists(os.path.join(self.output_path,b[6])):
            
            os.mkdir(os.path.join(self.output_path,b[6]))
        new_dir=os.path.join(self.output_path,b[6],b[7])
        if not os.path.exists(new_dir):
              os.mkdir(new_dir)
        if not os.path.exists(os.path.join(new_dir,b[8])):
              new_path=os.path.join(new_dir,b[8])
              os.mkdir(new_path)
              
        
        

        image_files = glob.glob(os.path.expanduser(os.path.join(image_path, '*density.nii.gz')))
        if not image_files==[]:
            for image in image_files:
                #print(image)
                basename = os.path.basename(image)
                out_path=os.path.join(output_path,b[6],b[7],b[8],basename)
                #print(out_path)

                binary_data(image,out_path)


        return  self.dir[index]

list_brain=['1043','0531','1127','1134','1525','1579','1632','5255','7822','7789','7759','7748','7690','7678','7573','6001','5923','5793','5750','5708','5414','5343','4767','4713','1881','1834','1692','130114','165436','135124','757764','971160','905147','177140','878877','167440','943862']
for number in list_brain: 
   path='/nfs/masi/wangx41/auto_transform_density/%s'%number
   output_path='/nfs/masi/wangx41/auto_binary_density/%s'%number
   if not os.path.exists(output_path):
       os.mkdir(output_path)
   data=write_data(path,output_path)
   for i in range(100000):
      data[i]
      print(i)
