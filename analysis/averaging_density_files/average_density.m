clc
clear all;
close all;

% Adjust these variables with each subject
subjectID_rater = '*';
tract = 'anterior_commissure';

tractList_correct = {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum';'cerebral_peduncle'; ...
'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';'frontal_lobe';'genu_corpus_callosum';...
'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';'inferior_longitudinal_fasciculus';'medial_lemniscus';'midbrain';...
'middle_cerebellar_peduncle';'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';'superior_cerebellar_peduncle';...
'superior_corona_radiata';'superior_fronto_occipital_fasciculus';'superior_longitudinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};

tractList_stupid = {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum';'cerebral_peduncle'; ...
'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';'frontal_lobe';'genu_corpus_callosum';...
'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';'inferior_longitundinal_fasciculus';'medial_lemniscus';'midbrain';...
'middle_cerebellar_peduncle';'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';'superior_cerebellar_peduncle';...
'superior_corona_radiata';'superior_fronto_occipital_fasciculus';'superior_longitundinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};

path = '/home-local/bayrakrg/';
folders = {'complete_BLSA_subjects', 'complete_HCP_subjects', '19_new_BLSA'};
% folders = {'auto_BLSA', 'auto_HCP'};
    
for t = 1:length(tractList_correct)
    % The location of the subject data
    for f = 1:length(folders)
        
        if f == 3
            tractList = tractList_stupid;
        else
            tractList = tractList_correct;
        end
        
        D = [path filesep folders{f} filesep subjectID_rater filesep tractList{t} filesep];

        % Isolate just the tract directories
        % single files
        files = dir(D);
        filenames = cellstr(char(files.name));
        dropfiles = false(length(files),1);
        dropfiles(cellfun(@isempty,strfind(filenames,'density.nii.gz'))) = true; 
        files = files(~dropfiles);

        % bilateral files
        if length(strfind(files(1).name,'_')) == 2
            files_bilat = dir(D);
            right = false(round(length(files)/2),1);
            right(cellfun(@isempty,strfind(filenames,'L_density.nii.gz'))) = true;    
            filesL = files_bilat(~right);
            left = false(round(length(files)/2),1);
            left(cellfun(@isempty,strfind(filenames,'R_density.nii.gz'))) = true;    
            filesR = files_bilat(~left);
        end 

        % Put all of the average results into a directory called AVG. If AVG or the tract directory do not
        % already exist, create the directory
        A = '/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/';
        if strcmp({dir(A)}, tractList{t})==0
            mkdir ([A tractList{t}])
        end

        % Load a random image for size
        %background = ['/home-local/bayrakrg/Dropbox (VUMC)/19_new_BLSA/0303_Christa/' tractList_stupid{t} filesep files(1).name];
        background = ['/home-local/bayrakrg/auto_BLSA/0531_auto/' tractList_stupid{t} filesep files(1).name];

        basevol = load_nii(background);
        basevol = basevol.img(:,:,:,1); % make sure it is just one volume
        avg = zeros(size(basevol));
        avgL = zeros(size(basevol));
        avgR = zeros(size(basevol));
        avg_img = zeros(size(basevol));
        avg_imgL = zeros(size(basevol));
        avg_imgR = zeros(size(basevol));

        % This for loop average and output each density file: left and right for each tract
        % For single tracts
        if length(strfind(files(1).name,'_')) == 1
            for k = 1:length(files)
                density =  [files(k).folder filesep files(k).name];
                vol = load_nii(density);
                avg_img = avg_img + double(vol.img);
            end
            avg_density = avg_img / k;
            avg = avg + avg_density;
%             vol.img = avg_density;
%             save_nii(vol, ['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/' tractList{t} filesep 'BLSA_' tractList{t} '.nii']);
%             figure;imshow(squeeze(double(avg_density(:,:,floor(end/2)))));title('Average'); % sanity visualization
%             close all;

        % For bilateral tracts
        elseif length(strfind(files(1).name,'_')) == 2 
            for l = 1:length(filesL)
                densityL =  [filesL(l).folder filesep filesL(l).name];
                volL = load_nii(densityL);
                avg_imgL = avg_imgL + double(volL.img);
            end
            avg_densityL = avg_imgL / l;
            avgL = avgL + avg_densityL;
%             volL.img = avg_densityL;
%             save_nii(volL, ['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/' tractList{t} filesep 'BLSA_L_' tractList{t} '.nii']);

            for r = 1:length(filesR)
                densityR =  [filesR(r).folder filesep filesR(r).name];
                volR = load_nii(densityR);
                avg_imgR = avg_imgR + double(volR.img);
            end
            avg_densityR = avg_imgR / r;
            avgR = avgR + avg_densityR;
%             volR.img = avg_densityR;
%             save_nii(volR, ['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/' tractList{t} filesep 'BLSA_R_' tractList{t} '.nii']);
%             figure;imshow(squeeze(double(avg_densityR(:,:,floor(end/2)))));title('Average'); % sanity visualization
%             figure;imshow(squeeze(double(avg_densityL(:,:,floor(end/2)))));title('Average'); % sanity visualization
%             close all;

        end

    end
    
    if length(strfind(files(1).name,'_')) == 1
        N = avg / f;
        vol.img = N;        
        save_nii(vol, ['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/' tractList_correct{t} filesep 'A-AVG_' tractList_correct{t} '.nii']);
        
    elseif length(strfind(files(1).name,'_')) == 2 
        L = avgL / f;
        volL.img = L;        
        save_nii(volL, ['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/' tractList_correct{t} filesep 'A-AVG_L_' tractList_correct{t} '.nii']);
        R = avgR / f;
        volR.img = R;
        save_nii(volR, ['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/' tractList_correct{t} filesep 'A-AVG_R_' tractList_correct{t} '.nii']);
    end
    
end
