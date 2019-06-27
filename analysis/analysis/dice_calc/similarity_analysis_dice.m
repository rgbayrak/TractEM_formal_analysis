%% This script is for similarity analysis between tract densities
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;


% % HCP
exDir              = '/share4/bayrakrg/tractEM/postprocessing/M-tracts/HCP';
subjectDir = fullfile(exDir, '*');  % directory names are as follows -> subject_rater
subDir = fullfile(subjectDir, '*');  % tract names are defined as published

abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
trackList = {'Anterior Commissure'; 'Anterior Corona Radiata'; 'Anterior Limb Internal Capsule';'Body Corpus Callosum';'Cerebral Peduncle';'Cingulum Cingulate Gyrus'; ...
            'Cingulum Hippocampal';'Corticospinal Tract';'Fornix';'Fornix Stria Terminalis';'Frontal Lobe';'Genu Corpus Callosum';'Inferior Cerebellar Peduncle'; ...
            'Inferior Fronto Occipital Fasciculus';'Inferior Longitudinal Fasciculus';'Medial Lemniscus';'Midbrain';'Middle Cerebellar Peduncle';'Occipital Lobe'; ...
            'Olfactory Radiation';'Optic Tract';'Parietal Lobe';'Pontine Crossing Tract';'Posterior Corona Radiata';'Posterior Limb Internal Capsule'; ...
            'Posterior Thalamic Radiation';'Sagittal Stratum';'Splenium Corpus Callosum';'Superior Cerebellar Peduncle';'Superior Corona Radiata'; ...
            'Superior Fronto Occipital Fasciculus';'Superior Longitudinal Fasciculus';'Tapetum Corpus Callosum';'Temporal Lobe';'Uncinate Fasciculus'};
        
        
% % OVERLAP BASED METRICS
% Dice Coefficient --------------------------------------------------------------------------------------------------------------------

threshold = 0.0;

for l = 1:length(abbList)
    % get track folders and do analysis on them
    densityDir = dir(fullfile(subDir, [abbList{l} '_*density.nii.gz'])); % not every folder has separate density files (left & right)
    
    if length(strfind(densityDir(1).name,'_')) == 1
        d = length(densityDir);
        density = load_density(densityDir);
        [nameMe, diceMatrix] = dice(densityDir, density, threshold, d);
        save(['/share4/bayrakrg/tractEM/postprocessing/DICE/human_dice_mat/HCP/' abbList{l} '_dice.mat'], 'diceMatrix');           
        save(['/share4/bayrakrg/tractEM/postprocessing/DICE/human_dice_mat/HCP/' abbList{l} '_nameMe'], 'nameMe');
        %plotting
        r = figure('Visible','off');   
        imagesc(diceMatrix)
        title(['Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Across Raters'], 'FontSize', 10); % set title
        colormap; % set the colorscheme
        xticks((1:d))
        nameMe = strrep(nameMe,'_',' ');
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
        set(r,'Position', [1 1 1680 1050]);
        name = densityDir(1).name(1:end-15);
        saveas(r,['/share4/bayrakrg/tractEM/postprocessing/DICE/human_dice/HCP/' 'dice_' name '.jpg']); 
        close all;
        disp([abbList{l} ' has been processed!'])

    elseif length(strfind(densityDir(1).name,'_')) == 2
        densityLDir = dir(fullfile(subDir, [abbList{l} '_L_density.nii.gz']));
        densityRDir = dir(fullfile(subDir, [abbList{l} '_R_density.nii.gz']));
        if length(strfind(densityLDir(1).name,'_L')) == 1
            dl = length(densityLDir);
            densityL = load_density(densityLDir);
            [nameMe, diceL] = dice(densityLDir, densityL, threshold, dl);
            save(['/share4/bayrakrg/tractEM/postprocessing/DICE/human_dice_mat/HCP/' abbList{l} '_L_dice.mat'], 'diceL');           
            save(['/share4/bayrakrg/tractEM/postprocessing/DICE/human_dice_mat/HCP/' abbList{l} '_L_nameMe'], 'nameMe');
            % plotting
            p = figure('Visible','off');   
            imagesc(diceL)
            title(['Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Left Across Raters'], 'FontSize', 10); % set title
            colormap; % set the colorscheme
            xticks((1:dl))
            nameMe = strrep(nameMe,'_',' ');
            xticklabels(nameMe);
            yticks((1:dl))
            yticklabels(nameMe);
            xtickangle(45)
            colorbar;
            textStrings = num2str(diceL(:), '%0.2f');       % Create strings from the matrix values
            textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
            [x, y] = meshgrid(1:length(densityLDir));  % Create x and y coordinates for the strings
            hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                            'HorizontalAlignment', 'center');

            set(p,'Position', [1 1 1680 1050]);
            name = densityDir(1).name(1:end-15);
            saveas(p,['/share4/bayrakrg/tractEM/postprocessing/DICE/human_dice/HCP/' 'dice_' name '.jpg']); 
            close all;
            disp([abbList{l} '_L has been processed!'])
        end

        if length(strfind(densityRDir(2).name,'_R')) == 1
            dr = length(densityRDir);
            densityR = load_density(densityRDir);
            [nameMe, diceR] = dice(densityRDir, densityR, threshold, dr);
            save(['/share4/bayrakrg/tractEM/postprocessing/DICE/human_dice_mat/HCP/' abbList{l} '_R_dice.mat'], 'diceR');
            save(['/share4/bayrakrg/tractEM/postprocessing/DICE/human_dice_mat/HCP/' abbList{l} '_R_nameMe'], 'nameMe');
            % plotting
            q = figure('Visible','off');   
            imagesc(diceR)
            title(['Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Right Across Raters'], 'FontSize', 10); % set title
            colormap; % set the colorscheme
            xticks((1:dr))
            nameMe = strrep(nameMe,'_',' ');
            xticklabels(nameMe);
            yticks((1:dr))
            yticklabels(nameMe);
            xtickangle(45)
            colorbar;
            textStrings = num2str(diceR(:), '%0.2f');       % Create strings from the matrix values
            textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
            [x, y] = meshgrid(1:length(densityRDir));  % Create x and y coordinates for the strings
            hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                            'HorizontalAlignment', 'center');
            set(q,'Position', [1 1 1680 1050]);
            name = densityDir(2).name(1:end-15);
            saveas(q,['/share4/bayrakrg/tractEM/postprocessing/DICE/human_dice/HCP/' 'dice_' name '.jpg']); 
            close all;
            clear density; clear densityL; clear densityR;
            disp([abbList{l} '_R has been processed!'])
        end
    end
end