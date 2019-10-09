clc
clear all



% BLSA_subject_path = '/home-local/bayrakrg/Dropbox (VUMC)/complete_BLSA_subjects';
BLSA_subject_path = '/nfs/masi/bayrakrg/tractem_data/corrected/BLSA';
BLSA_subject_dirs = dir(BLSA_subject_path);

% The last version of the protocol
ac = {'ac_L_seed1.nii.gz', 'ac_R_seed1.nii.gz', 'ac_ROA1.nii.gz', ...
    'ac_tract.trk.gz', 'ac_density.nii.gz'}; 

acr = {'acr_L_seed1.nii.gz', 'acr_R_seed1.nii.gz', 'acr_ROA1.nii.gz', 'acr_L_ROI1.nii.gz', 'acr_R_ROI1.nii.gz', ...
    'acr_L_tract.trk.gz', 'acr_R_tract.trk.gz', 'acr_L_density.nii.gz', 'acr_R_density.nii.gz'};

aic = {'aic_L_seed1.nii.gz', 'aic_R_seed1.nii.gz', 'aic_ROA1.nii.gz', ...
    'aic_L_tract.trk.gz', 'aic_R_tract.trk.gz', 'aic_L_density.nii.gz', 'aic_R_density.nii.gz'};

bcc = {'bcc_seed1.nii.gz', 'bcc_ROA1.nii.gz', ...
    'bcc_tract.trk.gz', 'bcc_density.nii.gz'}; % single seed

cp = {'cp_L_seed1.nii.gz', 'cp_R_seed1.nii.gz', 'cp_ROA1.nii.gz', ...
    'cp_L_tract.trk.gz', 'cp_R_tract.trk.gz', 'cp_L_density.nii.gz', 'cp_R_density.nii.gz'};

cgc = {'cgc_L_seed1.nii.gz', 'cgc_R_seed1.nii.gz', 'cgc_L_seed2.nii.gz', 'cgc_R_seed2.nii.gz', 'cgc_ROA1.nii.gz', ...
    'cgc_L_tract.trk.gz', 'cgc_R_tract.trk.gz', 'cgc_L_density.nii.gz', 'cgc_R_density.nii.gz'}; % multiple seed

cgh = {'cgh_L_seed1.nii.gz', 'cgh_R_seed1.nii.gz', 'cgh_ROA1.nii.gz', 'cgh_L_ROI1.nii.gz', 'cgh_R_ROI1.nii.gz', 'cgh_L_ROI2.nii.gz', 'cgh_R_ROI2.nii.gz', ...
    'cgh_L_tract.trk.gz', 'cgh_R_tract.trk.gz', 'cgh_L_density.nii.gz', 'cgh_R_density.nii.gz'}; % multiple ROI

cst = {'cst_L_seed1.nii.gz', 'cst_R_seed1.nii.gz', 'cst_ROA1.nii.gz', 'cst_L_ROI1.nii.gz', 'cst_R_ROI1.nii.gz', ...
    'cst_L_tract.trk.gz', 'cst_R_tract.trk.gz', 'cst_L_density.nii.gz', 'cst_R_density.nii.gz'};

fx = {'fx_L_seed1.nii.gz', 'fx_R_seed1.nii.gz', 'fx_ROA1.nii.gz', 'fx_ROI1.nii.gz', ...
    'fx_L_tract.trk.gz', 'fx_R_tract.trk.gz', 'fx_L_density.nii.gz', 'fx_R_density.nii.gz'}; % single ROI

fxst = {'fxst_L_seed1.nii.gz', 'fxst_R_seed1.nii.gz', 'fxst_ROA1.nii.gz', 'fxst_L_ROI1.nii.gz', 'fxst_R_ROI1.nii.gz', ...
    'fxst_L_tract.trk.gz', 'fxst_R_tract.trk.gz', 'fxst_L_density.nii.gz', 'fxst_R_density.nii.gz'}; 

gcc = {'gcc_seed1.nii.gz', 'gcc_ROA1.nii.gz', ...
    'gcc_tract.trk.gz', 'gcc_density.nii.gz'};

icp = {'icp_L_seed1.nii.gz', 'icp_R_seed1.nii.gz', 'icp_ROA1.nii.gz', 'icp_L_ROI1.nii.gz', 'icp_R_ROI1.nii.gz', ...
    'icp_L_tract.trk.gz', 'icp_R_tract.trk.gz', 'icp_L_density.nii.gz', 'icp_R_density.nii.gz'};

ifo = {'ifo_L_seed1.nii.gz', 'ifo_R_seed1.nii.gz', 'ifo_ROA1.nii.gz', 'ifo_L_ROI1.nii.gz', 'ifo_R_ROI1.nii.gz', 'ifo_L_ROI2.nii.gz', 'ifo_R_ROI2.nii.gz', ...
    'ifo_L_tract.trk.gz', 'ifo_R_tract.trk.gz', 'ifo_L_density.nii.gz', 'ifo_R_density.nii.gz'};

ilf = {'ilf_L_seed1.nii.gz', 'ilf_R_seed1.nii.gz', 'ilf_ROA1.nii.gz', 'ilf_L_ROI1.nii.gz', 'ilf_R_ROI1.nii.gz', 'ilf_L_ROI2.nii.gz', 'ilf_R_ROI2.nii.gz', ...
    'ilf_L_tract.trk.gz', 'ilf_R_tract.trk.gz', 'ilf_L_density.nii.gz', 'ilf_R_density.nii.gz'};

ml = {'ml_L_seed1.nii.gz', 'ml_R_seed1.nii.gz', 'ml_ROA1.nii.gz', ...
    'ml_L_tract.trk.gz', 'ml_R_tract.trk.gz', 'ml_L_density.nii.gz', 'ml_R_density.nii.gz'};

m = {'m_seed1.nii.gz', 'm_ROA1.nii.gz', ...
    'm_tract.trk.gz', 'm_density.nii.gz'};

mcp = {'mcp_L_seed1.nii.gz', 'mcp_R_seed1.nii.gz', 'mcp_ROA1.nii.gz', ...
    'mcp_tract.trk.gz', 'mcp_density.nii.gz'};

olfr = {'olfr_L_seed1.nii.gz', 'olfr_R_seed1.nii.gz', 'olfr_ROA1.nii.gz', ...
    'olfr_L_tract.trk.gz', 'olfr_R_tract.trk.gz', 'olfr_L_density.nii.gz', 'olfr_R_density.nii.gz'};

opt = {'opt_L_seed1.nii.gz', 'opt_R_seed1.nii.gz', 'opt_L_seed2.nii.gz', 'opt_R_seed2.nii.gz', 'opt_ROA1.nii.gz', ...
    'opt_tract.trk.gz', 'opt_density.nii.gz'};

pct = {'pct_L_seed1.nii.gz', 'pct_R_seed1.nii.gz', 'pct_ROA1.nii.gz', 'pct_L_ROI1.nii.gz', 'pct_R_ROI1.nii.gz', ...
    'pct_tract.trk.gz', 'pct_density.nii.gz'};

pcr = {'pcr_L_seed1.nii.gz', 'pcr_R_seed1.nii.gz', 'pcr_ROA1.nii.gz', ...
    'pcr_L_tract.trk.gz', 'pcr_R_tract.trk.gz', 'pcr_L_density.nii.gz', 'pcr_R_density.nii.gz'};

pic = {'pic_L_seed1.nii.gz', 'pic_R_seed1.nii.gz', 'pic_ROA1.nii.gz', ...
    'pic_L_tract.trk.gz', 'pic_R_tract.trk.gz', 'pic_L_density.nii.gz', 'pic_R_density.nii.gz'};

ptr = {'ptr_L_seed1.nii.gz', 'ptr_R_seed1.nii.gz', 'ptr_ROA1.nii.gz', 'ptr_L_ROI1.nii.gz', 'ptr_R_ROI1.nii.gz', 'ptr_L_ROI2.nii.gz', 'ptr_R_ROI2.nii.gz', 'ptr_L_ROI3.nii.gz', 'ptr_R_ROI3.nii.gz', ...
    'ptr_L_tract.trk.gz', 'ptr_R_tract.trk.gz', 'ptr_L_density.nii.gz', 'ptr_R_density.nii.gz'}; % more ROI

ss = {'ss_L_seed1.nii.gz', 'ss_R_seed1.nii.gz', 'ss_ROA1.nii.gz', ...
    'ss_L_tract.trk.gz', 'ss_R_tract.trk.gz', 'ss_L_density.nii.gz', 'ss_R_density.nii.gz'};

scc = {'scc_seed1.nii.gz', 'scc_ROA1.nii.gz', ...
    'scc_tract.trk.gz', 'scc_density.nii.gz'};

scp = {'scp_L_seed1.nii.gz', 'scp_R_seed1.nii.gz', 'scp_ROA1.nii.gz', 'scp_L_ROI1.nii.gz', 'scp_R_ROI1.nii.gz', ...
    'scp_L_tract.trk.gz', 'scp_R_tract.trk.gz', 'scp_L_density.nii.gz', 'scp_R_density.nii.gz'};

scr = {'scr_L_seed1.nii.gz', 'scr_R_seed1.nii.gz', 'scr_ROA1.nii.gz', ...
    'scr_L_tract.trk.gz', 'scr_R_tract.trk.gz', 'scr_L_density.nii.gz', 'scr_R_density.nii.gz'};

sfo = {'sfo_L_seed1.nii.gz', 'sfo_R_seed1.nii.gz', 'sfo_ROA1.nii.gz', 'sfo_L_ROI1.nii.gz', 'sfo_R_ROI1.nii.gz', ...
    'sfo_L_tract.trk.gz', 'sfo_R_tract.trk.gz', 'sfo_L_density.nii.gz', 'sfo_R_density.nii.gz'};

slf = {'slf_L_seed1.nii.gz', 'slf_R_seed1.nii.gz', 'slf_ROA1.nii.gz', ...
    'slf_L_tract.trk.gz', 'slf_R_tract.trk.gz', 'slf_L_density.nii.gz', 'slf_R_density.nii.gz'};

tap = {'tap_L_seed1.nii.gz', 'tap_R_seed1.nii.gz', 'tap_ROA1.nii.gz', ...
    'tap_tract.trk.gz', 'tap_density.nii.gz'};

unc = {'unc_L_seed1.nii.gz', 'unc_R_seed1.nii.gz', 'unc_ROA1.nii.gz', ...
    'unc_L_tract.trk.gz', 'unc_R_tract.trk.gz', 'unc_L_density.nii.gz', 'unc_R_density.nii.gz'};

fl = {'fl_L_seed1.nii.gz', 'fl_R_seed1.nii.gz', 'fl_L_end1.nii.gz', 'fl_R_end1.nii.gz', 'fl_L_end2.nii.gz', 'fl_R_end2.nii.gz', 'fl_L_ROA1.nii.gz', 'fl_R_ROA1.nii.gz',...
    'fl_L_tract.trk.gz', 'fl_R_tract.trk.gz', 'fl_L_density.nii.gz', 'fl_R_density.nii.gz'};

ol = {'ol_L_seed1.nii.gz', 'ol_R_seed1.nii.gz', 'ol_L_end1.nii.gz', 'ol_R_end1.nii.gz','ol_L_end2.nii.gz', 'ol_R_end2.nii.gz', 'ol_L_ROA1.nii.gz', 'ol_R_ROA1.nii.gz',...
    'ol_L_tract.trk.gz', 'ol_R_tract.trk.gz', 'ol_L_density.nii.gz', 'ol_R_density.nii.gz'};

pl = {'pl_L_seed1.nii.gz', 'pl_R_seed1.nii.gz', 'pl_L_end1.nii.gz', 'pl_R_end1.nii.gz', 'pl_L_end2.nii.gz', 'pl_R_end2.nii.gz', 'pl_L_ROA1.nii.gz', 'pl_R_ROA1.nii.gz', ...
    'pl_L_tract.trk.gz', 'pl_R_tract.trk.gz', 'pl_L_density.nii.gz', 'pl_R_density.nii.gz'};

tl = {'tl_L_seed1.nii.gz', 'tl_R_seed1.nii.gz', 'tl_L_end1.nii.gz', 'tl_R_end1.nii.gz', 'tl_L_end2.nii.gz', 'tl_R_end2.nii.gz', 'tl_ROA1.nii.gz', ...
    'tl_L_tract.trk.gz', 'tl_R_tract.trk.gz', 'tl_L_density.nii.gz', 'tl_R_density.nii.gz'}; % single ROA

% drop folders that are not subject_rater pair
filenames = cellstr(char(BLSA_subject_dirs.name));
dropfiles = false(length(BLSA_subject_dirs),1);
dropfiles(~contains(filenames, {'.','..','.dropbox', 'postproc', 'tracking_parameters'})) = true; 
BLSA_subject_dirs = BLSA_subject_dirs(dropfiles);

blsa_data = [];

for subj = 1:length(BLSA_subject_dirs)
    
    disp(BLSA_subject_dirs(subj).name);
    
    % preprocess
    tract_dirs = dir(fullfile(BLSA_subject_dirs(subj).folder,BLSA_subject_dirs(subj).name,'*'));
    tract_dirs = tract_dirs(~ismember({tract_dirs.name},{'.','..'}));
    if ~isempty(tract_dirs)        
        
        tractfolders = cellstr(char(tract_dirs.name));
        dropfolders = false(length(tract_dirs),1);
        dropfolders(~contains(tractfolders, {'.', '..', '_fib.gz', '_fib_qa.nii.gz','density','postproc','QA'})) = true; 
        tract_dirs = tract_dirs(dropfolders);

        for trk = 1:length(tract_dirs)

            disp(tract_dirs(trk).name);

            files = dir(fullfile(tract_dirs(trk).folder, tract_dirs(trk).name, '*'));
            files = files(~ismember({files.name},{'.','..', 'corrected_ROAs'}));

            seed_array = [];
            ROA_array = [];
            ROI_array = [];
            density_array = [];
            trk_array = [];

            if length(files) > 2

                tractem_data = struct;
                tractem_data.subject_rater = BLSA_subject_dirs(subj).name;
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
                
                tractem_data.error = error_files;
                tractem_data.error_count = length(error_files);

                for file = 1:length(files)

                    disp(files(file).name);

                    if contains(files(file).name, 'seed')

                        if isempty(seed_array)
                            seed_array = files(file).name;
                        else
                            seed_array = [seed_array ', ' files(file).name];
                        end

                    end

                    if contains(files(file).name, 'ROA')

                        if isempty(ROA_array)
                            ROA_array = files(file).name;
                        else
                            ROA_array = [ROA_array ', ' files(file).name];
                        end

                    end

                    if contains(files(file).name, 'ROI')

                        if isempty(ROI_array)
                            ROI_array = files(file).name;
                        else
                            ROI_array = [ROI_array ', ' files(file).name];
                        end

                    end


                    if contains(files(file).name, 'density.nii.gz')

                        if isempty(density_array)
                            density_array = files(file).name;
                        else
                            density_array = [density_array ', ' files(file).name];
                        end

                    end

                    if contains(files(file).name, 'trk.gz')
                        if isempty(trk_array)
                            trk_array = files(file).name;
                        else
                            trk_array = [trk_array ', ' files(file).name];
                        end

                    end 
                    
                    tractem_data.seed = seed_array;
                    tractem_data.ROA = ROA_array;         
                    tractem_data.ROI = ROI_array;
                    tractem_data.density = density_array;
                    tractem_data.trk = trk_array;
                    tractem_data.location = files(file).folder;
                    
                    if contains(files(file).name, '_L_tract') ||  contains(files(file).name, '_R_tract')           
                        tractem_data.bilateral = 'YES';
                    else
                        tractem_data.bilateral = 'single or unknown';
                    end

                end
                
                blsa_data = [blsa_data tractem_data];

            end
        end
    end
end

save('blsa_corrected_data.mat', 'blsa_data');


%%
orig = load('blsa_original_data.mat');
sum([orig.blsa_data.error_count])
orig.blsa_data([orig.blsa_data.error_count]>0)

corr = load('blsa_corrected_data.mat');
sum([corr.blsa_data.error_count])
corr.blsa_data([corr.blsa_data.error_count]>0)