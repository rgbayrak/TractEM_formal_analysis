%% This script is for similarity analysis between tract densities
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

% Accesing the files from different projects
% exDir = '~/Desktop/NF';
% exDir              = '/home/local/VANDERBILT/bayrakrg/Dropbox*VUMC*/complete_HCP_subjects';
exDir              = '/home/local/VANDERBILT/bayrakrg/Dropbox*VUMC*/complete_BLSA_subjects';
subjectDir = fullfile(exDir, '*');  % directory names are as follows -> subject_rater
subDir = fullfile(subjectDir, '*');  % tract names are defined as published
% densityDir = dir(fullfile(subDir, 'acr_L_density.nii.gz')); % not every folder has separate density files (left & right)
abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};

        
        
%     % % OVERLAP BASED METRICS
%     % Dice Coefficient --------------------------------------------------------------------------------------------------------------------
% 
% density = [];
% initd = 0;
% for l = 1:length(abbList)
%     densityDir = dir(fullfile(subDir, [abbList{l} '_*density.nii.gz'])); % not every folder has separate density files (left & right)
%     for d = 1:length(densityDir)
%         % Load nifti density .gz files 
%         density_nii = load_untouch_nii(fullfile(densityDir(d).folder, densityDir(d).name));
% 
%         if ~initd
%             density = zeros([size(density_nii.img) length(densityDir)]);
%             initd = 1;
%         end
% 
%         density(:,:,:,d) = density_nii.img;
%     %     disp(size(density_nii.img))
% 
%     % sanity check if images are empty
%     %     sanity = unique(density(:,:,:,d));
%     %     if length(sanity) == 1
%     %         
%     %     end
%     %     disp(length(sanity))
%     end
% 
%     % normalize everything into [0,1]
%     density = density ./ max(density(:));
% 
%     % Setting a threshold to avoid outliers
%     threshold = 0.05;
%     density(density < threshold) = 0;
%     density(density >= threshold) = 1;
% 
%     diceMatrix = [];
%     init = 0;
% 
%     nameMe = [];
% 
%     for i = 1:d
%         for j = i:d
%             im1 = density(:,:,:,i);
%             im2 = density(:,:,:,j);
%             is = sum(im1(:).*im2(:));
%             d1 = sum(im1(:));
%             d2 = sum(im2(:));
%             dice = (2*is)/(d1+d2);
% 
%             partsi = strsplit(densityDir(i).folder, '/');
%             dirParti = partsi{end-1};
%     %         partsj = strsplit(densityDir(j).folder, '/');
%     %         dirPartj = partsj{end-1};
%     %         
%     %         disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
%     %         fprintf('\n Dice similarity is %0.4f\n', dice);
%     %         fprintf('\n');
% 
%             if ~init
%                 diceMatrix = zeros([length(densityDir) length(densityDir)]);
%                 init = 1;
%             end
%             diceMatrix(i,j) = dice;
%             diceMatrix(j,i) = dice;
%         end
%            nameMe = [nameMe convertCharsToStrings(dirParti)]; % getting the subject names
%     end
% %     ---------------------------------------------------------------------------------------------------------------------------------------------------
% 
%     figure(1)   
%     imagesc(diceMatrix)
%     title('Dice Similarity Cross-Correlation Matrix for Anterior Corona Radiata Across Raters on | BLSA data', 'FontSize', 10); % set title
%     colormap; % set the colorscheme
%     xticks((1:d))
%     nameMe = strrep(nameMe,"_"," ");
%     xticklabels(nameMe);
%     yticks((1:d))
%     yticklabels(nameMe);
%     xtickangle(45)
%     colorbar;
% 
% 
%     textStrings = num2str(diceMatrix(:), '%0.2f');       % Create strings from the matrix values
%     textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
%     [x, y] = meshgrid(1:length(densityDir));  % Create x and y coordinates for the strings
%     hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
%                     'HorizontalAlignment', 'center');
% 
%     set(figure(1),'Position', [1 1 1680 1050]);
%     saveas(figure(1),['~/Desktop/figures/' 'dice_' abbList{l} '.jpg']);
% end
    
    
    
% Continuous Dice Coefficient --------------------------------------------------------------------------------------------------------------------
% 

cdiceMatrix = [];
initd = 0;
init = 0;
threshold = 0.05;
nameMe = [];

for l = 1:length(abbList)
    densityDir = dir(fullfile(subDir, [abbList{l} '_*density.nii.gz'])); % not every folder has separate density files (left & right)
    if densityDir
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
    
    for i = 1:d
        for j = i:d
            im1 = density(:,:,:,i);
            % continuous dice implementation
            im1(im1 < threshold) = 0; 
            im1(im1 >= threshold) = 1;
    
            im2 = density(:,:,:,j); 
            is = sum(im1(:).*im2(:));
            d1 = sum(im1(:));
            d2 = sum(im2(:));
    
            if (is > 0)
                cont = sum(im1(:).*im2(:))/sum(im1(:).*sign(im2(:)));
            else
                cont = 1;
            end
    
            cdice = (2*is)/(cont*d1+d2);
            % cdice ends here
    
            partsi = strsplit(densityDir(i).folder, '/');
            dirParti = partsi{end-1};
            partsj = strsplit(densityDir(j).folder, '/');
            dirPartj = partsj{end-1};
%             disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
%             fprintf('\n Continuous dice similarity is %0.4f\n', cdice);
%             fprintf('\n');
    
            if ~init
                cdiceMatrix = zeros([length(densityDir) length(densityDir)]);
                init = 1;
            end
            cdiceMatrix(i,j) = cdice;
            cdiceMatrix(j,i) = cdice;
        end
           nameMe = [nameMe convertCharsToStrings(dirParti)]; % getting the subject names
    end
    % --------------------------------------------------------------------------------------------------------------------
    
    figure(2)   
    imagesc(cdiceMatrix)
    title('Continuous Dice Similarity Cross-Correlation Matrix for Superior Cerebellar Peduncle Across Raters', 'FontSize', 10); % set title
    colormap; % set the colorscheme
    xticks((1:d))
    nameMe = strrep(nameMe,"_"," ");
    xticklabels(nameMe);
    yticks((1:d))
    yticklabels(nameMe);
    xtickangle(45)
    colorbar;
    
    textStrings = num2str(cdiceMatrix(:), '%0.2f');       % Create strings from the matrix values
    textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
    [x, y] = meshgrid(1:length(densityDir));  % Create x and y coordinates for the strings
    hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                    'HorizontalAlignment', 'center');
    
    set(figure(2),'Position', [1 1 1680 1050]);
%     name = densityDir(d).name(1:end-14);
    saveas(figure(2),['~/Desktop/figures/' 'cdice_' name '.jpg']); close all;
end

