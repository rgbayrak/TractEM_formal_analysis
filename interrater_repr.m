%% This script is for inter subject and inter rater reproducibility analysis for BLSA tractem data
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

% Loading the data from multiple directories
exDir              = '/home-local/bayrakrg/Dropbox*VUMC*/HCP';
matDir = fullfile(exDir, 'HCP_mat');  % directory names are as follows -> subject_rater

% load the directories of dice coefficients and their corresponding name files
dice_mat_files = dir(fullfile([matDir, '/*dice.mat']));
name_mat_files = dir(fullfile([matDir, '/*nameMe.mat']));

% abbreviation list
abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};

% initializations
dice_inter_subject = [];
dice_inter_rater = [];
dir_per_tract = [];
name_per_tract = [];

%%%
% This part of the script does the following: 
%       i - loads the dice and name files
%       ii - separates subject id#s and rater names
%       iii - grabs the relevant dice from the dice matrix using masks for:
%       1. inter-subject & 2. inter-rater(inter-subject)
%
% Some abbreviations: 
%   	dis = dice_inter_subject
%       dir = dir_per_tract
%   	npt = name_per_tract
%
%%%

for l = 1:length(dice_mat_files)
    
    % starts from ac goes through the list of tracts
    dice_mat = load(fullfile(dice_mat_files(l).folder, dice_mat_files(l).name));
    name_mat = load(fullfile(name_mat_files(l).folder, name_mat_files(l).name));
    name_mat = struct2cell(name_mat);
    name_mat = name_mat{1,1};
    
    % grab the subject id numbers
    id = {};
    name = {};
    for p = 1:length(name_mat)
        parts = strsplit(name_mat(p), '_');
        id{p} = parts{1}; % subject ids
        name{p} = parts{2}; % rater names
    end
    
    % create masks
    uni_id = unique(id);
    uni_name = unique(name);
    
    % grab corresponding dice coeff.
    for m = 1:length(uni_name)
        for d = 1:length(uni_id)
            disp(['For: ' char(uni_id(d)) '_inter-subject_' dice_mat_files(l).name(1:end-4) ' is: '])
            % picks the same subject dice coeff. and masks the rest
            mask_id = strcmp(id,uni_id(d)); 
            dice_mat_temp = struct2cell(dice_mat); 
            dice_mat_temp = dice_mat_temp{1,1};
            dice_mat_temp = dice_mat_temp(mask_id, mask_id);
            idx = triu(true(size(dice_mat_temp,1)), 1);  % since it is a matrix, we only grab the upper half      
            dice_mat_inter_subject = dice_mat_temp(idx)';
            disp(dice_mat_inter_subject)
            dice_inter_subject{d} = dice_mat_inter_subject; % saving inter-subject dice coefficients into 1xn cell 


            % picks the same rater (same-subject) dice coeff. and masks the rest
            mask_name = strcmp(name, uni_name(m)); 
            if sum(mask_name & mask_id) == 1
                dice_inter_rater{d} = dice_mat_inter_subject;
            else
                dice_inter_rater{d} = nan;
            end
        end
        % inter_rater_dice_coeff per tract
        dir_per_tract{m} = dice_inter_rater;
        % corresponding rater
        name_per_tract{m} = uni_name(m);
    end
    dis{l} = dice_inter_subject; % saving 1xn inter-subject dice coefficients into 1x61 cell (for all tracts)
    dir{l} = dir_per_tract; 
    npt{l} = name_per_tract;
    
    
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

% dir{a, b} | a is the rater name; b is the tract number

% with the help of Colin
dir_mat_deep = [];
for i = 1:length(dir)
    dir_mat = [];
    for j = 1:length(dir{1,i})
        data_dir = cell2mat(dir{1,i}{1,j})';
        if size(dir_mat,1) > size(data_dir,1)
            data_dir = [data_dir; nan(size(dir_mat,1) - size(data_dir,1), 1)];
        else
            dir_mat= [dir_mat; nan(size(data_dir,1) - size(dir_mat,1), size(dir_mat,2))];
        end
        dir_mat = [dir_mat data_dir];
    end
    % per tract
    if size(dir_mat_deep,2) > size(dir_mat,2)
        dir_mat = [dir_mat nan(size(dir_mat,1), size(dir_mat_deep,2) - size(dir_mat,2))];
    else
        dir_mat_deep= [dir_mat_deep nan(size(dir_mat_deep,1), size(dir_mat,2) - size(dir_mat_deep,2))];
    end
    dir_mat_deep = [dir_mat_deep; dir_mat];
end


% figure(1); boxplot(dis_mat)

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

% refline([0 .5])
% set(figure(1),'Position', [1 1 1680 1050]);
% xticklabels(tractList);
% title('Inter Subject Tract Reproducibility')
% xtickangle(45);
% grid on;
% ylim([0 1])
% 
% figure(2); distributionPlot(dis_mat, 'color', [0.3 0.6 0.08])
% alpha(.9)
% refline([0 .5])
% set(figure(2),'Position', [1 1 1680 1050]);
% xticklabels(tractList);
% title('Inter Subject Tract Reproducibility')
% xtickangle(45);
% grid on;
% ylim([-0.2 1.2])

figure(3); boxplot(dir_mat_deep)
refline([0 .5])
set(figure(3),'Position', [1 1 1680 1050]);
xticklabels(uni_name);
title('Inter Rater Reproducibility')
grid on;

figure(4); distributionPlot(dir_mat_deep, 'color', [0.3 0.6 0.08])
alpha(.8)
refline([0 .5])
set(figure(4),'Position', [1 1 1680 1050]);
xticklabels(uni_name);
title('Inter Rater Reproducibility')
grid minor;
