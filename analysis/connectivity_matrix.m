% Vanderbilt University, 2018
% roza.g.bayrak@vanderbilt.edu

clc
clear all
close all

%%
seg = load_nii('pathtofile/wcrBLSA_1134_16-0_10_MPRAGE_seg.nii');
density = load_nii('pathtofile/pic_R_density.nii.gz');

% Brain region labels
BrainColorROI = [4 11 23 30 31 32 35 36 37 38 39 40 41 44 45 47 48 49 50 51 52 55 56 57 58 59 60 61 62 71 72 73 75 76 100 101 102 103 104 105 106 107 108 109 112 113 114 115 116 117 118 119 120 121 122 123 124 125 128 129 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207];

connROI = zeros(length(BrainColorROI),length(BrainColorROI));

for jRoi = 1:length(BrainColorROI)

disp(jRoi)

   for kRoi = jRoi:length(BrainColorROI)

       roiJ = seg.img(:)==BrainColorROI(jRoi);

       roiK = seg.img(:)==BrainColorROI(kRoi);

       connROI(jRoi,kRoi) = min(sum(density.img(roiJ)),sum(density.img(roiK)));

       connROI(kRoi,jRoi) = connROI(jRoi,kRoi);

   end

end

p = figure('Visible', 'on');
image(connROI)
title('Connectivity Matrix for Right Posterior Limb Internal Capsule', 'FontSize', 10); % set title
ylabel('Brain Color ROI')
xlabel('Brain Color ROI')
% xticks(1:length(BrainColorROI))
% xticklabels(BrainColorROI);
% xtickangle(45)
% yticks(1:length(BrainColorROI))
% yticklabels(BrainColorROI);
% ytickangle(45)
colormap(parula(100000)); % set the colorscheme
hcb = colorbar;
hcb.Label.String = 'Correlation';
saveas(p,'pathtofile/pic_R.jpg'); 



