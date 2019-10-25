import subprocess
import os
import glob
import numpy as np
import nibabel as nib
from threading import Timer
import time
import eventlet

#def skip_timeout(args, timeout):
    #p = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE,shell=True)
    #timer = Timer(timeout, lambda process: process.kill(), [p])
    #try:
        #timer.start()
        #stdout, stderr = p.communicate()
        #return_code = p.returncode
        #eturn (stdout, stderr, return_code)
    #finally:
        #timer.cancel()
def skip_timeout(program,timeout):
     eventlet.monkey_patch()
     with eventlet.Timeout(timeout,False):
         time.sleep(4)
         subprocess.call(program,shell=True)


def merge_seed(seed_list,out_path):
    x=np.zeros((157,189,156))
    y=np.zeros((157,189,156))
    if not seed_list==[]:
        image_affine=nib.load(seed_list[0]).affine
        for roa in seed_list:
            image_data = nib.load(roa).get_data()
            x += image_data
        new_loc=x>=1
        y[:,:,:]=new_loc[0:157,0:189,0:156]
        new_roa = nib.Nifti1Image(y, image_affine)
        nib.save(new_roa, out_path)



def create_tract(in_path_den,in_path_ROA,out_path,txtfile,folder_name,short_name):
    list_files=[]
    out_files=[]
    list_density_files=[]
    with open(txtfile, 'a') as fileobject:
        #for file in os.listdir(in_path):
            #dire.append(os.path.join(in_path, file))
            #print(dire)

        if not os.path.exists(os.path.join(out_path,folder_name)):
            os.mkdir(os.path.join(out_path,folder_name))
        for j in os.listdir(os.path.join(in_path_ROA, folder_name)):
            #print(os.listdir(os.path.join(in_path_ROA, folder_name,j)))
            if not os.listdir(os.path.join(in_path_ROA, folder_name,j)):
    
                 os.rmdir(os.path.join(in_path_ROA, folder_name,j))
            else:
                 if not os.path.exists(os.path.join(out_path, folder_name,j)):
                        #print(1)
                        os.mkdir(os.path.join(out_path, folder_name,j))
                 out_files.append(os.path.join(out_path, folder_name,j))
                 list_files.append(os.path.join(in_path_ROA, folder_name,j))
                 list_density_files.append(os.path.join(in_path_den, folder_name, j))
        #print(list_files) 
        #print(out_files)


        for g in list_files:
            ROA = glob.glob(os.path.expanduser(os.path.join(g, '*.nii.gz')))
            #print(ROA)
            basename=os.path.basename(ROA[0])
            short=basename.split('_')[0]
            #print(short)
            if short in short_name:
                #program = '/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=/%s/%s_tal_fib.gz --threshold_index=nqa --fiber_count=100000 --fa_threshold=0.1 --min_length=30 --max_length=300 --thread_count=2' % (folder,number)
                program = '/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=/nfs/masi/wangx41/autotract_method2/1578/1578_tal_fib.gz --threshold_index=nqa --parameter_id=CDCCCC3D9A99193Fb803Fcb803FbF041b9643A08601ca01dcba'
                program1 = '/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=/nfs/masi/wangx41/autotract_method2/1578/1578_tal_fib.gz --threshold_index=nqa --parameter_id=CDCCCC3D9A99193Fb803Fcb803FbF041b9643A08601ca01dcba'
                out=out_files[list_files.index(g)]
                density=list_density_files[list_files.index(g)]
                program += ' --roa=%s' % ROA[0]
                program1 += ' --roa=%s' % ROA[0]
                list_ROI=glob.glob(os.path.expanduser(os.path.join(density, '*.nii.gz')))
                #print(list_ROI)
               
                if list_ROI:
                    if len(list_ROI) == 1:
                        basenameROI = os.path.basename(list_ROI[0])
                        program += ' --roi=%s' % list_ROI[0]
                        program += ' --output=%s --export=tdi' % os.path.join(out, basenameROI.replace('density.nii.gz',
                                                                                                   'tract.trk.gz'))
                        fileobject.write('\n' + program)
                        skip_timeout(program, 1500)

                    else:
                        basenameROI = os.path.basename(list_ROI[0])
                        basenameROI1 = os.path.basename(list_ROI[1])
                        program += ' --roi=%s' % list_ROI[0]
                        program1 += ' --roi=%s' % list_ROI[1]
                        program += ' --output=%s --export=tdi' % os.path.join(out, basenameROI.replace('density.nii.gz',
                                                                                                   'tract.trk.gz'))
                        program1 += ' --output=%s --export=tdi' % os.path.join(out, basenameROI1.replace('density.nii.gz',
                                                                                                     'tract.trk.gz'))
                        fileobject.write('\n' + program)
                        fileobject.write('\n' + program1)
                        skip_timeout(program, 1500)
                        skip_timeout(program1, 1500)
short_name=['ac','acr','aic','bcc','cp','cgc','cgh','cst','fx','fxst','gcc','icp','ifo','ilf','ml','m','mcp','olfr','opt','pct','pcr','pic','ptr','ss','scc', 'scp','scr','sfo','slf','tap','unc']
txtfile='/home-local/wangx41/tract_command_density.txt'
in_path_ROA='/nfs/masi/wangx41/transform_ROA/1578/BLSA'
in_path_den='/nfs/masi/wangx41/auto_binary_density/1578/BLSA'
folder_names=['5708_Xuan', '7759_Xuan', '1134_Christa', '1134_Roza', '5750_Jasmine', '1134_Xuan', '7748_Bruce', '1134_Bruce', '7678_Aviral', '5708_Christa', '1134_Christa_2', '7748_Xuan', '1632_Roza', '7748_Roza', '1632_Xuan', ]
#folder_names=['5708_Xuan']
#in_path='/nfs/masi/wangx41/complete_data/BLSA18'
out_path='/nfs/masi/wangx41/autotract_method2/1578/BLSA'
for foldername in folder_names:
    
    create_tract(in_path_den,in_path_ROA,out_path,txtfile,foldername,short_name)
