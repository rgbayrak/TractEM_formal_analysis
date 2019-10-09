%% This script is converts mat files into struct format for tractem data
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

% % Loading the data from multiple directories
exDir              = '/nfs/masi/bayrakrg/tractem_data/';
matDir = fullfile(exDir, 'old_dice_mat/HCP');  % directory names are as follows -> subject_rater
% matDir = fullfile(exDir, 'old_dice_mat/HCP');  % directory names are as follows -> subject_rater

% load the directories of dice coefficients and their corresponding name files
dice_mat_files = dir(fullfile([matDir, '/*dice.mat']));

% abbreviation list
abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};

% initializations
dice_intra_subject = [];
dice_intra_rater = [];
dir_per_tract = [];

%%%
% This part of the script does the following: 
%       i - loads the dice and name files
%       ii - separates subject id#s and rater names
%       iii - grabs the relevant dice from the dice matrix using masks for:
%       1. intra-subject & 2. intra-rater(intra-subject)
%
% Some abbreviations: 
%   	dis = dice_intra_subject
%
%%%
all_dice = struct;
count = 1;
for l = 1:length(dice_mat_files)
    
    % starts from ac goes through the list of tracts
    dice_mat_all = load(fullfile(dice_mat_files(l).folder, dice_mat_files(l).name));
    
    if isfield(dice_mat_all, 'out')
        dice_mat_all = dice_mat_all.out;
    elseif isfield(dice_mat_all, 'outL')
        dice_mat_all = dice_mat_all.outL;
    elseif isfield(dice_mat_all, 'outR')
        dice_mat_all = dice_mat_all.outR;
    end
    
    % grab the subject id numbers
    id = {};
    name = {};
    for p = 1:length(dice_mat_all(:,1))
        parts = strsplit(dice_mat_all(p,1), '_');
        
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
    dice_mat = str2double(dice_mat_all(:, 2:end));
    % grab corresponding dice coeff.
%     for m = 1:length(uni_name)
        for d = 1:length(uni_id)
            disp(['For: ' char(uni_id(d)) '_intra-subject_' dice_mat_files(l).name(1:end-4) ' is: '])
            % picks the same subject dice coeff. and masks the rest
            mask_id = strcmp(id,uni_id(d)); 
            
            if sum(mask_id(:)) > 1
%                 dice_mat_temp = struct2cell(dice_mat); 
%                 dice_mat_temp = dice_mat_temp{1,1};
                dice_mat_temp = dice_mat(mask_id, mask_id);
                idx = triu(true(size(dice_mat_temp,1)), 1);  % since it is a matrix, we only grab the upper half      
                dice_mat_intra_subject = dice_mat_temp(idx)';
                disp(dice_mat_intra_subject)
                dice_intra_subject{d} = dice_mat_intra_subject; % saving intra-subject dice coefficients into 1xn cell 

                % Save intra-subject results into a giant struct
                 % at this point I know which tract, subject, rater, what dice 
                if sum(mask_id(:)) > 2
                    tri = 1;
                    for x = 1:sum(mask_id(:))
                        for y = x:sum(mask_id(:))
                            if x ~= y
                                temp_name = name(mask_id);
                                all_dice(count).subject = char(uni_id(d));
                                all_dice(count).rater1 = char(temp_name(x));
                                all_dice(count).rater2 = char(temp_name(y));
                                all_dice(count).tract = dice_mat_files(l).name(1:end-9);  % tract name changes due to similarity matrix
                                if length(strfind(dice_mat_files(l).name,'_')) == 2
                                    all_dice(count).tractOne = dice_mat_files(l).name(1:end-11);
                                else
                                    all_dice(count).tractOne = dice_mat_files(l).name(1:end-9);
                                end
                                all_dice(count).dice = dice_mat_intra_subject(tri);
                                count = count + 1;
                                tri = tri + 1;
                            end
                        end
                    end
                else 
                    temp_name = name(mask_id);
                    all_dice(count).subject = char(uni_id(d));
                    all_dice(count).rater1 = char(temp_name(1));
                    all_dice(count).rater2 = char(temp_name(2));
                    all_dice(count).tract = dice_mat_files(l).name(1:end-9);
                    if length(strfind(dice_mat_files(l).name,'_')) == 2
                        all_dice(count).tractOne = dice_mat_files(l).name(1:end-11);
                    else
                        all_dice(count).tractOne = dice_mat_files(l).name(1:end-9);
                    end
                    all_dice(count).dice = dice_mat_intra_subject;
                    count = count + 1;
                end
            end
        end
       
    dis{l} = dice_intra_subject; % saving 1xn intra-subject dice coefficients into 1x61 cell (for all tracts)
    disp(fullfile(dice_mat_files(l).name(1:end-4)))
end

% dis_mat = [];
% for i = 1:length(dis)
%     data = cell2mat(dis{1,i})';
%     if size(dis_mat,1) > size(data,1)
%         data = [data; zeros(size(dis_mat,1) - size(data,1), 1)];
%     else
%         dis_mat= [dis_mat; zeros(size(data,1) - size(dis_mat,1), size(dis_mat,2))];
%     end
%     dis_mat = [dis_mat data];
% end

% all_dice.date = num2str(datetime('today'));
save('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg/tractem/error_tracking/mat_files/HCP05_orig_Sept_dice.mat', 'all_dice')


