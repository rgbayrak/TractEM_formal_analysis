%% This script is for Hausdorff similarity analysis between regions
% Author: roza.g.bayrak@vanderbilt.edu

% Comparison for one tract takes about a minute. For 61 tracts, the script
% runs the similarity analysis in a little over an hour. 

close all;
clear all;
clc;

addpath(genpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg'));
% addpath('/share4/wangx41/regions');

% % Data directories
exDir              = '/share4/wangx41/regions/HCP';
subjectDir = fullfile(exDir, '*');  % directory names are as follows -> subject_rater


abbList = {'unc'}; %'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
         %   'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
        
tract = {'uncinate_fasciculus'};
subDir = fullfile(subjectDir, '*');  % tract names are defined as published

trackList = {'Anterior Commissure'; 'Anterior Corona Radiata'; 'Anterior Limb Internal Capsule';'Body Corpus Callosum';'Cerebral Peduncle';'Cingulum Cingulate Gyrus'; ...
            'Cingulum Hippocampal';'Corticospinal Tract';'Fornix';'Fornix Stria Terminalis';'Frontal Lobe';'Genu Corpus Callosum';'Inferior Cerebellar Peduncle'; ...
            'Inferior Fronto Occipital Fasciculus';'Inferior Longitudinal Fasciculus';'Medial Lemniscus';'Midbrain';'Middle Cerebellar Peduncle';'Occipital Lobe'; ...
            'Olfactory Radiation';'Optic Tract';'Parietal Lobe';'Pontine Crossing Tract';'Posterior Corona Radiata';'Posterior Limb Internal Capsule'; ...
            'Posterior Thalamic Radiation';'Sagittal Stratum';'Splenium Corpus Callosum';'Superior Cerebellar Peduncle';'Superior Corona Radiata'; ...
            'Superior Fronto Occipital Fasciculus';'Superior Longitudinal Fasciculus';'Tapetum Corpus Callosum';'Temporal Lobe';'Uncinate Fasciculus'};


for l = 1:length(abbList)
    % get track folders and do analysis on them
    labelDir = dir(fullfile(subDir, [abbList{l} '_*ROI1.nii.gz'])); % not every folder has separate label files (left & right)
    
    if length(strfind(labelDir(1).name,'_')) == 1
        d = length(labelDir);
        label = load_only_nii_img(labelDir);
        [nameMe, mhdMatrix] = mhd(labelDir, label, d);
        save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/human_mhd_mat/HCP/' abbList{l} '_ROI1_mhd.mat'], 'mhdMatrix');           
        save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/human_mhd_mat/HCP/' abbList{l} '_ROI1_nameMe'], 'nameMe');
        % plotting
        r = figure('Visible','off');   
        imagesc(mhdMatrix)
        title(['Hausdorff Similarity Cross-Correlation Matrix for ' trackList{l} ' Across Raters'], 'FontSize', 10); % set title
        colormap; % set the colorscheme
        xticks((1:d))
        nameMe = strrep(nameMe,'_',' ');
        xticklabels(nameMe);
        yticks((1:d))
        yticklabels(nameMe);
        xtickangle(45)
        colorbar;
        textStrings = num2str(mhdMatrix(:), '%0.2f');       % Create strings from the matrix values
        textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
        [x, y] = meshgrid(1:length(labelDir));  % Create x and y coordinates for the strings
        hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                        'HorizontalAlignment', 'center');
        set(r,'Position', [1 1 1680 1050]);
        name = labelDir(1).name(1:end-15);
        saveas(r,['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/human_mhd/HCP/' 'mhd_' name '.jpg']); 
        close all;
        disp([abbList{l} ' has been processed!'])

    elseif length(strfind(labelDir(1).name,'_')) == 2
        labelLDir = dir(fullfile(subDir, [abbList{l} '_L_ROI1.nii.gz']));
        labelRDir = dir(fullfile(subDir, [abbList{l} '_R_ROI1.nii.gz']));
        if length(strfind(labelLDir(1).name,'_L')) == 1
            labelLDir = dir(fullfile(subDir, [abbList{l} '_L_ROI1.nii.gz'])); % not every folder has separate label files (left & right)
            dl = length(labelLDir);
            labelL = load_only_nii_img(labelLDir);
            [nameMe, mhdL] = mhd(labelLDir, labelL, dl);
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/human_mhd_mat/HCP/' abbList{l} '_L_ROI1_mhd.mat'], 'mhdL');           
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/human_mhd_mat/HCP/' abbList{l} '_L_ROI1_nameMe'], 'nameMe');
            % plotting
            p = figure('Visible','on');   
            imagesc(mhdL)
            title(['Hausdorff Similarity Cross-Correlation Matrix for ' trackList{l} ' Left Across Raters'], 'FontSize', 10); % set title
            colormap; % set the colorscheme
            xticks((1:dl))
            nameMe = strrep(nameMe,'_',' ');
            xticklabels(nameMe);
            yticks((1:dl))
            yticklabels(nameMe);
            xtickangle(45)
            colorbar;
            textStrings = num2str(mhdL(:), '%0.2f');       % Create strings from the matrix values
            textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
            [x, y] = meshgrid(1:length(labelLDir));  % Create x and y coordinates for the strings
            hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                            'HorizontalAlignment', 'center');

            set(p,'Position', [1 1 1680 1050]);
            name = labelDir(1).name(1:end-15);
            saveas(p,['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/human_mhd/HCP/' 'mhd_' name '.jpg']); 
            close all;
            disp([abbList{l} '_L has been processed!'])
        end

        if length(strfind(labelRDir(1).name,'_R')) == 1
            labelRDir = dir(fullfile(subDir, [abbList{l} '_R_ROI1.nii.gz'])); % not every folder has separate label files (left & right)
            dr = length(labelRDir);
            labelR = load_only_nii_img(labelRDir);
            [nameMe, mhdR] = mhd(labelRDir, labelR, dr);
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/human_mhd_mat/HCP/' abbList{l} '_R_ROI1_mhd.mat'], 'mhdR');
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/human_mhd_mat/HCP/' abbList{l} '_R_ROI1_nameMe'], 'nameMe');
            % plotting
            q = figure('Visible','off');   
            imagesc(mhdR)
            title(['Hausdorff Similarity Cross-Correlation Matrix for ' trackList{l} ' Right Across Raters'], 'FontSize', 10); % set title
            colormap; % set the colorscheme
            xticks((1:dr))
            nameMe = strrep(nameMe,'_',' ');
            xticklabels(nameMe);
            yticks((1:dr))
            yticklabels(nameMe);
            xtickangle(45)
            colorbar;
            textStrings = num2str(mhdR(:), '%0.2f');       % Create strings from the matrix values
            textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
            [x, y] = meshgrid(1:length(labelRDir));  % Create x and y coordinates for the strings
            hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                            'HorizontalAlignment', 'center');
            set(q,'Position', [1 1 1680 1050]);
            name = labelDir(2).name(1:end-15);
            saveas(q,['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/human_mhd/HCP/' 'mhd_' name '.jpg']); 
            close all;
            clear label; clear labelL; clear labelR;
            disp([abbList{l} '_R has been processed!'])
        end
    end
end