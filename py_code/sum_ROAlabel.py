import numpy as np
import glob
import os
import nibabel as nib

class average_data():
    def __init__(self, in_path,output_path,tractname,sumfile_name):
        self.dir = []
        self.tractname=tractname
        for i in os.listdir(in_path):
            for j in os.listdir(os.path.join(in_path, i)):
                    self.original_path = os.path.join(in_path, i, j)
                    self.dir.append(self.original_path)
                
        self.sumfile_name=sumfile_name
        self.output_path=os.path.join(output_path,self.sumfile_name)#'acr_LR_sum1.nii.gz'
        #print(self.output_path)
        print(self.dir)
        self.sample_size = len(self.dir)

    def __getitem__(self, index):
        image_path = self.dir[index]
        x= nib.load(self.output_path).get_data()
        #print(x)
        if np.all(x==0):
            print('the matrix is zero')
        
        b=image_path.split('/')
        #print(b)
       
        brain=b[6].split('_')
        number=brain[0]
        #print(number)
        if not number=='1578':
            image_files = glob.glob(os.path.expanduser(os.path.join(image_path, self.tractname,'*.nii.gz')))
            if not image_files==[]:
                for image in image_files:
                    basename = os.path.basename(image)
                    img = nib.load(image)
                    image_affine = img.affine
                    image_data = img.get_data()
                    if 'ROA' in basename:
                        x = x + image_data
                            #print(x.shape)
                    
                    new_image = nib.Nifti1Image(x, image_affine)
                    nib.save(new_image,self.output_path)
                    
  

    def __len__(self):
        return self.sample_size

    
file_name=['anterior_commissure','anterior_corona_radiata','anterior_limb_internal_capsule','body_corpus_callosum','cerebral_peduncle',
           'cingulum_cingulate_gyrus', 'cingulum_hippocampal', 'corticospinal_tract', 'fornix', 'fornix_stria_terminalis',
           'genu_corpus_callosum', 'inferior_cerebellar_peduncle', 'inferior_fronto_occipital_fasciculus', 'inferior_longitudinal_fasciculus',
           'medial_lemniscus', 'midbrain', 'middle_cerebellar_peduncle', 'olfactory_radiation', 'optic_tract', 'pontine_crossing_tract',
           'posterior_corona_radiata', 'posterior_limb_internal_capsule', 'posterior_thalamic_radiation','sagittal_stratum', 'splenium_corpus_callosum',
           'superior_cerebellar_peduncle', 'superior_corona_radiata', 'superior_fronto_occipital_fasciculus','superior_longitudinal_fasciculus',
           'tapetum_corpus_callosum', 'uncinate_fasciculus', 'frontal_lobe', 'parietal_lobe', 'occipital_lobe', 'temporal_lobe']
short_name=['ac','acr','aic','bcc','cp','cgc','cgh','cst','fx','fxst','gcc','icp','ifo','ilf','ml','m','mcp','olfr','opt','pct','pcr','pic','ptr','ss','scc', 'scp','scr','sfo','slf','tap','unc','fl','pl','ol','tl']


in_path ='/nfs/masi/wangx41/transform_ROA'
for tractname in file_name:
    
    sumfile_name=short_name[file_name.index(tractname)]+'_ROA_sum1.nii.gz'                             
    output_path =os.path.join('/nfs/masi/wangx41/sum_average_ROA/1578/sum')
    data=average_data(in_path,output_path,tractname,sumfile_name)
    for i in range(97):
        data[i]
        print(i)



