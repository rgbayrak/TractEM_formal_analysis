% Reproducibility intra-subject
% Author: roza.g.bayrak@vanderbilt.edu

clear all;
close all;
clc;

% Load the data
BLSA = load('reproducibility/BLSA00_Apr_dice.mat');
% BLSA_auto = load('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg/tractem/analysis/reproducibility/BLSA_Aug24_01.mat');
% BLSA_table = struct2table(BLSA.all_dice);
% BLSA_auto_table = struct2table(BLSA_auto.all_dice);

% %% Tract Reproducibility Analysis
% 
mask_BLSA_tract = unique({BLSA.all_dice.tract});
% mask_BLSA_auto_tract = unique({BLSA_auto.all_dice.tract});
% 
BLSA_tract = [];
for t = 1:length(mask_BLSA_tract)
    mask_per_tract = strcmp({BLSA.all_dice.tract}, mask_BLSA_tract(t));
    tmp_tract = BLSA.all_dice(mask_per_tract);
    
    tmp_BLSA_dice = [];
    for d = 1:length(tmp_tract)
        tmp_BLSA_dice(d, 1) = tmp_tract(d).dice;
    end
  
    if size(BLSA_tract,1) > size(tmp_BLSA_dice,1)
        tmp_BLSA_dice = [tmp_BLSA_dice; nan(size(BLSA_tract,1) - size(tmp_BLSA_dice,1), 1)];
    else
        BLSA_tract= [BLSA_tract; nan(size(tmp_BLSA_dice,1) - size(BLSA_tract,1), size(BLSA_tract,2))];
    end
    BLSA_tract = [BLSA_tract tmp_BLSA_dice];
end
% % 
% BLSA_auto_tract = [];
% for t = 1:length(mask_BLSA_auto_tract)
%     mask_per_tract = strcmp({BLSA_auto.all_dice.tract}, mask_BLSA_auto_tract(t));
%     tmp_tract = BLSA_auto.all_dice(mask_per_tract);
%     
%     tmp_BLSA_dice = [];
%     for d = 1:length(tmp_tract)
%         tmp_BLSA_dice(d, 1) = tmp_tract(d).dice;
%     end
%   
%     if size(BLSA_auto_tract,1) > size(tmp_BLSA_dice,1)
%         tmp_BLSA_dice = [tmp_BLSA_dice; nan(size(BLSA_auto_tract,1) - size(tmp_BLSA_dice,1), 1)];
%     else
%         BLSA_auto_tract= [BLSA_auto_tract; nan(size(tmp_BLSA_dice,1) - size(BLSA_auto_tract,1), size(BLSA_auto_tract,2))];
%     end
%     BLSA_auto_tract = [BLSA_auto_tract tmp_BLSA_dice];
% end
% 



% % end of Tract Reproducibility Analysis



% %% Rater Reproducibility Analysis
% % 
mask_BLSA_rater = unique({BLSA.all_dice.rater1 BLSA.all_dice.rater2});
% mask_BLSA_auto_rater = unique({BLSA_auto.all_dice.rater1 BLSA_auto.all_dice.rater2});
% %
% % 
% To exclude some raters
list_BLSA_rater = unique({BLSA.all_dice.rater1 BLSA.all_dice.rater2});
mask_BLSA_rater = zeros(1,length(list_BLSA_rater));
list = {'Aviral','Bruce','Cam','Christa','Eugene','Jasmine','Roza','Xuan','Yi', 'Yufei', 'auto'};
for l = 1:length(list)
    mask_BLSA_rater = mask_BLSA_rater + strcmp(list_BLSA_rater, list(l));
end
mask_BLSA_rater = list_BLSA_rater(logical(mask_BLSA_rater));

BLSA_rater = [];
for t = 1:length(mask_BLSA_rater)
    
    mask_per_rater1 = strcmp({BLSA.all_dice.rater1}, mask_BLSA_rater(t));
    mask_per_rater2 = strcmp({BLSA.all_dice.rater2}, mask_BLSA_rater(t));
    
    tmp_rater1 = BLSA.all_dice(mask_per_rater1);
    tmp_rater2 = BLSA.all_dice(mask_per_rater2);
    
%     tmp_mask_1 = ~strcmp({tmp_1.rater2}, 'xxx'); % excluding cross relation of the rater
%     tmp_rater1 = tmp_1(tmp_mask_1);
%     
%     tmp_mask_2 = ~strcmp({tmp_2.rater1}, 'xxx');
%     tmp_rater2 = tmp_2(tmp_mask_2);
 
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


% % To exclude some raters
% list_BLSA_auto_rater = unique({BLSA_auto.all_dice.rater1 BLSA_auto.all_dice.rater2});
% mask_BLSA_auto_rater = zeros(1,length(list_BLSA_auto_rater));
% list = {'Aviral','Bruce','Cam','Christa','Eugene','Jasmine','Roza','Xuan','Yi', 'Yufei', 'auto'};
% for l = 1:length(list)
%     mask_BLSA_auto_rater = mask_BLSA_auto_rater + strcmp(list_BLSA_auto_rater, list(l));
% end
% mask_BLSA_auto_rater = list_BLSA_auto_rater(logical(mask_BLSA_auto_rater));
% 
% BLSA_auto_rater = [];
% for t = 1:length(mask_BLSA_auto_rater)
%     
%     mask_per_rater1 = strcmp({BLSA_auto.all_dice.rater1}, mask_BLSA_auto_rater(t));
%     mask_per_rater2 = strcmp({BLSA_auto.all_dice.rater2}, mask_BLSA_auto_rater(t));
%     
%     tmp_rater1 = BLSA_auto.all_dice(mask_per_rater1);
%     tmp_rater2 = BLSA_auto.all_dice(mask_per_rater2);
%     
% %     tmp_mask_1 = ~strcmp({tmp_1.rater2}, 'xxx');
% %     tmp_rater1 = tmp_1(tmp_mask_1);
% %     
% %     tmp_mask_2 = ~strcmp({tmp_2.rater1}, 'xxx');
% %     tmp_rater2 = tmp_2(tmp_mask_2);
%     
%     tmp_BLSA_dice1 = [];
%     for g = 1:length(tmp_rater1)
%         tmp_BLSA_dice1(g, 1) = tmp_rater1(g).dice;
%     end
%     
%     tmp_BLSA_dice2 = [];
%     for h = 1:length(tmp_rater2)
%         tmp_BLSA_dice2(h, 1) = tmp_rater2(h).dice;
%     end
%     
%     tmp_BLSA_dice = [];
%     tmp_BLSA_dice = [tmp_BLSA_dice1; tmp_BLSA_dice2];
%     
%     % padding with NaN
%     if size(tmp_BLSA_dice,1) > size(BLSA_auto_rater,1)
%         BLSA_auto_rater= [BLSA_auto_rater; nan(size(tmp_BLSA_dice,1) - size(BLSA_auto_rater,1), size(BLSA_auto_rater,2))]; % padding with rows
%     else
%         tmp_BLSA_dice = [tmp_BLSA_dice; nan(size(BLSA_auto_rater,1) - size(tmp_BLSA_dice,1), 1)]; % padding with rows
%     end
%     BLSA_auto_rater = [BLSA_auto_rater tmp_BLSA_dice]; % adding columns
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

% sorting BLSA tracts
sorted_tractList = [];         
% sort the intra-subject tract dice 
BLSA_mean = nanmedian(BLSA_tract, 1);
[~, sort_idx] = sort(BLSA_mean,'descend');
BLSA_sorted_tract = nan(size(BLSA_tract));
for i=1:size(BLSA_tract, 2)
BLSA_sorted_tract(:,i) = BLSA_tract(:,sort_idx(i));
sorted_tractList{i} = tractList61{sort_idx(i)};
end

lobar = {'Frontal Lobe Left';'Frontal Lobe Right';'Occipital Lobe Left';'Occipital Lobe Right'; ...
            'Parietal Lobe Left';'Parietal Lobe Right';'Temporal Lobe Left';'Temporal Lobe Right'};
        
simple_tracts = {'Anterior Commissure'; 'Anterior Limb Internal Capsule Left';'Anterior Limb Internal Capsule Right';'Body Corpus Callosum';...
            'Cerebral Peduncle Left';'Cerebral Peduncle Right';'Genu Corpus Callosum';'Midbrain';'Middle Cerebellar Peduncle';'Medial Lemniscus Left';'Medial Lemniscus Right'; ...
            'Olfactory Radiation Left';'Olfactory Radiation Right';'Posterior Corona Radiata Left';'Posterior Corona Radiata Right';...
            'Posterior Limb Internal Capsule Left';'Posterior Limb Internal Capsule Right';'Splenium Corpus Callosum';'Superior Corona Radiata Left';'Superior Corona Radiata Right'; ...
            'Superior Longitudinal Fasciculus Left';'Superior Longitudinal Fasciculus Right';'Sagittal Stratum Left';'Sagittal Stratum Right';'Uncinate Fasciculus Left';'Uncinate Fasciculus Right'};

lobe_idx = [];
simple_idx = [];
for il = 1:length(lobar)
    lobe_idx = [lobe_idx , find(contains(sorted_tractList, lobar{il}))];
end

for is = 1:length(simple_tracts)
    simple_idx = [simple_idx , find(contains(sorted_tractList, simple_tracts{is}))];
end

% Human Tracts Plot
figure(1)
g = boxplot(BLSA_sorted_tract,'Widths',0.6);
set(findobj(gcf,'tag','Median'), 'Color', [0 0 0.2]);
a = get(get(gca, 'children'),'children');
t = get(a, 'tag');

% B.LSA
complex = a(123:183);
lobes = a(184 - lobe_idx );
simple = a(184 - simple_idx );

set(complex, 'Color', [0.6 0.2 0], 'linewidth',1.5);
set(simple, 'Color', [0 0 0.2], 'linewidth',1.5);
set(lobes, 'Color', [0 0.4 0.6], 'linewidth',1.5);

ylim([-.1 1.1])
% set(g,'Position', [1 1 1680 1050]);
title('Inter-rater Tract Reliability for BLSA', 'FontSize', 18)
ylabel('Dice Coefficient (th>0)', 'FontSize', 18)
xticks(1:1:61)
xticklabels(sorted_tractList);
xtickangle(45);
grid minor;

% Human Raters Plot
figure(3); 
BLSA_rater_woJasmine = [BLSA_rater(:, 1:5) BLSA_rater(:, 7:end)];
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
% xticklabels(mask_BLSA_rater)
ylabel('Dice Coefficient ((th>0)', 'FontSize', 18)
xticklabels({'R1', 'R2', 'R3',  'R4',  'R5',  'R6',  'R7', 'R8'});
% xticklabels({'R1', 'R2', 'R9', 'R3',  'R4', 'R6', 'R10', 'R7', 'R8'});
title('Rater Reproducibility for BLSA', 'FontSize', 18)
grid minor;


% % Rater Reproducibility by tract
% BLSA = load('reproducibility/BLSA19_auto_cdice.mat');
% 
% % To exclude some raters
% list_BLSA_rater = unique({BLSA.all_dice.rater1 BLSA.all_dice.rater2});
% mask_BLSA_rater = zeros(1,length(list_BLSA_rater));
% list = {'Aviral','Bruce','Cam','Christa','Eugene','Jasmine','Roza','Xuan','Yi', 'Yufei', 'auto'};
% for l = 1:length(list)
%     mask_BLSA_rater = mask_BLSA_rater + strcmp(list_BLSA_rater, list(l));
% end
% mask_BLSA_rater = list_BLSA_rater(logical(mask_BLSA_rater));
% 
% list_BLSA_tract = unique({BLSA.all_dice.tract});
% mask_BLSA_tract = zeros(1,length(list_BLSA_tract));
% 
% BLSA_rater = [];
% BLSA_tract = [];
% 
% for t = 1:length(list_BLSA_tract)
%     mask_per_tract = strcmp({BLSA.all_dice.tract}, list_BLSA_tract(t));
%     tmp_tract = BLSA.all_dice(mask_per_tract);
%     BLSA_rater = [];
%     for cc = 1:length(mask_BLSA_rater)
%         close all;
% 
%         mask_per_tr_rater1 = strcmp({tmp_tract.rater1}, mask_BLSA_rater(cc));
%         mask_per_tr_rater2 = strcmp({tmp_tract.rater2}, mask_BLSA_rater(cc));
% 
%         tmp_rater1 = tmp_tract(mask_per_tr_rater1);
%         tmp_rater2 = tmp_tract(mask_per_tr_rater2);    
%         
%         tmp_BLSA_dice1 = [];
%         for g = 1:length(tmp_rater1)
%             tmp_BLSA_dice1(g, 1) = tmp_rater1(g).dice;
%         end
%     
%         tmp_BLSA_dice2 = [];
%         for h = 1:length(tmp_rater2)
%             tmp_BLSA_dice2(h, 1) = tmp_rater2(h).dice;
%         end
%         
%         tmp_BLSA_dice = [];
%         tmp_BLSA_dice = [tmp_BLSA_dice1; tmp_BLSA_dice2];
%         
%         % padding with NaN
%         if size(tmp_BLSA_dice,1) > size(BLSA_rater,1)
%             BLSA_rater= [BLSA_rater; nan(size(tmp_BLSA_dice,1) - size(BLSA_rater,1), size(BLSA_rater,2))]; % adding rows
%         else
%             tmp_BLSA_dice = [tmp_BLSA_dice; nan(size(BLSA_rater,1) - size(tmp_BLSA_dice,1), 1)]; % adding rows
%         end
%         BLSA_rater = [BLSA_rater tmp_BLSA_dice]; % adding columns
%     end 
%     
%     % Raters Plot
%     figure; 
%     h = boxplot(BLSA_rater);
%     red  = [0.6 0.2 0];
%     blue = [0 0 0.2];
%     set(findobj(gcf,'tag','Median'), 'Color', blue, 'linewidth',1.5);
%     set(findobj(gcf,'tag','Box'), 'Color', blue, 'linewidth',1.5);
%     h = findobj(gcf,'tag','Outliers');
%     for iH = 1:length(h)
%         h(iH).MarkerEdgeColor = red;
%     end
%     alpha(.9)
%     % set(figure(4),'Position', [1 1 1680 1050]);
%     xticklabels(mask_BLSA_rater)
%     ylabel('cDice', 'FontSize', 18)
%     % xticklabels({'R1', 'R2', 'R3',  'R4',  'R5',  'R6',  'R7', 'R8', 'R9'});
%     title(list_BLSA_tract(t), 'FontSize', 18)
%     grid minor;
%     pause
% end