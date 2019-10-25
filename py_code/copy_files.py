import os
import subprocess
import shutil
import glob

def new_density(path):
   #if not os.path.exists(output):
          #os.mkdir(output)
   for  root, dirs, files in os.walk(path):
       print(files)
       if files:
           list1=[]
           
           for density in files:
               if 'tdi.nii.gz' in density:
                   list1.append(density)

                   b=(density.split('.')[0]).split('_')
                   del b[-1]
                   b=['_'.join(b)]
                   density_new=b[0]+'_density.nii.gz'
                   output_path=os.path.join(root,density_new)
                   in_path=os.path.join(root,density)
                   #print(in_path)
                   program1='cp '+in_path+' '+output_path
                   #print(density_new)
                   subprocess.call(program1,shell=True)
           #if list1==[]:
              #for density in files:               
                   #if 'density.nii.gz' in density:
                       #output_path=os.path.join(output,density)
                       #in_path=os.path.join(root,density)
                       #program1='cp '+in_path+' '+output_path
                       #subprocess.call(program1,shell=True)
def old_density(path,output):
    if not os.path.exists(output):
        os.mkdir(output)
    for  root, dirs, files in os.walk(path):
       if files:
           for density in files:
               if '_density.nii.gz' in density:
                   
                   output_path=os.path.join(output,density)
                   in_path=os.path.join(root,density)
                   #print(in_path)
                   program1='cp '+in_path+' '+output_path
                   #print(density_new)
                   subprocess.call(program1,shell=True)

#file_list=['5793_Xuan', '1525_Roza', '4767_Xuan', '7789_Christa', '4713_Christa', '5255_Xuan', '0531_Xuan', '5923_Christa', '1525_Christa', '5414_Christa', '5343_Christa', '6001_Xuan', '7822_Christa', '1043_Xuan', '1579_Roza', '1692_Xuan', '7690_Xuan', '1579_Christa', '1578_Xuan', '7573_Christa']
file_list=['average_ROA0.1_ROI0.1','average_ROA0.1_ROI0.3','average_ROA0.1_ROI0.5','average_ROA0.1_ROI0.7','average_ROA0.1_ROI0.0']


for iterm in file_list:
   
    #path='/nfs/masi/bayrakrg/tractem_data/corrected/BLSA18/'+iterm
    path='/nfs/masi/wangx41/autotract_methord1/binary_0.0/'+iterm
    #output='/nfs/masi/wangx41/missing_fix/old/BLSA18_old/'+iterm
    out_put='/nfs/masi/wangx41/missing_fix/average/1578/binary_0.0/'+iterm
    #output='/nfs/masi/wangx41/auto_tracked_from_corrected_regions/HCP/'+iterm
    #path='/nfs/masi/wangx41/auto_tracked_from_corrected_regions/BLSA18/'+iterm
    old_density(path,out_put)

