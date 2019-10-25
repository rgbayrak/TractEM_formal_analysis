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



def create_tract(in_path_den,in_path_ROA,out_path,txtfile,file_name,short_name):
    list_ROA=os.listdir(in_path_ROA)
    #print(list_ROA)
    with open(txtfile, 'a') as fileobject:
        #for file in os.listdir(in_path):
            #dire.append(os.path.join(in_path, file))
            #print(dire)
        for g in list_ROA:
            ROA=os.path.join(in_path_ROA,g)
            basename=os.path.basename(ROA)
            short=basename.split('_')[0]
            print(short)
                #program = '/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=/%s/%s_tal_fib.gz --threshold_index=nqa --fiber_count=100000 --fa_threshold=0.1 --min_length=30 --max_length=300 --thread_count=2' % (folder,number)
            program = '/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=/nfs/masi/wangx41/autotract_method2/1578/1578_tal_fib.gz --threshold_index=nqa --parameter_id=CDCCCC3D9A99193Fb803Fcb803FbF041b9643A08601ca01dcba'
            program1 = '/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=/nfs/masi/wangx41/autotract_method2/1578/1578_tal_fib.gz --threshold_index=nqa --parameter_id=CDCCCC3D9A99193Fb803Fcb803FbF041b9643A08601ca01dcba'
            tract=file_name[short_name.index(short)]
            if not os.path.exists(os.path.join(out_path, tract)):
                os.mkdir(os.path.join(out_path, tract))
            list_ROI=glob.glob(os.path.expanduser(os.path.join(in_path_den,basename.replace('ROA','density_average'))))
       
            program += ' --roa=%s' % ROA
            program1 += ' --roa=%s' % ROA

            if list_ROI:
                if len(list_ROI) == 1:
                    basenameROI = os.path.basename(list_ROI[0])
                    out = os.path.join(out_path, tract, basenameROI.replace('density_average1.nii.gz', 'tract.trk.gz'))
                    program += ' --roi=%s' % list_ROI[0]
                    program += ' --output=%s --export=tdi' % out
                    print(program)
                    fileobject.write('\n' + program)
                    skip_timeout(program, 1500)

                else:
                    basenameROI = os.path.basename(list_ROI[0])
                    basenameROI1 = os.path.basename(list_ROI[1])
                    out= os.path.join(out_path, tract, basenameROI.replace('density_average1.nii.gz', 'tract.trk.gz'))
                    out1 = os.path.join(out_path, tract, basenameROI1.replace('density_average1.nii.gz', 'tract.trk.gz'))
                    program += ' --roi=%s' % list_ROI[0]
                    program1 += ' --roi=%s' % list_ROI[1]
                    program += ' --output=%s --export=tdi' % out
                    program1 += ' --output=%s --export=tdi' % out1
                    fileobject.write('\n' + program)
                    fileobject.write('\n' + program1)
                    skip_timeout(program, 1500)
                    skip_timeout(program1, 1500)

list1=['0.0','0.1','0.3','0.5','0.7']
txtfile='/home-local/wangx41/tract_command_density2.txt'
file_name=['anterior_commissure','anterior_corona_radiata','anterior_limb_internal_capsule','body_corpus_callosum','cerebral_peduncle',
           'cingulum_cingulate_gyrus', 'cingulum_hippocampal', 'corticospinal_tract', 'fornix', 'fornix_stria_terminalis',
           'genu_corpus_callosum', 'inferior_cerebellar_peduncle', 'inferior_fronto_occipital_fasciculus', 'inferior_longitudinal_fasciculus',
           'medial_lemniscus', 'midbrain', 'middle_cerebellar_peduncle', 'olfactory_radiation', 'optic_tract', 'pontine_crossing_tract',
           'posterior_corona_radiata', 'posterior_limb_internal_capsule', 'posterior_thalamic_radiation','sagittal_stratum', 'splenium_corpus_callosum',
           'superior_cerebellar_peduncle', 'superior_corona_radiata', 'superior_fronto_occipital_fasciculus','superior_longitudinal_fasciculus',
           'tapetum_corpus_callosum', 'uncinate_fasciculus']
short_name=['ac','acr','aic','bcc','cp','cgc','cgh','cst','fx','fxst','gcc','icp','ifo','ilf','ml','m','mcp','olfr','opt','pct','pcr','pic','ptr','ss','scc', 'scp','scr','sfo','slf','tap','unc']
for i in list1:
    in_path_ROA='/nfs/masi/wangx41/sum_average/1578/average_0.0/average_%s/ROA'%i
    in_path_den='/nfs/masi/wangx41/sum_average/1578/average_0.0/average_%s'%i
    out_path='/nfs/masi/wangx41/autotract_methord1/binary_0.0/average_invROA_ROI%s'%i
    create_tract(in_path_den,in_path_ROA,out_path,txtfile,file_name,short_name)
    
  

