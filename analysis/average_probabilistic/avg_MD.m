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
MD1 = '/home-local/bayrakrg/Dropbox (VUMC)/BLSA/BLSA_1881/BLSA_1881_07-0_10/BLSA-x-BLSA_1881-x-BLSA_1881_07-0_10-x-dtiQA_Multi/TGZ/extra/recon_native/mni_MD.nii.gz';
basevol = load_nii(MD1);
basevol = basevol.img(:,:,:,1); % make sure it is just one volume
avg_img = zeros(size(basevol));
% files = files(~dropfiles);
figure;imagesc(squeeze(double(basevol(:,:,floor(end/2)))));

for k = 1:2:length(files)
    MD =  [files(k).folder filesep files(k).name];
    vol = load_nii(MD);
    avg_img = avg_img + double(vol.img);
end

avg_MD = avg_img / k;
vol.img = avg_MD;
figure;imagesc(squeeze(double(avg_MD(:,:,floor(end/2)))));title('Average'); % sanity visualiztion
save_nii(vol, '/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/avg_MNI_MD.nii');