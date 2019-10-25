import subprocess
import os
import glob
import numpy as np
import nibabel as nib
from threading import Timer
import time
import eventlet

def skip_timeout(program,timeout):
     eventlet.monkey_patch()
     with eventlet.Timeout(timeout,False):
         time.sleep(4)
         subprocess.call(program,shell=True)
#def skip_timeout(args, timeout):
    #p = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE,shell=True)
    #timer = Timer(timeout, lambda process: process.kill(), [p])
    #try:
        #timer.start()
        #stdout, stderr = p.communicate()
        #return_code = p.returncode
        #return (stdout, stderr, return_code)
    #finally:
        #timer.cancel()



#def merge_roa(roa_list,out_path):
    #x=np.zeros((157,189,156))
    #y=np.zeros((157,189,156))
    #if not roa_list==[]:
        #image_affine=nib.load(roa_list[0]).affine
        #for roa in roa_list:
            #image_data = nib.load(roa).get_data()
            #x += image_data
        #new_loc=x>=1
        #y[:,:,:]=new_loc[0:157,0:189,0:156]
        #new_roa = nib.Nifti1Image(y, image_affine)
        #nib.save(new_roa, out_path)



def create_tract(dire,in_path,out_path,txtfile,file_name,short_name,tract_number,number_roi):
    
    with open(txtfile, 'a') as fileobject:
        #for file in os.listdir(in_path):
            #dire.append(os.path.join(in_path, file))
            #print(dire)
        for basename_folder in dire:
            folder=os.path.join(in_path,basename_folder)
            #print(folder)
            #basename_folder = os.path.basename(folder)
            #print(basename_folder)
            path=os.path.join(out_path, basename_folder)
            #print(path)
            if not os.path.exists(path):
                os.mkdir(path)
            number = basename_folder[0:4]
            
            for tractfolder in file_name:
                #print(tractfolder)
                
                #if not tractfolder in file_name:
                    #R1 = '\n'+'Misnaming ' + os.path.join(folder, tractfolder)
                    #fileobject.write(R1)
                    #continue
                region_list = glob.glob(os.path.expanduser(os.path.join(folder, tractfolder, '*.nii.gz')))
                program = '/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=/%s/%s_tal_fib.gz  --fiber_count=100000 --threshold_index=nqa --fa_threshold=0.1' % (folder,number)
                program1='/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=/%s/%s_tal_fib.gz  --fiber_count=100000 --threshold_index=nqa --fa_threshold=0.1' % (folder,number)
               
              
            
                path1=os.path.join(out_path, basename_folder, tractfolder)
                if not os.path.exists(path1):
                    os.mkdir(path1)
                if not region_list == []:
                      roa_list =roa_listL=roa_listR= []
                      if short_name[file_name.index(tractfolder)] == 'tl':

                          il = k = jl = i = j = 0
                          for region in region_list:
                              basename = os.path.basename(region)
                              #print(basename)
                              
                              
                              if 'L_seed' in basename:
                                  il += 1
                                  if il == 1:
                                      program += ' --seed=%s' % region
                                      #print(program)
                                  else:
                                      program += ' --seed%d=%s' % (il, region)
                              if 'L_end' in basename:
                                  jl += 1
                                  if jl == 1:
                                      
                                      program += ' --end=%s' % region
                                  else:
                                      
                                      program += ' --end%d=%s' % (jl, region)
                              if 'R_end' in basename:
                                  j += 1
                                  if j == 1:
                                      program1 += ' --end=%s' % region
                                      
                                  else:
                                      program1 += ' --end%d=%s' % (j, region)
                                     


                              if 'ROA' in basename:
                                  #roa_list.append(region)
                                  program1 += ' --roa=%s' % region
                                  program += ' --roa=%s' % region
                              if 'R_seed' in basename:
                                  i += 1
                                  if i == 1:
                                      program1 += ' --seed=%s' % region
                                  else:
                                      program1 += ' --seed%d=%s' % (i, region)
                          #out_path1 = os.path.join(path1, 'tl_ROA1.nii.gz')
                          #merge_roa(roa_list, out_path1)
                          #program1 += ' --roa=%s' % out_path1
                          #program += ' --roa=%s' % out_path1
                          program += ' --output=%s/tl_L_tract.trk.gz --export=tdi' % os.path.join(out_path, basename_folder, tractfolder)
                        
                          program1 += ' --output=%s/tl_R_tract.trk.gz --export=tdi' % os.path.join(out_path, basename_folder, tractfolder)
                          
                          #fileobject.write(program1)
                          #fileobject.write(program)
                          #print(program)
                          #print(program1)
                          skip_timeout(program,900)
                          skip_timeout(program1,900)
                      else:
                         
                              il = jl = i = j =0
                                  
                              for region in region_list:
                                  basename = os.path.basename(region)
                                  
                                  
                                  if 'L_seed' in basename:
                                      il += 1
                                      if il == 1:
                                          program += ' --seed=%s' % region
                                      else:
                                          program += ' --seed%d=%s' % (il, region)
                                  if 'L_end' in basename:
                                      jl += 1
                                      if jl== 1:
                                          program += ' --end=%s' % region
                                      else:
                                          program += ' --end%d=%s' % (jl, region)
                                  if 'L_ROA' in basename:
                                      program += ' --roa=%s' % region
                                  if 'R_ROA' in basename:
                                      program1 += ' --roa=%s' % region#roa_listR.append(region)


                                  if 'R_seed' in basename:
                                      i += 1
                                      if i == 1:
                                          program1 += ' --seed=%s' % region
                                      else:
                                          program1 += ' --seed%d=%s' % (i, region)
                                  if 'R_end' in basename:
                                      j += 1
                                      if j == 1:
                                          program1 += ' --end=%s' % region
                                      else:
                                          program1 += ' --end%d=%s' % (j, region)
                              #out_path2 = os.path.join(path1, short_name[file_name.index(tractfolder)] + '_L_ROA1.nii.gz')
                              #merge_roa(roa_listL, out_path2)
                              #out_path3 = os.path.join(path1, short_name[file_name.index(tractfolder)] + '_R_ROA1.nii.gz')
                              #merge_roa(roa_listR, out_path3)
                              #program += ' --roa=%s' % out_path2
                              #program1 += ' --roa=%s' % out_path3
                              program += ' --output=%s' % os.path.join(out_path, basename_folder, tractfolder)
                              program += '/%s_L_tract.trk.gz  --export=tdi' %short_name[file_name.index(tractfolder)]
                              program1 += ' --output=%s' % os.path.join(out_path, basename_folder, tractfolder)
                              program1 += '/%s_R_tract.trk.gz --export=tdi' % short_name[file_name.index(tractfolder)]
                              #print(program)
                              #print(program1)
                              #fileobject.write(program1)
                              #fileobject.write(program)

                              skip_timeout(program,900)
                              skip_timeout(program1,900)
                      #tract_list = glob.glob(os.path.expanduser(os.path.join(folder, tractfolder, '*.trk.gz')))
                      #if not tract_list == []:
                              #for tract in tract_list:
                                  #program2='/home-local/wangx41/dsistudio/build/dsi_studio --action=ana --source=/%s/%s_tal_fib.gz ' % (folder,number)
                                  #tract_basename = os.path.basename(tract)
                                  #program2 += '--tract=%s --export=tdi --output=%s' % (
                                  #tract, os.path.join(path1, tract_basename.split('.')[0].replace('tract', 'density')))
                                  #subprocess.call(program2,shell=True)
                      #density_list = glob.glob(
                              #os.path.expanduser(os.path.join(folder, tractfolder, '*.tdi.nii.gz')))
                          # print(density_list)
                      #if not density_list == []:
                             # for density in density_list:
                                # density_basename = os.path.basename(density)
                                 # os.rename(density, os.path.join(path1, density_basename.replace('.tdi', '')))


file_name=['frontal_lobe', 'parietal_lobe', 'occipital_lobe', 'temporal_lobe']
short_name=['fl','pl','ol','tl']
tract_number=[2,2,2,2]
number_roi=[4,4,4,4]
dire=['1632_Roza','1127_Xuan','1632_Xuan','5708_Xuan','5750_Xuan','7678_Xuan','7678_Roza','7748_Xuan','7759_Xuan','1134_Xuan']
txtfile='/nfs/masi/wangx41/misnamed_record.txt'
in_path='/nfs/masi/bayrakrg/tractem_data/corrected/BLSA'
out_path='/nfs/masi/wangx41/auto_tracked_from_corrected_regions/BLSA'
create_tract(dire,in_path,out_path,txtfile,file_name,short_name,tract_number,number_roi)
