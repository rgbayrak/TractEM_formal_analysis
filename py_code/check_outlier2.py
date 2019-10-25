import numpy as np
import glob
import os
import nibabel as nib

def data_size(in_path,tractname,size_limit_LR,size_limit_ROA,size_limit_sum):
    dirt=[]
    for file in os.walk(in_path):
        #print(file)
        

        if os.path.basename(file[0])==tractname:
            print(file)
            xxxx
            for k in range(0,len(file[-1])):
                    path=os.path.join(str(file[0]),str(file[-1][k]))
                    dirt.append(path)
                  #print(dirt[0])
   
    with open('/home-local/wangx41/Downloads/test.txt', 'a') as fileobject:
        for files in dirt:
            a=0
            b=0
            c=np.ones((189,156))
            #image_affine=imag.affine
            basename=os.path.basename(files)
            R0 = '\nsize of ' + files+ ' may be wrong'
            R1 = '\nLeft file cover right region in ' + files
            R2 = '\nRight file covers left region in ' + files
            if not 'ROA' in basename & 'density' in basename & 'tract' in basename:
                if '_L_' in basename:
                    imag=nib.load(files)
                    image_data=imag.get_data()
                    #print('L')
                    if (os.path.getsize(files) / 1024) > size_limit_LR or (os.path.getsize(files) / 1024) < 4.5:
                        fileobject.write(R0)

                    for i in range(78, 157):
                        if np.where(image_data[i, :, :] > 0) != []:
                            
                            if sum(sum(image_data[i,:,:]==c))>=4:
                                b=1
                    if b==1:
                            fileobject.write(R1)
                else:
                    if not '_R_'in basename:
                        if (os.path.getsize(files) / 1024) > size_limit_sum or (os.path.getsize(files) / 1024) < 4.5:
                            fileobject.write(R0)
                if '_R_' in basename:
                    imag=nib.load(files)
                    image_data=imag.get_data()
                    if (os.path.getsize(files) / 1024) >size_limit_LR or (os.path.getsize(files) / 1024) <4.5:
                        fileobject.write(R0)
                    for i in range(0,78):
                        if np.where(image_data[i, :, :] > 0) != []:
                            if sum(sum(image_data[i,:,:]==c))>=4:
                                a=1
                    if a==1:
                        fileobject.write(R2)
                    
            if 'ROA' in basename:
                if (os.path.getsize(files) / 1024) > size_limit_ROA or (os.path.getsize(files) / 1024) <4.5 :
                    fileobject.write(R0)

in_path='/home-local/wangx41/Downloads/BLSA'
tractname='anterior_commissure'
size_limit_LR=6
size_limit_ROA=32
size_limit_sum=6
data_size(in_path,tractname,size_limit_LR,size_limit_ROA,size_limit_sum)








