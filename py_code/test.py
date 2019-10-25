import numpy as np
import glob
import os
import nibabel as nib



def write_file(in_path,out_path):
    img=nib.load(in_path)
    image_data=np.zeros((157, 189, 156))
    image_affine=img.affine
    new_image = nib.Nifti1Image(image_data, image_affine)
    nib.save(new_image, os.path.join(out_path, 'zero.nii.gz'))

out_path='/home-local/wangx41'
in_path= '/share4/wangx41/corrected_header_regions/BLSA/1127_Aviral/anterior_commissure/ac_L_seed1.nii.gz'   
#write_file(in_path,out_path)

def file_count(path1,path2,tractname):
    number=0
    for i in os.listdir(path1):
        for j in os.listdir(os.path.join(path1,i)):
            if os.path.basename(j)==tractname:
                image_files = glob.glob(os.path.expanduser(os.path.join(path1,i,j, '*.nii.gz')))
                #print(image_files )
                if not image_files==[]:
                     number+=1
                else:
                    print(i)
    print(number)
    number1=0
    for i in os.listdir(path2):
        for j in os.listdir(os.path.join(path2,i)):
            if os.path.basename(j)==tractname:
                image_files = glob.glob(os.path.expanduser(os.path.join(path2,i,j, '*.nii.gz')))
                #print(image_files )
                if not image_files==[]:
                     number1+=1
    print(number1)                    
    if number!=17:
        print(11)
file_name=['anterior_commissure','anterior_corona_radiata','anterior_limb_internal_capsule','body_corpus_callosum','cerebral_peduncle',
           'cingulum_cingulate_gyrus', 'cingulum_hippocampal', 'corticospinal_tract', 'fornix', 'fornix_stria_terminalis',
           'genu_corpus_callosum', 'inferior_cerebellar_peduncle', 'inferior_fronto_occipital_fasciculus', 'inferior_longitudinal_fasciculus',
           'medial_lemniscus', 'midbrain', 'middle_cerebellar_peduncle', 'olfactory_radiation', 'optic_tract', 'pontine_crossing_tract',
           'posterior_corona_radiata', 'posterior_limb_internal_capsule', 'posterior_thalamic_radiation','sagittal_stratum', 'splenium_corpus_callosum',
           'superior_cerebellar_peduncle', 'superior_corona_radiata', 'superior_fronto_occipital_fasciculus','superior_longitudinal_fasciculus',
           'tapetum_corpus_callosum', 'uncinate_fasciculus', 'frontal_lobe', 'parietal_lobe', 'occipital_lobe', 'temporal_lobe']
for tractname in file_name:    
    path2='/share4/wangx41/corrected_header_regions/BLSA18'
    path1='/share4/wangx41/transformed_regions/1632/BLSA18'
    print(tractname)
    
    file_count(path1,path2,tractname)
def add_region(inpath,inpath2):
    img1=nib.load(inpath1).get_data()
    img2=nib.load(inpath2)
    image_affine=img2.affine
    imgdata=img2.get_data()

    new_image = nib.Nifti1Image(imgdata+img1, image_affine)
    nib.save(new_image,inpath2)
inpath1='/share4/wangx41/transfomd_regions/1043/BLSA18/5414_Christa/superior_longitudinal_fasciculus/slf_L_seed1.nii.gz'
inpath2='/share4/wangx41/result/1043/sum_regions/superior_longitudinal_fasciculus/slf_LR_sum1.nii.gz'
#add_region(inpath1,inpath2)