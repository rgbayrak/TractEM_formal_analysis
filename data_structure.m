% This script compares subject ids and tract names
% Not used for any particular reason so far
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

% BLSA
exDir              = '/home-local/bayrakrg/Dropbox*VUMC*/complete_BLSA_subjects/';
subjDir = fullfile(exDir, '*/');  % directory names are as follows -> subject_rater
subjectDir = dir(fullfile([exDir, '*']));


% removing should-not-be-there files
filenames = cellstr(char(subjectDir.name));
dropfiles = false(length(subjectDir),1);
dropfiles(ismember(filenames,{'.','..','.DS_Store','README.rtf', 'README.txt', 'QA', 'tracking_parameters.ini', 'density', '.dropbox', '.dropbox.attr', 'postproc', 'filelist.txt'})) = true;
subjectDir = subjectDir(~dropfiles);

% abbreviations and tract names in lists
abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
tractList = {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum';'cerebral_peduncle'; ...
            'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';'frontal_lobe';'genu_corpus_callosum';...
            'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';'inferior_longitundinal_fasciculus';'medial_lemniscus';'midbrain';...
            'middle_cerebellar_peduncle';'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
            'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';'superior_cerebellar_peduncle';...
            'superior_corona_radiata';'superior_fronto_occipital_fasciculus';'superior_longitundinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};

% Comparing the subject ids
for i = 1:length(subjectDir)
    if subjectDir(i).isdir 
        parts = strsplit(subjectDir(i).name, '_');
        % save the subject ids as sr(subject_rater) struct part{1} is the
        % id, part{2} is the rater
        sr(i).id = parts{1};
        sr(i).rater = parts{2};
        subDir = dir(fullfile([exDir, subjectDir(i).name, '/*']));
        filenames = cellstr(char(subDir.name));
        tracts = false(length(subDir),1);
        
        % only the proper folder names as in the protocol will be passed to subDir
        tracts(ismember(filenames,{'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum';'cerebral_peduncle'; ...
            'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';'frontal_lobe';'genu_corpus_callosum';...
            'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';'inferior_longitundinal_fasciculus';'medial_lemniscus';'midbrain';...
            'middle_cerebellar_peduncle';'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
            'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';'superior_cerebellar_peduncle';...
            'superior_corona_radiata';'superior_fronto_occipital_fasciculus';'superior_longitundinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'})) = true;
        subDir = subDir(tracts);
        sr(i).tract = {subDir.name}; % saves the tract directories under sr struct as tract
    end
end




diceMatrix = [];
nameMe = [];
init = 0;

% if the id number is the same, do *something
uni_id = unique({sr.id});
for d = 1:length(uni_id)
    % masking if same id numbers
    mask_id = strcmp({sr.id},uni_id{d});
    srm = sr(mask_id);
    for m = 1:length(srm)
        for s = m:length(srm)
%             if s ~= m
                % masking if same tracts
                mask_tract = intersect(srm(m).tract,srm(s).tract);
                if isempty(mask_tract)
                    dice = 0;
                    disp([dice, ' comparing ', char(srm(m).tract(1)), ' to ' char(srm(s).tract(1))])
                end
                if ~isempty(mask_tract)
                    for di = 1:length(mask_tract)
                        num = strcmp(mask_tract(di), tractList);
                        abb = char(abbList(num));
                        
                        % load nifti files (only, comparing 2 at a time)
                        dir1 = dir(fullfile(exDir, [char(srm(m).id) '_' char(srm(m).rater) '/' char(srm(m).tract(di)) '/' abb '_*density.nii.gz']));
                        density1_nii = load_untouch_nii(fullfile(dir1.folder, dir1.name));
                        density1 = zeros(size(density1_nii.img));
                        density1(:,:,:) = density1_nii.img;
                        
                        dir2 = dir(fullfile(exDir, [char(srm(s).id) '_' char(srm(s).rater) '/' char(srm(s).tract(di)) '/' abb '_*density.nii.gz']));
                        density2_nii = load_untouch_nii(fullfile(dir2.folder, dir2.name));
                        density2 = zeros(size(density2_nii.img));
                        density2(:,:,:) = density2_nii.img;
                        
                        % comparing if there the same tract file exist
                        % normalization
                        density1= density1./ max(density1(:));
                        % Setting threshold to avoid outliers
                        density1(density1 < threshold) = 0;
                        density1(density1 >= threshold) = 1;  
                        
                        density2 = density2./ max(density2(:));
                        % Setting threshold to avoid outliers
                        density2(density2 < threshold) = 0;
                        density2(density2 >= threshold) = 1;  
                        
                        im1 = density1(:,:,:);
                        im2 = density2(:,:,:); 
                        is = sum(im1(:).*im2(:));
                        d1 = sum(im1(:));
                        d2 = sum(im2(:));
                        dice = (2*is)/(d1+d2);
                        diceMatrix(s,m) = dice;
                    end
                end
%             end
        end
    end
end
