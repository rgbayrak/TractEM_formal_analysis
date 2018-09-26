% Load BLSA data for now. Convert to table
D = load('reproducibility/BLSA_Aug30_01.mat');
D = struct2table(D.all_dice);
 
% Sort raters alphabetically so we can combine names and get unique
% combination IDs
warning('off','MATLAB:table:RowsAddedNewVars')
for k = 1:height(D)
    r = table2cell( D(k,{'rater1','rater2'}) );
    D.rater1{k} = r{1};
    D.rater2{k} = r{2};
    D.raters{k,1} = [r{1} '_' r{2}];
end
 
% Label the intra-rater cases
D.intra = strcmp(D.rater1,D.rater2);
Dintra = D(D.intra,:);
Dinter = D(~D.intra,:);
 
% Count some things
fprintf(['\nInter-rater data', ...
    '\n  Subjects: %d\n  Rater pairs: %d\n  Tracts: %d\n'], ...
    length(unique(Dinter.subject)), ...
    length(unique(Dinter.raters)), ...
    length(unique(Dinter.tract)) );
 
% Summarize over tracts
figure(1); clf
boxplot(Dinter.dice,Dinter.raters,'whisker',1.5,'orientation','vertical')
hold on
plot([median(Dinter.dice) median(Dinter.dice)],get(gca,'YLim'),'k-')
ylabel('DICE Coefficient')
xtickangle(45)
title('Auto Traced BLSA data')
hold off
 
% Summarize over raters
figure(2); clf
boxplot(Dinter.dice,Dinter.tract,'whisker',1.5,'orientation','vertical')
hold on
plot([median(Dinter.dice) median(Dinter.dice)],get(gca,'YLim'),'k-')
hold off
Draters = varfun(@median,Dinter,'GroupingVariables','raters','InputVariables','dice');
Draters.Properties.VariableNames{'GroupCount'} = 'tract_count';
Dtract = varfun(@median,Dinter,'GroupingVariables','tract','InputVariables','dice');
Dtract.Properties.VariableNames{'GroupCount'} = 'raters_count';
xtickangle(45)
 
% Find a "good" and a "poor" tract
goodval = prctile(Dtract.median_dice,75);
goodind = Dtract.median_dice>=goodval;
mingoodind = Dtract.median_dice==min(Dtract.median_dice(goodind));
Dinter_good = Dinter(strcmp(Dinter.tract,Dtract.tract{mingoodind}),:);
 
poorval = prctile(Dtract.median_dice,25);
poorind = Dtract.median_dice<=poorval;
maxpoorind = Dtract.median_dice==max(Dtract.median_dice(poorind));
Dinter_poor = Dinter(strcmp(Dinter.tract,Dtract.tract{maxpoorind}),:);
 
% Find a specific tract
Dinter(strcmp(Dinter.tract,'fxst_L'),:)
 
%%
 
% Create indicator variables for raters
% rater mask
raterlist = unique([Dinter.rater1;Dinter.rater2]);
for r = 1:length(raterlist)
    Dinter.(raterlist{r}) = strcmp(Dinter.rater1,raterlist{r}) | strcmp(Dinter.rater2,raterlist{r});
end

% tract mask
tractlist = unique([Dinter.tract]);
for r = 1:length(tractlist)
    Dinter.(tractlist{r}) = strcmp(Dinter.tract,tractlist{r});
end


% Plot coefficient estimates (mean effects of rater and tract)
Frater = fitlme(Dinter,'dice ~ ac*(Jasmine+Aviral+Bruce+Christa+Eugene+Xuan+Yi+Yufei)');
F = Frater;
figure(3); clf; hold on
plot(F.Coefficients.Estimate(2:end),1:size(F.Coefficients,1)-1,'o')
set(gca,'YLim',[0 size(F.Coefficients,1)])
plot([0 0],get(gca,'YLim'),':k')
set(gca,'YTick',1:size(F.Coefficients,1)-1)
set(gca,'YTickLabel',F.Coefficients.Name(2:end))
xlabel('Dice difference relative to Auto')
set(gca,'XLim',[-0.15 0.15])

Ftract = fitlme(Dinter,'dice ~ tract');
F = Ftract;
figure(4); clf; hold on
plot(F.Coefficients.Estimate(2:end),1:size(F.Coefficients,1)-1,'o')
set(gca,'YLim',[0 size(F.Coefficients,1)])
plot([0 0],get(gca,'YLim'),':k')
set(gca,'YTick',1:size(F.Coefficients,1)-1)
set(gca,'YTickLabel',cellfun(@(x) strrep(x,'_',' '),F.Coefficients.Name(2:end),'UniformOutput',false))
xlabel('Dice difference relative to ac')
 
%% Interaction model to three plots
Finter = fitlme(Dinter,'dice ~ tract * (Aviral+Bruce+Christa+Eugene+Xuan+Yi+Yufei)');
F = Finter;
 
figure(5); clf; hold on
cind = 2:9; ind = cind-1; ylim = [ind(1)-1 ind(end)+1];
plot(F.Coefficients.Estimate(cind),ind,'o')
set(gca,'YLim',ylim)
plot([0 0],get(gca,'YLim'),':k')
set(gca,'YTick',ind)
set(gca,'YTickLabel',cellfun(@(x) strrep(x,'_',' '),F.Coefficients.Name(cind),'UniformOutput',false))
title('Tract main effects')
 
figure(6); clf; hold on
cind = 2:9; ind = cind-1; ylim = [ind(1)-1 ind(end)+1];
plot(F.Coefficients.Estimate(cind),ind,'o')
set(gca,'YLim',ylim)
plot([0 0],get(gca,'YLim'),':k')
set(gca,'YTick',ind)
set(gca,'YTickLabel',cellfun(@(x) strrep(x,'_',' '),F.Coefficients.Name(cind),'UniformOutput',false))
title('Rater main effects relative to auto, tract: body corpus callosum')
 
figure(7); clf; hold on
cind = 69:488; ind = cind-1; ylim = [ind(1)-1 ind(end)+1];
plot(F.Coefficients.Estimate(cind),ind,'o')
set(gca,'YLim',ylim)
plot([0 0],get(gca,'YLim'),':k')
set(gca,'YTick',ind)
set(gca,'YTickLabel',cellfun(@(x) strrep(x,'_',' '),F.Coefficients.Name(cind),'UniformOutput',false))
title('Tract by rater interactions')