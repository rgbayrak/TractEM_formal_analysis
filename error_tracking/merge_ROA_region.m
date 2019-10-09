%% This script merges the regions (union of ROA labels)
% Author: roza.g.bayrak@vanderbilt.edu

clear all;
close all;

exDir = {'/nfs/masi/bayrakrg/tractem_data/corrected/BLSA'};
    
for e = 1:length(exDir)
    subjectDir = fullfile(exDir{e}, '*');
    sub = fullfile(subjectDir, '*');  
    subDir = dir(fullfile(subjectDir, '*'));
 
    regionList = {'ROA'};
    abbList =  {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
                'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};

    tractList =  {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum'; ...
    'cerebral_peduncle'; 'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';...
    'frontal_lobe';'genu_corpus_callosum';'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';...
    'inferior_longitudinal_fasciculus';'medial_lemniscus';'midbrain'; 'middle_cerebellar_peduncle';...
    'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
    'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';...
    'superior_cerebellar_peduncle'; 'superior_corona_radiata';'superior_fronto_occipital_fasciculus';...
    'superior_longitudinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};
    
    % exclude folder in the subDir if not in the tractList (QA, density or other tracts)
    filenames = cellstr(char(subDir.name));
    tracts = false(length(subDir),1);
    tracts(ismember(filenames,tractList)) = true;
    subDir = subDir(tracts);

    namePlot = [];

    for l = 1:length(subDir)
        init = 0;
        initL = 0;
        initR = 0;
        sum_of_nifty = 0;
        sum_of_nifty_L = 0;
        sum_of_nifty_R = 0;
        spec_tract_dir = dir(fullfile([subDir(l).folder,'/', subDir(l).name, '/*' regionList{:} '*.nii.gz']));
        spec_tract_dir_L = dir(fullfile([subDir(l).folder,'/', subDir(l).name, '/*L_' regionList{:} '*.nii.gz']));
        spec_tract_dir_R = dir(fullfile([subDir(l).folder,'/', subDir(l).name, '/*R_' regionList{:} '*.nii.gz']));

        if length(spec_tract_dir) > 1
            if length(strfind(spec_tract_dir(1).name,'_')) == 1      
                for s = 1:length(spec_tract_dir) 
                    tract_parts = strsplit(spec_tract_dir(s).name, '_');
                    vol = load_nii(fullfile(spec_tract_dir(s).folder, spec_tract_dir(s).name));
                    nifty = zeros(size(vol.img));
                    nifty(:, :, :) = vol.img;     

                    if init==0
                        sum_of_nifty = zeros(size(nifty));
                        init = 1;
                    end
                    % union of regions
                    sum_of_nifty = sum_of_nifty + nifty;
                end
                      
                vol.img = zeros(size(vol.img));
                vol.img(:, :, :) = sum_of_nifty;
                save_nii(vol, [spec_tract_dir(s).folder '/' tract_parts{1} '_ROA1.nii.gz'])
            end
        end

        if length(spec_tract_dir_L) > 1
            for s = 1:length(spec_tract_dir_L) 
                tract_parts_L = strsplit(spec_tract_dir_L(s).name, '_');
                volL = load_nii(fullfile(spec_tract_dir_L(s).folder, spec_tract_dir_L(s).name));
                niftyL = zeros(size(volL.img));
                niftyL(:, :, :) = volL.img;     

                if initL==0
                    sum_of_nifty_L = zeros(size(niftyL));
                    initL = 1;
                end
                % union of regions
                sum_of_nifty_L = sum_of_nifty_L + niftyL;
            end
            
            volL.img = zeros(size(volL.img));
            volL.img(:, :, :) = sum_of_nifty_L;
            save_nii(volL, [spec_tract_dir(s).folder '/' tract_parts{1} '_L_ROA1.nii.gz'])
        end

        if length(spec_tract_dir_R) > 1
            for s = 1:length(spec_tract_dir_R)
                tract_parts_R = strsplit(spec_tract_dir_R(s).name, '_');
                volR = load_nii(fullfile(spec_tract_dir_R(s).folder, spec_tract_dir_R(s).name));
                niftyR = zeros(size(volR.img));
                niftyR(:, :, :) = volR.img;     

                if initR==0
                    sum_of_nifty_R = zeros(size(niftyR));
                    initR = 1;
                end
                % union of regions
                sum_of_nifty_R = sum_of_nifty_R + niftyR;
            end
                
            volR.img = zeros(size(volR.img));
            volR.img(:, :, :) = sum_of_nifty_R;
            save_nii(volR, [spec_tract_dir(s).folder '/' tract_parts{1} '_R_ROA1.nii.gz'])
        end
    end
end