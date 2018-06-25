%% This script is for similarity analysis between tract densities
% Author: roza.g.bayrak@vanderbilt.edu

% close all;
% clear all;
% clc;

% Accesing the files from different projects
% exDir = '~/Desktop/NF';

% % HCP
% exDir              = '/home/local/VANDERBILT/bayrakrg/Dropbox*VUMC*/complete_HCP_subjects';
% subjectDir = fullfile(exDir, '*');  % directory names are as follows -> subject_rater
% subDir = fullfile(subjectDir, 'postproc/*');

% BLSA
exDir              = '/home/local/VANDERBILT/bayrakrg/Dropbox*VUMC*/complete_BLSA_subjects';
subjectDir = fullfile(exDir, '*');  % directory names are as follows -> subject_rater
subDir = fullfile(subjectDir, '*');  % tract names are defined as published

abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
trackList = {'Anterior Commissure'; 'Anterior Corona Radiata'; 'Anterior Limb Internal Capsule';'Body Corpus Callosum';'Cerebral Peduncle';'Cingulum Cingulate Gyrus'; ...
            'Cingulum Hippocampal';'Corticospinal Tract';'Fornix';'Fornix Stria Terminalis';'Frontal Lobe';'Genu Corpus Callosum';'Inferior Cerebellar Peduncle'; ...
            'Inferior Fronto Occipital Fasciculus';'Inferior Longitudinal Fasciculus';'Medial Lemniscus';'Midbrain';'Middle Cerebellar Peduncle';'Occipital Lobe'; ...
            'Olfactory Radiation';'Optic Tract';'Parietal Lobe';'Pontine Crossing Tract';'Posterior Corona Radiata';'Posteriorlimb Internal Capsule'; ...
            'Posterior Thalamic Radiation';'Sagittal Stratum';'Splenium Corpus Callosum';'Superior Cerebellar Peduncle';'Superior Corona Radiata'; ...
            'Superior Fronto Occipital Fasciculus';'Superior Longitudinal Fasciculus';'Tapetum Corpus Callosum';'Temporal Lobe';'Uncinate Fasciculus'};
        
        
% % OVERLAP BASED METRICS
% Dice Coefficient --------------------------------------------------------------------------------------------------------------------

threshold = 0.05;

for l = 16:length(abbList)
    % get track folders and do analysis on them
    densityDir = dir(fullfile(subDir, [abbList{l} '_*density.nii.gz'])); % not every folder has separate density files (left & right)
    
    if length(strfind(densityDir(1).name,'_')) == 1
        d = length(densityDir);
        density = load_density(densityDir);
        [nameMe, diceMatrix] = cdice(densityDir, density, threshold, d);

        figure(1);   
        imagesc(diceMatrix)
%         track = convertCharsToStrings(trackList{l});
%         title(['Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Across Raters'], 'FontSize', 10); % set title
        title(['Continuous Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Across Raters'], 'FontSize', 10); % set title
        colormap; % set the colorscheme
        xticks((1:d))
        nameMe = strrep(nameMe,"_"," ");
        xticklabels(nameMe);
        yticks((1:d))
        yticklabels(nameMe);
        xtickangle(45)
        colorbar;

        textStrings = num2str(diceMatrix(:), '%0.2f');       % Create strings from the matrix values
        textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
        [x, y] = meshgrid(1:length(densityDir));  % Create x and y coordinates for the strings
        hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                        'HorizontalAlignment', 'center');

        set(figure(1),'Position', [1 1 1680 1050]);
        name = densityDir(1).name(1:end-15);
%             saveas(figure(1),['/home/local/VANDERBILT/bayrakrg/Dropbox (VUMC)/BLSA/BLSA_Dice' 'dice_' name '.jpg']); 
            saveas(figure(1),['/home/local/VANDERBILT/bayrakrg/Dropbox (VUMC)/BLSA/BLSA_CDice/' 'cdice_' name '.jpg']); 
        close all;

    elseif length(strfind(densityDir(1).name,'_')) == 2
        if length(strfind(densityDir(1).name,'_L')) == 1
            densityLDir = dir(fullfile(subDir, [abbList{l} '_L_density.nii.gz'])); % not every folder has separate density files (left & right)
            dl = length(densityLDir);
            densityL = load_density(densityLDir);
            [nameMe, diceMatrix] = cdice(densityLDir, densityL, threshold, dl);

            figure(2);   
            imagesc(diceMatrix)
%             title(['Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Left Across Raters'], 'FontSize', 10); % set title
            title(['Continuous Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Left Across Raters'], 'FontSize', 10); % set title
            colormap; % set the colorscheme
            xticks((1:dl))
            nameMe = strrep(nameMe,"_"," ");
            xticklabels(nameMe);
            yticks((1:dl))
            yticklabels(nameMe);
            xtickangle(45)
            colorbar;

            textStrings = num2str(diceMatrix(:), '%0.2f');       % Create strings from the matrix values
            textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
            [x, y] = meshgrid(1:length(densityLDir));  % Create x and y coordinates for the strings
            hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                            'HorizontalAlignment', 'center');

            set(figure(2),'Position', [1 1 1680 1050]);
            name = densityDir(1).name(1:end-15);
%             saveas(figure(2),['/home/local/VANDERBILT/bayrakrg/Dropbox (VUMC)/BLSA/BLSA_Dice' 'dice_' name '.jpg']); 
            saveas(figure(2),['/home/local/VANDERBILT/bayrakrg/Dropbox (VUMC)/BLSA/BLSA_CDice/' 'cdice_' name '.jpg']); 
            close all;
        end

        if length(strfind(densityDir(2).name,'_R')) == 1
            densityRDir = dir(fullfile(subDir, [abbList{l} '_R_density.nii.gz'])); % not every folder has separate density files (left & right)
            dr = length(densityRDir);
            densityR = load_density(densityRDir);
            [nameMe, diceMatrix] = cdice(densityRDir, densityR, threshold, dr);

            figure(3);   
            imagesc(diceMatrix)
%             title(['Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Right Across Raters'], 'FontSize', 10); % set title
            title(['Continuous Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Right Across Raters'], 'FontSize', 10); % set title
            colormap; % set the colorscheme
            xticks((1:dr))
            nameMe = strrep(nameMe,"_"," ");
            xticklabels(nameMe);
            yticks((1:dr))
            yticklabels(nameMe);
            xtickangle(45)
            colorbar;

            textStrings = num2str(diceMatrix(:), '%0.2f');       % Create strings from the matrix values
            textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
            [x, y] = meshgrid(1:length(densityRDir));  % Create x and y coordinates for the strings
            hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                            'HorizontalAlignment', 'center');

            set(figure(3),'Position', [1 1 1680 1050]);
            name = densityDir(2).name(1:end-15);
%             saveas(figure(3),['/home/local/VANDERBILT/bayrakrg/Dropbox (VUMC)/BLSA/BLSA_Dice' 'dice_' name '.jpg']); 
            saveas(figure(3),['/home/local/VANDERBILT/bayrakrg/Dropbox (VUMC)/BLSA/BLSA_CDice/' 'cdice_' name '.jpg']); 
            close all;
        end
    end
end