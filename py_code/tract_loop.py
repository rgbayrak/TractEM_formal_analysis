import xlrd
import os
import subprocess

def open_loop(new_path,old_path,list_path,file_name,short_name,i,tract_number):
     workbook = xlrd.open_workbook(list_path)
     sheet1 = workbook.sheet_by_name('0.5')
     tract_list = sheet1.col_values(1)
     folder_list=sheet1.col_values(0)
     tract_index=short_name.index(tract_list[i])
     tract_name=file_name[tract_index]
     number = folder_list[i][0:4]
     tractnumber=tract_number[tract_index]
     new_path1=os.path.join(new_path,folder_list[i],tract_name)
     old_path1=os.path.join(old_path,folder_list[i],tract_name)
     if tractnumber==1:
         program='/nfs/masi/bayrakrg/dsistudio/dsi_other_files/dsi_studio --action=vis --source=/nfs/masi/bayrakrg/tractem_data/corrected/BLSA/1881_Xuan/1881_tal.fib.gz --track="%s,%s" --cmd=" " --stay_open=1'%(os.path.join(new_path1,tract_list[i]+'_tract.trk.gz'),os.path.join(old_path1,tract_list[i]+'_tract.trk.gz'))
         print(program)
         subprocess.call(program, shell=True)
     else:
         program = '/nfs/masi/bayrakrg/dsistudio/dsi_other_files/dsi_studio --action=vis --source=/nfs/masi/bayrakrg/tractem_data/corrected/BLSA/1881_Xuan/1881_tal.fib.gz --track="%s,%s" --cmd=" " --stay_open=1' % (os.path.join(new_path1, tract_list[i] + '_L_tract.trk.gz'),
         os.path.join(old_path1, tract_list[i] + '_L_tract.trk.gz'))
         program1= '/nfs/masi/bayrakrg/dsistudio/dsi_other_files/dsi_studio --action=vis --source=/nfs/masi/bayrakrg/tractem_data/corrected/BLSA/1881_Xuan/1881_tal.fib.gz --track="%s,%s" --cmd=" " --stay_open=1' % (os.path.join(new_path1, tract_list[i] + '_R_tract.trk.gz'),
             os.path.join(old_path1, tract_list[i] + '_R_tract.trk.gz'))
         print(program)
         subprocess.call(program,shell=True)
         subprocess.call(program1, shell=True)


tract_number=[1,2,2,1,2,2,2,2,2,2,1,2,2,2,2,1,1,2,1,1,2,2,2,2,1,2,2,2,2,1,2]
file_name = ['anterior_commissure', 'anterior_corona_radiata', 'anterior_limb_internal_capsule',
                      'body_corpus_callosum', 'cerebral_peduncle',
                      'cingulum_cingulate_gyrus', 'cingulum_hippocampal', 'corticospinal_tract', 'fornix',
                      'fornix_stria_terminalis',
                      'genu_corpus_callosum', 'inferior_cerebellar_peduncle', 'inferior_fronto_occipital_fasciculus',
                      'inferior_longitudinal_fasciculus',
                      'medial_lemniscus', 'midbrain', 'middle_cerebellar_peduncle', 'olfactory_radiation',
                      'optic_tract', 'pontine_crossing_tract',
                      'posterior_corona_radiata', 'posterior_limb_internal_capsule', 'posterior_thalamic_radiation',
                      'sagittal_stratum', 'splenium_corpus_callosum',
                      'superior_cerebellar_peduncle', 'superior_corona_radiata', 'superior_fronto_occipital_fasciculus',
                      'superior_longitudinal_fasciculus',
                      'tapetum_corpus_callosum', 'uncinate_fasciculus']
short_name = ['ac', 'acr', 'aic', 'bcc', 'cp', 'cgc', 'cgh', 'cst', 'fx', 'fxst', 'gcc', 'icp', 'ifo', 'ilf',
                       'ml', 'm', 'mcp', 'olfr', 'opt', 'pct', 'pcr', 'pic', 'ptr', 'ss', 'scc',
                       'scp', 'scr', 'sfo', 'slf', 'tap', 'unc']
new_path='/nfs/masi/wangx41/auto_tracked_from_corrected_regions/BLSA'
old_path='/nfs/masi/bayrakrg/tractem_data/corrected/BLSA'
list_path='/home-local/wangx41/code/code/compare_density.xls'
i=0
open_loop(new_path,old_path,list_path,file_name,short_name,i,tract_number)

