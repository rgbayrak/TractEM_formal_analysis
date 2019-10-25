import subprocess
import os
import glob
 
def create_tract(in_path,out_path,txtfile,file_name,short_name,tract_number,number_roi):
    dire=[]
    with open(txtfile, 'a') as fileobject:
        for file in os.listdir(in_path):
            dire.append(os.path.join(in_path, file))
            #print(dire)
        for folder in dire:
            #print(folder)
            basename_folder = os.path.basename(folder)
            #print(basename_folder)
            path=os.path.join(out_path, basename_folder)
            #print(path)
            if not os.path.exists(path):
                os.mkdir(path)
            number = basename_folder[0:4]
            
            for tractfolder in os.listdir(folder):
                #print(tractfolder)
                
                if not tractfolder in file_name:
                    R1 = 'Misnaming ' + os.path.join(folder, tractfolder)
                    fileobject.write(R1)
                    continue
                region_list = glob.glob(os.path.expanduser(os.path.join(folder, tractfolder, '*.nii.gz')))
                program = '/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=/%s/%s_tal_fib.gz  --fiber_count=100000' % (folder,number)
                program1='/home-local/wangx41/dsistudio/build/dsi_studio --action=trk --source=/%s/%s_tal_fib.gz  --fiber_count=100000' % (folder,number)
                program2='/home-local/wangx41/dsistudio/build/dsi_studio --action=ana --source=/%s/%s_tal_fib.gz ' % (folder,number)
              
            
                path1=os.path.join(out_path, basename_folder, tractfolder)
                if not os.path.exists(path1):
                    os.mkdir(path1)
                if not region_list == []:
                      
                      if short_name[file_name.index(tractfolder)] == 'fx':
                          #print(region_list)
                          for region in region_list:
                              basename = os.path.basename(region)
                              #print(basename)
                              il = i = j = k = 0
                              
                              if 'L_seed' in basename:
                                  il += 1
                                  if il == 1:
                                      program += ' --seed=%s' % region
                                      #print(program)
                                  else:
                                      program += ' --seed%d=%s' % (il, region)
                              if 'ROI' in basename:
                                  j += 1
                                  if j == 1:
                                      program1 += ' --roi=%s' % region
                                      program += ' --roi=%s' % region
                                  else:
                                      program1 += ' --roi%d=%s' % (j, region)
                                      program += ' --roi%d=%s' % (j, region)
                              if 'ROA' in basename:
                                  k += 1
                                  if k == 1:
                                      program1 += ' --roa=%s' % region
                                      program += ' --roa=%s' % region
                                  else:
                                      program1 += ' --roa%d=%s' % (k, region)
                                      program += ' --roa%d=%s' % (k, region)
                              if 'R_seed' in basename:
                                  i += 1
                                  if i == 1:
                                      program1 += ' --seed=%s' % region
                                  else:
                                      program1 += ' --seed%d=%s' % (i, region)

                          program += ' --output=%s' % os.path.join(out_path, basename_folder, tractfolder)
                          program += '/%s_L_tract.trk.gz' % short_name[file_name.index(tractfolder)]
                          program1 += ' --output=%s' % os.path.join(out_path, basename_folder, tractfolder)
                          program1 += '/%s_R_tract.trk.gz' % short_name[file_name.index(tractfolder)]
                          print(program)
                          print(program1)
                          subprocess.call(program, shell=True)
                          subprocess.call(program1, shell=True)
                      else:

                          if tract_number[file_name.index(tractfolder)] == 1:
                              for region in region_list:
                                  basename = os.path.basename(region)
                                  i = k = j = 0
                                  if 'seed' in basename:
                                      i += 1
                                      if i == 1:
                                          program += ' --seed=%s' % region
                                      else:
                                          program += ' --seed%d=%s' % (i, region)
                                  if 'ROI' in basename:
                                      j += 1
                                      if j == 1:
                                          program += ' --roi=%s' % region
                                      else:
                                          program += ' --roi%d=%s' % (j, region)
                                  if 'ROA' in basename:
                                      k += 1
                                      if k == 1:
                                          program += ' --roa=%s' % region
                                      else:
                                          program += ' --roa%d=%s' % (k, region)
                              program += ' --output=%s' % path1
                              program += '/%s_tract.trk.gz' % short_name[file_name.index(tractfolder)]
                              # print(program)

                              subprocess.call(program, shell=True)
                          else:
                              for region in region_list:
                                  basename = os.path.basename(region)
                                  il = k = jl = i = j = 0
                                  program1 = program
                                  if 'L_seed' in basename:
                                      il += 1
                                      if il == 1:
                                          program += ' --seed=%s' % region
                                      else:
                                          program += ' --seed%d=%s' % (il, region)
                                  if 'L_ROI' in basename:
                                      jl += 1
                                      if j == 1:
                                          program += ' --roi=%s' % region
                                      else:
                                          program += ' --roi%d=%s' % (jl, region)
                                  if 'ROA' in basename:
                                      k += 1
                                      if k == 1:
                                          program1 += ' --roa=%s' % region
                                          program += ' --roa=%s' % region
                                      else:
                                          program1 += ' --roa%d=%s' % (k, region)
                                          program += ' --roa%d=%s' % (k, region)
                                  if 'R_seed' in basename:
                                      i += 1
                                      if i == 1:
                                          program1 += ' --seed=%s' % region
                                      else:
                                          program1 += ' --seed%d=%s' % (i, region)
                                  if 'R_ROI' in basename:
                                      j += 1
                                      if j == 1:
                                          program1 += ' --roi=%s' % region
                                      else:
                                          program1 += ' --roi%d=%s' % (j, region)

                              program += ' --output=%s' % os.path.join(out_path, basename_folder, tractfolder)
                              program += '/%s_L_tract.trk.gz' % short_name[file_name.index(tractfolder)]
                              program1 += ' --output=%s' % os.path.join(out_path, basename_folder, tractfolder)
                              program1 += '/%s_R_tract.trk.gz' % short_name[file_name.index(tractfolder)]
                              #print(program)
                              #print(program1)

                              subprocess.call(program, shell=True)
                              subprocess.call(program1, shell=True)
                      tract_list = glob.glob(os.path.expanduser(os.path.join(folder, tractfolder, '*.trk.gz')))
                      if not tract_list == []:
                              for tract in tract_list:
                                  tract_basename = os.path.basename(tract)
                                  program2 += '--tract=%s --export=tdi --output=%s' % (
                                  tract, os.path.join(path1, tract_basename.split('.')[0].replace('tract', 'density')))
                                  subprocess.call(program2, shell=True)
                      #density_list = glob.glob(
                              #os.path.expanduser(os.path.join(folder, tractfolder, '*.tdi.nii.gz')))
                          # print(density_list)
                      #if not density_list == []:
                             # for density in density_list:
                                # density_basename = os.path.basename(density)
                                 # os.rename(density, os.path.join(path1, density_basename.replace('.tdi', '')))


file_name=['anterior_commissure','anterior_corona_radiata','anterior_limb_internal_capsule','body_corpus_callosum','cerebral_peduncle',
           'cingulum_cingulate_gyrus', 'cingulum_hippocampal', 'corticospinal_tract', 'fornix', 'fornix_stria_terminalis',
           'genu_corpus_callosum', 'inferior_cerebellar_peduncle', 'inferior_fronto_occipital_fasciculus', 'inferior_longitudinal_fasciculus',
           'medial_lemniscus', 'midbrain', 'middle_cerebellar_peduncle', 'olfactory_radiation', 'optic_tract', 'pontine_crossing_tract',
           'posterior_corona_radiata', 'posterior_limb_internal_capsule', 'posterior_thalamic_radiation','sagittal_stratum', 'splenium_corpus_callosum',
           'superior_cerebellar_peduncle', 'superior_corona_radiata', 'superior_fronto_occipital_fasciculus','superior_longitudinal_fasciculus',
           'tapetum_corpus_callosum', 'uncinate_fasciculus']
short_name=['ac','acr','aic','bcc','cp','cgc','cgh','cst','fx','fxst','gcc','icp','ifo','ilf','ml','m','mcp','olfr','opt','pct','pcr','pic','ptr','ss','scc',
            'scp','scr','sfo','slf','tap','unc']
tract_number=[1,2,2,1,2,2,2,2,2,2,1,2,2,2,2,1,1,2,1,1,2,2,2,2,1,2,2,2,2,1,2]
number_roi=[0,2,0,0,0,0,4,2,1,2,0,2,4,4,0,0,0,0,0,2,0,0,6,0,0,2,0,2,0,0,0]
 
txtfile='/nfs/masi/wangx41/misnamed_record.txt'
in_path='/nfs/masi/bayrakrg/tractem_data/original/complete_BLSA_subjects'
out_path='/nfs/masi/wangx41/original_tract/BLSA'
create_tract(in_path,out_path,txtfile,file_name,short_name,tract_number,number_roi)
