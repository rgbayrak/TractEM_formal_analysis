%% averaging T1 images
clc
clear all;
close all;

% Adjust these variables with each subject
subjectID_rater = '*';

% The location of the subject data for BLSA
path = '/home-local/bayrakrg/Dropbox (VUMC)/BLSA';
file = 'MPRAGE-x-MPRAGE-x-T1wStructuralMRI/NIFTI/wcrmBLSA*';
D = [path filesep subjectID_rater filesep subjectID_rater filesep file]; 

% % % The location of the subject data for HCP
% % path = '/home-local/bayrakrg/Dropbox (VUMC)/HCP';
% % file = 'T1w/T1w*1.25.nii';
% % D = [path filesep subjectID_rater filesep file]; 

% Isolate just the tract directories
% single files
files = dir(D);
% filenames = cellstr(char(files.name));
% dropfiles = false(length(files),1);
% dropfiles(cellfun(@isempty,strfind(filenames,'wcrm'))) = true; % Tal

% Load a random image for size
T1W = '/home-local/bayrakrg/Dropbox (VUMC)/BLSA/BLSA_1881/BLSA_1881_07-0_10/MPRAGE-x-MPRAGE-x-T1wStructuralMRI/NIFTI/wcrmBLSA_1881_07-0_10_MPRAGE.nii'; % BLSA
% T1W = '/home-local/bayrakrg/Dropbox (VUMC)/HCP/130114/T1w/T1w_acpc_dc_restore_1.25.nii'; % HCP
basevol = load_untouch_nii(T1W);
basevol = basevol.img(:,:,:,1); % make sure it is just one volume
avg_img = zeros(size(basevol));
% files = files(~dropfiles);
figure(1);imagesc(squeeze(double(basevol(:,:,floor(3*end/5)))));

for k = 1:length(files)
    T1 =  [files(k).folder filesep files(k).name];
%     % sanity check 
%     basevol2 = load_untouch_nii(T1);
%     basevol2 = basevol2.img(:,:,:,1); % make sure it is just one volume
%     avg_img = zeros(size(basevol2));
%     files = files(~dropfiles);
%     figure;imagesc(squeeze(double(basevol2(:,:, floor(3*end/5)))));
    
    vol = load_untouch_nii(T1);
    avg_img = avg_img + double(vol.img);
end
avg_T1 = avg_img / k;
vol.img = avg_T1;
figure(2);imagesc(squeeze(double(avg_T1(:,:,floor(3*end/5)))));title('Average'); % sanity visualization
% save_untouch_nii(vol, '/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/prob_atlases/BLSA/Tal_T1.nii');

%% averaging MD maps

clc
clear all;
close all;

% Adjust these variables with each subject
subjectID_rater = '*';

% % The location of the subject data for BLSA
% path = '/home-local/bayrakrg/Dropbox (VUMC)/BLSA';
% file = '*dtiQA_Multi/TGZ/extra/recon_native/mni_MD*';
% D = [path filesep subjectID_rater filesep subjectID_rater filesep file]; 

% The location of the subject data for HCP
path = '/home-local/bayrakrg/Dropbox (VUMC)/HCP';
file = 'T1w/Diffusion/recon_native/mni_MD*';
D = [path filesep subjectID_rater filesep file]; 

% Isolate just the tract directories
% single files
files = dir(D);
% filenames = cellstr(char(files.name));
% dropfiles = false(length(files),1);
% dropfiles(cellfun(@isempty,strfind(filenames,'wcrm'))) = true; 

% Load a random image for size
% MD1 = '/home-local/bayrakrg/Dropbox (VUMC)/HCp/BLSA_1881/BLSA_1881_07-0_10/BLSA-x-BLSA_1881-x-BLSA_1881_07-0_10-x-dtiQA_Multi/TGZ/extra/recon_native/mni_MD.nii.gz'; % BLSA
MD1 = '/home-local/bayrakrg/Dropbox (VUMC)/HCP/130114/T1w/Diffusion/recon_native/mni_MD.nii.gz'; % HCP
basevol = load_nii(MD1);
basevol = basevol.img(:,:,:,1); % make sure it is just one volume
avg_img = zeros(size(basevol));
% files = files(~dropfiles);
% figure(3);imagesc(squeeze(double(basevol(:,:,floor(end/2)))));

for k = 1:length(files)
    MD =  [files(k).folder filesep files(k).name];
    vol = load_nii(MD);
    avg_img = avg_img + double(vol.img);
end

avg_MD = avg_img ./ k;
vol.img = avg_MD;
figure(4);imagesc(squeeze(double(avg_MD(:,:,floor(end/2)))));title('Average'); % sanity visualiztion
%save_nii(vol, '/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/prob_atlases/HCP/crmMNI_MD.nii');


%% averaging FA maps
% Adjust these variables with each subject
subjectID_rater = '*';

% % The location of the subject data for BLSA
% path = '/home-local/bayrakrg/Dropbox (VUMC)/BLSA';
% file = '*dtiQA_Multi/TGZ/extra/recon_native/mni_MD*';
% D = [path filesep subjectID_rater filesep subjectID_rater filesep file]; 

% The location of the subject data for HCP
path = '/home-local/bayrakrg/Dropbox (VUMC)/HCP';
file = 'T1w/Diffusion/recon_native/mni_FA*';
D = [path filesep subjectID_rater filesep file]; 

% Isolate just the tract directories
% single files
files = dir(D);
% filenames = cellstr(char(files.name));
% dropfiles = false(length(files),1);
% dropfiles(cellfun(@isempty,strfind(filenames,'wcrm'))) = true; 

% Load a random image for size
% FA1 = '/home-local/bayrakrg/Dropbox (VUMC)/HCp/BLSA_1881/BLSA_1881_07-0_10/BLSA-x-BLSA_1881-x-BLSA_1881_07-0_10-x-dtiQA_Multi/TGZ/extra/recon_native/mni_FA.nii.gz'; % BLSA
FA1 = '/home-local/bayrakrg/Dropbox (VUMC)/HCP/130114/T1w/Diffusion/recon_native/mni_FA.nii.gz'; % HCP
basevol = load_nii(FA1);
basevol = basevol.img(:,:,:,1); % make sure it is just one volume
avg_img = zeros(size(basevol));
% files = files(~dropfiles);
% figure(5);imagesc(squeeze(double(basevol(:,:,floor(end/2)))));

for k = 1:length(files)
    FA =  [files(k).folder filesep files(k).name];
    vol = load_nii(FA);
    avg_img = avg_img + double(vol.img);
end

avg_FA = avg_img / k;
vol.img = avg_FA;
figure(6);imagesc(squeeze(double(avg_FA(:,:,floor(end/2)))));title('Average'); % sanity visualiztion
%save_nii(vol, '/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/prob_atlases/HCP/crmMNI_FA.nii');