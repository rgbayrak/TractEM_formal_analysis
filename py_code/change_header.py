import numpy as np
import glob
import os
import nibabel as nib



class write_data():
    def __init__(self, path,output_path):
        self.dir = []
        for i in os.listdir(path):
            for j in os.listdir(os.path.join(path, i)):
                self.original_path = os.path.join(os.path.join(path, i), j)
                self.dir.append(self.original_path)

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
        if not os.path.exists(os.path.join(self.output_path,b[4])):
            
            os.mkdir(os.path.join(self.output_path,b[4]))
        new_dir=os.path.join(self.output_path,b[4],b[5])
        if not os.path.exists(new_dir):
            os.mkdir(new_dir)
        
        #print(new_dir)

        image_files = glob.glob(os.path.expanduser(os.path.join(image_path, '*.nii.gz')))
        if not image_files==[]:
            for image in image_files:
                #print(image)
                basename = os.path.basename(image)
                img=nib.load(image)

                image_data = img.get_data()
                #print(image_data)
                image_affine = img.affine
                rot_affine = np.array([[-1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]])
                new_affine = rot_affine.dot(image_affine)
                new_affine = new_affine + np.array([[0, 0, 0, 78], [0, 0, 0, -112], [0, 0, 0, -70], [0, 0, 0, 0]])
                x = np.zeros((156, 189, 157))
                image_data = np.transpose(image_data, (2, 1, 0))
                for i in range(0, 189):
                    x[:, i, :] = np.fliplr(image_data[:, i, :])
                x = np.transpose(x, (2, 1, 0))
                #print(x.shape)
                new_image = nib.Nifti1Image(x, new_affine)
                nib.save(new_image, os.path.join(new_dir, basename))


        return  self.dir[index]

    #def __len__(self):
        #return self.sample_size

path = '/share4/wangx41/regions'
output_path = '/share4/wangx41/corrected_header_regions'

data=write_data(path,output_path)
for i in range(2200):
    data[i]
    print(i)
   




