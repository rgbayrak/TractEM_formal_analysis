import numpy as np
import glob
import os
import nibabel as nib

def add_regions(in_path,out_path):
    x=np.zeros((157,189,156))
    image_files = glob.glob(os.path.expanduser(os.path.join(in_path,'*.nii.gz')))
    print(image_files)
    for image in image_files:
        basename=os.path.basename(image)
        img = nib.load(image)
        image_affine = img.affine
        image_data = img.get_data()
        if not 'ROA' in basename:
               #if not 'R_' in basename:
                    x=x+image_data
        new_image = nib.Nifti1Image(x, image_affine)
        nib.save(new_image,out_path)
file_name=['anterior_commissure','anterior_corona_radiata','anterior_limb_internal_capsule','body_corpus_callosum','cerebral_peduncle',
           'cingulum_cingulate_gyrus', 'cingulum_hippocampal', 'corticospinal_tract', 'fornix', 'fornix_stria_terminalis',
           'genu_corpus_callosum', 'inferior_cerebellar_peduncle', 'inferior_fronto_occipital_fasciculus', 'inferior_longitudinal_fasciculus',
           'medial_lemniscus', 'midbrain', 'middle_cerebellar_peduncle', 'olfactory_radiation', 'optic_tract', 'pontine_crossing_tract',
           'posterior_corona_radiata', 'posterior_limb_internal_capsule', 'posterior_thalamic_radiation','sagittal_stratum', 'splenium_corpus_callosum',
           'superior_cerebellar_peduncle', 'superior_corona_radiata', 'superior_fronto_occipital_fasciculus','superior_longitudinal_fasciculus',
           'tapetum_corpus_callosum', 'uncinate_fasciculus', 'frontal_lobe', 'parietal_lobe', 'occipital_lobe', 'temporal_lobe']
short_name=['ac','acr','aic','bcc','cp','cgc','cgh','cst','fx','fxst','gcc','icp','ifo','ilf','ml','m','mcp','olfr','opt','pct','pcr','pic','ptr','ss','scc',
            'scp','scr','sfo','slf','tap','unc','fl','pl','ol','tl']

for file in file_name:
    in_path=os.path.join('/share4/wangx41/corrected_header_regions/BLSA18/5414_Christa',file)
    out_path=os.path.join('/share4/wangx41/result/5414/truth_regions','%s_LR_truth1.nii.gz'%short_name[file_name.index(file)])
    add_regions(in_path,out_path)