%% This script is for similarity analysis between tract densities
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

newDir              = {'/nfs/masi/wangx41/auto_tracked_from_corrected_regions/HCP'}; 
exDir               = {'/nfs/masi/wangx41/auto2_tracked_from_corrected_regions/HCP'}; 
outDir              = {'/nfs/masi/bayrakrg/tractem_data/tract_similarity/HCP'}; 
for e = 1:length(exDir)
    exsubDir = fullfile(exDir{e}, '*/');  % directory names are as follows -> subject_rater
    newsubDir = fullfile(newDir{e}, '*/');  % tract names are defined as published  

    abbList = { 'aic'; 'gcc'; 'ilf'; }; 

    tractList = {'anterior_limb_internal_capsule';'genu_corpus_callosum'; ...
        'inferior_longitudinal_fasciculus'};

    % % OVERLAP BASED METRICS
    % Dice Coefficient --------------------------------------------------------------------------------------------------------------------
    threshold = 0.05;
%     similarity = struct;
    for l = 1:length(abbList)
        % get track folders and do analysis on them
        exdensDir = dir(fullfile(exsubDir, tractList{l}, [abbList{l} '*tdi.nii.gz'])); % not every folder has separate density files (left & right)
        newdensDir = dir(fullfile(newsubDir, tractList{l}, [abbList{l} '*density.nii.gz'])); 

        
        if length(strfind(exdensDir(1).name,'_')) == 1            
            out = tract_dice(exdensDir, newdensDir, threshold);
            save([outDir{e} '/' abbList{l} '2_dice.mat'], 'out');             
            disp([abbList{l} ' has been processed!'])        
%             similarity.dice = out;

        elseif length(strfind(exdensDir(1).name,'_')) == 2
            exdensDir_L = dir(fullfile(exsubDir, tractList{l}, [abbList{l} '*_L_*tdi.nii.gz']));
            newdensDir_L = dir(fullfile(newsubDir, tractList{l}, [abbList{l} '*_L_density.nii.gz']));
            exdensDir_R = dir(fullfile(exsubDir, tractList{l}, [abbList{l} '*_R_*tdi.nii.gz']));
            newdensDir_R = dir(fullfile(newsubDir, tractList{l}, [abbList{l} '*_R_density.nii.gz']));
            
            if length(strfind(exdensDir_L(1).name,'_L')) == 1
                out_L = tract_dice(exdensDir_L, newdensDir_L,  threshold);
                save([outDir{e} '/' abbList{l} '2_L_dice.mat'], 'out_L');                     
                disp([abbList{l} '_L has been processed!'])        
%                 similarity.dice_left = out_L;
            end

            if length(strfind(exdensDir_R(1).name,'_R')) == 1
                out_R = tract_dice(exdensDir_R, newdensDir_R,  threshold);
                save([outDir{e} '/' abbList{l} '2_R_dice.mat'], 'out_R');               
                disp([abbList{l} '_R has been processed!'])        
%                 similarity.dice_right = out_R;
            end
        end
    end
end