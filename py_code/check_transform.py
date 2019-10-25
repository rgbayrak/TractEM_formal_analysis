import numpy as np
import glob
import os
import nibabel as nib

def check_density(path1,path2,number):
   
    for  root, dirs, files in os.walk(path1):
       if files:
           for density in files:
               #print(root)
               if '_density.nii.gz' in density: 
                   b=root.split('/')
                   #print(b)
                   number1=b[6].split('_')[0]
                   #print(number1)
                   if not number1==number:
                      path_original=os.path.join(root,density)
                      if os.path.exists(path_original):
                          #print(path_original)
                          path_transform=os.path.join(path2,b[5],b[6],b[7],density)
                          #print(path_transform)
                          if not os.path.exists(path_transform):
                               print(path_transform)
list_brain=['1043','0531','1127','1134','1525','1578','1579','1632','5255','7822','7789','7759','7748','7690','7678','7573','6001','5923','5793','5750','5708','5414','5343','4767','4713','1881','1834','1692','130114','165436','135124','757764','971160','905147','177140','878877','167440','943862']
                  
for number in list_brain: 
        
   path1='/nfs/masi/wangx41/auto_changed_header_density'
   path2='/nfs/masi/wangx41/auto_transform_density/'+number
   check_density(path1,path2,number)    
