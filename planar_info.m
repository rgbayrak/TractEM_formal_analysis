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
    fig = figure('Visible','off');
    
    for l = 1:length(spec_tract)
        spec_tract_dir = dir(fullfile([spec_tract(l).folder,'/', spec_tract(l).name, '/*ROA*.nii.gz']));
        nifty = load_density(spec_tract_dir);
        clear size;
        % find the ones in mask
        idx = find(nifty == 1);
        [x, y, z] = ind2sub(size(nifty), idx); %get the location of the ones 
        scatter3(x, y, z, 'filled') % plot the ones
        hold on;
        parts = strsplit(spec_tract(l).folder, '/');
        dirPart = parts{end};
        namePlot = [namePlot convertCharsToStrings(dirPart)];
        namePlot = strrep(namePlot,'_',' ');
        
    end
    legend(namePlot)
    st = strrep(spec_tract(l).name,'_',' ');
    title(['ROA Overlay for ' st])
    xlabel('Sagital')
    ylabel('Coronal')
    zlabel('Axial')
    set(fig,'Position', [1 1 1680 1050]);
    saveas(fig,['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/BLSA/region_overlays/BLSA_' spec_tract(l).name '.jpg']); 
    close all;
end




