%% This script is for similarity analysis between tract densities
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

newDir              = {'/nfs/masi/wangx41/auto_tracked_from_corrected_regions/HCP'; '/nfs/masi/wangx41/auto_tracked_from_corrected_regions/BLSA18';'/nfs/masi/wangx41/auto_tracked_from_corrected_regions/BLSA'};% 
exDir               = {'/nfs/masi/bayrakrg/tractem_data/corrected/HCP'; '/nfs/masi/bayrakrg/tractem_data/corrected/BLSA18';'/nfs/masi/bayrakrg/tractem_data/corrected/BLSA'};% 
outDir              = {'/nfs/masi/bayrakrg/tractem_data/tract_similarity/HCP'; '/nfs/masi/bayrakrg/tractem_data/tract_similarity/BLSA18';'/nfs/masi/bayrakrg/tractem_data/tract_similarity/BLSA'};% 

for e = 1:length(exDir)
    exsubDir = fullfile(exDir{e}, '*/');  % directory names are as follows -> subject_rater
    newsubDir = fullfile(newDir{e}, '*/');  % tract names are defined as published  

    abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
                'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'}; 

    tractList = {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum'; ...
        'cerebral_peduncle'; 'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';...
        'frontal_lobe';'genu_corpus_callosum';'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';...
        'inferior_longitudinal_fasciculus';'medial_lemniscus';'midbrain'; 'middle_cerebellar_peduncle';...
        'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
        'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';...
        'superior_cerebellar_peduncle'; 'superior_corona_radiata';'superior_fronto_occipital_fasciculus';...
        'superior_longitudinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};

    % % OVERLAP BASED METRICS
    % Dice Coefficient --------------------------------------------------------------------------------------------------------------------
    threshold = 0.05;
%     similarity = struct;
    for l = 1:length(abbList)
        % get track folders and do analysis on them
        exdensDir = dir(fullfile(exsubDir, tractList{l}, [abbList{l} '*density.nii.gz'])); % not every folder has separate density files (left & right)
        newdensDir = dir(fullfile(newsubDir, tractList{l}, [abbList{l} '*density.nii.gz'])); 

        
        if length(strfind(exdensDir(1).name,'_')) == 1            
            out = tract_dice(exdensDir, newdensDir, threshold);
            save([outDir{e} '/' abbList{l} '_dice.mat'], 'out');             
            disp([abbList{l} ' has been processed!'])        
%             similarity.dice = out;

        elseif length(strfind(exdensDir(1).name,'_')) == 2
            exdensDir_L = dir(fullfile(exsubDir, tractList{l}, [abbList{l} '*_L_density.nii.gz']));
            newdensDir_L = dir(fullfile(newsubDir, tractList{l}, [abbList{l} '*_L_density.nii.gz']));
            exdensDir_R = dir(fullfile(exsubDir, tractList{l}, [abbList{l} '*_R_density.nii.gz']));
            newdensDir_R = dir(fullfile(newsubDir, tractList{l}, [abbList{l} '*_R_density.nii.gz']));
            
            if length(strfind(exdensDir_L(1).name,'_L')) == 1
                out_L = tract_dice(exdensDir_L, newdensDir_L,  threshold);
                save([outDir{e} '/' abbList{l} '_L_dice.mat'], 'out_L');                     
                disp([abbList{l} '_L has been processed!'])        
%                 similarity.dice_left = out_L;
            end

            if length(strfind(exdensDir_R(1).name,'_R')) == 1
                out_R = tract_dice(exdensDir_R, newdensDir_R,  threshold);
                save([outDir{e} '/' abbList{l} '_R_dice.mat'], 'out_R');               
                disp([abbList{l} '_R has been processed!'])        
%                 similarity.dice_right = out_R;
            end
        end
    end
end