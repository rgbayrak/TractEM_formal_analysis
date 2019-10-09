%% This script is for similarity analysis between tract densities
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;


% % HCP
% exDir              = {'/nfs/masi/bayrakrg/tractem_data/original/complete_HCP_subjects';'/nfs/masi/bayrakrg/tractem_data/corrected/complete_BLSA_subjects'};
exDir = {'/home-local/bayrakrg/Dropbox (VUMC)/complete_HCP_subjects'};


abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
        
regionList = {'seed1', 'seed2', 'ROA1', 'ROI1', 'ROI2', 'ROI3'};  
        
% % OVERLAP BASED METRICS
% Dice Coefficient --------------------------------------------------------------------------------------------------------------------

threshold = 0.0;
region_data = [];

for t = 1:length(exDir)

    subjectDir = fullfile(exDir{t}, '*');  % directory names are as follows -> subject_rater
    subDir = fullfile(subjectDir, 'preprocess/*');  % tract names are defined as published
    cheat = struct;
    cheat.dataset = exDir{t};

    for l = 17:length(abbList)
        cheat.abb = abbList{l};  
        for r = 1:length(regionList)
            region = regionList{r};
            cheat.region = region;
                     
            
            cheat.similar = [];
            cheat.single_count = 0;
            cheat.right_similar = [];
            cheat.right_count = 0;
            cheat.left_similar = [];
            cheat.left_count = 0;
            % get track folders and do analysis on them
            densityDir = dir(fullfile(subDir, [abbList{l} '_*' region '.nii.gz'])); % not every folder has separate density files (left & right)
            if ~isempty(densityDir)
                if length(strfind(densityDir(1).name,'_')) == 1
                    d = length(densityDir);
                    density = load_density(densityDir);
                    [nameMe, diceMatrix, same_regionS] = dice(densityDir, density, threshold, d);
                    cheat.similar = same_regionS;
                    cheat.single_count = length(same_regionS);

    %                 save(['same_region', abbList{l},'.mat'], 'same_region');

    %                 r = figure('Visible','on');   
    %                 imagesc(diceMatrix)
    %                 title(['Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Across Raters'], 'FontSize', 10); % set title
    %                 colormap; % set the colorscheme
    %                 xticks((1:d))
    %                 nameMe = strrep(nameMe,'_',' ');
    %                 xticklabels(nameMe);
    %                 yticks((1:d))
    %                 yticklabels(nameMe);
    %                 xtickangle(45)
    %                 colorbar;
    %                 textStrings = num2str(diceMatrix(:), '%0.2f');       % Create strings from the matrix values
    %                 textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
    %                 [x, y] = meshgrid(1:length(densityDir));  % Create x and y coordinates for the strings
    %                 hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
    %                                 'HorizontalAlignment', 'center');
    %                 set(r,'Position', [1 1 1680 1050]);
    %                 disp([abbList{l} ' has been processed!'])
    %                 pause

                elseif length(strfind(densityDir(1).name,'_')) == 2
                    densityLDir = dir(fullfile(subDir, [abbList{l} '_L_' region '.nii.gz']));
                    densityRDir = dir(fullfile(subDir, [abbList{l} '_R_' region '.nii.gz']));
                    if length(densityLDir) > 1
                        if length(strfind(densityLDir(1).name,'_L')) == 1
                            dl = length(densityLDir);
                            densityL = load_density(densityLDir);
                            [nameMe, diceL, same_regionL] = dice(densityLDir, densityL, threshold, dl);
                            cheat.left_similar = same_regionL;
                            cheat.left_count = length(same_regionL);
        %                     save(['same_region', abbList{l},'_L.mat'], 'same_regionL');
        %                     p = figure('Visible','on');   
        %                     imagesc(diceL)
        %                     title(['Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Left Across Raters'], 'FontSize', 10); % set title
        %                     colormap; % set the colorscheme
        %                     xticks((1:dl))
        %                     nameMe = strrep(nameMe,'_',' ');
        %                     xticklabels(nameMe);
        %                     yticks((1:dl))
        %                     yticklabels(nameMe);
        %                     xtickangle(45)
        %                     colorbar;
        %                     textStrings = num2str(diceL(:), '%0.2f');       % Create strings from the matrix values
        %                     textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
        %                     [x, y] = meshgrid(1:length(densityLDir));  % Create x and y coordinates for the strings
        %                     hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
        %                                     'HorizontalAlignment', 'center');
        % 
        %                     set(p,'Position', [1 1 1680 1050]);
        %                     disp([abbList{l} '_L has been processed!'])
        %                     pause

                        end
                    end
                    
                    if length(densityRDir) > 1
                        if length(strfind(densityRDir(2).name,'_R')) == 1
                            dr = length(densityRDir);
                            densityR = load_density(densityRDir);
                            [nameMe, diceR, same_regionR] = dice(densityRDir, densityR, threshold, dr);
        %                     save(['same_region', abbList{l},'_R.mat'], 'same_regionR');
                            cheat.right_similar = same_regionR;
                            cheat.right_count = length(same_regionR);

        %                     q = figure('Visible','on');   
        %                     imagesc(diceR)
        %                     title(['Dice Similarity Cross-Correlation Matrix for ' trackList{l} ' Right Across Raters'], 'FontSize', 10); % set title
        %                     colormap; % set the colorscheme
        %                     xticks((1:dr))
        %                     nameMe = strrep(nameMe,'_',' ');
        %                     xticklabels(nameMe);
        %                     yticks((1:dr))
        %                     yticklabels(nameMe);
        %                     xtickangle(45)
        %                     colorbar;
        %                     textStrings = num2str(diceR(:), '%0.2f');       % Create strings from the matrix values
        %                     textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
        %                     [x, y] = meshgrid(1:length(densityRDir));  % Create x and y coordinates for the strings
        %                     hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
        %                                     'HorizontalAlignment', 'center');
        %                     set(q,'Position', [1 1 1680 1050]);
        %                     disp([abbList{l} '_R has been processed!'])
        %                     pause

                        end
                    end
                end
            region_data = [region_data cheat];
            end
        end
    end
end

%%
sum([HCP.region_data.single_count]) + ...
sum([HCP.region_data.right_count]) + ...
sum([HCP.region_data.left_count])

seed1 = HCP.region_data(strcmp({HCP.region_data.region}, 'seed1'));
seed1_sum = sum([seed1.single_count]) + ...
sum([seed1.right_count]) + ...
sum([seed1.left_count]);
disp(seed1_sum)

seed2 = HCP.region_data(strcmp({HCP.region_data.region}, 'seed2'));
seed2_sum = sum([seed2.single_count]) + ...
sum([seed2.right_count]) + ...
sum([seed2.left_count]);
disp(seed2_sum)

ROI1 = HCP.region_data(strcmp({HCP.region_data.region}, 'ROI1'));
ROI1_sum = sum([ROI1.single_count]) + ...
sum([ROI1.right_count]) + ...
sum([ROI1.left_count]);
disp(ROI1_sum)

ROI2 = HCP.region_data(strcmp({HCP.region_data.region}, 'ROI2'));
ROI2_sum = sum([ROI2.single_count]) + ...
sum([ROI2.right_count]) + ...
sum([ROI2.left_count]);
disp(ROI2_sum)

ROI3 = HCP.region_data(strcmp({HCP.region_data.region}, 'ROI3'));
ROI3_sum = sum([ROI3.single_count]) + ...
sum([ROI3.right_count]) + ...
sum([ROI3.left_count]);
disp(ROI3_sum)

ROA1 = HCP.region_data(strcmp({HCP.region_data.region}, 'ROA1'));
ROA1_sum = sum([ROA1.single_count]) + ...
sum([ROA1.right_count]) + ...
sum([ROA1.left_count]);
disp(ROA1_sum)

HCP.region_data([HCP.region_data.single_count]>0)
HCP.region_data([HCP.region_data.right_count]>0)
HCP.region_data([HCP.region_data.left_count]>0)

%%
sum([BLSA.region_data.single_count]) + ...
sum([BLSA.region_data.right_count]) + ...
sum([BLSA.region_data.left_count])

seed1 = BLSA.region_data(strcmp({BLSA.region_data.region}, 'seed1'));
seed1_sum = sum([seed1.single_count]) + ...
sum([seed1.right_count]) + ...
sum([seed1.left_count]);
disp(seed1_sum)

seed2 = BLSA.region_data(strcmp({BLSA.region_data.region}, 'seed2'));
seed2_sum = sum([seed2.single_count]) + ...
sum([seed2.right_count]) + ...
sum([seed2.left_count]);
disp(seed2_sum)

ROI1 = BLSA.region_data(strcmp({BLSA.region_data.region}, 'ROI1'));
ROI1_sum = sum([ROI1.single_count]) + ...
sum([ROI1.right_count]) + ...
sum([ROI1.left_count]);
disp(ROI1_sum)

ROI2 = BLSA.region_data(strcmp({BLSA.region_data.region}, 'ROI2'));
ROI2_sum = sum([ROI2.single_count]) + ...
sum([ROI2.right_count]) + ...
sum([ROI2.left_count]);
disp(ROI2_sum)

ROI3 = BLSA.region_data(strcmp({BLSA.region_data.region}, 'ROI3'));
ROI3_sum = sum([ROI3.single_count]) + ...
sum([ROI3.right_count]) + ...
sum([ROI3.left_count]);
disp(ROI3_sum)

ROA1 = BLSA.region_data(strcmp({BLSA.region_data.region}, 'ROA1'));
ROA1_sum = sum([ROA1.single_count]) + ...
sum([ROA1.right_count]) + ...
sum([ROA1.left_count]);
disp(ROA1_sum)

BLSA.region_data([BLSA.region_data.single_count]>0)
BLSA.region_data([BLSA.region_data.right_count]>0)
BLSA.region_data([BLSA.region_data.left_count]>0)
%%
save('same_region.mat', 'region_data')
