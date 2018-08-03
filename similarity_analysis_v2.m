%% This scrip is for similarity analysis between tract densities
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

% Accesing the files from different projects
% exDir = '~/Desktop/NF';
% exDir              = '/home/local/VANDERBILT/bayrakrg/Dropbox*VUMC*/complete_HCP_subjects';
exDir              = '/home/local/VANDERBILT/bayrakrg/Dropbox*VUMC*/complete_BLSA_subjects';
% subjects_id = {1127; 1134; 1632; 1834; 1881; 5708; 5750; 7678; 7748; 7759};
% raters = {'Christa'; 'Aviral'; 'Bruce'; 'Yi'; 'Yufei'; 'Eugene'; 'Xuan'; 'Jasmine'};
% abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
%             'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
        
subjectDir = fullfile(exDir, '*');  % directory names are as follows -> subject_rater
subDir = fullfile(subjectDir, '*');  % tract names are defined as published
densityDir = dir(fullfile(subDir, '*ac_density.nii.gz')); % not every folder has separate density files (left & right)
% densityDir = dir(fullfile(subDir, '*acr_L_density.nii.gz')); % not every folder has separate density files (left & right)
% densityDir = dir(fullfile(subDir, '*acr_R_density.nii.gz')); % not every folder has separate density files (left & right)

% trkDir = fullfile(subDir, '*ac_tract.trk.gz');  % not every folder has separate trk files
% trkDirUnzipped = dir(fullfile(subDir, '*ac_tract.trk.gz'));

density = [];
initd = 0;
for d = 1:length(densityDir)
    % Load nifti density .gz files 
    density_nii = load_untouch_nii(fullfile(densityDir(d).folder, densityDir(d).name));
    
    if ~initd
        density = zeros([size(density_nii.img) length(densityDir)]);
        initd = 1;
    end
    
    density(:,:,:,d) = density_nii.img;
    disp(size(density_nii.img))

end 


% OVERLAP BASED METRICS
% Dice Coefficient 

% Setting a threshold to avoid outliers
threshold = 0.05;
density(density < threshold) = 0;
density(density >= threshold) = 1;

is = [];
d1 = [];
d2 = [];
Dice = [];


for i = 1:d
    for j = i:d
        if i ~= j
            im1 = density(:,:,:,i);
            im2 = density(:,:,:,j);
            intersection = (im1 & im2);
            is = sum(intersection(:));
            d1 = sum(im1(:));
            d2 = sum(im2(:));

            Dice = 2*is/(d1+d2);
            partsi = strsplit(densityDir(i).folder, '/');
            dirParti = partsi{end-1};
            partsj = strsplit(densityDir(j).folder, '/');
            dirPartj = partsj{end-1};
            disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
            fprintf('\n Dice similarity is %0.4f\n', Dice);
            fprintf('\n');
        end
    end
end