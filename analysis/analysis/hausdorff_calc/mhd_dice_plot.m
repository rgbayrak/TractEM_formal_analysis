clear all;
clc;

% % Loading the data from multiple directories
exDir = '/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd';
matDir = fullfile(exDir, 'human_mhd_mat/BLSA');  % directory names are as follows -> subject_rater

rep_dir = '/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/*';
rep_matDir = fullfile(rep_dir, 'human_*_mat/BLSA');  % directory names are as follows -> subject_rater


abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ... % 
    'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};

tractList =  {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum'; ...
    'cerebral_peduncle'; 'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';...
    'frontal_lobe';'genu_corpus_callosum';'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';...
    'inferior_longitudinal_fasciculus';'medial_lemniscus';'midbrain'; 'middle_cerebellar_peduncle';...
    'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
    'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';...
    'superior_cerebellar_peduncle'; 'superior_corona_radiata';'superior_fronto_occipital_fasciculus';...
    'superior_longitudinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};

for a = 1:length(tractList)
    % load the directories of DICE coefficients and their corresponding name files
    hd_mat_files = dir(fullfile([matDir, '/', tractList{a} '/*_hd.mat']));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    hdmean_mat_files = dir(fullfile([matDir, '/*_hdmean.mat']));
    modHausdd_mat_files = dir(fullfile([matDir, '/*_modHausdd.mat']));
    hd90_mat_files = dir(fullfile([matDir, '/*_hd90.mat']));
    name_mat_files = dir(fullfile([matDir, '/*_nameMe.mat']));

    dice_mat_filesL = dir(fullfile([rep_matDir, '/acr_L_dice.mat']));
    dice_mat_filesR = dir(fullfile([rep_matDir, '/acr_R_dice.mat']));

    l = 1;
    hd_mat = load(fullfile(hd_mat_files(l).folder, hd_mat_files(l).name));
    hdmean_mat = load(fullfile(hdmean_mat_files(l).folder, hdmean_mat_files(l).name));
    modHausdd_mat = load(fullfile(modHausdd_mat_files(l).folder, modHausdd_mat_files(l).name));
    hd90_mat = load(fullfile(hd90_mat_files(l).folder, hd90_mat_files(l).name));
    name_mat = load(fullfile(name_mat_files(l).folder, name_mat_files(l).name));
    name_mat = struct2cell(name_mat);
    name_mat = name_mat{1,1};

    dice_matL = load(fullfile(dice_mat_filesL(l).folder, dice_mat_filesL(l).name));
    dice_matR = load(fullfile(dice_mat_filesR(l).folder, dice_mat_filesR(l).name));

    % grab the subject id numbers
    id = {};
    name = {};
    for p = 1:length(name_mat)
        parts = strsplit(name_mat(p), '_');

        if length(parts) == 1
            name{p} = 'NaN';
        elseif length(parts) == 4
            name{p} = [parts{1}  '_2']; % rater names  
            id{p} = parts{3};
        else 
            name{p} = [parts{2}]; %
            id{p} = parts{1}; % subject ids
        end
    end

    % create masks
    uni_id = unique(id);
    uni_name = unique(name);

    for d = 1:length(uni_id)

        mask_id = strcmp(id,uni_id(d)); 
        if sum(mask_id(:)) > 1
            dice_mat_temp = struct2cell(dice_matR); 
            dice_mat_temp = dice_mat_temp{1,1};
            dice_mat_temp = dice_mat_temp(mask_id, mask_id);
            idx = triu(true(size(dice_mat_temp,1)), 1);  % since it is a matrix, we only grab the upper half      
            temp_dice_mat_intra_subject{d, 1} = dice_mat_temp(idx)';
            dice_mat_intra_subject{d, 1} = temp_dice_mat_intra_subject{d, 1}(1);

            hd_mat_temp = struct2cell(hd_mat); 
            hd_mat_temp = hd_mat_temp{1,1};
            hd_mat_temp = hd_mat_temp(mask_id, mask_id);
            temp_dice_mat_intra_subject{d, 2} = hd_mat_temp(idx)';
            dice_mat_intra_subject{d, 2} = temp_dice_mat_intra_subject{d, 2}(1);

            hdmean_mat_temp = struct2cell(hdmean_mat); 
            hdmean_mat_temp = hdmean_mat_temp{1,1};
            hdmean_mat_temp = hdmean_mat_temp(mask_id, mask_id);
            temp_dice_mat_intra_subject{d, 3} = hdmean_mat_temp(idx)';
            dice_mat_intra_subject{d, 3} = temp_dice_mat_intra_subject{d, 3}(1);

            modHausdd_mat_temp = struct2cell(modHausdd_mat); 
            modHausdd_mat_temp = modHausdd_mat_temp{1,1};
            modHausdd_mat_temp = modHausdd_mat_temp(mask_id, mask_id);
            temp_dice_mat_intra_subject{d, 4} = modHausdd_mat_temp(idx)';
            dice_mat_intra_subject{d, 4} = temp_dice_mat_intra_subject{d, 4}(1);

            hd90_mat_temp = struct2cell(hd90_mat); 
            hd90_mat_temp = hd90_mat_temp{1,1};
            hd90_mat_temp = hd90_mat_temp(mask_id, mask_id);
            temp_dice_mat_intra_subject{d, 5} = hd90_mat_temp(idx)';
            dice_mat_intra_subject{d, 5} = temp_dice_mat_intra_subject{d, 5}(1);

        end 
    end

    scatter([dice_mat_intra_subject{:, 4}], [dice_mat_intra_subject{:, 1}])
    grid minor;
    xlabel('modHausdorff distance(mm)');
    ylabel('DICE');
    ylim([0 1])
    title('acr R ROA label')


    % save('/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/dice_ROA1_L_mhd.mat', 'dice_mat_intra_subject')

end