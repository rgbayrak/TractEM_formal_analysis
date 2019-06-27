%% This script merges the regions for auto-labels (union of manual labels)
% Author: roza.g.bayrak@vanderbilt.edu

% Usage: 
% change abbList
% change tractList
% label axis -> sagittal, coronal, axial change axis variable accordingly
% slice number: R, L, single

clear all;
close all;

exDir = {'/home-local/bayrakrg/Dropbox*VUMC*/complete_corrected_*_subjects'};
project = {'regions'};
    
for e = 1:length(exDir)
    subjectDir = fullfile(exDir{e}, '*');
    sub = fullfile(subjectDir, '*');  
    subDir = dir(fullfile(subjectDir, '*'));
    addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg:')
    

    threshold_value = {21, 25}; 
    for th = 1:length(threshold_value)
        % ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        % Here we choose what region we would like to average
        % what plane it is on 
        % does it have bilateral parts
        % abbreviation of the tracts
        % and finally tract name
        threshold = strcat('threshold_', num2str(threshold_value{th}));
        regionList = {'seed'}; % {'seed1', 'ROI1', 'seed2','ROI2', 'seed3', 'ROI3'};
        % for coronal 189 - slice
        % for the rest +1
        axis = 2; % sagittal=1, coronal=2, axial=3      
        R = 79; % for sagittal and axial +1
        L = 79;
        single = 0;
        abbList = {'ilf'}; % {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
        %            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};

        tractList = {'inferior_longitudinal_fasciculus'};% {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum'; ...
        % 'cerebral_peduncle'; 'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';...
        % 'frontal_lobe';'genu_corpus_callosum';'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';...
        % 'inferior_longitudinal_fasciculus';'medial_lemniscus';'midbrain'; 'middle_cerebellar_peduncle';...
        % 'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
        % 'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';...
        % 'superior_cerebellar_peduncle'; 'superior_corona_radiata';'superior_fronto_occipital_fasciculus';...
        % 'superior_longitudinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};

        % create the tract directory if it does not exist
        
        folder = fullfile('/share4/bayrakrg/tractEM/postprocessing/', project{e}, threshold, tractList{1});

        if ~isfolder(folder)
            folder_name = ['/share4/bayrakrg/tractEM/postprocessing/' project{e} '/' threshold '/' tractList{1}];
            mkdir (folder_name)
            disp(' ')
            disp(['Mixed ' tractList{1} ' ' threshold ' folder is created!'])

        end
        % exclude folder in the subDir if not in the tractList (QA, density or other tracts)
        filenames = cellstr(char(subDir.name));
        tracts = false(length(subDir),1);
        tracts(ismember(filenames,tractList)) = true;
        subDir = subDir(tracts);

        namePlot = [];
        
        for t = 1:length(regionList)
            for d = 1:length(tractList)        
                mask_tract = strcmp({subDir.name}, tractList(d));
                spec_tract = subDir(mask_tract);
                coords = {};

                sum_of_nifty = 0;
                init = 0;
                sum_of_niftyL = 0;
                initL = 0;
                sum_of_niftyR = 0;
                initR = 0;
                for l = 1:length(spec_tract)
                    spec_tract_dir = dir(fullfile([spec_tract(l).folder,'/', spec_tract(l).name, '/*' regionList{t} '*.nii.gz']));
                    if ~isempty(spec_tract_dir)
                        if length(strfind(spec_tract_dir(1).name,'_')) == 1
                            nifty = load_density(spec_tract_dir);
                            vol = load_nii(fullfile(spec_tract_dir(1).folder, spec_tract_dir(1).name));

                            if init==0
                                sum_of_nifty = zeros(size(nifty));
                                init = 1;
                            end

                            % union of regions
                            sum_of_nifty = sum_of_nifty + nifty;

                            % find the ones in mask
                            idx = find(nifty == 1);
                            [x, y, z] = ind2sub(size(nifty), idx); %get the location of the ones 
                            coord = [x, y, z];
                            s = scatter3(x,y,z, 'filled');
                            xlabel('Sagital'); ylabel('Coronal'); zlabel('Axial')
                            xlim([0 156]); ylim([0 189]); zlim([0 157])
                            grid on; box on; hold on;
                            coords{l} = coord;
                            parts = strsplit(spec_tract(l).folder, '/');
                            dirPart = parts{end};
                            namePlot = [namePlot convertCharsToStrings(dirPart)];
                            namePlot = strrep(namePlot,'_',' ');


                        elseif length(strfind(spec_tract_dir(1).name,'_')) == 2
                            if length(spec_tract_dir) == 2 % ignoring
                                if length(strfind(spec_tract_dir(1).name,'_L_')) == 1
                                    spec_tract_dir_L = dir(fullfile([spec_tract(l).folder,'/', spec_tract(l).name, '/*_L_' regionList{t} '*.nii.gz']));
                                    niftyL = load_density(spec_tract_dir_L);
                                    volL = load_nii(fullfile(spec_tract_dir_L(1).folder, spec_tract_dir_L(1).name));

                                    if initL==0
                                        sum_of_niftyL = zeros(size(niftyL));
                                        initL = 1;
                                    end

                                    % union of regions
                                    sum_of_niftyL = sum_of_niftyL + niftyL;

                                    % find the ones in mask
                                    idxL = find(niftyL == 1);
                                    [x, y, z] = ind2sub(size(niftyL), idxL); %get the location of the ones 
                                    coord = [x, y, z];
                                    scatter3(x,y,z, 'filled');
                                    xlabel('Sagital'); ylabel('Coronal'); zlabel('Axial')
                                    xlim([0 156]); ylim([0 189]); zlim([0 157])
                                    grid on; box on; hold on;
                                    coords{l} = coord;
                                    partsL = strsplit(spec_tract(l).folder, '/');
                                    dirPartL = partsL{end};
                                    namePlot = [namePlot convertCharsToStrings(dirPartL)];
                                    namePlot = strrep(namePlot,'_',' ');

                                end

                                if length(strfind(spec_tract_dir(2).name,'_R_')) == 1
                                    spec_tract_dir_R = dir(fullfile([spec_tract(l).folder,'/', spec_tract(l).name, '/*_R_' regionList{t} '*.nii.gz']));
                                    niftyR = load_density(spec_tract_dir_R);

                                    if initR==0
                                        sum_of_niftyR = zeros(size(niftyR));
                                        initR = 1;
                                    end

                                    % union of regions
                                    sum_of_niftyR = sum_of_niftyR + niftyR;  

                                    % find the ones in mask
                                    idxR = find(niftyR == 1);
                                    [x, y, z] = ind2sub(size(niftyR), idxR); %get the location of the ones 
                                    coord = [x, y, z];
                                    scatter3(x,y,z, 'filled');
                                    xlabel('Sagital'); ylabel('Coronal'); zlabel('Axial')
                                    xlim([0 156]); ylim([0 189]); zlim([0 157])
                                    grid on; box on; hold on;
                                    coords{l} = coord;
                                    partsR = strsplit(spec_tract(l).folder, '/');
                                    dirPartR = partsR{end};
                                    namePlot = [namePlot convertCharsToStrings(dirPartR)];
                                    namePlot = strrep(namePlot,'_',' ');

                                end
                            end
                        end 
                    end  
                end  

                % SAVE THE MASKS    
                if single ~= 0  
                    % sagittal slice
                    if axis == 1
                        if ~isempty(spec_tract_dir)
                            vol = load_nii(fullfile(spec_tract_dir(1).folder, spec_tract_dir(1).name));
                            a = sum(sum_of_nifty, axis);
                            a(a < threshold_value{th}) = 0;
                            a = logical(a);
                            figure; imagesc(squeeze(a))
                            vol.img = zeros(size(vol.img));
                            vol.img(single, :, :) = a;
                            sum(vol.img(:))
                            save_nii(vol, ['/share4/bayrakrg/tractEM/postprocessing/' project{e} filesep threshold filesep tractList{1} filesep abbList{1} '_' regionList{t} '.nii.gz']);
                        end
                    end

                    % coronal slice
                    if axis == 2
                        if ~isempty(spec_tract_dir)
                            vol = load_nii(fullfile(spec_tract_dir(1).folder, spec_tract_dir(1).name));
                            b = sum(sum_of_nifty, axis); 
                            b(b < threshold_value{th}) = 0;
                            b = logical(b);
                            figure; imagesc(squeeze(b))
                            vol.img = zeros(size(vol.img));
                            vol.img(:, single, :) = b;
                            sum(vol.img(:))                    
                            save_nii(vol, ['/share4/bayrakrg/tractEM/postprocessing/' project{e} filesep threshold filesep tractList{1} filesep abbList{1} '_' regionList{t} '.nii.gz']);
                        end
                    end

                    % axial slice
                    if axis == 3
                        if ~isempty(spec_tract_dir)
                            vol = load_nii(fullfile(spec_tract_dir(1).folder, spec_tract_dir(1).name));
                            c = sum(sum_of_nifty, axis);
                            c(c < threshold_value{th}) = 0;
                            c = logical(c);
                            figure; imagesc(squeeze(c))
                            vol.img = zeros(size(vol.img));
                            vol.img(:, :, single) = c;
                            sum(vol.img(:))
                            save_nii(vol, ['/share4/bayrakrg/tractEM/postprocessing/' project{e} filesep threshold filesep tractList{1} filesep abbList{1} '_' regionList{t} '.nii.gz']);
                        end
                    end
                    disp([project{e} ' ' tractList{1} ' ' threshold ' _' regionList{1} ' is created!'])
                end


                if L ~= 0
                    % sagittal slice
                    if axis == 1
                        if ~isempty(spec_tract_dir_R)
                            % right
                            volR = load_nii(fullfile(spec_tract_dir_R(1).folder, spec_tract_dir_R(1).name));
                            c = sum(sum_of_niftyR, axis);
                            c(c < threshold_value{th}) = 0;
                            c = logical(c);
                            figure; imagesc(squeeze(c))
                            volR.img = zeros(size(volR.img));
                            volR.img(R, :, :) = c;
                            sum(volR.img(:))
                            save_nii(volR, ['/share4/bayrakrg/tractEM/postprocessing/' project{e} filesep threshold filesep tractList{1} filesep abbList{1} '_R_' regionList{t} '.nii.gz']);
                        end

                        if ~isempty(spec_tract_dir_L)
                            % left
                            volL = load_nii(fullfile(spec_tract_dir_L(1).folder, spec_tract_dir_L(1).name));
                            b = sum(sum_of_niftyL, axis); 
                            b(b < threshold_value{th}) = 0;
                            b = logical(b);
                            figure; imagesc(squeeze(b))
                            volL.img = zeros(size(volL.img));
                            volL.img(L, :, :) = b;
                            sum(volL.img(:))
                            save_nii(volL, ['/share4/bayrakrg/tractEM/postprocessing/' project{e} filesep threshold filesep tractList{1} filesep abbList{1} '_L_' regionList{t} '.nii.gz']);
                            clear size;
                        end
                    end

                    % coronal slice
                    if axis == 2
                        if ~isempty(spec_tract_dir_R)
                            % right
                            volR = load_nii(fullfile(spec_tract_dir_R(1).folder, spec_tract_dir_R(1).name));
                            c = sum(sum_of_niftyR, axis);
                            c(c < threshold_value{th}) = 0;
                            c = logical(c);
                            figure; imagesc(squeeze(c))
                            volR.img = zeros(size(volR.img));
                            volR.img(:, R, :) = c;
                            sum(volR.img(:))
                            save_nii(volR, ['/share4/bayrakrg/tractEM/postprocessing/' project{e} filesep threshold filesep tractList{1} filesep abbList{1} '_R_' regionList{t} '.nii.gz']);
                        end
                        if ~isempty(spec_tract_dir_L)
                            % left
                            volL = load_nii(fullfile(spec_tract_dir_L(1).folder, spec_tract_dir_L(1).name));
                            b = sum(sum_of_niftyL, axis); 
                            b(b < threshold_value{th}) = 0;
                            b = logical(b);
                            figure; imagesc(squeeze(b))
                            volL.img = zeros(size(volL.img));
                            volL.img(:, L, :) = b;
                            sum(volL.img(:))
                            save_nii(volL, ['/share4/bayrakrg/tractEM/postprocessing/' project{e} filesep threshold filesep tractList{1} filesep abbList{1} '_L_' regionList{t} '.nii.gz']);
                            clear size;
                        end
                    end

                    % axial slice
                    if axis == 3
                        if ~isempty(spec_tract_dir_R)
                            % right
                            volR = load_nii(fullfile(spec_tract_dir_R(1).folder, spec_tract_dir_R(1).name));
                            c = sum(sum_of_niftyR, axis);
                            c(c < threshold_value{th}) = 0;
                            c = logical(c);
                            figure; imagesc(squeeze(c))
                            volR.img = zeros(size(volR.img));
                            volR.img(:, :, R) = c;
                            sum(volR.img(:))
                            save_nii(volR, ['/share4/bayrakrg/tractEM/postprocessing/' project{e} filesep threshold filesep tractList{1} filesep abbList{1} '_R_' regionList{t} '.nii.gz']);
                        end

                        if ~isempty(spec_tract_dir_L)
                            % left
                            volL = load_nii(fullfile(spec_tract_dir_L(1).folder, spec_tract_dir_L(1).name));
                            b = sum(sum_of_niftyL, axis); 
                            b(b < threshold_value{th}) = 0;
                            b = logical(b);
                            figure; imagesc(squeeze(b))
                            volL.img = zeros(size(volL.img));
                            volL.img(:, :, L) = b;
                            sum(volL.img(:))
                            save_nii(volL, ['/share4/bayrakrg/tractEM/postprocessing/' project{e} filesep threshold filesep tractList{1} filesep abbList{1} '_L_' regionList{t} '.nii.gz']);
                            clear size;
                        end
                    end
                    disp(['Mixed ' tractList{1} ' ' threshold ' R_' regionList{1} ' is created!'])
                    disp(['Mixed ' tractList{1} ' ' threshold ' L_' regionList{1} ' is created!'])
                    disp('//')
                end
            end
        end
    end
end