clc
clear all

% SPM12
spm_dir = '/nfs/masi/bayrakrg/spm12';

% 
code_dir = '/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg/tractem/preprocessing';

% Get our toolkits in the path
addpath(genpath(code_dir));
addpath(spm_dir);

seg_file = '/share4/bayrakrg/tractEM/postprocessing/tal_T1/mask_HCP/165436_wcT1w_acpc_dc_restore_1.25_seg.nii';
out_dir = '/share4/bayrakrg/tractEM/brain_regions';

labels = readtable([code_dir '/make_lobes/braincolor_hierarchy_STAPLE.txt'], ...
	'ReadVariableNames',true);

regionnames = readtable('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg/tractem/preprocessing/make_lobes/atlas-label-info.csv');


% Save the label list
writetable(labels(:,{'x133','x133_1'}), fullfile(out_dir,'braincolor_region.csv'))

V = spm_vol(seg_file);
Yseg = spm_read_vols(V);
Yregions = zeros(size(Yseg));

% all brain regions from multi-atlas segmentation
for k = 1:height(labels)
	Yregions(ismember(Yseg(:),labels.x133(labels.x133_1==k))) = k;
end
Vout = V;
Vout.fname = fullfile(out_dir,'brain.nii');
spm_write_vol(Vout,Yregions);

for k = 1:132
	Yout = zeros(size(Yseg));
	Yout(Yregions(:)==k) = 1;
	Vout = V;
	Vout.fname = fullfile(out_dir,[regionnames.Var2{k} '.nii']);
	spm_write_vol(Vout,Yout);
end

