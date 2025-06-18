function [t1,seg,dwi,mask,grad,bvals,bvecs] = get_Test_BLSA_filenames(blsa_dir)

% Given a directory where a BLSA preprocessed DWI image set was downloaded
% from XNAT, get the filenames of the relevant files for diffusion
% processing.

% Get session name
q = strsplit(blsa_dir,'/');
subj = q{end};
d = dir([blsa_dir '/' subj '_*-0_10']);
if length(d) ~= 1
	error('Could not find session for %s',blsa_dir)
end
sess = d(1).name;

% Other directory names
dtiqa = ['BLSA-x-' subj '-x-' sess '-x-dtiQA_v6'];
mprage = 'MPRAGE-x-MPRAGE-x-T1wStructuralMRI';
dti_dir = [blsa_dir '/' sess '/' dtiqa '/PREPROCESSED'];

% Extract DWI and scheme file from tgz
system(['cd ' dti_dir ' && gunzip ' dti_dir '/dwmri.nii.gz']);
dwi = [dti_dir '/dwmri.nii'];

% Convert scheme file to bval/bvec
% S = importdata([dti_dir '/extra/scheme.txt'],' ',1);
% bvec = S.data(:,1:3)';
% bval = S.data(:,4)';
bvals = [dti_dir '/dwmri.bval'];
bvecs = [dti_dir '/dwmri.bvec'];

% fid = fopen(bvals,'wt');
% fprintf(fid,'%0.2f ',bval);
% fprintf(fid,'\n');
% fclose(fid);
% 
% fid = fopen(bvecs,'wt');
% fprintf(fid,'%0.6f ',bvec(1,:));
% fprintf(fid,'\n');
% fprintf(fid,'%0.6f ',bvec(2,:));
% fprintf(fid,'\n');
% fprintf(fid,'%0.6f ',bvec(3,:));
% fprintf(fid,'\n');
% fclose(fid);


% Mask file
system(['cd ' dti_dir ' && gunzip ' dti_dir '/mask.nii.gz']);
mask = [dti_dir '/mask.nii'];

% Zero out ex-mask voxels in the DWI so DSI Studio doesn't get confused
% takes a couple of minutes ...
zero_exmask_dwi(dwi,mask);

% Filenames for T1 and segmented T1
zt1 = [blsa_dir '/' sess '/' mprage '/NIFTI/' sess '_MPRAGE.nii.gz'];
system(['gunzip ' zt1]);
t1 = zt1(1:end-3);

zseg_dir = dir([blsa_dir '/' sess '/*MaCRUISE*']);
zseg = fullfile(zseg_dir.folder, zseg_dir.name, 'SegRefine/SEG_refine.nii.gz');
system(['gunzip ' zseg]);
seg = zseg(1:end-3);

% Register T1 and seg to dwi B=0. First compute b=0, then COM shift, then
% SPM coreg estimate. No need to resample at this stage but we will copy
% the files to avoid changing original images.
[t1,seg] = coregister_t1(dwi,bvals,t1,seg);

grad = []; % No grad dev for BLSA

