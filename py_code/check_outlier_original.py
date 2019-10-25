import numpy as np
import glob
import os



class check_name():
    def __init__(self, first_path,file_name,error_txt,short_name,number_seeds,number_roi,number_roa,number_trk):
        self.dir = []
        for second_path in os.listdir(first_path):
            for third_path in os.listdir(os.path.join(first_path, second_path)):
                #for forth_path in os.listdir(os.path.join(first_path, second_path,third_path)):
                    self.folder_path = third_path
                    self.dir.append(os.path.join(first_path, second_path,self.folder_path))
        #self.dir = self.dir[::2]
        #del self.dir[0]
        #print( self.dir[0])
        self.number_roa=number_roa
        self.number_seeds=number_seeds
        self.number_roi=number_roi
        self.number_trk=number_trk
        self.short_name=short_name
        #self.output_path=output_path
        self.file_name=file_name
        self.error_txt=error_txt
        #print(self.output_path)
        print(len(self.dir))
        self.sample_size = len(self.dir)

    def __getitem__(self, index):
        with open(self.error_txt, 'a') as fileobject:
            image_path = self.dir[index]
            c = image_path.split('/')
            
            track_path=os.path.join(c[5],c[6])
            print(track_path)
            
        # print(image_path)
            folder_name=os.path.basename(image_path)
            folder_name=folder_name.split('.')[0]
            if folder_name in self.file_name:
                index_number=self.file_name.index(folder_name)
                short_name=self.short_name[index_number]
                seeds_number=self.number_seeds[index_number]
                roi_number=self.number_roi[index_number]
                roa_number = self.number_roa[index_number]
                trk_number = self.number_trk[index_number]
                tract_file=glob.glob(os.path.expanduser(os.path.join(image_path, '*.trk.gz')))
                print(tract_file)
        
                image_files = glob.glob(os.path.expanduser(os.path.join(image_path, '*.nii.gz')))
                list_shortname = []
                list_regions = []
                list_orientation = []
                list_ROA = []
                #list_b = []
                list_den=[]
                if len(tract_file)!=trk_number:
                    R13= '\n' + 'The number of tract files in ' + track_path + ' is wrong'
                    fileobject.write(R13)
                else:
                    if trk_number==1:
                        if not os.path.basename(tract_file[0])==(short_name+'_tract.trk.gz'):
                              R14='\n' + 'The name of tract files in ' + track_path +' is wrong'
                              fileobject.write(R14)
                    else:
                        if os.path.basename(tract_file[0])!=(short_name+'_L_tract.trk.gz'):
                              if not os.path.basename(tract_file[1])==(short_name+'_L_tract.trk.gz'):
                                    R14='\n' + 'The name of tract files in ' + track_path + ' is wrong'
                                    fileobject.write(R14)
                        else:
                            if not os.path.basename(tract_file[1])==(short_name+'_R_tract.trk.gz'):
                                     R14='\n' + 'The name of tract files in ' + track_path+ ' is wrong'
                                     fileobject.write(R14)
                            
                   
                if not image_files == []:
                    for image in image_files:
                        basename = os.path.basename(image)
                        #print(basename)
                        
                        if 'ROA' in basename:
                            a = basename.split('_')
                            b = a[-1].split('.')
                            list_ROA.append(b[0])
                            #list_b.append(b[1])
                        elif 'density' in basename:
                   
                            list_den.append(basename)
                            #list_b.append(b[1])
                        else:
                            a = basename.split('_')
                            list_shortname.append(a[0])
                            list_orientation.append(a[1])
                            b = a[-1].split('.')
                            list_regions.append(b[0])
                            #list_b.append(b[1])
                #if not set(list_b) == 1:
                    #R8 = '\n' + 'Files in ' + track_path + ' miss nii'
                    #fileobject.write(R8)
                #print(list_regions)
                #print(list_ROA)
                #print(list_orientation)
                list_all=list_orientation + list_regions + list_ROA
                
                if len(list_den)!=trk_number:
                    R9= '\n' + 'The number of density files in ' + track_path + ' is wrong'
                    fileobject.write(R9)
                else:
                    if trk_number==1:
                        if not list_den[0]==(short_name+'_density.nii.gz'):
                            R15='\n' + 'The name of density files in ' + track_path + ' is wrong'
                            fileobject.write(R15)
                    else:
                        if list_den[0]!=(short_name+'_L_density.nii.gz'):
                              if not list_den[1]==(short_name+'_L_density.nii.gz'):
                                    R15='\n' + 'The name of density files in ' + track_path + ' is wrong'
                                    fileobject.write(R15)
                        else:
                            if not list_den[1]==(short_name+'_R_density.nii.gz'):
                                     R15='\n' + 'The name of density files in ' + track_path + ' is wrong'
                                     fileobject.write(R15)
                            

                if roa_number==2:

                    if not len(list_ROA) == roa_number:
                        R = '\n' + 'The number of ROA files in ' + track_path + ' is wrong'
                        fileobject.write(R)
                else:
                    if len(list_ROA) == 0:
                        R = '\n' + 'The number of ROA files in ' + track_path + ' is missing'
                        fileobject.write(R)

                if ('seed' in list_all) or ('ROA' in list_all) or ('ROI' in list_all) or ('end' in list_all):
                    R0 = '\n' + 'the name of files missing 1 in ' + track_path
                    #print(2)
                    fileobject.write(R0)
                if len(set(list_shortname)) != 1:
                    R2 = '\n' + 'short-name in ' + track_path + ' is wrong'
                    fileobject.write(R2)

                if seeds_number <= 1 & roi_number <= 1:
                    if len(set(list_orientation)) == 1:
                        if not roi_number == 0 & list_regions == 0:
                            R3 = '\n' + 'seed or roi names in ' + track_path + ' are wrong'
                            fileobject.write(R3)

                    else:
                        R5 = '\n' + 'The number of seed or roi regions in ' + track_path + ' is wrong'
                        fileobject.write(R5)

                if seeds_number >= 2 & roi_number != 1:
                    if not len(list_orientation) == len(list_regions)== (seeds_number + roi_number):
                        R4 = '\n' + 'The number of seed or roi regions in ' + track_path + ' is wrong'
                        fileobject.write(R4)

                    if not list_orientation.count('L') == list_orientation.count('R'):
                        R6 = '\n' + 'The number of L or R regions in ' + track_path + ' is wrong'
                        fileobject.write(R6)

                if seeds_number >= 2 & roi_number == 1:
                    if not len(set(list_orientation)) == 3:
                        R11 = '\n' + 'Missing ROI or L or R seed regions in ' + track_path + ' is wrong'
                        fileobject.write(R11)

                    if not len(list_regions) == seeds_number:
                        R12 = '\n' + 'The number of ROI regions in ' + track_path + ' is wrong'
                        fileobject.write(R12)

                if seeds_number <= 1 and roi_number >= 2:
                    if not len(set(list_orientation)) == 3:
                        R7 = '\n' + 'Missing seed or L or R ROI regions in ' + track_path + ' is wrong'
                        fileobject.write(R7)
                    if not len(list_regions) == roi_number:
                        R10 = '\n' + 'The number of ROI regions in ' + track_path + ' is wrong'
                        fileobject.write(R10)

            else:
                R1='\n'+'folder name of '+track_path+' is wrong'
                fileobject.write(R1)
            

            return  self.dir[index]

    def __len__(self):
        return self.sample_size

first_path= '/home-local/wangx41/Downloads/HCP'

file_name=['anterior_commissure','anterior_corona_radiata','anterior_limb_internal_capsule','body_corpus_callosum','cerebral_peduncle',
           'cingulum_cingulate_gyrus', 'cingulum_hippocampal', 'corticospinal_tract', 'fornix', 'fornix_stria_terminalis',
           'genu_corpus_callosum', 'inferior_cerebellar_peduncle', 'inferior_fronto_occipital_fasciculus', 'inferior_longitudinal_fasciculus',
           'medial_lemniscus', 'midbrain', 'middle_cerebellar_peduncle', 'olfactory_radiation', 'optic_tract', 'pontine_crossing_tract',
           'posterior_corona_radiata', 'posterior_limb_internal_capsule', 'posterior_thalamic_radiation','sagittal_stratum', 'splenium_corpus_callosum',
           'superior_cerebellar_peduncle', 'superior_corona_radiata', 'superior_fronto_occipital_fasciculus','superior_longitudinal_fasciculus',
           'tapetum_corpus_callosum', 'uncinate_fasciculus', 'frontal_lobe', 'parietal_lobe', 'occipital_lobe', 'temporal_lobe']
short_name=['ac','acr','aic','bcc','cp','cgc','cgh','cst','fx','fxst','gcc','icp','ifo','ilf','ml','m','mcp','olfr','opt','pct','pcr','pic','ptr','ss','scc',
            'scp','scr','sfo','slf','tap','unc','fl','pl','ol','tl']

number_seeds=[1,2,2,1,2,4,2,2,2,2,1,2,2,2,2,1,2,2,4,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2]
number_roi=[0,2,0,0,0,0,4,2,1,2,0,2,4,4,0,0,0,0,0,2,0,0,6,0,0,2,0,2,0,0,0,4,4,4,4]
number_roa=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,1]
number_trk=[1,2,2,1,2,2,2,2,2,2,1,2,2,2,2,1,1,2,1,1,2,2,2,2,1,2,2,2,2,1,2,2,2,2,2]
error_txt='/home-local/wangx41/Downloads/error_record_HCP3.txt'
data=check_name(first_path,file_name,error_txt,short_name,number_seeds,number_roi,number_roa,number_trk)
for i in range(5000):
    data[i]





