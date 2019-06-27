clear all;
clc;

% % Loading the data from multiple directories
exDir              = '/share4/bayrakrg/tractEM/postprocessing/metric_analysis/label/mhd';
matDir = fullfile(exDir, 'human_mhd_mat/BLSA/uncinate_fasciculus');  % directory names are as follows -> subject_rater

% load the directories of dice coefficients and their corresponding name files
hd_mat_files = dir(fullfile([matDir, '/*temp_hd.mat']));
hdmean_mat_files = dir(fullfile([matDir, '/*temp_hdmean.mat']));
modHausdd_mat_files = dir(fullfile([matDir, '/*temp_modHausdd.mat']));
temp_hd90_mat_files = dir(fullfile([matDir, '/*temp_hd90.mat']));
name_mat_files = dir(fullfile([matDir, '/*nameMe.mat']));

% abbreviation list
abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};

% initializations
dice_intra_subject = [];
dice_intra_rater = [];
dir_per_tract = [];
name_per_tract = [];

all_dice = struct;
count = 1;


nameMe = 
temp_hd = 
temp_hdmean = 
temp_modHausdd
temp_hd90 = 

