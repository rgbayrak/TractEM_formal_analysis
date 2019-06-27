% Reproducibility intra-rater intra-subject
% Load the data

clear all;
close all;
clc;
addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg:')
% Load the data
HCP = load('HCP_Nov.mat');
% HCP_auto = load('7678_Aug_01.mat');
mask_HCP_tract = unique({HCP.all_dice.tract});
% mask_HCP_auto_tract = unique({HCP_auto.all_dice.tract});
mask_HCP_rater = unique({HCP.all_dice.rater1 HCP.all_dice.rater2});
% mask_HCP_auto_rater = unique({HCP_auto.all_dice.rater1 HCP_auto.all_dice.rater2});
% list_HCP_rater = unique({HCP.all_dice.rater1 HCP.all_dice.rater2});
% mask_HCP_rater = zeros(1,length(list_HCP_rater));
% list = {'Aviral','Bruce','Cam','Christa','Eugene','Jasmine','Roza','Xuan','Yi'};
% for l = 1:length(list)
%     mask_HCP_rater = mask_HCP_rater + strcmp(list_HCP_rater, list(l));
% end
% mask_HCP_rater = list_HCP_rater(logical(mask_HCP_rater));


% HCP_auto_tract = [];
% tmp_HCP_dice = [];
% for t = 1:length(mask_HCP_auto_tract)
%     mask_per_tract = strcmp({HCP_auto.all_dice.tract}, mask_HCP_auto_tract(t));
%     tmp_tract = HCP_auto.all_dice(mask_per_tract);
%     
%     for d = 1:length(tmp_tract)
%         tmp_HCP_dice(d, 1) = tmp_tract(d).dice;
%     end
%     
%   
%     if size(HCP_auto_tract,1) > size(tmp_HCP_dice,1)
%         tmp_HCP_dice = [tmp_HCP_dice; nan(size(HCP_auto_tract,1) - size(tmp_HCP_dice,1), 1)];
%     else
%         HCP_auto_tract= [HCP_auto_tract; nan(size(tmp_HCP_dice,1) - size(HCP_auto_tract,1), size(HCP_auto_tract,2))];
%     end
%     HCP_auto_tract = [HCP_auto_tract tmp_HCP_dice];
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HCP_tract = [];
tmp_HCP_dice = [];
for t = 1:length(mask_HCP_tract)
    mask_per_tract = strcmp({HCP.all_dice.tract}, mask_HCP_tract(t));
    tmp_tract = HCP.all_dice(mask_per_tract);
    
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% HCP_auto_rater = [];
% tmp_HCP_dice = [];
% 
% for t = 1:length(mask_HCP_auto_rater)
%     tmp_HCP_dice1 = [];
%     tmp_HCP_dice2 = [];
%     mask_per_rater1 = strcmp({HCP.all_dice.rater1}, mask_HCP_auto_rater(t));
%     exlude = ~strcmp({HCP.all_dice.rater1}, 'Yufei');
%     mask_per_rater2 = strcmp({HCP.all_dice.rater2}, mask_HCP_auto_rater(t));
%     
%     
%     tmp_1 = HCP.all_dice(mask_per_rater1);
%     tmp_2 = HCP.all_dice(mask_per_rater2);
%     
%     tmp_mask_1 = ~strcmp({tmp_1.rater2}, 'Yufei');
%     tmp_rater1 = tmp_1(tmp_mask_1);
%     
%     tmp_mask_2 = ~strcmp({tmp_2.rater1}, 'Yufei');
%     tmp_rater2 = tmp_2(tmp_mask_2);
%  
%     for g = 1:length(tmp_rater1)
%         tmp_HCP_dice1(g, 1) = tmp_rater1(g).dice;
%     end
%     
% %     if length(tmp_rater2) ~= 0
%         for h = 1:length(tmp_rater2)
%             tmp_HCP_dice2(h, 1) = tmp_rater2(h).dice;
%         end
% %     end
%     
%     tmp_HCP_dice = [tmp_HCP_dice1; tmp_HCP_dice2];
%     
%     % padding with NaN
%     if size(tmp_HCP_dice,1) > size(HCP_auto_rater,1)
%         HCP_auto_rater= [HCP_auto_rater; nan(size(tmp_HCP_dice,1) - size(HCP_auto_rater,1), size(HCP_auto_rater,2))]; % row
%     else
%         tmp_HCP_dice = [tmp_HCP_dice; nan(size(HCP_auto_rater,1) - size(tmp_HCP_dice,1), 1)]; % row
%     end
%     HCP_auto_rater = [HCP_auto_rater tmp_HCP_dice]; % column
%     
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HCP_rater = [];
tmp_HCP_dice = [];

for t = 1:length(mask_HCP_rater)
    tmp_HCP_dice1 = [];
    tmp_HCP_dice2 = [];
    mask_per_rater1 = strcmp({HCP.all_dice.rater1}, mask_HCP_rater(t));
    exlude = ~strcmp({HCP.all_dice.rater1}, 'Yufei');
    mask_per_rater2 = strcmp({HCP.all_dice.rater2}, mask_HCP_rater(t));
    
    
    tmp_1 = HCP.all_dice(mask_per_rater1);
    tmp_2 = HCP.all_dice(mask_per_rater2);
    
    tmp_mask_1 = ~strcmp({tmp_1.rater2}, 'Yufei');
    tmp_rater1 = tmp_1(tmp_mask_1);
    
    tmp_mask_2 = ~strcmp({tmp_2.rater1}, 'Yufei');
    tmp_rater2 = tmp_2(tmp_mask_2);
 
    for g = 1:length(tmp_rater1)
        tmp_HCP_dice1(g, 1) = tmp_rater1(g).dice;
    end
    
%     if length(tmp_rater2) ~= 0
        for h = 1:length(tmp_rater2)
            tmp_HCP_dice2(h, 1) = tmp_rater2(h).dice;
        end
%     end
    
    tmp_HCP_dice = [tmp_HCP_dice1; tmp_HCP_dice2];
    
    % padding with NaN
    if size(tmp_HCP_dice,1) > size(HCP_rater,1)
        HCP_rater= [HCP_rater; nan(size(tmp_HCP_dice,1) - size(HCP_rater,1), size(HCP_rater,2))]; % row
    else
        tmp_HCP_dice = [tmp_HCP_dice; nan(size(HCP_rater,1) - size(tmp_HCP_dice,1), 1)]; % row
    end
    HCP_rater = [HCP_rater tmp_HCP_dice]; % column
    
end


tractList = {'Anterior Commissure'; 'Anterior Corona Radiata Left';'Anterior Corona Radiata Right'; 'Anterior Limb Internal Capsule Left';'Anterior Limb Internal Capsule Right';'Body Corpus Callosum';...
            'Cingulum Cingulate Gyrus Left';'Cingulum Cingulate Gyrus Right'; 'Cingulum Hippocampal Left'; ...
            'Cingulum Hippocampal Right';'Cerebral Peduncle Left';'Cerebral Peduncle Right';...
            'Corticospinal Tract Left';'Corticospinal Tract Right';'Frontal Lobe Left';'Frontal Lobe Right';'Fornix Left';'Fornix Right';'Fornix Stria Terminalis Left';'Fornix Stria Terminalis Right';...
            'Genu Corpus Callosum';'Inferior Cerebellar Peduncle Left';'Inferior Cerebellar Peduncle Right'; ...
            'Inferior Fronto Occipital Fasciculus Left';'Inferior Fronto Occipital Fasciculus Right';'Inferior Longitudinal Fasciculus Left';'Inferior Longitudinal Fasciculus Right';...
            'Midbrain';'Middle Cerebellar Peduncle';'Medial Lemniscus Left';'Medial Lemniscus Right';'Occipital Lobe Left';'Occipital Lobe Right'; ...
            'Olfactory Radiation Left';'Olfactory Radiation Right';'Optic Tract';...
            'Posterior Corona Radiata Left';'Posterior Corona Radiata Right';'Pontine Crossing Tract';...
            'Posteriorlimb Internal Capsule Left';'Posteriorlimb Internal Capsule Right';'Parietal Lobe Left';'Parietal Lobe Right';...
            'Posterior Thalamic Radiation Left';'Posterior Thalamic Radiation Right';'Splenium Corpus Callosum';...
            'Superior Cerebellar Peduncle Left';'Superior Cerebellar Peduncle Right';'Superior Corona Radiata Left';'Superior Corona Radiata Right'; ...
            'Superior Fronto Occipital Fasciculus Left';'Superior Fronto Occipital Fasciculus Right';'Superior Longitudinal Fasciculus Left';'Superior Longitudinal Fasciculus Right';...
             'Sagittal Stratum Left';'Sagittal Stratum Right';'Tapetum Corpus Callosum';'Temporal Lobe Left';'Temporal Lobe Right';'Uncinate Fasciculus Left';'Uncinate Fasciculus Right'};


% HCP_merged_plot = [];
% HCP_auto_tract = [HCP_auto_tract; nan(size(HCP_tract,1) - size(HCP_auto_tract,1), size(HCP_tract,2))];
% 
%    
% for g = 1:61
%     HCP_merged_plot = [HCP_merged_plot HCP_tract(:,g)];
%     HCP_merged_plot = [HCP_merged_plot HCP_auto_tract(:,g)];
% end

figure(1)
h = boxplot(HCP_tract, 'colors', 'b', 'Widths',0.5);
% plotSpread(fixedROI)

red  = [198 0 0]./255;
blue = [0 123 198]./255;

set(findobj(gcf,'tag','Median'), 'Color', blue);

set(findobj(gcf,'tag','Box'), 'Color', red);

h = findobj(gcf,'tag','Outliers');
for iH = 1:length(h)
    h(iH).MarkerEdgeColor = red;
end
ylim([-.1 1.1])
refline([0 .5])
% set(figure(2),'Position', [1 1 1680 1050]);
% xticks(1:2:122)
xticklabels(tractList);
% ylabel('blue: with auto, black: without auto')
title('Intra-subject Tract Reproducibility for HCP')
xtickangle(45);
grid minor;
         
% figure(2); distributionPlot(HCP_merged_plot, 'colormap', winter)
% alpha(.7)
% refline([0 .5])
% % set(figure(2),'Position', [1 1 1680 1050]);
% xticks(1:2:122);
% xticklabels(tractList);
% title('Intra-subject Tract Reproducibility for HCP')
% xtickangle(45);
% grid on;

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
refline([0 .5])
% set(figure(4),'Position', [1 1 1680 1050]);
disp(mask_HCP_rater)
xticklabels(mask_HCP_rater)
% xticklabels({'R1', 'R2', 'R3',  'R4',  'R5',  'R6',  'R7', 'R8', 'R9'});
title('Intra-subject Inter-rater Reproducibility for HCP')
grid minor;

% figure(4); 
% distributionPlot(HCP_rater,'colormap', winter, 'variableWidth',true)
% alpha(.9)
% refline([0 .5])
% % set(figure(4),'Position', [1 1 1680 1050]);
% disp(mask_HCP_rater)
% xticklabels(mask_HCP_rater)
% xtickangle(45);
% % xticklabels({'R1', 'R2', 'R3',  'R4',  'R5',  'R6',  'R7', 'R8', 'R9'});
% title('Intra-rater Reproducibility for HCP')
% grid minor;