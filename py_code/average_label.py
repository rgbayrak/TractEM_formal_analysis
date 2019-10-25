import numpy as np
import glob
import os
import nibabel as nib                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           


def average_file(in_path,out_path):
    #x=np.zeros((157,189,156))
    img=nib.load(in_path)
    image_data=img.get_data()
    #print(image_data+x)
    image_data=image_data/57
    image_affine=img.affine
    new_image = nib.Nifti1Image(image_data, image_affine)
    nib.save(new_image, os.path.join(out_path))
    
#file_name=['anterior_commissure','anterior_corona_radiata','anterior_limb_internal_capsule','cerebral_peduncle','fornix','genu_corpus_callosum', 'inferior_fronto_occipital_fasciculus', 'medial_lemniscus', 'midbrain','olfactory_radiation', 'optic_tract', 'pontine_crossing_tract','posterior_corona_radiata', 'posterior_limb_internal_capsule','posterior_thalamic_radiation','sagittal_stratum', 'splenium_corpus_callosum','superior_cerebellar_peduncle','superior_corona_radiata','tapetum_corpus_callosum', 'uncinate_fasciculus', 'frontal_lobe','occipital_lobe', 'temporal_lobe']
#short_name=['ac','acr','aic','cp','fx','gcc','ifo','ml','m','olfr','opt','pct','pcr','pic','ptr','ss','scc','scp','scr','tap','unc','fl','ol','tl']
#file_name=['body_corpus_callosum', 'cingulum_cingulate_gyrus','cingulum_hippocampal','fornix_stria_terminalis','inferior_cerebellar_peduncle','inferior_longitudinal_fasciculus','middle_cerebellar_peduncle','superior_fronto_occipital_fasciculus','superior_longitudinal_fasciculus','parietal_lobe']
#short_name=['bcc','cgc','cgh','fxst','icp','ilf','mcp','sfo','slf','pl']
#file_name=['corticospinal_tract']
#short_name=['cst']
#for tract in file_name:
    
    #out_path=os.path.join('/share4/wangx41/result/1692/average_regions/%s'%tract,'%s_LR_average1.nii.gz'%short_name[file_name.index(tract)])
    #in_path= os.path.join('/share4/wangx41/result/1692/sum_regions/%s'%tract,'%s_LR_sum1.nii.gz'%short_name[file_name.index(tract)])
    #average_file(in_path,out_path)

def binary_data(in_path,out_path,threshole):
    x=np.zeros((157,189,156))
    img=nib.load(in_path)
    image_data=img.get_data()
    new_loc=image_data>threshole
    x[:,:,:]=new_loc[0:157,0:189,0:156]
    #print(np.where(x==1))
    image_affine=img.affine
    new_image = nib.Nifti1Image(x, image_affine)
    nib.save(new_image, os.path.join(out_path))

def binary_data2(in_path,out_path):
    x=np.zeros((157,189,156))
    img=nib.load(in_path)
    image_data=img.get_data()
    new_loc=image_data!=0
    x[:,:,:]=new_loc[0:157,0:189,0:156]
    print(np.where(x==1))
    image_affine=img.affine
    new_image = nib.Nifti1Image(x, image_affine)
    nib.save(new_image, os.path.join(out_path, 'ac_LR_seed1_average_0.nii.gz'))
    
file_name=['anterior_commissure','anterior_corona_radiata','anterior_limb_internal_capsule','body_corpus_callosum','cerebral_peduncle','cingulum_cingulate_gyrus', 'cingulum_hippocampal', 'corticospinal_tract', 'fornix', 'fornix_stria_terminalis','genu_corpus_callosum', 'inferior_cerebellar_peduncle', 'inferior_fronto_occipital_fasciculus', 'inferior_longitudinal_fasciculus','medial_lemniscus', 'midbrain', 'middle_cerebellar_peduncle', 'olfactory_radiation', 'optic_tract', 'pontine_crossing_tract','posterior_corona_radiata', 'posterior_limb_internal_capsule', 'posterior_thalamic_radiation','sagittal_stratum', 'splenium_corpus_callosum','superior_cerebellar_peduncle', 'superior_corona_radiata', 'superior_fronto_occipital_fasciculus','superior_longitudinal_fasciculus','tapetum_corpus_callosum', 'uncinate_fasciculus', 'frontal_lobe', 'parietal_lobe', 'occipital_lobe', 'temporal_lobe']
short_name=['ac','acr','aic','bcc','cp','cgc','cgh','cst','fx','fxst','gcc','icp','ifo','ilf','ml','m','mcp','olfr','opt','pct','pcr','pic','ptr','ss','scc','scp','scr','sfo','slf','tap','unc','fl','pl','ol','tl']
    
for tract in file_name:
    in_path= '/share4/wangx41/result/1525/average_regions/%s/%s_LR_average1.nii.gz'%(tract,short_name[file_name.index(tract)])
    out_path='/share4/wangx41/result/1525/average_regions/%s/%s_LR_average1_0.0.nii.gz'%(tract,short_name[file_name.index(tract)])
    threshold=0.0
    binary_data(in_path,out_path,threshold)

def find_plane(in_path,out_path):
    x=np.zeros((157,189,156))
    img=nib.load(in_path)
    a=np.ones((189,156))
    b=np.ones((157,156))
    c=np.ones((157,189))
    l1=[]
    l2=[]
    l3=[]
    image_data=img.get_data()
    image_affine=img.affine
    for i in range(1,157):
        if sum(sum(image_data[i,:,:]==a))>=3000:
            x[i,:,:]=a
    for j in range(0,189):
        if sum(sum(image_data[:,j,:]==b))>=3000:
            x[:,j,:]=b
    for k in range(0,156):
        if sum(sum(image_data[:,:,k]==c))>=3000:
            x[:,:,k]=c
    new_image = nib.Nifti1Image(x, image_affine)
    nib.save(new_image, out_path)
#in_path='/share4/wangx41/result/1043/average_regions/anterior_commissure/ac_ROA_average1_0.1.nii.gz'
#out_path='/share4/wangx41/result/1043/average_regions/anterior_commissure/ac_ROA_average1_0.1_4000.nii.gz'
#find_plane(in_path,out_path)