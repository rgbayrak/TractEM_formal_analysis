% Load HCP data for now. Convert to table
D = load('HCP_Dec_icc.mat');
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
title('Auto Traced HCP data')
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
 
% % Find a specific tract
% Dinter(strcmp(Dinter.tract,'fxst_L'),:)

% Create indicator variables for raters
% rater mask
raterlist = unique([Dinter.rater1;Dinter.rater2]);
for r = 1:length(raterlist)
    Dinter.(raterlist{r}) = strcmp(Dinter.rater1,raterlist{r}) | strcmp(Dinter.rater2,raterlist{r});
end

% tract mask
tractlist = unique([Dinter.tractOne]);
for r = 1:length(tractlist)
    Dinter.(tractlist{r}) = strcmp(Dinter.tract,tractlist{r});
end

subjectlist = unique([Dinter.subject]);
for r = 1:length(subjectlist)
    S = ['Subj_' subjectlist{r}];
    Dinter.(S) = strcmp(Dinter.subject,subjectlist{r});
end
% HCP
% x = {(1:53) (54:159) (160:265) (266:315) (316:415) (416:515) (516:621) (622:727) (754:857) (858:955)}; 

% % HCP
x = {(1:28) (29:88) (89:148) (149:178) (179:238) (239:298) (299:358) (359:418) (439:498) (499:558)};
DICE = [];
for n = 1:length(x)
    AR = [];
    AR = Dinter(x{n}, {'tract','dice', 'rater1', 'rater2', 'auto'});
    toDelete = (AR.auto == false);
    AR(toDelete,:) = [];
    AR.auto = [];
    AR = AR.dice;

    % AR2 = Dinter(x, {'tract','dice', 'rater2', 'auto'});
    % toDelete = (AR2.auto == false);
    % AR2(toDelete,:) = [];
    % AR2.auto = [];
    
    RR = [];
    RR = Dinter(x{n}, {'tract','dice','rater1', 'rater2', 'auto'});
    toDelete = (RR.auto == true);
    RR(toDelete,:) = [];
    RR.auto = [];
    RR = RR.dice;
    
    if size(DICE, 1) < size(AR,1)
        DICE = [DICE; nan(size(AR,1) - size(DICE,1), size(DICE,2))];
    else
        AR = [AR; nan(size(DICE,1) - size(AR,1), 1)];
    end
    RR = [RR; nan(size(AR,1) - size(RR,1), 1)];
    DICE = [DICE AR RR];
end
figure(1)
% ylim([0 1])
boxplot(DICE, 'colors', 'kr')
xticks(1.5:2:20)
xticklabels(tractlist)
ylabel('DICE Coefficient')
grid minor;
vline(2.5:2:20, {'b', '-'})
title('AR [BLACK] vs RR [RED] for 10 HCP tracts')







