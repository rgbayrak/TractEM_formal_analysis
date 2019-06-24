clc
clear all;
close all;

% Adjust these variables with each subject
subjectID_rater = '*';

% The location of the subject data
path = '/share5/bayrakrg/tractEM/preprocessing/Kirby21';
file = 'MPRAGE-x-MPRAGE-x-MPRAGE/NIFTI';
D = [path filesep subjectID_rater filesep subjectID_rater filesep file filesep]; 

% Isolate just the tract directories
% single files
files = dir(D);
filenames = cellstr(char(files.name));
dropfiles = false(length(files),1);
dropfiles(cellfun(@isempty,strfind(filenames,'wcrm'))) = true; 

% Load a random image for size
T1 = '/share5/bayrakrg/tractEM/preprocessing/Kirby21/Kirby21_113/Kirby21_113_30/MPRAGE-x-MPRAGE-x-MPRAGE/NIFTI/wcrmKirby21_113_30-x-MPRAGE.nii';
basevol = load_nii(T1);
basevol = basevol.img(:,:,:,1); % make sure it is just one volume
avg_img = zeros(size(basevol));
files = files(~dropfiles);
figure;imagesc(squeeze(double(basevol(:,:,floor(end/2)))));

for k = 1:2:length(files)
    T1W =  [files(k).folder filesep files(k).name];
    vol = load_nii(T1W);
    avg_img = avg_img + double(vol.img);
end
avg_T1W = avg_img / k;
vol.img = avg_T1W;
figure;imagesc(squeeze(double(avg_T1W(:,:,floor(end/2)))));title('Average'); % sanity visualiztion
save_nii(vol, '/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/T1_.nii');