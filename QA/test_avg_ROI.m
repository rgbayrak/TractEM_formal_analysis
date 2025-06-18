clear all;
close all;
clc;

exDir              = '/home-local/bayrakrg/Dropbox*VUMC*/complete_BLSA_subjects';
subjectDir = fullfile(exDir, '*');
sub = fullfile(subjectDir, '*');  
subDir = dir(fullfile(subjectDir, '*'));

tractList = {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum';'cerebral_peduncle'; ...
'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';'frontal_lobe';'genu_corpus_callosum';...
'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';'inferior_longitundinal_fasciculus';'medial_lemniscus';'midbrain';...
'middle_cerebellar_peduncle';'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';'superior_cerebellar_peduncle';...
'superior_corona_radiata';'superior_fronto_occipital_fasciculus';'superior_longitundinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};

% exclude folder if not in the tractList
filenames = cellstr(char(subDir.name));
tracts = false(length(subDir),1);
tracts(ismember(filenames,tractList)) = true;
subDir = subDir(tracts);




namePlot = [];
for d = 1:length(tractList)
%     one tract
    mask_tract = strcmp({subDir.name}, tractList(d));
    spec_tract = subDir(mask_tract);
    
    % majority vote
    i = 0;
    M = [];
    
    for l = 1:length(spec_tract)
        spec_tract_dir = dir(fullfile([spec_tract(l).folder,'/', spec_tract(l).name, '/*ROA*.nii.gz']));
        nifty = load_density(spec_tract_dir);
        clear size;
        % find the 1s in mask
        idx = find(nifty == 1);
        [x, y, z] = ind2sub(size(nifty), idx); %get the location of the ones 
        scatter3(x, y, z, 'filled') % plot the ones
        hold on;
        parts = strsplit(spec_tract(l).folder, '/');
        dirPart = parts{end};
        namePlot = [namePlot convertCharsToStrings(dirPart)];
        
        % majority vote
        if i == 0
            m = idx;
            i = 1;
        elseif m == idx
            i = i + 1;
        else
            i = i - 1;
        end

 
    end
    legend(namePlot)
end



