clc
clear all


BLSA18_subject_path = '/nfs/masi/wangx41/auto_tracked_from_corrected_regions/BLSA18';
BLSA18_subject_dirs = dir(BLSA18_subject_path);

% The last version of the protocol
ac = {'ac_tract.trk.gz', 'ac_density.nii.gz'}; 

acr = {'acr_L_tract.trk.gz', 'acr_R_tract.trk.gz', 'acr_L_density.nii.gz', 'acr_R_density.nii.gz'};

aic = {'aic_L_tract.trk.gz', 'aic_R_tract.trk.gz', 'aic_L_density.nii.gz', 'aic_R_density.nii.gz'};

bcc = {'bcc_tract.trk.gz', 'bcc_density.nii.gz'}; % single seed

cp = {'cp_L_tract.trk.gz', 'cp_R_tract.trk.gz', 'cp_L_density.nii.gz', 'cp_R_density.nii.gz'};

cgc = {'cgc_L_tract.trk.gz', 'cgc_R_tract.trk.gz', 'cgc_L_density.nii.gz', 'cgc_R_density.nii.gz'}; % multiple seed

cgh = {'cgh_L_tract.trk.gz', 'cgh_R_tract.trk.gz', 'cgh_L_density.nii.gz', 'cgh_R_density.nii.gz'}; % multiple ROI

cst = {'cst_L_tract.trk.gz', 'cst_R_tract.trk.gz', 'cst_L_density.nii.gz', 'cst_R_density.nii.gz'};

fx = {'fx_L_tract.trk.gz', 'fx_R_tract.trk.gz', 'fx_L_density.nii.gz', 'fx_R_density.nii.gz'}; % single ROI

fxst = {'fxst_L_tract.trk.gz', 'fxst_R_tract.trk.gz', 'fxst_L_density.nii.gz', 'fxst_R_density.nii.gz'}; 

gcc = {'gcc_tract.trk.gz', 'gcc_density.nii.gz'};

icp = {'icp_L_tract.trk.gz', 'icp_R_tract.trk.gz', 'icp_L_density.nii.gz', 'icp_R_density.nii.gz'};

ifo = {'ifo_L_tract.trk.gz', 'ifo_R_tract.trk.gz', 'ifo_L_density.nii.gz', 'ifo_R_density.nii.gz'};

ilf = {'ilf_L_tract.trk.gz', 'ilf_R_tract.trk.gz', 'ilf_L_density.nii.gz', 'ilf_R_density.nii.gz'};

ml = {'ml_L_tract.trk.gz', 'ml_R_tract.trk.gz', 'ml_L_density.nii.gz', 'ml_R_density.nii.gz'};

m = {'m_tract.trk.gz', 'm_density.nii.gz'};

mcp = {'mcp_tract.trk.gz', 'mcp_density.nii.gz'};

olfr = {'olfr_L_tract.trk.gz', 'olfr_R_tract.trk.gz', 'olfr_L_density.nii.gz', 'olfr_R_density.nii.gz'};

opt = {'opt_tract.trk.gz', 'opt_density.nii.gz'};

pct = {'pct_tract.trk.gz', 'pct_density.nii.gz'};

pcr = {'pcr_L_tract.trk.gz', 'pcr_R_tract.trk.gz', 'pcr_L_density.nii.gz', 'pcr_R_density.nii.gz'};

pic = { 'pic_L_tract.trk.gz', 'pic_R_tract.trk.gz', 'pic_L_density.nii.gz', 'pic_R_density.nii.gz'};

ptr = {'ptr_L_tract.trk.gz', 'ptr_R_tract.trk.gz', 'ptr_L_density.nii.gz', 'ptr_R_density.nii.gz'}; % more ROI

ss = { 'ss_L_tract.trk.gz', 'ss_R_tract.trk.gz', 'ss_L_density.nii.gz', 'ss_R_density.nii.gz'};

scc = {'scc_tract.trk.gz', 'scc_density.nii.gz'};

scp = {'scp_L_tract.trk.gz', 'scp_R_tract.trk.gz', 'scp_L_density.nii.gz', 'scp_R_density.nii.gz'};

scr = {'scr_L_tract.trk.gz', 'scr_R_tract.trk.gz', 'scr_L_density.nii.gz', 'scr_R_density.nii.gz'};

sfo = {'sfo_L_tract.trk.gz', 'sfo_R_tract.trk.gz', 'sfo_L_density.nii.gz', 'sfo_R_density.nii.gz'};

slf = {'slf_L_tract.trk.gz', 'slf_R_tract.trk.gz', 'slf_L_density.nii.gz', 'slf_R_density.nii.gz'};

tap = {'tap_tract.trk.gz', 'tap_density.nii.gz'};

unc = {'unc_L_tract.trk.gz', 'unc_R_tract.trk.gz', 'unc_L_density.nii.gz', 'unc_R_density.nii.gz'};

fl = {'fl_L_tract.trk.gz', 'fl_R_tract.trk.gz', 'fl_L_density.nii.gz', 'fl_R_density.nii.gz'};

ol = {'ol_L_tract.trk.gz', 'ol_R_tract.trk.gz', 'ol_L_density.nii.gz', 'ol_R_density.nii.gz'};

pl = { 'pl_L_tract.trk.gz', 'pl_R_tract.trk.gz', 'pl_L_density.nii.gz', 'pl_R_density.nii.gz'};

tl = {'tl_L_tract.trk.gz', 'tl_R_tract.trk.gz', 'tl_L_density.nii.gz', 'tl_R_density.nii.gz'}; % single ROA

% drop folders that are not subject_rater pair
filenames = cellstr(char(BLSA18_subject_dirs.name));
dropfiles = false(length(BLSA18_subject_dirs),1);
dropfiles(~contains(filenames, {'.','..'})) = true; 
BLSA18_subject_dirs = BLSA18_subject_dirs(dropfiles);

blsa18_data = [];
blsa18_error_data =  [];
for subj = 1:length(BLSA18_subject_dirs)
    
    disp(BLSA18_subject_dirs(subj).name);
    
    % preprocess
    tract_dirs = dir(fullfile(BLSA18_subject_dirs(subj).folder,BLSA18_subject_dirs(subj).name,'*'));
    tract_dirs = tract_dirs(~ismember({tract_dirs.name},{'.','..'}));
    if ~isempty(tract_dirs)     

        for trk = 1:length(tract_dirs)

            disp(tract_dirs(trk).name);

            files = dir(fullfile(tract_dirs(trk).folder, tract_dirs(trk).name, '*'));
            files = files(~ismember({files.name},{'.','..'}));
            
            density_array = [];
            trk_array = [];

            if length(files) > 2

                tractem_data = struct;
                tractem_data.subject_rater = BLSA18_subject_dirs(subj).name;
                tractem_data.tract = tract_dirs(trk).name;
                
                % check if it follows the convention
                file_parts = strsplit(files(3).name, '_'); 
                abb = file_parts{1}; % what abbreviation is used for this tract
                
                % deal with default and weird files
                init_filelist = cellstr(char(files.name));
                dropinit = false(length(files), 1);
                dropinit(contains(init_filelist, abb, 'IgnoreCase', true)) = true;
                files = files(dropinit);              
                
                abb_string = eval(lower(abb)); % convert the abb string into a variable name
                % if it follows the convention add it to the struct, 
                % if does not follow the protocol convention add it to the error list
                fileslist = cellstr(char(files.name));
                dropfile = false(length(files),1);
                dropfile(contains(fileslist, abb_string)) = true;
                error_files = files(~dropfile);
                files = files(dropfile);
%                 
%                 tractem_data.error = error_files;
%                 tractem_data.error_count = length(error_files);
                

                for file = 1:length(files)

                    disp(files(file).name);

                    if contains(files(file).name, 'density.nii.gz')

                        if isempty(density_array)
                            density_array = files(file).name;
                        else
                            density_array = [density_array ', ' files(file).name];
                        end

                    end

%                     if contains(files(file).name, 'trk.gz')
%                         if isempty(trk_array)
%                             trk_array = files(file).name;
%                         else
%                             trk_array = [trk_array ', ' files(file).name];
%                         end
%                     end                    
                end

                tractem_data.density = density_array;
%                 tractem_data.trk = trk_array;
                tractem_data.location = files(file).folder;
                

                if sum(contains(abb_string, '.trk')) > 1  
                    tractem_data.bilateral = 'YES';
                else
                    tractem_data.bilateral = 'single';
                end
                
                % record when there is error
                if sum(contains(abb_string, 'density')) ~= sum(contains({files.name}, 'density')) % sum(contains(abb_string, 'trk')) ~= sum(contains({files.name}, 'trk')) || 
                    
                    tractem_data.missing = abb_string(~ismember(abb_string, {files.name}));
                    tractem_data.error_count = length(tractem_data.missing);
                    blsa18_error_data =  [blsa18_error_data tractem_data];
                    
                else
                    tractem_data.missing = {};
                    tractem_data.error_count = 0;
                    
                end
                
%                 tractem_data.extra = {error_files};
                
                blsa18_data = [blsa18_data tractem_data];

            end
        end
    end
end

save('autoblsa18_corrected_data.mat', 'blsa18_data');

%%
sub = blsa18_data([blsa18_data.error_count]>0);

tract = {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum'; ...
    'cerebral_peduncle'; 'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';...
    'frontal_lobe';'genu_corpus_callosum';'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';...
    'inferior_longitudinal_fasciculus';'medial_lemniscus';'midbrain'; 'middle_cerebellar_peduncle';...
    'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
    'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';...
    'superior_cerebellar_peduncle'; 'superior_corona_radiata';'superior_fronto_occipital_fasciculus';...
    'superior_longitudinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};

tract_first_error = [];
for n = 1:length(tract)
    tract_spec = [];
    tract_spec = sub(strcmp({sub.tract}, tract{n}));
    if ~isempty(tract_spec)
        tract_first_error = [tract_first_error tract_spec];
    end 
end

save('autoblsa18_error_data.mat', 'tract_first_error');
%%
% orig = load('autoblsa18_original_data.mat');
% sum([orig.blsa18_data.error_count])
% orig.blsa18_data([orig.blsa18_data.error_count]>0)

corr = load('autoblsa18_corrected_data.mat');
sum([corr.blsa18_data.error_count])
corr.blsa18_data([corr.blsa18_data.error_count]>0)