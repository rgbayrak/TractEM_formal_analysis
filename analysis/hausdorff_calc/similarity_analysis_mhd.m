%% This script is for Hausdorff similarity analysis between tracts
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

addpath(genpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg'));
% addpath('/share4/wangx41/regions');
% % Data directories
exDir              = '/share4/bayrakrg/tractEM/postprocessing/M-tracts/BLSA/';
subjectDir = fullfile(exDir, '*');  % directory names are as follows -> subject_rater


abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ... %  
           'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
        
% tract = {'uncinate_fasciculus'};
subDir = fullfile(subjectDir, '*');  % tract names are defined as published

trackList = {'Anterior Commissure'; 'Anterior Corona Radiata'; 'Anterior Limb Internal Capsule';'Body Corpus Callosum';'Cerebral Peduncle';'Cingulum Cingulate Gyrus'; ...
            'Cingulum Hippocampal';'Corticospinal Tract';'Fornix';'Fornix Stria Terminalis';'Frontal Lobe';'Genu Corpus Callosum';'Inferior Cerebellar Peduncle'; ...
            'Inferior Fronto Occipital Fasciculus';'Inferior Longitudinal Fasciculus';'Medial Lemniscus';'Midbrain';'Middle Cerebellar Peduncle';'Occipital Lobe'; ...
            'Olfactory Radiation';'Optic Tract';'Parietal Lobe';'Pontine Crossing Tract';'Posterior Corona Radiata';'Posterior Limb Internal Capsule'; ...
            'Posterior Thalamic Radiation';'Sagittal Stratum';'Splenium Corpus Callosum';'Superior Cerebellar Peduncle';'Superior Corona Radiata'; ...
            'Superior Fronto Occipital Fasciculus';'Superior Longitudinal Fasciculus';'Tapetum Corpus Callosum';'Temporal Lobe';'Uncinate Fasciculus'};

threshold = 0.05;

for l = 1:length(abbList)
    % get track folders and do analysis on them
    tractDir = dir(fullfile(subDir, [abbList{l} '_*density.nii.gz'])); % not every folder has separate tract files (left & right)
    
    if length(strfind(tractDir(1).name,'_')) == 1
        d = length(tractDir);
        tract = load_only_nii_img(tractDir);
        [nameMe, hd, hdmean, modHausdd, hd90] = mhd_th(tractDir, tract, threshold, d);
        save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_hd.mat'], 'hd');
        save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_hdmean.mat'], 'hdmean');
        save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_modHausdd.mat'], 'modHausdd');
        save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_hd90.mat'], 'hd90');
        save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_nameMe'], 'nameMe');
%         % plotting
%         r = figure('Visible','off');   
%         imagesc(mhdMatrix)
%         title(['Hausdorff Similarity Cross-Correlation Matrix for ' trackList{l} ' Across Raters'], 'FontSize', 10); % set title
%         colormap; % set the colorscheme
%         xticks((1:d))
%         nameMe = strrep(nameMe,'_',' ');
%         xticktracts(nameMe);
%         yticks((1:d))
%         yticktracts(nameMe);
%         xtickangle(45)
%         colorbar;
%         textStrings = num2str(mhdMatrix(:), '%0.2f');       % Create strings from the matrix values
%         textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
%         [x, y] = meshgrid(1:length(tractDir));  % Create x and y coordinates for the strings
%         hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
%                         'HorizontalAlignment', 'center');
%         set(r,'Position', [1 1 1680 1050]);
%         name = tractDir(1).name(1:end-15);
%         saveas(r,['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd/BLSA/' 'mhd_' name '.jpg']); 
%         close all;
        disp([abbList{l} ' has been processed!'])

    elseif length(strfind(tractDir(1).name,'_')) == 2
        tractLDir = dir(fullfile(subDir, [abbList{l} '_L_density.nii.gz']));
        tractRDir = dir(fullfile(subDir, [abbList{l} '_R_density.nii.gz']));
        if length(strfind(tractLDir(1).name,'_L_')) == 1
            tractLDir = dir(fullfile(subDir, [abbList{l} '_L_density.nii.gz'])); % not every folder has separate tract files (left & right)
            dl = length(tractLDir);
            tractL = load_only_nii_img(tractLDir);
            [nameMe, hdL, hdmeanL, modHausddL, hd90L] = mhd_th(tractLDir, tractL, threshold, dl);
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_L_hdL.mat'], 'hdL');
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_L_hdmeanL.mat'], 'hdmeanL');
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_L_modHausddL.mat'], 'modHausddL');
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_L_hd90L.mat'], 'hd90L');
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_L_nameMe'], 'nameMe');
%             % plotting
%             p = figure('Visible','on');   
%             imagesc(mhdL)
%             title(['Hausdorff Similarity Cross-Correlation Matrix for ' trackList{l} ' Left Across Raters'], 'FontSize', 10); % set title
%             colormap; % set the colorscheme
%             xticks((1:dl))
%             nameMe = strrep(nameMe,'_',' ');
%             xticktracts(nameMe);
%             yticks((1:dl))
%             yticktracts(nameMe);
%             xtickangle(45)
%             colorbar;
%             textStrings = num2str(mhdL(:), '%0.2f');       % Create strings from the matrix values
%             textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
%             [x, y] = meshgrid(1:length(tractLDir));  % Create x and y coordinates for the strings
%             hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
%                             'HorizontalAlignment', 'center');
% 
%             set(p,'Position', [1 1 1680 1050]);
%             name = tractDir(1).name(1:end-15);
%             saveas(p,['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd/BLSA/' 'mhd_' name '.jpg']); 
%             close all;
            disp([abbList{l} '_L has been processed!'])
        end

        if length(strfind(tractRDir(1).name,'_R_')) == 1
            tractRDir = dir(fullfile(subDir, [abbList{l} '_R_density.nii.gz'])); % not every folder has separate tract files (left & right)
            dr = length(tractRDir);
            tractR = load_only_nii_img(tractRDir);
            [nameMe, hdR, hdmeanR, modHausddR, hd90R] = mhd_th(tractRDir, tractR, threshold, dr);
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_R_hdR.mat'], 'hdR');
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_R_hdmeanR.mat'], 'hdmeanR');
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_R_modHausddR.mat'], 'modHausddR');
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_R_hd90R.mat'], 'hd90R');
            save(['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd_mat/BLSA/' abbList{l} '_R_nameMe'], 'nameMe');
%             % plotting
%             q = figure('Visible','off');   
%             imagesc(mhdR)
%             title(['Hausdorff Similarity Cross-Correlation Matrix for ' trackList{l} ' Right Across Raters'], 'FontSize', 10); % set title
%             colormap; % set the colorscheme
%             xticks((1:dr))
%             nameMe = strrep(nameMe,'_',' ');
%             xticktracts(nameMe);
%             yticks((1:dr))
%             yticktracts(nameMe);
%             xtickangle(45)
%             colorbar;
%             textStrings = num2str(mhdR(:), '%0.2f');       % Create strings from the matrix values
%             textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
%             [x, y] = meshgrid(1:length(tractRDir));  % Create x and y coordinates for the strings
%             hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
%                             'HorizontalAlignment', 'center');
%             set(q,'Position', [1 1 1680 1050]);
%             name = tractDir(2).name(1:end-15);
%             saveas(q,['/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/mhd/human_mhd/BLSA/' 'mhd_' name '.jpg']); 
%             close all;
%             clear tract; clear tractL; clear tractR;
            disp([abbList{l} '_R has been processed!'])
        end
    end
end