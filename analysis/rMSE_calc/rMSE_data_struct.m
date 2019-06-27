%% This script is converts mat files into struct format for tractem data
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;

% % Loading the data from multiple directories
exDir              = '/share4/bayrakrg/tractEM/postprocessing/rMSE/';
matDir = fullfile(exDir, 'human_rMSE_mat/HCP');  % directory names are as follows -> subject_rater

% load the directories of rMSE coefficients and their corresponding name files
rMSE_mat_files = dir(fullfile([matDir, '/*rMSE.mat']));
name_mat_files = dir(fullfile([matDir, '/*nameMe.mat']));

% abbreviation list
abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};

% initializations
rMSE_intra_subject = [];
rMSE_intra_rater = [];
dir_per_tract = [];
name_per_tract = [];

%%%
% This part of the script does the following: 
%       i - loads the rMSE and name files
%       ii - separates subject id#s and rater names
%       iii - grabs the relevant rMSE from the rMSE matrix using masks for:
%       1. intra-subject & 2. intra-rater(intra-subject)
%
% Some abbreviations: 
%   	dis = rMSE_intra_subject
%
%%%
all_rMSE = struct;
count = 1;
for l = 1:length(rMSE_mat_files)
    
    % starts from ac goes through the list of tracts
    rMSE_mat = load(fullfile(rMSE_mat_files(l).folder, rMSE_mat_files(l).name));
    name_mat = load(fullfile(name_mat_files(l).folder, name_mat_files(l).name));
    name_mat = struct2cell(name_mat);
    name_mat = name_mat{1,1};
    
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
    
    % grab corresponding rMSE coeff.
%     for m = 1:length(uni_name)
        for d = 1:length(uni_id)
            disp(['For: ' char(uni_id(d)) '_intra-subject_' rMSE_mat_files(l).name(1:end-4) ' is: '])
            % picks the same subject rMSE coeff. and masks the rest
            mask_id = strcmp(id,uni_id(d)); 
            
            if sum(mask_id(:)) > 1
                rMSE_mat_temp = struct2cell(rMSE_mat); 
                rMSE_mat_temp = rMSE_mat_temp{1,1};
                rMSE_mat_temp = rMSE_mat_temp(mask_id, mask_id);
                idx = triu(true(size(rMSE_mat_temp,1)), 1);  % since it is a matrix, we only grab the upper half      
                rMSE_mat_intra_subject = rMSE_mat_temp(idx)';
                disp(rMSE_mat_intra_subject)
                rMSE_intra_subject{d} = rMSE_mat_intra_subject; % saving intra-subject rMSE coefficients into 1xn cell 

                % Save intra-subject results into a giant struct
                 % at this point I know which tract, subject, rater, what rMSE 
                if sum(mask_id(:)) > 2
                    tri = 1;
                    for x = 1:sum(mask_id(:))
                        for y = x:sum(mask_id(:))
                            if x ~= y
                                temp_name = name(mask_id);
                                all_rMSE(count).subject = char(uni_id(d));
                                all_rMSE(count).rater1 = char(temp_name(x));
                                all_rMSE(count).rater2 = char(temp_name(y));
                                all_rMSE(count).tract = rMSE_mat_files(l).name(1:end-9);  % tract name changes due to similarity matrix
                                if length(strfind(rMSE_mat_files(l).name,'_')) == 2
                                    all_rMSE(count).tractOne = rMSE_mat_files(l).name(1:end-11);
                                else
                                    all_rMSE(count).tractOne = rMSE_mat_files(l).name(1:end-9);
                                end
                                all_rMSE(count).rMSE = rMSE_mat_intra_subject(tri);
                                count = count + 1;
                                tri = tri + 1;
                            end
                        end
                    end
                else 
                    temp_name = name(mask_id);
                    all_rMSE(count).subject = char(uni_id(d));
                    all_rMSE(count).rater1 = char(temp_name(1));
                    all_rMSE(count).rater2 = char(temp_name(2));
                    all_rMSE(count).tract = rMSE_mat_files(l).name(1:end-9);
                    if length(strfind(rMSE_mat_files(l).name,'_')) == 2
                        all_rMSE(count).tractOne = rMSE_mat_files(l).name(1:end-11);
                    else
                        all_rMSE(count).tractOne = rMSE_mat_files(l).name(1:end-9);
                    end
                    all_rMSE(count).rMSE = rMSE_mat_intra_subject;
                    count = count + 1;
                end
            end
        end
       
    dis{l} = rMSE_intra_subject; % saving 1xn intra-subject rMSE coefficients into 1x61 cell (for all tracts)
    disp(fullfile(rMSE_mat_files(l).name(1:end-4)))
end

dis_mat = [];
for i = 1:length(dis)
    data = cell2mat(dis{1,i})';
    if size(dis_mat,1) > size(data,1)
        data = [data; zeros(size(dis_mat,1) - size(data,1), 1)];
    else
        dis_mat= [dis_mat; zeros(size(data,1) - size(dis_mat,1), size(dis_mat,2))];
    end
    dis_mat = [dis_mat data];
end

% all_rMSE.date = num2str(datetime('today'));
save('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg/tractem/analysis/reproducibility/HCP_Apr_rMSE.mat', 'all_rMSE')


