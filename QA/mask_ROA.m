clc;
clear all;
close all;

%%% Averaging ROIs
% Author: roza.g.bayrak@vanderbilt.edu
% BLSA
exDir              = '/home-local/bayrakrg/Dropbox*VUMC*/complete_BLSA*';
subjectDir = fullfile(exDir, '*'); 
subDir = dir(fullfile(subjectDir, '*'));

abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
% abb_pos = 1;

% Choose only the raters that you would like to use their masks
foldernames = cellstr(char(subDir.folder));
raters = false(length(subDir),1);
for i = 1:length(foldernames)
    foldernames = strsplit(subDir(i).folder, '_'); % the rater name is the last word at the end of the folder name
    raternames{i} = foldernames{end}; 
    raters(ismember(raternames,{'Jasmine', 'Bruce'})) = true; % INPUT: which rater's ROI will be used for fixed ROIs, defined here
    raters(ismember(raternames,{'subjects/postproc'})) = false;
end
subDir = subDir(raters);

filenames = cellstr(char(subDir.name));
tracts = false(length(subDir),1);
% only the proper folder names as in the protocol will be passed to subDir
tracts(ismember(filenames,{'anterior_corona_radiata'})) = true;
% {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum';'cerebral_peduncle'; ...
% 'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';'frontal_lobe';'genu_corpus_callosum';...
% 'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';'inferior_longitundinal_fasciculus';'medial_lemniscus';'midbrain';...
% 'middle_cerebellar_peduncle';'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
% 'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';'superior_cerebellar_peduncle';...
% 'superior_corona_radiata';'superior_fronto_occipital_fasciculus';'superior_longitundinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'}

%%%%% INPUT: for which tract, ROI will be used for fixed ROIs, defined here
subDir = subDir(tracts);

% for i = 1:length(subDir)
%     init = 0;
%     initl = 0;
%     initr = 0;
%     fixed_region(i) = dir(fullfile(subDir(i).folder, subDir(i).name, '*ROA*.nii.gz')); 
% end

init = 0;
initl = 0;
initr = 0;
fixed_seed_region = dir(fullfile(subDir(1).folder, subDir(1).name, '*seed*.nii.gz')); 
fixed_ROA_region = dir(fullfile(subDir(1).folder, subDir(1).name, '*ROA*.nii.gz')); 
fixed_ROI_region = dir(fullfile(subDir(1).folder, subDir(1).name, '*ROI*.nii.gz')); 

% if there is only one region of interest meaning no left or right

% ROA
if length(strfind(fixed_ROA_region(1).name,'_')) == 1
    merged_ROA_region = [];
    
    for i = 1:length(subDir)
        if length(fixed_ROA_region) > 1
            % merge loop---------------------------------------------------------------------------
            for c = 1:length(fixed_ROA_region)
                prev_mask = load_nii(fullfile(fixed_ROA_region(c).folder, fixed_ROA_region(c).name));
                prev_mask_img = prev_mask.img; % get the image part of nii
                if ~init 
                    mask = zeros(size(prev_mask_img));
        %                             temp = prev_mask;
                    init = 1;
                end   
                mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
            end
            if length(fixed_ROA_region) >= 1 % excluding the folders with no ROA regions
                prev_mask.img = mask;
                save_nii(prev_mask, fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], 'merged_ROA0.nii.gz')); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
            end
            %--------------------------------------------------------------------------------------
            fixed_ROA_region(i) = dir(fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], 'merged_ROA0.nii.gz')); 
        else
            fixed_ROA_region(i) = dir(fullfile(subDir(i).folder, subDir(i).name, '*ROA*.nii.gz')); 
        end
    end

    if length(strfind(fixed_ROA_region(1).name,'_')) == 1
        % merge loop---------------------------------------------------------------------------
        for c = 1:length(fixed_ROA_region)
            prev_mask = load_nii(fullfile(fixed_ROA_region(c).folder, fixed_ROA_region(c).name));
            prev_mask_img = prev_mask.img; % get the image part of nii
            if ~init 
                mask = zeros(size(prev_mask_img));
    %                             temp = prev_mask;
                init = 1;
            end   
            mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
        end
        if length(fixed_ROA_region) >= 1 % excluding the folders with no ROA regions
            prev_mask.img = mask;
            save_nii(prev_mask, fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], [subDir(i).name '_ROA0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
            disp(['For: ' fullfile(subDir(i).name), ', one mask ready!'])
        end
        %--------------------------------------------------------------------------------------
    end
end
    
% seed
if length(strfind(fixed_seed_region(1).name,'_')) == 1
    for i = 1:length(subDir)
        fixed_seed_region(i) = dir(fullfile(subDir(i).folder, subDir(i).name, '*seed*.nii.gz')); 
    end

    if length(strfind(fixed_seed_region(1).name,'_')) == 1
        % merge loop---------------------------------------------------------------------------
        for c = 1:length(fixed_seed_region)
            prev_mask = load_nii(fullfile(fixed_seed_region(c).folder, fixed_seed_region(c).name));
            prev_mask_img = prev_mask.img; % get the image part of nii
            if ~init 
                mask = zeros(size(prev_mask_img));
    %                             temp = prev_mask;
                init = 1;
            end   
            mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
        end
        if length(fixed_seed_region) >= 1 % excluding the folders with no ROA regions
            prev_mask.img = mask;
            save_nii(prev_mask, fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], [subDir(i).name '_seed0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
            disp(['For: ' fullfile(subDir(i).name), ', one mask ready!'])
        end
        %--------------------------------------------------------------------------------------
    end
end



if length(strfind(fixed_ROA_region(1).name,'_')) == 2
    % left ROA
    if length(strfind(fixed_ROA_region(1).name,'_L_')) == 1
        for i = 1:length(subDir)
            fixed_L_region(i) = dir(fullfile(subDir(i).folder, subDir(i).name, '*_L_ROA*.nii.gz')); 
        end
        % merge loop---------------------------------------------------------------------------
        for c = 1:length(fixed_L_region)
            prev_mask = load_nii(fullfile(fixed_L_region(c).folder, fixed_L_region(c).name));
            prev_mask_img = prev_mask.img;
            if ~initl 
                mask = zeros(size(prev_mask_img));
%                             temp = prev_mask;
                initl = 1;
            end   
            mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
        end
        if length(fixed_L_region) >= 0 
            prev_mask.img = mask;
            save_nii(prev_mask, fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], [subDir(i).name '_L_ROA0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
            disp(['For: ' fullfile(subDir(i).name), ', left mask ready!'])
        end
        %--------------------------------------------------------------------------------------
    end
    
    % right ROA
    if length(strfind(fixed_ROA_region(2).name,'_R_')) == 1
        for i = 1:length(subDir)
            fixed_R_region(i) = dir(fullfile(subDir(i).folder, subDir(i).name, '*_R_ROA*.nii.gz')); 
        end
        % merge loop---------------------------------------------------------------------------
        for c = 1:length(fixed_R_region)
            prev_mask = load_nii(fullfile(fixed_R_region(c).folder, fixed_R_region(c).name));
            prev_mask_img = prev_mask.img;
            if ~initr 
                mask = zeros(size(prev_mask_img));
%                             temp = prev_mask;
                initr = 1;
            end   
            mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
        end
        if length(fixed_R_region) >= 0 
            prev_mask.img = mask;
            save_nii(prev_mask, fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], [subDir(i).name '_R_ROA0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
            disp(['For: ' fullfile(subDir(i).name), ', right mask ready!'])
        end
        %--------------------------------------------------------------------------------------
    end
end

if length(strfind(fixed_seed_region(1).name,'_')) == 2

    if length(strfind(fixed_seed_region(1).name,'_L_')) == 1
        for i = 1:length(subDir)
            fixed_L_region(i) = dir(fullfile(subDir(i).folder, subDir(i).name, '*_L_seed*.nii.gz')); 
        end
        % merge loop---------------------------------------------------------------------------
        for c = 1:length(fixed_L_region)
            prev_mask = load_nii(fullfile(fixed_L_region(c).folder, fixed_L_region(c).name));
            prev_mask_img = prev_mask.img;
            if ~initl 
                mask = zeros(size(prev_mask_img));
%                             temp = prev_mask;
                initl = 1;
            end   
            mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
        end
        if length(fixed_L_region) >= 0 
            prev_mask.img = mask;
            save_nii(prev_mask, fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], [subDir(i).name '_L_seed0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
            disp(['For: ' fullfile(subDir(i).name), ', left mask ready!'])
        end
        %--------------------------------------------------------------------------------------
    end

    % right seed
    if length(strfind(fixed_seed_region(2).name,'_R_')) == 1
        for i = 1:length(subDir)
            fixed_R_region(i) = dir(fullfile(subDir(i).folder, subDir(i).name, '*_R_seed*.nii.gz')); 
        end
        % merge loop---------------------------------------------------------------------------
        for c = 1:length(fixed_R_region)
            prev_mask = load_nii(fullfile(fixed_R_region(c).folder, fixed_R_region(c).name));
            prev_mask_img = prev_mask.img;
            if ~initr 
                mask = zeros(size(prev_mask_img));
%                             temp = prev_mask;
                initr = 1;
            end   
            mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
        end
        if length(fixed_R_region) >= 0 
            prev_mask.img = mask;
            save_nii(prev_mask, fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], [subDir(i).name '_R_seed0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
            disp(['For: ' fullfile(subDir(i).name), ', right mask ready!'])
        end
        %--------------------------------------------------------------------------------------
    end
end
    
%     % right ROI
%     if length(strfind(fixed_ROI_region(2).name,'_R_')) == 1
%         for i = 1:length(subDir)
%             fixed_R_region(i) = dir(fullfile(subDir(i).folder, subDir(i).name, '*_R_ROI*.nii.gz')); 
%         end
%         % merge loop---------------------------------------------------------------------------
%         for c = 1:length(fixed_R_region)
%             prev_mask = load_nii(fullfile(fixed_R_region(c).folder, fixed_R_region(c).name));
%             prev_mask_img = prev_mask.img;
%             if ~initr 
%                 mask = zeros(size(prev_mask_img));
% %                             temp = prev_mask;
%                 initr = 1;
%             end   
%             mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
%         end
%         if length(fixed_R_region) >= 0 
%             prev_mask.img = mask;
%             save_nii(prev_mask, fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], [subDir(i).name '_R_ROI0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
%             disp(['For: ' fullfile(subDir(i).name), ', right mask ready!'])
%         end
%         %--------------------------------------------------------------------------------------
%     end
%     
%     % right end
%     if length(strfind(fixed_end_region(2).name,'_R_')) == 1
%         for i = 1:length(subDir)
%             fixed_R_region(i) = dir(fullfile(subDir(i).folder, subDir(i).name, '*_R_end*.nii.gz')); 
%         end
%         % merge loop---------------------------------------------------------------------------
%         for c = 1:length(fixed_R_region)
%             prev_mask = load_nii(fullfile(fixed_R_region(c).folder, fixed_R_region(c).name));
%             prev_mask_img = prev_mask.img;
%             if ~initr 
%                 mask = zeros(size(prev_mask_img));
% %                             temp = prev_mask;
%                 initr = 1;
%             end   
%             mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
%         end
%         if length(fixed_R_region) >= 0 
%             prev_mask.img = mask;
%             save_nii(prev_mask, fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], [subDir(i).name '_R_end0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
%             disp(['For: ' fullfile(subDir(i).name), ', right mask ready!'])
%         end
%         %--------------------------------------------------------------------------------------
%     end
%     
%     % right term
%     if length(strfind(fixed_term_region(2).name,'_R_')) == 1
%         for i = 1:length(subDir)
%             fixed_R_region(i) = dir(fullfile(subDir(i).folder, subDir(i).name, '*_R_term*.nii.gz')); 
%         end
%         % merge loop---------------------------------------------------------------------------
%         for c = 1:length(fixed_R_region)
%             prev_mask = load_nii(fullfile(fixed_R_region(c).folder, fixed_R_region(c).name));
%             prev_mask_img = prev_mask.img;
%             if ~initr 
%                 mask = zeros(size(prev_mask_img));
% %                             temp = prev_mask;
%                 initr = 1;
%             end   
%             mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
%         end
%         if length(fixed_R_region) >= 0 
%             prev_mask.img = mask;
%             save_nii(prev_mask, fullfile(['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/fixed_masks/' subDir(i).name], [subDir(i).name '_R_term0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
%             disp(['For: ' fullfile(subDir(i).name), ', right mask ready!'])
%         end
%         %--------------------------------------------------------------------------------------
%     end
    
%     abb_pos = abb_pos +1;
% end