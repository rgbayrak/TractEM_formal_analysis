function a30_process_subject(code_dir,out_dir,dsi_studio,atlas,t1,seg,dwi,mask,grad,bvals,bvecs,model)

% Processing stream for a single subject for DSI recons.

% Unzip niis for SPM if needed
atlas = unziptest(atlas);
t1 = unziptest(t1);
seg = unziptest(seg);
dwi = unziptest(dwi);
mask = unziptest(mask);
grad = unziptest(grad);

% Where to stow results
native_dir = fullfile(out_dir,'recon_native');
tal_dir = fullfile(out_dir,'recon_tal');

% % 1. Generate DTI-based FA image from the dwi images using DSI Studio
% % command line.
% % Requirement: the template images of dsi-studio
disp('Making FA')
[src,dti_fib,dti_fa0,dwi,bvals,bvecs,mask] = a31_make_native( ...
	dsi_studio,dwi,bvals,bvecs,mask,native_dir);

% Fix the geometry in the Nifti header of the saved FA image. DSI
% Studio clobbers it for some reason.
disp('Restoring geometry')
dti_fa0 = a32_restore_nii_geom(mask,dti_fa0);

% Shift center of mass to align with template
disp('Adjusting center of mass')
[cdti_fa0,cdwi,ct1,cseg,cgrad,cmask] = a33_shift_COM( ...
	dti_fa0,dwi,t1,seg,grad,mask,atlas);

% Estimate affine transformation to template
disp('Estimating affine transform to atlas')
[wcdti_fa0,wcdwi,wct1,wcseg,wcgrad,wcmask] = a34_affine_to_tal( ...
	cdti_fa0,cdwi,ct1,cseg,cgrad,cmask,atlas);

% Adjust b-values
disp('Adjusting b vectors')
[pth,nam] = fileparts(cdti_fa0);
wb_table = a35_b_vec_transformation( ...
	bvals, ...
	bvecs, ...
	[pth '/' nam '_sn.mat'] ...
	);

% GQI reconstruction with DSI Studio
a36_make_Tal(dsi_studio,wcdwi,wcgrad,wcmask,wb_table,tal_dir,model);

% Create lobe ROIs from seg image
braincolor_to_lobes(wcseg,tal_dir,code_dir);


