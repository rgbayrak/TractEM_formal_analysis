bashrc
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

% % Data directories
exDir              = '~/Desktop/region';
subjectDir = fullfile(exDir, '*');  % directory names are as follows -> subject_rater
subDir = fullfile(subjectDir, '*');  % tract names are defined as published

abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'};  %; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
%             'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
trackList = {'Anterior Commissure'; 'Anterior Corona Radiata'; 'Anterior Limb Internal Capsule';'Body Corpus Callosum';'Cerebral Peduncle'}; %;'Cingulum Cingulate Gyrus'; ...
%             'Cingulum Hippocampal';'Corticospinal Tract';'Fornix';'Fornix Stria Terminalis';'Frontal Lobe';'Genu Corpus Callosum';'Inferior Cerebellar Peduncle'; ...
%             'Inferior Fronto Occipital Fasciculus';'Inferior Longitudinal Fasciculus';'Medial Lemniscus';'Midbrain';'Middle Cerebellar Peduncle';'Occipital Lobe'; ...
%             'Olfactory Radiation';'Optic Tract';'Parietal Lobe';'Pontine Crossing Tract';'Posterior Corona Radiata';'Posterior Limb Internal Capsule'; ...
%             'Posterior Thalamic Radiation';'Sagittal Stratum';'Splenium Corpus Callosum';'Superior Cerebellar Peduncle';'Superior Corona Radiata'; ...
%             'Superior Fronto Occipital Fasciculus';'Superior Longitudinal Fasciculus';'Tapetum Corpus Callosum';'Temporal Lobe';'Uncinate Fasciculus'};

for l = 1:length(abbList)
    % get track folders and do analysis on them
    densityDir = dir(fullfile(subDir, [abbList{l} '_*density.nii.gz'])); % not every folder has separate density files (left & right)
    
    if length(strfind(densityDir(1).name,'_')) == 1
        d = length(densityDir);
        for d = 1:length(densityDir)
        % Load nifti density .gz files 
            density_nii = load_nii(fullfile(densityDir(d).folder, densityDir(d).name));
        end
      

    elseif length(strfind(densityDir(1).name,'_')) == 2
        densityLDir = dir(fullfile(subDir, [abbList{l} '_L_density.nii.gz']));
        densityRDir = dir(fullfile(subDir, [abbList{l} '_R_density.nii.gz']));
        if length(strfind(densityLDir(1).name,'_L')) == 1
          
        end

        if length(strfind(densityRDir(1).name,'_R')) == 1
            
        end
    end
end