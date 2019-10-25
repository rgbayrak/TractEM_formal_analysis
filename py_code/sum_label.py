import numpy as np
import glob
import os
import nibabel as nib


class average_data():
    def __init__(self, in_path,output_path,tractname,sumfile_name,suffix):
        self.dir = []
        self.tractname=tractname
        for i in os.listdir(in_path):
            for j in os.listdir(os.path.join(in_path, i)):
                    self.original_path = os.path.join(os.path.join(in_path, i), j)
                    self.dir.append(self.original_path)
                
        self.sumfile_name=sumfile_name
        self.output_path=os.path.join(output_path,self.sumfile_name)#'acr_LR_sum1.nii.gz'
        #print(self.output_path)
        #print(len(self.dir))
        self.sample_size = len(self.dir)
        self.suffix=suffix

    def __getitem__(self, index):
        image_path = self.dir[index]
        x= nib.load(self.output_path).get_data()
        #print(image_path)
        if np.all(x==0):
            print('the matrix is zero')
        
        b=image_path.split('/')
        #print(b)
       
        brain=b[7].split('_')
        number=brain[0]
        #print(number)
        if not number=='1578':
            image_files = glob.glob(os.path.expanduser(os.path.join(image_path, self.tractname,self.suffix)))
            if not image_files==[]:
                for image in image_files:
                    #print(image)
                    basename = os.path.basename(image)
                    img = nib.load(image)
                    image_affine = img.affine
                    image_data = img.get_data()
                    if not 'ROA' in basename:
                        if not 'term' in basename:
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
           'tapetum_corpus_callosum', 'uncinate_fasciculus']
short_name=['ac','acr','aic','bcc','cp','cgc','cgh','cst','fx','fxst','gcc','icp','ifo','ilf','ml','m','mcp','olfr','opt','pct','pcr','pic','ptr','ss','scc', 'scp','scr','sfo','slf','tap','unc']
tract_number=[1,2,2,1,2,2,2,2,2,2,1,2,2,2,2,1,1,2,1,1,2,2,2,2,1,2,2,2,2,1,2]
list_brain=['1043','0531','1127','1134','1525','1579','1632','5255','7822','7789','7759','7748','7690','7678','7573','6001','5923','5793','5750','5708','5414','5343','4767','4713','1881','1834','1692','130114','165436','135124','757764','971160','905147','177140','878877','167440','943862']
for number in list_brain:
    in_path='/nfs/masi/wangx41/auto_binary_density/%s'%number
    
    for tractname in file_name:
        if tract_number[file_name.index(tractname)]==1:
           sumfile_name=short_name[file_name.index(tractname)]+'_density_sum1.nii.gz'                             
           output_path='/nfs/masi/wangx41/sum_average/%s/sum_density'%number
           data=average_data(in_path,output_path,tractname,sumfile_name,'*.nii.gz')
           for i in range(94):
               data[i]
               print(i)
        else:
            sumfile_name=short_name[file_name.index(tractname)]+'_L_density_sum1.nii.gz' 
            output_path='/nfs/masi/wangx41/sum_average/%s/sum_density'%number
            data=average_data(in_path,output_path,tractname,sumfile_name,'*L_density.nii.gz')
            sumfile_name1=short_name[file_name.index(tractname)]+'_R_density_sum1.nii.gz' 
            output_path1='/nfs/masi/wangx41/sum_average/%s/sum_density'%number
            data1=average_data(in_path,output_path1,tractname,sumfile_name1,'*R_density.nii.gz')
            for i in range(94):
              data1[i]
              data[i]
              print(i)



