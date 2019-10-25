import numpy as np
import glob
import os

class write_order():
    def __init__(self, path,output_path,reference,tractname,filename,list_brain):
        self.dir = []
        for i in os.listdir(path):
            for j in os.listdir(os.path.join(path, i)):
                self.original_path = os.path.join(os.path.join(path, i), j)
                self.dir.append(self.original_path)

        self.output_path=output_path
        self.reference=reference
        self.tractname=tractname
        self.filename=filename
        self.list_brain=list_brain
        #print(self.dir)
        #print(len(self.dir))
       # self.sample_size = len(self.dir)

    def __getitem__(self, index):
        image_path = self.dir[index] 
        #print(image_path)
        b=image_path.split('/')
        print(b)
        if not os.path.exists(os.path.join(self.output_path,b[5])):
            os.mkdir(os.path.join(self.output_path,b[5]))
        if not os.path.exists(os.path.join(self.output_path,b[5],b[6])):
            os.mkdir(os.path.join(self.output_path,b[5],b[6]))
        if not os.path.exists(os.path.join(self.output_path,b[5],b[6],self.tractname)):
            os.mkdir(os.path.join(self.output_path,b[5],b[6],self.tractname))
          
        brain=b[6].split('_')
        number=brain[0]
        reference_number=self.reference.split('_')[1]
        #print(brain)
        
        I = ['antsApplyTransforms', '-d', '3', '-i', '$m', '-r', '$f', '-n', 'linear', '-t', '${nm}1Warp.nii.gz', '-t',
              '${nm}0GenericAffine.mat', '-o', '${nm}_warped.nii.gz', '--float', '1', '-v', '1']
        image_files = glob.glob(os.path.expanduser(os.path.join(image_path, self.tractname,'*.nii.gz')))
        #print(image_files)
        if not image_files==[]:
            for image in image_files:
                basename = os.path.basename(image)
                I[4] = image
                I[6] = '/home-local/wangx41/registration/others/brains/'+self.reference
                if self.list_brain.index(reference_number)<=self.list_brain.index(number):
                    I[10] = '/share4/wangx41/registration/output/%s/reg_'%reference_number + number + '1Warp.nii.gz'
                    I[12] = '/share4/wangx41/registration/output/%s/reg_'%reference_number + number + '0GenericAffine.mat'
                else:
                    I[10] = '/share4/wangx41/registration/output/%s/reg_'%number + reference_number + '1InverseWarp.nii.gz'
                    I[12] = '/share4/wangx41/registration/output/%s/reg_'%number+ reference_number + '0GenericAffine.mat'
                I[14] = os.path.join(self.output_path,b[5],b[6],self.tractname,basename)
                L1 = ' '.join(I) + '\n'
                #print(L1)
                with open(self.filename, 'a') as fileobject:
                    fileobject.write(L1)
                
                

        #print(index)
        return  self.dir[index]

    #def __len__(self):
        #return self.sample_size

path = '/nfs/masi/wangx41/changed_header_ROA'
output_path = '/nfs/masi/wangx41/transform_ROA/943862'
reference='wcT1w_943862_acpc_dc_restore_1.25_brain.nii.gz'
#tractname='anterior_corona_radiata'
filename='/nfs/masi/wangx41/transform_ROA/transform_ROA943862.sh'
list_brain=['1043','0531','1127','1134','1525','1578','1579','1632','5255','7822','7789','7759','7748','7690','7678','7573','6001','5923','5793','5750','5708','5414','5343','4767','4713','1881','1834','1692','130114','165436','135124','757764','971160','905147','177140','878877','167440','943862']
file_name=['anterior_commissure','anterior_corona_radiata','anterior_limb_internal_capsule','body_corpus_callosum','cerebral_peduncle',
           'cingulum_cingulate_gyrus', 'cingulum_hippocampal', 'corticospinal_tract', 'fornix', 'fornix_stria_terminalis',
           'genu_corpus_callosum', 'inferior_cerebellar_peduncle', 'inferior_fronto_occipital_fasciculus', 'inferior_longitudinal_fasciculus',
           'medial_lemniscus', 'midbrain', 'middle_cerebellar_peduncle', 'olfactory_radiation', 'optic_tract', 'pontine_crossing_tract',
           'posterior_corona_radiata', 'posterior_limb_internal_capsule', 'posterior_thalamic_radiation','sagittal_stratum', 'splenium_corpus_callosum',
           'superior_cerebellar_peduncle', 'superior_corona_radiata', 'superior_fronto_occipital_fasciculus','superior_longitudinal_fasciculus',
           'tapetum_corpus_callosum', 'uncinate_fasciculus', 'frontal_lobe', 'parietal_lobe', 'occipital_lobe', 'temporal_lobe']
for tractname in file_name:
    data=write_order(path,output_path,reference,tractname,filename,list_brain)
    for i in range(97):
        data[i]





