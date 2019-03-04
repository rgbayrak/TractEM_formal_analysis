% Reproducibility intra-subject
% Author: roza.g.bayrak@vanderbilt.edu

clear all;
close all;
clc;

% Load the data
BLSA19 = load('reproducibility/BLSA19_auto_icc.mat');
% BLSA19_auto = load('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg/tractem/analysis/reproducibility/BLSA19_Aug24_01.mat');
% BLSA19_table = struct2table(BLSA19.all_dice);
% BLSA19_auto_table = struct2table(BLSA19_auto.all_dice);

% %% Tract Reproducibility Analysis
% 
mask_BLSA19_tract = unique({BLSA19.all_dice.tract});
% mask_BLSA19_auto_tract = unique({BLSA19_auto.all_dice.tract});
% 
BLSA19_tract = [];
for t = 1:length(mask_BLSA19_tract)
    mask_per_tract = strcmp({BLSA19.all_dice.tract}, mask_BLSA19_tract(t));
    tmp_tract = BLSA19.all_dice(mask_per_tract);
    
    tmp_BLSA19_dice = [];
    for d = 1:length(tmp_tract)
        tmp_BLSA19_dice(d, 1) = tmp_tract(d).dice;
    end
  
    if size(BLSA19_tract,1) > size(tmp_BLSA19_dice,1)
        tmp_BLSA19_dice = [tmp_BLSA19_dice; nan(size(BLSA19_tract,1) - size(tmp_BLSA19_dice,1), 1)];
    else
        BLSA19_tract= [BLSA19_tract; nan(size(tmp_BLSA19_dice,1) - size(BLSA19_tract,1), size(BLSA19_tract,2))];
    end
    BLSA19_tract = [BLSA19_tract tmp_BLSA19_dice];
end
% % 
% BLSA19_auto_tract = [];
% for t = 1:length(mask_BLSA19_auto_tract)
%     mask_per_tract = strcmp({BLSA19_auto.all_dice.tract}, mask_BLSA19_auto_tract(t));
%     tmp_tract = BLSA19_auto.all_dice(mask_per_tract);
%     
%     tmp_BLSA19_dice = [];
%     for d = 1:length(tmp_tract)
%         tmp_BLSA19_dice(d, 1) = tmp_tract(d).dice;
%     end
%   
%     if size(BLSA19_auto_tract,1) > size(tmp_BLSA19_dice,1)
%         tmp_BLSA19_dice = [tmp_BLSA19_dice; nan(size(BLSA19_auto_tract,1) - size(tmp_BLSA19_dice,1), 1)];
%     else
%         BLSA19_auto_tract= [BLSA19_auto_tract; nan(size(tmp_BLSA19_dice,1) - size(BLSA19_auto_tract,1), size(BLSA19_auto_tract,2))];
%     end
%     BLSA19_auto_tract = [BLSA19_auto_tract tmp_BLSA19_dice];
% end
% 



% % end of Tract Reproducibility Analysis



% %% Rater Reproducibility Analysis
% % 
mask_BLSA19_rater = unique({BLSA19.all_dice.rater1 BLSA19.all_dice.rater2});
% mask_BLSA19_auto_rater = unique({BLSA19_auto.all_dice.rater1 BLSA19_auto.all_dice.rater2});
% %
% % 
% To exclude some raters
list_BLSA19_rater = unique({BLSA19.all_dice.rater1 BLSA19.all_dice.rater2});
mask_BLSA19_rater = zeros(1,length(list_BLSA19_rater));
list = {'Aviral','Bruce','Cam','Christa','Eugene','Jasmine','Roza','Xuan','Yi', 'Yufei', 'auto'};
for l = 1:length(list)
    mask_BLSA19_rater = mask_BLSA19_rater + strcmp(list_BLSA19_rater, list(l));
end
mask_BLSA19_rater = list_BLSA19_rater(logical(mask_BLSA19_rater));

BLSA19_rater = [];
for t = 1:length(mask_BLSA19_rater)
    
    mask_per_rater1 = strcmp({BLSA19.all_dice.rater1}, mask_BLSA19_rater(t));
    mask_per_rater2 = strcmp({BLSA19.all_dice.rater2}, mask_BLSA19_rater(t));
    
    tmp_rater1 = BLSA19.all_dice(mask_per_rater1);
    tmp_rater2 = BLSA19.all_dice(mask_per_rater2);
    
%     tmp_mask_1 = ~strcmp({tmp_1.rater2}, 'xxx'); % excluding cross relation of the rater
%     tmp_rater1 = tmp_1(tmp_mask_1);
%     
%     tmp_mask_2 = ~strcmp({tmp_2.rater1}, 'xxx');
%     tmp_rater2 = tmp_2(tmp_mask_2);
 
    tmp_BLSA19_dice1 = [];
    for g = 1:length(tmp_rater1)
        tmp_BLSA19_dice1(g, 1) = tmp_rater1(g).dice;
    end
    
    tmp_BLSA19_dice2 = [];
    for h = 1:length(tmp_rater2)
        tmp_BLSA19_dice2(h, 1) = tmp_rater2(h).dice;
    end
    
    tmp_BLSA19_dice = [];
    tmp_BLSA19_dice = [tmp_BLSA19_dice1; tmp_BLSA19_dice2];
    
    % padding with NaN
    if size(tmp_BLSA19_dice,1) > size(BLSA19_rater,1)
        BLSA19_rater= [BLSA19_rater; nan(size(tmp_BLSA19_dice,1) - size(BLSA19_rater,1), size(BLSA19_rater,2))]; % adding rows
    else
        tmp_BLSA19_dice = [tmp_BLSA19_dice; nan(size(BLSA19_rater,1) - size(tmp_BLSA19_dice,1), 1)]; % adding rows
    end
    BLSA19_rater = [BLSA19_rater tmp_BLSA19_dice]; % adding columns
    
end


% % To exclude some raters
% list_BLSA19_auto_rater = unique({BLSA19_auto.all_dice.rater1 BLSA19_auto.all_dice.rater2});
% mask_BLSA19_auto_rater = zeros(1,length(list_BLSA19_auto_rater));
% list = {'Aviral','Bruce','Cam','Christa','Eugene','Jasmine','Roza','Xuan','Yi', 'Yufei', 'auto'};
% for l = 1:length(list)
%     mask_BLSA19_auto_rater = mask_BLSA19_auto_rater + strcmp(list_BLSA19_auto_rater, list(l));
% end
% mask_BLSA19_auto_rater = list_BLSA19_auto_rater(logical(mask_BLSA19_auto_rater));
% 
% BLSA19_auto_rater = [];
% for t = 1:length(mask_BLSA19_auto_rater)
%     
%     mask_per_rater1 = strcmp({BLSA19_auto.all_dice.rater1}, mask_BLSA19_auto_rater(t));
%     mask_per_rater2 = strcmp({BLSA19_auto.all_dice.rater2}, mask_BLSA19_auto_rater(t));
%     
%     tmp_rater1 = BLSA19_auto.all_dice(mask_per_rater1);
%     tmp_rater2 = BLSA19_auto.all_dice(mask_per_rater2);
%     
% %     tmp_mask_1 = ~strcmp({tmp_1.rater2}, 'xxx');
% %     tmp_rater1 = tmp_1(tmp_mask_1);
% %     
% %     tmp_mask_2 = ~strcmp({tmp_2.rater1}, 'xxx');
% %     tmp_rater2 = tmp_2(tmp_mask_2);
%     
%     tmp_BLSA19_dice1 = [];
%     for g = 1:length(tmp_rater1)
%         tmp_BLSA19_dice1(g, 1) = tmp_rater1(g).dice;
%     end
%     
%     tmp_BLSA19_dice2 = [];
%     for h = 1:length(tmp_rater2)
%         tmp_BLSA19_dice2(h, 1) = tmp_rater2(h).dice;
%     end
%     
%     tmp_BLSA19_dice = [];
%     tmp_BLSA19_dice = [tmp_BLSA19_dice1; tmp_BLSA19_dice2];
%     
%     % padding with NaN
%     if size(tmp_BLSA19_dice,1) > size(BLSA19_auto_rater,1)
%         BLSA19_auto_rater= [BLSA19_auto_rater; nan(size(tmp_BLSA19_dice,1) - size(BLSA19_auto_rater,1), size(BLSA19_auto_rater,2))]; % padding with rows
%     else
%         tmp_BLSA19_dice = [tmp_BLSA19_dice; nan(size(BLSA19_auto_rater,1) - size(tmp_BLSA19_dice,1), 1)]; % padding with rows
%     end
%     BLSA19_auto_rater = [BLSA19_auto_rater tmp_BLSA19_dice]; % adding columns
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

% sorting BLSA19 tracts
sorted_tractList = [];        

% sort the intra-subject tract dice 
BLSA19_mean = nanmedian(BLSA19_tract, 1);
[~, sort_idx] = sort(BLSA19_mean,'descend');
BLSA19_sorted_tract = nan(size(BLSA19_tract));
for i=1:size(BLSA19_tract, 2)
    BLSA19_sorted_tract(:,i) = BLSA19_tract(:,sort_idx(i));
    sorted_tractList{i} = tractList61{sort_idx(i)};
end

% % % sorting auto tracts
% auto_mean = nanmean(BLSA19_auto_tract, 1);
% [~, sort_auto_idx] = sort(auto_mean,'descend');
% auto_sorted_tract = zeros(size(BLSA19_auto_tract));
% BLSA19_auto_tract(isnan(BLSA19_auto_tract)) = 0;
% for i=1:size(BLSA19_auto_tract, 2)
%     auto_sorted_tract(:,i) = BLSA19_auto_tract(:,sort_auto_idx(i));
%     auto_sorted_tractList{i} = tractList61{sort_auto_idx(i)};
% end
% 

% % merge plot
% BLSA19_merged_tract = [];
% auto_sorted_tract = [auto_sorted_tract; nan(size(BLSA19_sorted_tract,1) - size(auto_sorted_tract,1), size(BLSA19_sorted_tract,2))];
% 
% for g = 1:size(BLSA19_sorted_tract,2)
%     BLSA19_merged_tract = [BLSA19_merged_tract BLSA19_sorted_tract(:,g)];
%     BLSA19_merged_tract = [BLSA19_merged_tract auto_sorted_tract(:,g)];
% end

% Human Tracts Plot
figure(1)
g = boxplot(BLSA19_sorted_tract,'Widths',0.6);
set(findobj(gcf,'tag','Median'), 'Color', [0 0 0.2]);
a = get(get(gca, 'children'),'children');
t = get(a, 'tag');

% % B.LSA
% lobes = a(176:183);
% simple = a(123:175);
% complex = a([123, 124, 125, 127, 128, 129, 131, 132, 133, 134, 135, 139, 140, 141, 143, 144, 149, 151, 156, 157, 159, 160, 165, 169, 170, 172, 173]);
% H.CP
% lobes = a([154, 157, 160, 164, 166, 170, 171, 172]);
% simple = a(123:183);
% complex = a([123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 135, 136, 137, 138, 139, 142, 146, 148, 149, 152, 159, 163, 165, 167, 175, 183]);
% 
% set(simple, 'Color', [0 0 0.2], 'linewidth',1.5);
% set(lobes, 'Color', [0 0.4 0.6], 'linewidth',1.5);
% set(complex, 'Color', [0.6 0.2 0], 'linewidth',1.5);
ylim([-.1 1.1])
% set(g,'Position', [1 1 1680 1050]);
title('Intra-subject Inter-rater Tract Reproducibility for BLSA19', 'FontSize', 18)
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
h = boxplot(BLSA19_rater);
red  = [0.6 0.2 0];
blue = [0 0 0.2];
set(findobj(gcf,'tag','Median'), 'Color', blue, 'linewidth',1.5);
set(findobj(gcf,'tag','Box'), 'Color', blue, 'linewidth',1.5);
h = findobj(gcf,'tag','Outliers');
for iH = 1:length(h)
    h(iH).MarkerEdgeColor = red;
end
alpha(.9)
% set(figure(4),'Position', [1 1 1680 1050]);
xticklabels(mask_BLSA19_rater)
ylabel('Intraclass Correlation', 'FontSize', 18)
% xticklabels({'R1', 'R2', 'R3',  'R4',  'R5',  'R6',  'R7', 'R8', 'R9'});
title('Rater Reproducibility for BLSA19', 'FontSize', 18)
grid minor;
% 
% % Auto Rater Plot
% figure(3); 
% k = boxplot(BLSA19_auto_rater);
% red  = [198 0 0]./255;
% blue = [0 123 198]./255;
% set(findobj(gcf,'tag','Median'), 'Color', blue);
% set(findobj(gcf,'tag','Box'), 'Color', red);
% k = findobj(gcf,'tag','Outliers');
% for iK = 1:length(k)
%     k(iK).MarkerEdgeColor = red;
% end
% % set(figure(4),'Position', [1 1 1680 1050]);
% xticklabels(mask_BLSA19_auto_rater)
% xticklabels({'R1', 'R2', 'R3',  'R4',  'R5',  'R6',  'R7', 'R8', 'R9'});
% title('Intra-subject Inter-rater Reproducibility for BLSA19')
% grid minor;

%% 
% Rater Reproducibility by tract
BLSA = load('reproducibility/BLSA19_auto_cdice.mat');

% To exclude some raters
list_BLSA_rater = unique({BLSA.all_dice.rater1 BLSA.all_dice.rater2});
mask_BLSA_rater = zeros(1,length(list_BLSA_rater));
list = {'Aviral','Bruce','Cam','Christa','Eugene','Jasmine','Roza','Xuan','Yi', 'Yufei', 'auto'};
for l = 1:length(list)
    mask_BLSA_rater = mask_BLSA_rater + strcmp(list_BLSA_rater, list(l));
end
mask_BLSA_rater = list_BLSA_rater(logical(mask_BLSA_rater));

list_BLSA_tract = unique({BLSA.all_dice.tract});
mask_BLSA_tract = zeros(1,length(list_BLSA_tract));

BLSA_rater = [];
BLSA_tract = [];

for t = 1:length(list_BLSA_tract)
    mask_per_tract = strcmp({BLSA.all_dice.tract}, list_BLSA_tract(t));
    tmp_tract = BLSA.all_dice(mask_per_tract);
    BLSA_rater = [];
    for cc = 1:length(mask_BLSA_rater)
        close all;

        mask_per_tr_rater1 = strcmp({tmp_tract.rater1}, mask_BLSA_rater(cc));
        mask_per_tr_rater2 = strcmp({tmp_tract.rater2}, mask_BLSA_rater(cc));

        tmp_rater1 = tmp_tract(mask_per_tr_rater1);
        tmp_rater2 = tmp_tract(mask_per_tr_rater2);    
        
        tmp_BLSA_dice1 = [];
        for g = 1:length(tmp_rater1)
            tmp_BLSA_dice1(g, 1) = tmp_rater1(g).dice;
        end
    
        tmp_BLSA_dice2 = [];
        for h = 1:length(tmp_rater2)
            tmp_BLSA_dice2(h, 1) = tmp_rater2(h).dice;
        end
        
        tmp_BLSA_dice = [];
        tmp_BLSA_dice = [tmp_BLSA_dice1; tmp_BLSA_dice2];
        
        % padding with NaN
        if size(tmp_BLSA_dice,1) > size(BLSA_rater,1)
            BLSA_rater= [BLSA_rater; nan(size(tmp_BLSA_dice,1) - size(BLSA_rater,1), size(BLSA_rater,2))]; % adding rows
        else
            tmp_BLSA_dice = [tmp_BLSA_dice; nan(size(BLSA_rater,1) - size(tmp_BLSA_dice,1), 1)]; % adding rows
        end
        BLSA_rater = [BLSA_rater tmp_BLSA_dice]; % adding columns
    end 
    
    % Raters Plot
    figure; 
    h = boxplot(BLSA_rater);
    red  = [0.6 0.2 0];
    blue = [0 0 0.2];
    set(findobj(gcf,'tag','Median'), 'Color', blue, 'linewidth',1.5);
    set(findobj(gcf,'tag','Box'), 'Color', blue, 'linewidth',1.5);
    h = findobj(gcf,'tag','Outliers');
    for iH = 1:length(h)
        h(iH).MarkerEdgeColor = red;
    end
    alpha(.9)
    % set(figure(4),'Position', [1 1 1680 1050]);
    xticklabels(mask_BLSA_rater)
    ylabel('cDice', 'FontSize', 18)
    % xticklabels({'R1', 'R2', 'R3',  'R4',  'R5',  'R6',  'R7', 'R8', 'R9'});
    title(list_BLSA_tract(t), 'FontSize', 18)
    grid minor;
    pause
end