%% Combine tract density maps to get segmentation
% We will create:
%      Segmented ROI image
%      Overall tract density image
 
%% Setup
% addpath('~/Dropbox/matlab/softwareinstallations/spm12/')
addpath('~/spm12/')
 
D = '~/Desktop/density/';
 
%% Find density images
d = dir([D '*density.nii']);
img_files = cellstr(char(d.name));
img_paths = cellstr(char(d.folder));
info = table(img_paths, img_files,'VariableNames',{'Folder', 'File'});
 
%% Get ROI names and labels
for k = 1:height(info)
    q = regexp(info.File{k},'(.*)_density.nii','tokens');
    info.ROI{k,1} = q{1}{1};
end
info.Label = (1:height(info))';
 
writetable(info,'roi_info.csv');
 
%% Load density images
V = spm_vol(fullfile(info.Folder, info.File));
Y = spm_read_vols(V);
osize = size(Y);
rY = reshape(Y,[],osize(4))';
 
 
% %% Load whole brain image
% A = spm_vol('/Users/greerjm1/Desktop/whole_brain.nii');
% B = spm_read_vols(A);
% C = size(B); 
% DB = reshape(Y, [], osize(4))';
% 
% E = spm_vol('/Users/greerjm1/Desktop/seg.nii');
% F = spm_read_vols(E); 
% G = size(F); 
% H = reshape(F, [], osize(4))';
 
%% Create segmentation image
% Which tract has highest value at each voxel. Give special label for
% multiple assignments (edges)
seg = zeros(size(rY(1,:)));
ovr = zeros(size(rY(1,:)));
maxY = repmat(max(rY),size(rY,1),1);
labind = maxY==rY & rY~=0;
[r,v] = find(labind);
seg(v) = r;
mult = sum(labind)>1;
seg(mult) = 0;
ovr(mult) = height(info) + 1;
 
Vseg = V(1);
Vseg.fname = 'seg.nii';
Vseg.pinfo(1:2) = [0 1]';
spm_write_vol(Vseg,reshape(seg,osize(1:3)));
 
Vovr = V(1);
Vovr.fname = 'ovr.nii';
Vovr.pinfo(1:2) = [0 1]';
spm_write_vol(Vovr,reshape(ovr,osize(1:3)));
 
% %%
% addpath('/Users/greerjm1/Documents/MATLAB/MASI_SC_Seg/masi-fusion/src/ext/')
% nii = load_untouch_nii_gz('seg.nii.gz');
% nii.img = B - F; 
% save_untouch_nii_gz(nii, 'cortex.nii.gz');