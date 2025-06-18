% Process BLSA XNAT download for DSI Studio tractography work
clc
clear all
close all

%% Setup

% Location of DSI Studio
dsi_studio = '/nfs/masi/bayrakrg/dsistudio/dsi_other_files/dsi_studio';

% SPM12
spm_dir = '/nfs/masi/bayrakrg/spm12';

% Script location
code_dir = '/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg/tractem/preprocessing';

% Where to find image files
blsa_dir = '/share4/bayrakrg/tractEM/preprocessing/Test_BLSA/BLSA'; % + subject_id

% Recon to use
model = 'QBI4'; % single shell


%% Process

% Get our toolkits in the path
addpath(genpath(code_dir));
addpath(spm_dir);

% Atlas FA image for normalisation
atlas = [code_dir '/atlas/rJHU-ICBM-FA-2mm-TAL.nii'];

% Get a list of BLSA subject directories (XNAT style)
dirs = dir(blsa_dir);
names = cellstr(char(dirs.name));
subjs = regexp(names,'^BLSA_\d{4}$','match');
subjs = [subjs{~cellfun(@isempty,subjs)}];


%% Loop through directories
% Note that we change directory to the appropriate location ahead of each
% DSI Studio command - DSI Studio is a bit inconsistent about where it
% looks for files, and a lot of these files have the same name for every
% subject. DSI Studio will automatically find our bval, bvec, mask, and
% grad_dev images in the directory with the dwi images.

for s = 2:2 %length(subjs)
	
	try
		
		% Files for this subject
		[zt1,zseg,zdwi,zmask,zgrad,bvals,bvecs,out_dir] = a20_get_2019_BLSA_filenames([blsa_dir '/' subjs{s}]);
		
		% Run the processing
		a30_process_subject(code_dir,out_dir,dsi_studio,atlas,zt1,zseg,zdwi,zmask,zgrad,bvals,bvecs,model)
		
	catch
		
		warning('Failure in subject %s',subjs{s});
		
	end
	
end

