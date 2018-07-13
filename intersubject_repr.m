%% This script is for similarity analysis between tract densities
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

% Loading the data from multiple directories
exDir              = '/home-local/bayrakrg/Dropbox*VUMC*/BLSA';
matDir = fullfile(exDir, 'BLSA_mat');  % directory names are as follows -> subject_rater
dice_mat_files = dir(fullfile([matDir, '/*dice.mat']));
name_mat_files = dir(fullfile([matDir, '/*nameMe.mat']));


abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
trackList = {'Anterior Commissure'; 'Anterior Corona Radiata'; 'Anterior Limb Internal Capsule';'Body Corpus Callosum';'Cerebral Peduncle';'Cingulum Cingulate Gyrus'; ...
            'Cingulum Hippocampal';'Corticospinal Tract';'Fornix';'Fornix Stria Terminalis';'Frontal Lobe';'Genu Corpus Callosum';'Inferior Cerebellar Peduncle'; ...
            'Inferior Fronto Occipital Fasciculus';'Inferior Longitudinal Fasciculus';'Medial Lemniscus';'Midbrain';'Middle Cerebellar Peduncle';'Occipital Lobe'; ...
            'Olfactory Radiation';'Optic Tract';'Parietal Lobe';'Pontine Crossing Tract';'Posterior Corona Radiata';'Posteriorlimb Internal Capsule'; ...
            'Posterior Thalamic Radiation';'Sagittal Stratum';'Splenium Corpus Callosum';'Superior Cerebellar Peduncle';'Superior Corona Radiata'; ...
            'Superior Fronto Occipital Fasciculus';'Superior Longitudinal Fasciculus';'Tapetum Corpus Callosum';'Temporal Lobe';'Uncinate Fasciculus'};

dice_inter_subject = [];

for l = 1:length(dice_mat_files)
    % starts from ac goes through the list of tracts
    dice_mat = load(fullfile(dice_mat_files(l).folder, dice_mat_files(l).name));
    name_mat = load(fullfile(name_mat_files(l).folder, name_mat_files(l).name));
    name_mat = struct2cell(name_mat);
    name_mat = name_mat{1,1};
    id = {};
    for p = 1:length(name_mat)
        parts = strsplit(name_mat(p), '_');
        id{p} = parts{1};
    end
    uni_id = unique(id);
    for d = 1:length(uni_id)
        disp(['For: ' char(uni_id(d)) '_inter-subject_' dice_mat_files(l).name(1:end-4) ' is: '])
        % picks the same subject dice coeff. and masks the rest
% %         mask_id = strcmp(id,uni_id(d));
% %         dice_mat_temp = struct2cell(dice_mat);
% %         dice_mat_temp = dice_mat_temp{1,1};
% %         dice_mat_temp = dice_mat_temp(mask_id, mask_id);
% %         dice_mat_inter_subject = triu(dice_mat_temp, 1);
% %         disp(dice_mat_inter_subject)
% %         dice_inter_subject{d} = dice_mat_inter_subject;
        
        mask_id = strcmp(id,uni_id(d));
        dice_mat_temp = struct2cell(dice_mat);
        dice_mat_temp = dice_mat_temp{1,1};
        dice_mat_temp = dice_mat_temp(mask_id, mask_id);
        idx = triu(true(size(dice_mat_temp,1)), 1);        
        dice_mat_inter_subject = dice_mat_temp(idx)';
        disp(dice_mat_inter_subject)
        dice_inter_subject{d} = dice_mat_inter_subject;
        
    end
    dis{l} = dice_inter_subject;
%     boxplot(cell2mat(dice_inter_subject))
%     title(['something' \fontsize{6}])
%     nameMe = strrep(dice_mat.nameMe,"_"," ");
%     ylabel('dice coefficient')
% %     xticklabels('avg')
%     xticklabels(dice_mat.nameMe);
    disp(fullfile(dice_mat_files(l).name(1:end-4)))
end

dis_mat = [];
for i = 1:length(dis)
    data = cell2mat(dis{1,i})';
    if size(dis_mat,1) > size(data,1)
        data = [data; nan(size(dis_mat,1) - size(data,1), 1)];
    else
        dis_mat= [dis_mat; nan(size(data,1) - size(dis_mat,1), size(dis_mat,2))];
    end
    dis_mat = [dis_mat data];
end


boxplot(dis_mat)

tractList = {'Anterior Commissure'; 'Anterior Corona Radiata Left';'Anterior Corona Radiata Right'; 'Anterior Limb Internal Capsule Left';'Anterior Limb Internal Capsule Right';'Body Corpus Callosum';...
            'Cingulum Cingulate Gyrus Left';'Cingulum Cingulate Gyrus Right'; 'Cingulum Hippocampal Left'; ...
            'Cingulum Hippocampal Right';'Cerebral Peduncle Left';'Cerebral Peduncle Right';...
            'Corticospinal Tract Left';'Corticospinal Tract Right';'Frontal Lobe Left';'Frontal Lobe Right';'Fornix Left';'Fornix Right';'Fornix Stria Terminalis Left';'Fornix Stria Terminalis Right';...
            'Genu Corpus Callosum';'Inferior Cerebellar Peduncle Left';'Inferior Cerebellar Peduncle Right'; ...
            'Inferior Fronto Occipital Fasciculus Left';'Inferior Fronto Occipital Fasciculus Right';'Inferior Longitudinal Fasciculus Left';'Inferior Longitudinal Fasciculus Right';...
            'Midbrain';'Middle Cerebellar Peduncle';'Medial Lemniscus Left';'Medial Lemniscus Right';'Occipital Lobe Left';'Occipital Lobe Right'; ...
            'Olfactory Radiation Left';'Olfactory Radiation Right';'Optic Tract';...
            'Posterior Corona Radiata Left';'Posterior Corona Radiata Right';'Pontine Crossing Tract';...
            'Posteriorlimb Internal Capsule Left';'Posteriorlimb Internal Capsule Right';'Parietal Lobe Left';'Parietal Lobe Right';...
            'Posterior Thalamic Radiation Left';'Posterior Thalamic Radiation Right';'Splenium Corpus Callosum';...
            'Superior Cerebellar Peduncle Left';'Superior Cerebellar Peduncle Right';'Superior Corona Radiata Left';'Superior Corona Radiata Right'; ...
            'Superior Fronto Occipital Fasciculus Left';'Superior Fronto Occipital Fasciculus Right';'Superior Longitudinal Fasciculus Left';'Superior Longitudinal Fasciculus Right';...
             'Sagittal Stratum Left';'Sagittal Stratum Right';'Tapetum Corpus Callosum';'Temporal Lobe Left';'Temporal Lobe Right';'Uncinate Fasciculus Left';'Uncinate Fasciculus Right'};
 
xticklabels(tractList);
title('Inter Subject Tract Reproducibility')
xtickangle(45);
grid on;
% ylim([0 1])

figure; distributionPlot(dis_mat, 'color', [0.3 0.6 0.08] )
xticklabels(tractList);
title('Inter Subject Tract Reproducibility')
xtickangle(45);
grid on;
