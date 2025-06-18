function [t1,seg,dwi,mask,grad,bvals,bvecs, out_dir] = a20_get_2019_BLSA_filenames(blsa_dir)

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
macruise = ['BLSA-x-' subj '-x-' sess '-x-MPRAGE-x-MaCRUISE_v3'];
mprage = 'MPRAGE-x-MPRAGE-x-T1wStructuralMRI';
dti_dir = [blsa_dir '/' sess '/' dtiqa '/PREPROCESSED'];
dwi = [dti_dir '/dwmri.nii'];

% bval/bvec viles
bvals = [dti_dir '/dwmri.bval'];
bvecs = [dti_dir '/dwmri.bvec'];

% Mask file
mask = [dti_dir '/mask.nii'];

% Zero out ex-mask voxels in the DWI so DSI Studio doesn't get confused
% -----> mask was flipped: TAKES A COUPLE OF MINS
% a21_zero_exmask_dwi(dwi,mask);

% Filenames for T1 and segmented T1
zt1 = [blsa_dir '/' sess '/' mprage '/NIFTI/' sess '_MPRAGE.nii.gz'];
t1 = unziptest(zt1);
zseg = [blsa_dir '/' sess '/' macruise '/SegRefine/SEG_refine.nii.gz'];
seg = unziptest(zseg);

% Register T1 and seg to dwi B=0. First compute b=0, then COM shift, then
% SPM coreg estimate. No need to resample at this stage but we will copy
% the files to avoid changing original images.

out_dir = [blsa_dir '/' sess '/RECON'];
mkdir(out_dir);
% [t1,seg] = a22_coregister_t1(dwi,bvals,t1,seg, out_dir);

grad = []; % No grad dev for BLSA

% % fid = fopen(bvals,'wt');
% % fprintf(fid,'%0.2f ',bval);
% % fprintf(fid,'\n');
% % fclose(fid);
% % 
% % fid = fopen(bvecs,'wt');
% % fprintf(fid,'%0.6f ',bvec(1,:));
% % fprintf(fid,'\n');
% % fprintf(fid,'%0.6f ',bvec(2,:));
% % fprintf(fid,'\n');
% % fprintf(fid,'%0.6f ',bvec(3,:));
% % fprintf(fid,'\n');
% % fclose(fid);