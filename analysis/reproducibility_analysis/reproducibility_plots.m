% Reproducibility intra-subject
% Author: roza.g.bayrak@vanderbilt.edu

clear all;
close all;
clc;

% Load the data
HCP = load('reproducibility/HCP_Dec_cdice.mat');
% HCP_auto = load('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg/tractem/analysis/reproducibility/HCP_Aug24_01.mat');
% HCP_table = struct2table(HCP.all_dice);
% HCP_auto_table = struct2table(HCP_auto.all_dice);

% %% Tract Reproducibility Analysis
% 
mask_HCP_tract = unique({HCP.all_dice.tract});
% mask_HCP_auto_tract = unique({HCP_auto.all_dice.tract});
% 
HCP_tract = [];
for t = 1:length(mask_HCP_tract)
    mask_per_tract = strcmp({HCP.all_dice.tract}, mask_HCP_tract(t));
    tmp_tract = HCP.all_dice(mask_per_tract);
    
    tmp_HCP_dice = [];
    for d = 1:length(tmp_tract)
        tmp_HCP_dice(d, 1) = tmp_tract(d).dice;
    end
  
    if size(HCP_tract,1) > size(tmp_HCP_dice,1)
        tmp_HCP_dice = [tmp_HCP_dice; nan(size(HCP_tract,1) - size(tmp_HCP_dice,1), 1)];
    else
        HCP_tract= [HCP_tract; nan(size(tmp_HCP_dice,1) - size(HCP_tract,1), size(HCP_tract,2))];
    end
    HCP_tract = [HCP_tract tmp_HCP_dice];
end
% % 
% HCP_auto_tract = [];
% for t = 1:length(mask_HCP_auto_tract)
%     mask_per_tract = strcmp({HCP_auto.all_dice.tract}, mask_HCP_auto_tract(t));
%     tmp_tract = HCP_auto.all_dice(mask_per_tract);
%     
%     tmp_HCP_dice = [];
%     for d = 1:length(tmp_tract)
%         tmp_HCP_dice(d, 1) = tmp_tract(d).dice;
%     end
%   
%     if size(HCP_auto_tract,1) > size(tmp_HCP_dice,1)
%         tmp_HCP_dice = [tmp_HCP_dice; nan(size(HCP_auto_tract,1) - size(tmp_HCP_dice,1), 1)];
%     else
%         HCP_auto_tract= [HCP_auto_tract; nan(size(tmp_HCP_dice,1) - size(HCP_auto_tract,1), size(HCP_auto_tract,2))];
%     end
%     HCP_auto_tract = [HCP_auto_tract tmp_HCP_dice];
% end
% 



% % end of Tract Reproducibility Analysis



% %% Rater Reproducibility Analysis
% % 
mask_HCP_rater = unique({HCP.all_dice.rater1 HCP.all_dice.rater2});
% mask_HCP_auto_rater = unique({HCP_auto.all_dice.rater1 HCP_auto.all_dice.rater2});
% %
% % 
% To exclude some raters
list_HCP_rater = unique({HCP.all_dice.rater1 HCP.all_dice.rater2});
mask_HCP_rater = zeros(1,length(list_HCP_rater));
list = {'Aviral','Bruce','Cam','Christa','Eugene','Jasmine','Roza','Xuan','Yi', 'Yufei', 'auto'};
for l = 1:length(list)
    mask_HCP_rater = mask_HCP_rater + strcmp(list_HCP_rater, list(l));
end
mask_HCP_rater = list_HCP_rater(logical(mask_HCP_rater));

HCP_rater = [];
for t = 1:length(mask_HCP_rater)
    
    mask_per_rater1 = strcmp({HCP.all_dice.rater1}, mask_HCP_rater(t));
    mask_per_rater2 = strcmp({HCP.all_dice.rater2}, mask_HCP_rater(t));
    
    tmp_rater1 = HCP.all_dice(mask_per_rater1);
    tmp_rater2 = HCP.all_dice(mask_per_rater2);
    
%     tmp_mask_1 = ~strcmp({tmp_1.rater2}, 'xxx'); % excluding cross relation of the rater
%     tmp_rater1 = tmp_1(tmp_mask_1);
%     
%     tmp_mask_2 = ~strcmp({tmp_2.rater1}, 'xxx');
%     tmp_rater2 = tmp_2(tmp_mask_2);
 
    tmp_HCP_dice1 = [];
    for g = 1:length(tmp_rater1)
        tmp_HCP_dice1(g, 1) = tmp_rater1(g).dice;
    end
    
    tmp_HCP_dice2 = [];
    for h = 1:length(tmp_rater2)
        tmp_HCP_dice2(h, 1) = tmp_rater2(h).dice;
    end
    
    tmp_HCP_dice = [];
    tmp_HCP_dice = [tmp_HCP_dice1; tmp_HCP_dice2];
    
    % padding with NaN
    if size(tmp_HCP_dice,1) > size(HCP_rater,1)
        HCP_rater= [HCP_rater; nan(size(tmp_HCP_dice,1) - size(HCP_rater,1), size(HCP_rater,2))]; % adding rows
    else
        tmp_HCP_dice = [tmp_HCP_dice; nan(size(HCP_rater,1) - size(tmp_HCP_dice,1), 1)]; % adding rows
    end
    HCP_rater = [HCP_rater tmp_HCP_dice]; % adding columns
    
end


% % To exclude some raters
% list_HCP_auto_rater = unique({HCP_auto.all_dice.rater1 HCP_auto.all_dice.rater2});
% mask_HCP_auto_rater = zeros(1,length(list_HCP_auto_rater));
% list = {'Aviral','Bruce','Cam','Christa','Eugene','Jasmine','Roza','Xuan','Yi', 'Yufei', 'auto'};
% for l = 1:length(list)
%     mask_HCP_auto_rater = mask_HCP_auto_rater + strcmp(list_HCP_auto_rater, list(l));
% end
% mask_HCP_auto_rater = list_HCP_auto_rater(logical(mask_HCP_auto_rater));
% 
% HCP_auto_rater = [];
% for t = 1:length(mask_HCP_auto_rater)
%     
%     mask_per_rater1 = strcmp({HCP_auto.all_dice.rater1}, mask_HCP_auto_rater(t));
%     mask_per_rater2 = strcmp({HCP_auto.all_dice.rater2}, mask_HCP_auto_rater(t));
%     
%     tmp_rater1 = HCP_auto.all_dice(mask_per_rater1);
%     tmp_rater2 = HCP_auto.all_dice(mask_per_rater2);
%     
% %     tmp_mask_1 = ~strcmp({tmp_1.rater2}, 'xxx');
% %     tmp_rater1 = tmp_1(tmp_mask_1);
% %     
% %     tmp_mask_2 = ~strcmp({tmp_2.rater1}, 'xxx');
% %     tmp_rater2 = tmp_2(tmp_mask_2);
%     
%     tmp_HCP_dice1 = [];
%     for g = 1:length(tmp_rater1)
%         tmp_HCP_dice1(g, 1) = tmp_rater1(g).dice;
%     end
%     
%     tmp_HCP_dice2 = [];
%     for h = 1:length(tmp_rater2)
%         tmp_HCP_dice2(h, 1) = tmp_rater2(h).dice;
%     end
%     
%     tmp_HCP_dice = [];
%     tmp_HCP_dice = [tmp_HCP_dice1; tmp_HCP_dice2];
%     
%     % padding with NaN
%     if size(tmp_HCP_dice,1) > size(HCP_auto_rater,1)
%         HCP_auto_rater= [HCP_auto_rater; nan(size(tmp_HCP_dice,1) - size(HCP_auto_rater,1), size(HCP_auto_rater,2))]; % padding with rows
%     else
%         tmp_HCP_dice = [tmp_HCP_dice; nan(size(HCP_auto_rater,1) - size(tmp_HCP_dice,1), 1)]; % padding with rows
%     end
%     HCP_auto_rater = [HCP_auto_rater tmp_HCP_dice]; % adding columns
%     
% end

% % The end of Rater Reproducibility Analysis

%%

tractList61 = {'Anterior Commissure'; 'Anterior Corona Radiata Left';'Anterior Corona Radiata Right'; 'Anterior Limb Internal Capsule Left';'Anterior Limb Internal Capsule Right';'Body Corpus Callosum';...
            'Cingulum Cingulate Gyrus Left';'Cingulum Cingulate Gyrus Right'; 'Cingulum Hippocampal Left'; ...
            'Cingulum Hippocampal Right';'Cerebral Peduncle Left';'Cerebral Peduncle Right';...
            'Corticospinal Tract Left';'Corticospinal Tract Right';'Frontal Lobe Left';'Frontal Lobe Right';'Fornix Left';'Fornix Right';'Fornix Stria Terminalis Left';'Fornix Stria Terminalis Right';...
            'Genu Corpus Callosum';'Inferior Cerebellar Peduncle Left';'Inferior Cerebellar Peduncle Right'; ...
            'Inferior Fronto Occipital Fasciculus Left';'Inferior Fronto Occipital Fasciculus Right';'Inferior Longitudinal Fasciculus Left';'Inferior Longitudinal Fasciculus Right';...
            'Midbrain';'Middle Cerebellar Peduncle';'Medial Lemniscus Left';'Medial Lemniscus Right';'Occipital Lobe Left';'Occipital Lobe Right'; ...
            'Olfactory Radiation Left';'Olfactory Radiation Right';'Optic Tract';...
            'Posterior Corona Radiata Left';'Posterior Corona Radiata Right';'Pontine Crossing Tract';...
            'Posterior Limb Internal Capsule Left';'Posterior Limb Internal Capsule Right';'Parietal Lobe Left';'Parietal Lobe Right';...
            'Posterior Thalamic Radiation Left';'Posterior Thalamic Radiation Right';'Splenium Corpus Callosum';...
            'Superior Cerebellar Peduncle Left';'Superior Cerebellar Peduncle Right';'Superior Corona Radiata Left';'Superior Corona Radiata Right'; ...
            'Superior Fronto Occipital Fasciculus Left';'Superior Fronto Occipital Fasciculus Right';'Superior Longitudinal Fasciculus Left';'Superior Longitudinal Fasciculus Right';...
             'Sagittal Stratum Left';'Sagittal Stratum Right';'Tapetum Corpus Callosum';'Temporal Lobe Left';'Temporal Lobe Right';'Uncinate Fasciculus Left';'Uncinate Fasciculus Right'};

% tractList35 = {'Anterior Commissure'; 'Anterior Corona Radiata'; 'Anterior Limb Internal Capsule';'Body Corpus Callosum';...
%             'Cingulum Cingulate Gyrus'; 'Cingulum Hippocampal';'Cerebral Peduncle';...
%             'Corticospinal Tract';'Frontal Lobe';'Fornix';'Fornix Stria Terminalis';...
%             'Genu Corpus Callosum';'Inferior Cerebellar Peduncle'; ...
%             'Inferior Fronto Occipital Fasciculus';'Inferior Longitudinal Fasciculus';...
%             'Midbrain';'Middle Cerebellar Peduncle';'Medial Lemniscus';'Occipital Lobe'; ...
%             'Olfactory Radiation';'Optic Tract';...
%             'Posterior Corona Radiata';'Pontine Crossing Tract';...
%             'Posteriorlimb Internal Capsule';'Parietal Lobe';...
%             'Posterior Thalamic Radiation';'Splenium Corpus Callosum';...
%             'Superior Cerebellar Peduncle';'Superior Corona Radiata'; ...
%             'Superior Fronto Occipital Fasciculus';'Superior Longitudinal Fasciculus';...
%              'Sagittal Stratum';'Tapetum Corpus Callosum';'Temporal Lobe';'Uncinate Fasciculus'};



%% Sorting the tracts

% % sorting by distance (ar1+ar2)/2 - rr
% diff_mean = nanmean(dice_ar_rr, 1);
% [~, sort_diff_idx] = sort(dice_ar_rr,'descend');
% diff_sorted_tract = nan(size(dice_ar_rr));
% for i=1:size(dice_ar_rr, 2)
% diff_sorted_tract(i) = dice_ar_rr(sort_diff_idx(i));
% sorted_diff_tractList{i} = tractList{sort_diff_idx(i)};
% end

% sorting HCP tracts
sorted_tractList = [];         
% sort the intra-subject tract dice 
HCP_mean = nanmedian(HCP_tract, 1);
[~, sort_idx] = sort(HCP_mean,'descend');
HCP_sorted_tract = nan(size(HCP_tract));
for i=1:size(HCP_tract, 2)
    HCP_sorted_tract(:,i) = HCP_tract(:,sort_idx(i));
    sorted_tractList{i} = tractList61{sort_idx(i)};
end

% % % sorting auto tracts
% auto_mean = nanmean(HCP_auto_tract, 1);
% [~, sort_auto_idx] = sort(auto_mean,'descend');
% auto_sorted_tract = zeros(size(HCP_auto_tract));
% HCP_auto_tract(isnan(HCP_auto_tract)) = 0;
% for i=1:size(HCP_auto_tract, 2)
%     auto_sorted_tract(:,i) = HCP_auto_tract(:,sort_auto_idx(i));
%     auto_sorted_tractList{i} = tractList61{sort_auto_idx(i)};
% end
% 

% % merge plot
% HCP_merged_tract = [];
% auto_sorted_tract = [auto_sorted_tract; nan(size(HCP_sorted_tract,1) - size(auto_sorted_tract,1), size(HCP_sorted_tract,2))];
% 
% for g = 1:size(HCP_sorted_tract,2)
%     HCP_merged_tract = [HCP_merged_tract HCP_sorted_tract(:,g)];
%     HCP_merged_tract = [HCP_merged_tract auto_sorted_tract(:,g)];
% end

% Human Tracts Plot
figure(1)
g = boxplot(HCP_sorted_tract,'Widths',0.6);
red  = [198 0 0]./255;
blue = [0 123 198]./255;
set(findobj(gcf,'tag','Median'), 'Color', blue);
set(findobj(gcf,'tag','Box'), 'Color', red);
g = findobj(gcf,'tag','Outliers');
for iG = 1:length(g)
    g(iG).MarkerEdgeColor = red;
end
ylim([-.1 1.1])
% set(g,'Position', [1 1 1680 1050]);
title('Intra-subject Inter-rater Tract Reproducibility for HCP', 'FontSize', 12)
ylabel('Intraclass Correlation', 'FontSize', 18)
xticks(1:1:61)
xticklabels(sorted_tractList);
xtickangle(45);
grid minor;
% vline(0, 'good')
% vline(7.5, 'ok')
% vline(17.5, 'bad')

% % Auto Tracts Plot
% figure(2)
% f = boxplot(auto_sorted_tract,'Widths',0.5);
% set(figure(2),'Position', [1 1 1680 1050]);
% xticklabels(auto_sorted_tractList);
% title('Intra-subject Tract Reproducibility for Auto Sorted')
% xtickangle(45);
% grid minor;

% Human Raters Plot
figure(3); 
h = boxplot(HCP_rater);
red  = [198 0 0]./255;
blue = [0 123 198]./255;
set(findobj(gcf,'tag','Median'), 'Color', blue);
set(findobj(gcf,'tag','Box'), 'Color', red);
h = findobj(gcf,'tag','Outliers');
for iH = 1:length(h)
    h(iH).MarkerEdgeColor = red;
end
alpha(.9)
% set(figure(4),'Position', [1 1 1680 1050]);
xticklabels(mask_HCP_rater)
ylabel('Dice Coefficient', 'FontSize', 12)
% xticklabels({'R1', 'R2', 'R3',  'R4',  'R5',  'R6',  'R7', 'R8', 'R9'});
title('Rater Reproducibility for HCP', 'FontSize', 12)
grid minor;
% 
% % Auto Rater Plot
% figure(3); 
% k = boxplot(HCP_auto_rater);
% red  = [198 0 0]./255;
% blue = [0 123 198]./255;
% set(findobj(gcf,'tag','Median'), 'Color', blue);
% set(findobj(gcf,'tag','Box'), 'Color', red);
% k = findobj(gcf,'tag','Outliers');
% for iK = 1:length(k)
%     k(iK).MarkerEdgeColor = red;
% end
% % set(figure(4),'Position', [1 1 1680 1050]);
% xticklabels(mask_HCP_auto_rater)
% xticklabels({'R1', 'R2', 'R3',  'R4',  'R5',  'R6',  'R7', 'R8', 'R9'});
% title('Intra-subject Inter-rater Reproducibility for HCP')
% grid minor;