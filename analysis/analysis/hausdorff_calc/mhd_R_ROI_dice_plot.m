clear all;
clc;

% % Loading the data from multiple directories
exDir              = '/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd';
matDir = fullfile(exDir, 'human_mhd_mat/BLSA/anterior_corona_radiata');  % directory names are as follows -> subject_rater
rep_dir            = '/share4/bayrakrg/tractEM/postprocessing/metric_analysis/tract/*';
rep_matDir = fullfile(rep_dir, 'human_*_mat/BLSA');  % directory names are as follows -> subject_rater


% load the directories of dice coefficients and their corresponding name files
hd_mat_files = dir(fullfile([matDir, '/*ROI1_temp_hdR.mat']));
hdmean_mat_files = dir(fullfile([matDir, '/*ROI1_temp_hdmeanR.mat']));
modHausdd_mat_files = dir(fullfile([matDir, '/*ROI1_temp_modHausddR.mat']));
hd90_mat_files = dir(fullfile([matDir, '/*ROI1_temp_hd90R.mat']));
name_mat_files = dir(fullfile([matDir, '/*ROI1_nameMe.mat']));

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
title('acr R ROI label')


% save('/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd/dice_ROI1_R_mhd.mat', 'dice_mat_intra_subject')


