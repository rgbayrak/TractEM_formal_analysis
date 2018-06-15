%% This scrip is for similarity analysis between tract densities
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

% Accesing the files from different projects
% exDir = '~/Desktop/NF';
% exDir              = '/home/local/VANDERBILT/bayrakrg/Dropbox*VUMC*/complete_HCP_subjects';
exDir              = '/home/local/VANDERBILT/bayrakrg/Dropbox*VUMC*/complete_BLSA_subjects';
subjects_id = {1127; 1134; 1632; 1834; 1881; 5708; 5750; 7678; 7748; 7759};
raters = {'Christa'; 'Aviral'; 'Bruce'; 'Yi'; 'Yufei'; 'Eugene'; 'Xuan'; 'Jasmine'};
abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
        
subjectDir = fullfile(exDir, '*');  % directory names are as follows -> subject_rater
subDir = fullfile(subjectDir, '*');  % tract names are defined as published
densityDir = dir(fullfile(subDir, '*scp_R_density.nii.gz')); % not every folder has separate density files (left & right)

% trkDir = fullfile(subDir, '*ac_tract.trk.gz');  % not every folder has separate trk files
% % trkDirUnzipped = dir(fullfile(subDir, '*ac_tract.trk.gz'));

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
%     disp(size(density_nii.img))

% sanity check if images are empty
%     sanity = unique(density(:,:,:,d));
%     if length(sanity) == 1
%         
%     end
%     disp(length(sanity))
end

% % OVERLAP BASED METRICS
% Dice Coefficient --------------------------------------------------------------------------------------------------------------------

% normalize everything into [0,1]
density = density ./ max(density(:));

% Setting a threshold to avoid outliers
threshold = 0.05;
density(density < threshold) = 0;
density(density >= threshold) = 1;

diceMatrix = [];
init = 0;

for i = 1:d
    for j = i:d
        im1 = density(:,:,:,i);
        im2 = density(:,:,:,j);
%             intersection = (im1 & im2);
%             is = sum(intersection(:));
        is = sum(im1(:).*im2(:));
        d1 = sum(im1(:));
        d2 = sum(im2(:));
        dice = (2*is)/(d1+d2);

        partsi = strsplit(densityDir(i).folder, '/');
        dirParti = partsi{end-1};
        partsj = strsplit(densityDir(j).folder, '/');
        dirPartj = partsj{end-1};
        disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
        fprintf('\n Dice similarity is %0.4f\n', dice);
        fprintf('\n');
        
        if ~init
            diceMatrix = zeros([length(densityDir) length(densityDir)]);
            init = 1;
        end
        diceMatrix(i,j) = dice;
    end
end
%---------------------------------------------------------------------------------------------------------------------------------------------------



% % Continuous Dice Coefficient --------------------------------------------------------------------------------------------------------------------

% % normalize everything into [0,1]
% density = density ./ max(density(:));
% 
% cdiceMatrix = [];
% init = 0;
% threshold = 0.05;
% 
% for i = 1:d
%     for j = i:d
%         im1 = density(:,:,:,i);
%         im1(im1 < threshold) = 0;
%         im1(im1 >= threshold) = 1;
% 
%         im2 = density(:,:,:,j);
% %             intersection = (im1 & im2);
% %             is = sum(intersection(:));
%         is = sum(im1(:).*im2(:));
%         d1 = sum(im1(:));
%         d2 = sum(im2(:));
% 
%         if (is > 0)
%             cont = sum(im1(:).*im2(:))/sum(im1(:).*sign(im2(:)));
%         else
%             cont = 1;
%         end
% 
%         cdice = (2*is)/(cont*d1+d2);
% 
%         partsi = strsplit(densityDir(i).folder, '/');
%         dirParti = partsi{end-1};
%         partsj = strsplit(densityDir(j).folder, '/');
%         dirPartj = partsj{end-1};
%         disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
%         fprintf('\n Continuous dice similarity is %0.4f\n', cdice);
%         fprintf('\n');
% 
%         if ~init
%             cdiceMatrix = zeros([length(densityDir) length(densityDir)]);
%             init = 1;
%         end
%         cdiceMatrix(i,j) = cdice;
%     end
% end
% --------------------------------------------------------------------------------------------------------------------

    
imagesc(diceMatrix)
title('Dice Similarity Cross-Correlation Matrix for Superior Cerebellar Peduncle Across Raters', 'FontSize', 10); % set title
colormap; % set the colorscheme
xticks((1:15))
xticklabels({'1134 Bruce' '1632 Christa' '1632 Yufei' '1834 Christa' '1834 Eugene' '1881 Christa' '1881 Xuan'...
    '5708 Jasmine' '5750 Eugene' '5750 Jasmine' '7678 Aviral' '7678 Yi' '7748 Eugene' '7759 Aviral' '7759 Bruce' });
yticks((1:15))
yticklabels({'1134 Bruce' '1632 Christa' '1632 Yufei' '1834 Christa' '1834 Eugene' '1881 Christa' '1881 Xuan'...
    '5708 Jasmine' '5750 Eugene' '5750 Jasmine' '7678 Aviral' '7678 Yi' '7748 Eugene' '7759 Aviral' '7759 Bruce' });
xtickangle(45)
colorbar;

textStrings = num2str(diceMatrix(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
[x, y] = meshgrid(1:length(densityDir));  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                'HorizontalAlignment', 'center');