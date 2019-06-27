clc
clear all;
close all;
% Location of DSI Studio
dsi_studio = '/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/dsistudio/build/dsi_studio';
% Adjust these variables with each subject
subjectID_rater = '*';

% The location of the subject data for BLSA
path = '/home-local/bayrakrg/Dropbox (VUMC)/BLSA';
file = '*dtiQA_Multi/TGZ/extra/recon_tal/tal_src.gz';
D = [path filesep subjectID_rater filesep subjectID_rater filesep file]; 

% % The location of the subject data for HCP
% path = '/home-local/bayrakrg/Dropbox (VUMC)/HCP';
% file = 'T1w/Diffusion/recon_tal/tal_src.gz';
% D = [path filesep subjectID_rater filesep file]; 

% Isolate just the tract directories
% single files
files = dir(D);
% filenames = cellstr(char(files.name));
% dropfiles = false(length(files),1);
% dropfiles(cellfun(@isempty,strfind(filenames,'wcrm'))) = true; 


for k = 1:length(files)
    % Generate the FA image and rename.
    tal_dir = files(k).folder;
    tal_dir = strrep(tal_dir, ' ', '\ ');
    tal_dir = strrep(tal_dir, '(', '\(');
    tal_dir = strrep(tal_dir, ')', '\)');
    
    disp('Exporting FA0')
    system([ ...
        'cd ' tal_dir ' ; ' ...
        dsi_studio ' --action=exp ' ...
        '--source=tal_fib.gz ' ...
        '--export=fa0 ' ...
        '> fa_exp.log ; ' ...
        'mv tal_fib.gz.fa0.nii.gz tal_fa0.nii.gz' ...
        ]);

%     % Generate the MD image and rename.
%     disp('Exporting MD')
%     system([ ...
%         'cd ' tal_dir ' ; ' ...
%         dsi_studio ' --action=exp ' ...
%         '--source=tal_fib.gz ' ...
%         '--export=md ' ...
%         '> md_exp.log ; ' ...
%         'mv tal_fib.gz.md.nii.gz tal_md.nii.gz' ...
%         ]);
end

