% Process Kirby XNAT download for DSI Studio tractography work
clc
clear all;
close all;

% Setup

% Location of DSI Studio
dsi_studio = '/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/dsistudio/build/dsi_studio';

% SPM12
spm_dir = '/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/spm12';

% Script location
code_dir = '/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg/tractem/preprocessing';

% Where to find image files
kirby = '/share5/bayrakrg/tractEM/preprocessing/Kirby21';

% Recon to use
model = 'QBI4';
%model = 'DTI';


%% Process

% Get our toolkits in the path
addpath(genpath(code_dir));
addpath(spm_dir);

% Atlas FA image for normalisation
atlas = [code_dir '/atlas/rJHU-ICBM-FA-2mm-TAL.nii'];

% Get a list of Kirby21 subject directories (XNAT style)
dirs = dir(kirby);
names = cellstr(char(dirs.name));
subjs = regexp(names,'^Kirby21_\d{3}$','match');
subjs = [subjs{~cellfun(@isempty,subjs)}];

% Get sessions for each subject
allsubjs = cell(0,1);
for s = 1:length(subjs)
	d = dir(fullfile([kirby '/' subjs{s} '/' subjs{s} '_*']));
	for n = 1:length(d)
		allsubjs{end+1,1} = [subjs{s} '/' d(n).name];
	end
end
subjs = allsubjs;


% Or hard code the subject list for testing etc
% subjs = {'Kirby21_127/Kirby21_127_7'};
% subjs = subjs(2:end);


%% Loop through directories
% Note that we change directory to the appropriate location ahead of each
% DSI Studio command - DSI Studio is a bit inconsistent about where it
% looks for files, and a lot of these files have the same name for every
% subject. DSI Studio will automatically find our bval, bvec, mask, and
% grad_dev images in the directory with the dwi images.

for s = 1:length(subjs)
	
	try
		
		% Files for this subject
		[zt1,zseg,zdwi,zmask,zgrad,bvals,bvecs] = get_Kirby_filenames([kirby '/' subjs{s}]);
		
		% Run the processing
		process_subject(code_dir,dsi_studio,atlas,zt1,zseg,zdwi,zmask,zgrad,bvals,bvecs,model)
		
	catch
		
		warning('Failure in subject %s',subjs{s});
		
	end
	
end

