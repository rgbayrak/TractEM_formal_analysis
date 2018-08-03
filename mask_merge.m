clc;
clear all;
close all;

%%% Merging masks for tractem old protocols
% Author: roza.g.bayrak@vanderbilt.edu

exDir = '/home-local/bayrakrg/Dropbox*VUMC*/complete_BLSA*';
subjectDir = dir([exDir, '/*']);
mask = 0;
abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
abb_pos = 1;


for i = 3:length(subjectDir)
    tractFolder = dir(fullfile(exDir, subjectDir(i).name));
%     subFolders = dir(fullfile(exDir, subjectDir(i).name));
%     for j = 3:length(subFolders)
%         if subFolders(j).isdir
%             lobe_folders = dir(fullfile(exDir, subjectDir(i).name, '*_lobe'));
%             
%         end 
%     end
    for j = 3:length(tractFolder)
        fileDir_mask = dir(fullfile(exDir, subjectDir(i).name, tractFolder(j).name, '*ROA*.nii.gz'));
        init = 0;
        if tractFolder(j).isdir && ...
               ~strcmp(tractFolder(j).name,'QA') && ...
               ~strcmp(tractFolder(j).name,'__MACOSX') && ...
               ~strcmp(tractFolder(j).name,'density') && ...
               ~strcmp(tractFolder(j).name,'postproc')&& ...
               ~strcmp(tractFolder(j).name,subjectDir(i).name)
            
            if isempty(fileDir_mask)
               disp(['For: ' fullfile(subjectDir(i).name,tractFolder(j).name), ', no ROA found!'])

            else
                if length(strfind(fileDir_mask(1).name,'_')) == 1
                    % merge loop---------------------------------------------------------------------------
                        for c = 1:length(fileDir_mask)
                            prev_mask = load_nii(fullfile(fileDir_mask(c).folder, fileDir_mask(c).name));
                            prev_mask_img = prev_mask.img;
                            if ~init 
                                mask = zeros(size(prev_mask_img));
        %                             temp = prev_mask;
                                init = 1;
                            end   
                            mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
                        end
                        if length(fileDir_mask) >= 1 % excluding the folders with no ROA regions
                            prev_mask.img = mask;
                            save_nii(prev_mask, fullfile(fileDir_mask(1).folder, [abbList{abb_pos} '_ROA0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
%                             disp(['For: ' fullfile(subjectDir(i).name,tractFolder(j).name), ', ROAs merged!'])
                        end
                        %--------------------------------------------------------------------------------------
                end  

                if length(strfind(fileDir_mask(1).name,'_R_')) == 1
                    % merge loop---------------------------------------------------------------------------
                        for c = 1:length(fileDir_mask)
                                prev_mask = load_nii(fullfile(fileDir_mask(c).folder, fileDir_mask(c).name));
                                prev_mask_img = prev_mask.img;
                                if ~init 
                                    mask = zeros(size(prev_mask_img));
                                        temp = prev_mask;
                                    init = 1;
                                end   
                                mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
                            end
                            if length(fileDir_mask) >= 0 % excluding the folders with no ROA regions
                                prev_mask.img = mask;
                                save_nii(prev_mask, fullfile(fileDir_mask(1).folder, [abbList{abb_pos} '_R_ROA0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
    %                             disp(['For: ' fullfile(subjectDir(i).name,tractFolder(j).name), ', Right ROAs merged!'])
                            end
                        %--------------------------------------------------------------------------------------
                end  

                if length(strfind(fileDir_mask(1).name,'_L_')) == 1
                        % merge loop---------------------------------------------------------------------------
                            for c = 1:length(fileDir_mask)
                                prev_mask = load_nii(fullfile(fileDir_mask(c).folder, fileDir_mask(c).name));
                                prev_mask_img = prev_mask.img;
                                if ~init 
                                    mask = zeros(size(prev_mask_img));
                                        temp = prev_mask;
                                    init = 1;
                                end   
                                mask(prev_mask_img>0) = prev_mask_img(prev_mask_img>0); % takes masking and intersection regions into account
                            end
                            if length(fileDir_mask) >= 0 
                                prev_mask.img = mask;
                                save_nii(prev_mask, fullfile(fileDir_mask(1).folder,[abbList{abb_pos}  '_L_ROA0.nii.gz'])); % change the file name accordingly i.e. ROA0.nii.gz, seed1.nii.gz
    %                             disp(['For: ' fullfile(subjectDir(i).name,tractFolder(j).name), ', Left ROAs merged!'])
                            end
                            %--------------------------------------------------------------------------------------
                end
            end
            abb_pos = abb_pos +1;
        end  
    end
end