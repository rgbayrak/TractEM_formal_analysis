% % Overlaying two density files
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;


addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg:')


% BLSA
exDir              = '/home-local/bayrakrg/Dropbox*VUMC*/complete_BLSA_*';
subjectDir = fullfile(exDir, '7678_*');  % directory names are as follows -> subject_rater
subDir = fullfile(subjectDir, '*');  % tract names are defined as published

mat_exDir = '/home-local/bayrakrg/Dropbox*VUMC*/tractEM/BLSA_auto';
matDir = fullfile(mat_exDir, 'BLSA_DICE_mat');  % directory names are as follows -> subject_rater
dice_mat_files = dir(fullfile([matDir, '/*dice.mat']));
name_mat_files = dir(fullfile([matDir, '/*nameMe.mat']));

background = '/home/local/VANDERBILT/bayrakrg/Desktop/7678_auto/7678_tal_fib_qa.nii.gz';


abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
trackList = {'Anterior Commissure'; 'Anterior Corona Radiata'; 'Anterior Limb Internal Capsule';'Body Corpus Callosum';'Cerebral Peduncle';'Cingulum Cingulate Gyrus'; ...
            'Cingulum Hippocampal';'Corticospinal Tract';'Fornix';'Fornix Stria Terminalis';'Frontal Lobe';'Genu Corpus Callosum';'Inferior Cerebellar Peduncle'; ...
            'Inferior Fronto Occipital Fasciculus';'Inferior Longitudinal Fasciculus';'Medial Lemniscus';'Midbrain';'Middle Cerebellar Peduncle';'Occipital Lobe'; ...
            'Olfactory Radiation';'Optic Tract';'Parietal Lobe';'Pontine Crossing Tract';'Posterior Corona Radiata';'Posteriorlimb Internal Capsule'; ...
            'Posterior Thalamic Radiation';'Sagittal Stratum';'Splenium Corpus Callosum';'Superior Cerebellar Peduncle';'Superior Corona Radiata'; ...
            'Superior Fronto Occipital Fasciculus';'Superior Longitudinal Fasciculus';'Tapetum Corpus Callosum';'Temporal Lobe';'Uncinate Fasciculus'};
  
threshold = .05;
for l = 1:length(abbList)
    % get track folders and do analysis on them
    densityDir = dir(fullfile(subDir, [abbList{l} '_*density.nii.gz'])); % not every folder has separate density files (left & right)
    
    % If there is only one tract file
    if length(strfind(densityDir(1).name,'_')) == 1
        d = length(densityDir);
        density = load_density(densityDir);
        [nameMe, diceMatrix] = dice(densityDir, density, threshold, d);
        
        
           %loop to overlay same subject images
            for i = 1:d
                for j = i:d
                    % Getting the names of compared files
                    partsi = strsplit(densityDir(i).folder, '/');
                    dirParti = partsi{end-1}; 
                    partsj = strsplit(densityDir(j).folder, '/');
                    dirPartj = partsj{end-1};
                    if diceMatrix(i,j) < 1
                        if i ~= j && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4))

                            im1 = density(:,:,:,i);
                            im2 = density(:,:,:,j);
                            % -------------------------------
                            f = figure('Visible','on');
                            overlap_plots(im1, im2, background)
                            set(f,'Position', [1 1 1680 1050]);
                            name = densityDir(1).name(1:end-15);
                            saveas(f,['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/BLSA_auto/overlay/' dirParti '_vs_' dirPartj '_' name '_overlay.jpg']); 
                            close all;

                        end
                    end
                end
           end
   
    % If there is two tract files
    % for left side
    elseif length(strfind(densityDir(1).name,'_')) == 2
        if length(strfind(densityDir(1).name,'_L')) == 1
            densityLDir = dir(fullfile(subDir, [abbList{l} '_L_density.nii.gz'])); % not every folder has separate density files (left & right)
            dl = length(densityLDir);
            densityL = load_density(densityLDir);
            [nameMe, diceL] = dice(densityLDir, densityL, threshold, dl);
            
            %loop to overlay to same subject images
            for i = 1:dl
                for j = i:dl
                    % Getting the names of compared files
                    partsi = strsplit(densityLDir(i).folder, '/');
                    dirParti = partsi{end-1};  
                    partsj = strsplit(densityLDir(j).folder, '/');
                    dirPartj = partsj{end-1};
                    
                    if diceL(i,j) < 1
                        if i ~= j && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4))

                            im1 = densityL(:,:,:,i);
                            im2 = densityL(:,:,:,j);
                            g = figure('Visible','on');
                            overlap_plots(im1, im2, background)
                            set(g,'Position', [1 1 1680 1050]);
                            name = densityDir(1).name(1:end-15);
                            saveas(g,['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/BLSA_auto/overlay/' dirParti '_vs_' dirPartj '_' name '_overlay.jpg']); 
                            close all;
                            

                        end
                    end
                end
            end

        end
        
        % for right side
        if length(strfind(densityDir(2).name,'_R')) == 1
            densityRDir = dir(fullfile(subDir, [abbList{l} '_R_density.nii.gz'])); % not every folder has separate density files (left & right)
            dr = length(densityRDir);
            densityR = load_density(densityRDir);
            [nameMe, diceR] = dice(densityRDir, densityR, threshold, dr);
            
            %loop to overlay to same subject images
            for i = 1:dr
                for j = i:dr
                    % Getting the names of compared files
                    partsi = strsplit(densityRDir(i).folder, '/');
                    dirParti = partsi{end-1};
                    partsj = strsplit(densityRDir(j).folder, '/');
                    dirPartj = partsj{end-1};
                    
                    if diceR(i,j) < 1
                        if i ~= j && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4))

                            im1 = densityR(:,:,:,i);
                            im2 = densityR(:,:,:,j);
                            h = figure('Visible','off');
                            overlap_plots(im1, im2, background)
                            set(h,'Position', [1 1 1680 1050]);
                            name = densityDir(1).name(1:end-15);
                            saveas(h,['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/BLSA_auto/overlay/' dirParti '_vs_' dirPartj '_' name '_overlay.jpg']); 
                            close all;

                        end
                    end
                end
            end
        end   
    end
end

