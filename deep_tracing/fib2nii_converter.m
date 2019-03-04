close all;
clear all;
clc;

exDir              = '/share4/bayrakrg/tractEM/postprocessing/fib_files/*';

abbList = {'gcc'}; %{'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            %'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
        
fibDir = dir(fullfile(exDir, '*_fib.gz'));

for l = 1:length(fibDir)
    fo2nifti(fullfile(fibDir(l).folder, fibDir(l).name));
end

