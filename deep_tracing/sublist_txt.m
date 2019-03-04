close all;
clear all;
clc;

fibDir              = '/share4/bayrakrg/tractEM/postprocessing/fib_files/*';
labelDir              = '/share4/bayrakrg/tractEM/postprocessing/M-tracts/*';



abbList = {'gcc'}; %{'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            %'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
tractList =  {'genu_corpus_callosum'}; %{'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum';'cerebral_peduncle'; ...
%'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';'frontal_lobe';'genu_corpus_callosum';...
%'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';'inferior_longitudinal_fasciculus';'medial_lemniscus';'midbrain';...
%'middle_cerebellar_peduncle';'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
%'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';'superior_cerebellar_peduncle';...
%'superior_corona_radiata';'superior_fronto_occipital_fasciculus';'superior_longitudinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};
   
fos = dir(fullfile(fibDir, '*_fo.nii'));
fileID = fopen('sublist.txt','w');

for l = 1:length(fos)
    
    % get the subject id 
    fo_id = strsplit(fos(l).name, '_');
    fo_id = fo_id{1};
    labels = dir(fullfile([labelDir,filesep, fo_id, '_*/', tractList{1}, filesep, '*density.nii.gz']));
    %fileID = fopen('sublist.txt','w');
    for m = 1:length(labels)
        path_to_fo = fullfile(fos(l).folder, fos(l).name);
        path_to_label = fullfile(labels(m).folder,labels(m).name); 
        fprintf(fileID, '%s, %s\n', path_to_fo, path_to_label);
    end
    
end
fclose(fileID);