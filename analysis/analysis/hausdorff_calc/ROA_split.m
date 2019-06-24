%% This script splits the regions for mhd analysis
% Author: roza.g.bayrak@vanderbilt.edu

% Usage: 

clear all;
close all;
clc;

exDir = {'/share4/wangx41/regions/BLSA', ...
        '/share4/wangx41/regions/HCP'};
project = {'ROA_regions'};
    
for e = 2:length(exDir)
    subjectDir = fullfile(exDir{e}, '*');
    sub = fullfile(subjectDir, '*');  
    subDir = dir(fullfile(subjectDir, '*'));
    addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg:')
    
    regionList = {'ROA'};

    abbList = {'ac'}; % {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
    %            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};

    tractList = {'anterior_commissure'}; % {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum'; ...
    % 'cerebral_peduncle'; 'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';...
    % 'frontal_lobe';'genu_corpus_callosum';'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';...
    % 'inferior_longitundinal_fasciculus';'medial_lemniscus';'midbrain'; 'middle_cerebellar_peduncle';...
    % 'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
    % 'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';...
    % 'superior_cerebellar_peduncle'; 'superior_corona_radiata';'superior_fronto_occipital_fasciculus';...
    % 'superior_longitundinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};

    % create the tract directory if it does not exist

    folder = fullfile('/share4/bayrakrg/tractEM/postprocessing/', project{:}, tractList{1});

    if ~isfolder(folder)
        folder_name = ['/share4/bayrakrg/tractEM/postprocessing/' project{:} '/' tractList{1}];
        mkdir (folder_name)
        disp([tractList{1} ' folder is processed!'])

    end
    % exclude folder in the subDir if not in the tractList (QA, density or other tracts)
    filenames = cellstr(char(subDir.name));
    tracts = false(length(subDir),1);
    tracts(ismember(filenames,tractList)) = true;
    subDir = subDir(tracts);
    roa_extension = [abbList{:} '_ROA1.nii.gz'];
    
    for s = 1:length(subDir)
        roa = load_nii(fullfile(subDir(s).folder, subDir(s).name, roa_extension));
        
        coords = {};
        init = 0;

        idx = find(roa.img == 1); % find the ones in mask
        [x, y, z] = ind2sub(size(roa.img), idx); % get the location of the ones (index to subscript)
        coord = [x, y, z];

        % plot
        plt = scatter3(x,y,z, 'filled');
        xlabel('Sagital'); ylabel('Coronal'); zlabel('Axial')
        xlim([0 156]); ylim([0 189]); zlim([0 157])
        grid on; box on; hold on;
        coords{1} = coord;
        
        figure(2);
        for i = 121:121
            imagesc(squeeze(roa.img(:, i, :)))
            disp(i)
            pause
        end
        
        axis = 2;
        slice = 121;
        
        vol = roa;
        b = roa.img(:, slice, :); 
%         b = logical(b);
        figure; imagesc(squeeze(b))
        vol.img = zeros(size(vol.img));
        vol.img(:, slice, :) = b;
        sum(vol.img(:))
        save_nii(vol, ['~/Desktop/', roa_extension]);
        
        
        
        % Visualize with bin count
%         if size(coords) ~= 0
%             loc = vertcat(coords{:}); % this makes sense when there is multiple regions/labels
%             x = loc(:,1);
%             y = loc(:,2);
%             z = loc(:,3);
% 
%             figure(3)
%             set(figure(3),'Position', [1 1 1680 1050]);
%             subplot(2,2,1)
%             sortedIndx = 0; sortedIndy = 0; sortedIndz = 0;
%             [sortedX, sortedIndx] = sort(histcounts(x),'descend');
%             [sortedY, sortedIndy] = sort(histcounts(y),'descend');
%             
%             [X, Indx] = histcounts(x);
%             [Y, Indy] = histcounts(y);
% 
%             histogram2(x, y)
%             xlim([0 157]); ylim([0 189])
%             xlabel('Sagital')
%             ylabel('Coronal')
%             zlabel('# of voxels'); grid minor;
% 
%             
%             subplot(2,2,2)
%             sortedIndx = 0; sortedIndy = 0; sortedIndz = 0;
%             [sortedX, sortedIndx] = sort(histcounts(x),'descend');
%             [sortedZ, sortedIndz] = sort(histcounts(z),'descend');
% 
%             histogram2(x, z)
%             xlim([0 157]); ylim([0 156])
%             xlabel('Sagital')
%             ylabel('Axial')
%             zlabel('# of voxels'); grid minor;
% 
%             subplot(2,2,3)
%             sortedIndx = 0; sortedIndy = 0; sortedIndz = 0;
%             [sortedY, sortedIndy] = sort(histcounts(y),'descend');
%             [sortedZ, sortedIndz] = sort(histcounts(z),'descend');
% 
%             histogram2(y, z)
%             xlim([0 189]); ylim([0 156])
%             xlabel('Coronal')
%             ylabel('Axial')
%             zlabel('# of voxels'); grid minor;
%             
%             subplot(2,2,4)
%             s = scatter3(x,y,z, 'filled');
%             xlabel('Sagital'); ylabel('Coronal'); zlabel('Axial')
%             xlim([0 156]); ylim([0 189]); zlim([0 157])
%             grid on; box on; hold on;
%             
%         end

        

        
        pause 
        close all;
    end
end