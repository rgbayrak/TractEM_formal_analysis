%
% ISBI2018_SquirrelMonkey_Wrapper - parse challenge submission for squirrel monkey
% data and generate report + output variables
%
% Syntax:  
% submission_directory = '/Volumes/GRAID/ISBI2018/SquirrelMonkey_Testing_B_Lucky/B22SubmissionTest/'
%[out] = ST2D(submission_directory)
%
% Inputs:
%    submission_directory: directory to challenge submission
%      MUST CONTAIN THE FOLLOWING
%           (1) SM.nii.gz: voxel-wise tractography "visitation" counts
%           (2) Tracks.tck (or Tracks.trk): tractography file (not
%           necessary for wrapper, only subsequent visualization)
%           (3) Information.txt: text file containing tracking information
%           for subsequent analysis
%
% Outputs:
%    out - structure that contains the following metrics
%       (1) Voxel-wise Dice score: (D) (how similar objects are): 2|A*B|/(|A|+|B|) 
%       (2) Voxel-wise Accuracy: accuracy(a,b) = |A*B| + |Abar*Bbar| / |All| = TP + TN / All
%       (3)* Voxel-wise bundle overlap (proportion of voxels within volume of ground truth bundle traversed by at least one valid streamline)
%       (4)* Voxel-wise bundle overreach (fraction of voxels outside volume of ground truth bundle over total number of voxels wihtin ground truth)
%       (5) Voxel-wise Hausdorff Distance, longest distance one must travel from one to other point set
%       (6)* Voxel-wise Hausdorff 90th percentile, 90th percentile of distance one must travel from one to other point set
%       (7)* Voxel-wise Hausdorff mean, mean distance one must travel from one to other point set
%       (8)* Voxel-wise Binary Tractography Overlap (BTO) BTO = 1 - sum_i(|PA(xi) - PB(xi)|) / sum (PA(xi) + PB(xi))
%       (9) ROI-based Sensitivity
%       (10) ROI-based specifity
%       (11) ROI-based Accuracy
%       (12)* ROI-based Youden index (J) [(specificity + sensitivity) ?1] 
%
%   pdf: contains table with indices, ROC curve, text from file?, tracto
%   picture?
%
% Packages required: 
%   Matlab NIFTI package (NIFTI_20130306)
% Functions required: 
%   HausdorffDists.m
% m-files required: 
% Files required: 
%   Subject_B_BDABinary.nii.gz (in current folder),
%   Subject_B_brainmask.nii.gz (in current folder),
%   Subject_B_seed.nii.gz (in current folder),
%   Subject_B_BDAcount.nii.gz (in current folder)
%   Subject_B_labels.nii.gz (in current folder)
% 
%
% See also: 
%
% Author:  schillkg
% Date:    17-Jan-2018 
% Version: 1.0
% Changelog:
% 17-Jan-2018  - initial creation
%
%------------- BEGIN CODE --------------

%% Load files

submission_directory = '/Volumes/GRAID/ISBI2018/SquirrelMonkey_Testing_B_Lucky/B22SubmissionTest/'
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306/'))

% Load BDA binary mask
% created by thresholding at 1 BDA fiber per voxel
nii = load_untouch_nii_gz('Subject_B_BDABinary.nii.gz');
bda_binary = single(nii.img); % 115*192*128 uint16 to double

% Load Brain Mask
nii2 = load_untouch_nii_gz('Subject_B_brainmask.nii.gz');
bm = single(nii2.img);

% Load Seed (Injection Region)
nii3 = load_untouch_nii_gz('Subject_B_seed.nii.gz');
seed = nii3.img; seed = single(seed);

% Load BDA count
nii4 = load_untouch_nii_gz('Subject_B_BDAcount.nii.gz');
bda = nii4.img;

% Load voxel-wise visitation count
name = 'SM.nii.gz'
nii5 = load_untouch_nii_gz([submission_directory name]);
track = single(nii5.img);

% load labels
nii6 = load_untouch_nii_gz('Subject_B_labels.nii.gz'); 
labels = nii6.img;


%% Pre-process

% BDA binary without seed (seed not included in most calculations)
bda_binary_s = bda_binary.*(1-seed); % 46299 non-zeros

% mask without seed
MaskMinusSeed = single(bm) - seed;

% Coordinates of voxels in BDA binary ROI
[h_x, h_y, h_z] = ind2sub(size(bda_binary_s), find(bda_binary_s));
h_coords = cat(2, h_x, h_y, h_z); % Nx3 N=46299

% verify that sizes of track match that of bm
if isequal(size(track), size(bm))==0
    fprintf('SM.nii.gz is not correct size\n')
    return
end

% make binary track mask
track_binary = track;
track_binary(track_binary>0)=1; 

% remove seed (not included in analysis)
track_binary_s = track_binary.*(1-seed);

% Unique Labels
C = unique(labels); C(C==0) = [];

% Labels that BDA goes through
PositiveLabels = labels(bda_binary==1); PositiveLabels = unique(PositiveLabels); PositiveLabels(PositiveLabels==0) = [];
NegativeLabels = setdiff(C,PositiveLabels);


%% Voxel-wise measures 

% Dice = 2|A*B|/(|A|+|B|) 
union = bda_binary_s.*track_binary_s ;
D = 2*nnz(union(:))/ (nnz(bda_binary_s(:)) + nnz(track_binary_s(:)));
   
% Accuracy(a,b) = |A*B| + |Abar*Bbar| / |All| = TP + TN / All
bda_bar = (1-bda_binary); bda_bar_s = bda_bar.*(1-seed);
track_bar = (1-track_binary); track_bar_s = track_bar.*(1-seed);
% need to mask these
bda_bar_s_mask = bda_bar_s.*bm;
track_bar_s_mask = track_bar_s.*bm;
bm_s = bm.*(1-seed);
union_bar = bda_bar_s_mask.*track_bar_s_mask ;
TP = nnz(union(:));
TN = nnz(union_bar(:));
All = nnz(bm_s(:));
ACC = (TP+TN)/All;

% Bundle Overlap
BO = nnz(union(:))/nnz(bda_binary_s(:));

% Bundle Overreach
BnotinA = track_binary_s.*(1-bda_binary_s);
BOR = nnz(BnotinA(:))/nnz(bda_binary_s(:));

% HD, HDmean, HD90
[c_x, c_y, c_z] = ind2sub(size(track_binary_s), find(track_binary_s));
c_coords = cat(2, c_x, c_y, c_z); % Mx3
clear c_x c_y c_z
[hd, hdmean, hd90] = HausdorffDists(h_coords,c_coords);

% binary tractography overlap (BTO):
% BTO = 1 - sum_i(|PA(xi) - PB(xi)|) / sum (PA(xi) + PB(xi))
% PA(xi) is a measure of the probability that voxel xi part of the tract. 
% Approximated by dividing # of streamlines in voxel by median # of 
% streamlines over all voxels containing any streamlines & clamping to a 
% max val of 1. Intended to label as high probability voxels of tract 
% containing a significant # of streamlines while tapering out influence 
% for voxels with few streamlines.
Pa = bda(MaskMinusSeed>0) / median(bda(bda>0)); Pa(Pa>1) = 1;
Pb = track(MaskMinusSeed>0) / median(track(track>0)); Pb(Pb>1) = 1;
BTO = 1 - sum(abs(Pa-Pb)) / sum(Pa+Pb);

%% ROI-based measures

trackLabels = labels(track_binary==1); trackLabels = unique(trackLabels); trackLabels(trackLabels==0) = [];
members = ismember(trackLabels,PositiveLabels);
nTP = sum(members); nFP = length(members)-nTP;
nFP2 = sum(ismember(trackLabels,NegativeLabels));
nFP3 = length(intersect(trackLabels,NegativeLabels));
trackNegatives = setxor(C,trackLabels);
nTN = sum(ismember(trackNegatives,NegativeLabels));
nFN = length(ismember(trackNegatives,NegativeLabels)) - nTN;
nFN2 = sum(ismember(trackNegatives,PositiveLabels));
TotalPositives = length(PositiveLabels);
TotalNegatives = length(NegativeLabels);
TotalAll = length(C);

% check to make sure calculations are correct
if nFP ~= nFP2; error('nFP ~= nFP2'); end
if nFP2 ~= nFP3; error('nFP2 ~= nFP3'); end
if nTP + nFN ~= TotalPositives; error('nTP + nFN ~= TotalPositives'); end
if nTN + nFP ~= TotalNegatives; error('nTN + nFP ~= TotalNegatives'); end
if TotalPositives+TotalNegatives ~= TotalAll; error('TotalPositives+TotalNegatives ~= TotalAll'); end
if nFN2 ~= nFN; error('nFN2 ~= nFN'); end

Sensitivity = nTP/(nTP+nFN);
if Sensitivity ~= nTP/TotalPositives; error('Sensitivity ~= nTP/TotalPositives'); end

Specificity = nTN/(nTN+nFP);
if Specificity ~= nTN/TotalNegatives; error('Specificity ~= nTN/TotalNegatives'); end

Accuracy = (nTP + nTN)/TotalAll;

J =  (Specificity + Sensitivity) - 1;

%% Output

out = struct;

out.vDice = D;
out.vAccuracy = ACC;
out.vBundleOverlap = BO;
out.vBundleOverreach = BOR;
out.vHD = hd;
out.vHD90 = hd90;
out.vHDmean = hdmean;
out.vBTO = BTO;
out.rSensitivity = Sensitivity;
out.rSpecificity = Specificity;
out.rYouden = J;
out.rAccuracy = Accuracy;

%   ???
%   pdf: table with indices, ROC curve, text from file, tracto picture?








