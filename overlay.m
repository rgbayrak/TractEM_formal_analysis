% % Overlaying two density files
% Author: roza.g.bayrak@vanderbilt.edu

close all;
clear all;
clc;


% BLSA
exDir              = '/home-local/bayrakrg/Dropbox*VUMC*/complete_BLSA_subjects';
subjectDir = fullfile(exDir, '*');  % directory names are as follows -> subject_rater
subDir = fullfile(subjectDir, '*');  % tract names are defined as published

abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
            'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
trackList = {'Anterior Commissure'; 'Anterior Corona Radiata'; 'Anterior Limb Internal Capsule';'Body Corpus Callosum';'Cerebral Peduncle';'Cingulum Cingulate Gyrus'; ...
            'Cingulum Hippocampal';'Corticospinal Tract';'Fornix';'Fornix Stria Terminalis';'Frontal Lobe';'Genu Corpus Callosum';'Inferior Cerebellar Peduncle'; ...
            'Inferior Fronto Occipital Fasciculus';'Inferior Longitudinal Fasciculus';'Medial Lemniscus';'Midbrain';'Middle Cerebellar Peduncle';'Occipital Lobe'; ...
            'Olfactory Radiation';'Optic Tract';'Parietal Lobe';'Pontine Crossing Tract';'Posterior Corona Radiata';'Posteriorlimb Internal Capsule'; ...
            'Posterior Thalamic Radiation';'Sagittal Stratum';'Splenium Corpus Callosum';'Superior Cerebellar Peduncle';'Superior Corona Radiata'; ...
            'Superior Fronto Occipital Fasciculus';'Superior Longitudinal Fasciculus';'Tapetum Corpus Callosum';'Temporal Lobe';'Uncinate Fasciculus'};
  
threshold = .05;
for l = 1:length(abbList)
    % get track folders and do analysis on them
    densityDir = dir(fullfile(subDir, [abbList{l} '_*density.nii.gz'])); % not every folder has separate density files (left & right)
    
    % If there is only one tract file
    if length(strfind(densityDir(1).name,'_')) == 1
           d = length(densityDir);
           density = load_density(densityDir);
           [nameMe, diceMatrix] = dice(densityDir, density, threshold, d);
           
           %loop to overlay same subject images
            for i = 1:d
                for j = i:d
                    % Getting the names of compared files
                    partsi = strsplit(densityDir(i).folder, '/');
                    dirParti = partsi{end-1};  % ----------------------------------------------1 - for BLSA, 2 - for HCP
                    partsj = strsplit(densityDir(j).folder, '/');
                    dirPartj = partsj{end-1};
                    if diceMatrix(i,j) < .1
                        if i ~= j && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4))

                            im1 = density(:,:,:,i);
                            im2 = density(:,:,:,j);

                            figure(1)
                            subplot(2,2,1);
                            A = squeeze(sum(im1,3));
                            A(:,:,2) = squeeze(sum(im2,3));
                            A(:,:,3) = (A(:,:,1) + A(:,:,2))/2;
                            A = log(A);
                            image(A/max(A(:)))
                            ylabel('\bf Axial');
                            name = densityDir(1).name(1:end-15);
                            title([strrep(dirParti, '_', ' ') ' vs ' strrep(dirPartj, '_', ' ') ' ' name])
                            subplot(2,2,2);
                            A = squeeze(sum(im1,2));
                            A(:,:,2) = squeeze(sum(im2,2));
                            A(:,:,3) = (A(:,:,1) + A(:,:,2))/2;
                            A = log(A);
                            image(A/max(A(:)))
                            title(['Dice: ' num2str(diceMatrix(i,j))])
                            ylabel('\bf Coronal')
                            subplot(2,2,3);
                            A = squeeze(sum(im1,1));
                            A(:,:,2) = squeeze(sum(im2,1));
                            A(:,:,3) = (A(:,:,1) + A(:,:,2))/2;
                            A = log(A);
                            image(A/max(A(:)))
                            ylabel('\bf Sagital')

                            set(figure(1),'Position', [1 1 1680 1050]);
                            saveas(figure(1),['/home-local/bayrakrg/Dropbox (VUMC)/BLSA/lessThan10PercentOverlap/' dirParti '_vs_' dirPartj '_' name '_overlay.jpg']); 
                            close all;

                        end
                    end
                end
           end
   
    % If there is two tract files
    % for left side
    elseif length(strfind(densityDir(1).name,'_')) == 2
        if length(strfind(densityDir(1).name,'_L')) == 1
            densityLDir = dir(fullfile(subDir, [abbList{l} '_L_density.nii.gz'])); % not every folder has separate density files (left & right)
            dl = length(densityLDir);
            densityL = load_density(densityLDir);
            [nameMe, diceL] = dice(densityLDir, densityL, threshold, dl);
            
            %loop to overlay to same subject images
            for i = 1:dl
                for j = i:dl
                    % Getting the names of compared files
                    partsi = strsplit(densityLDir(i).folder, '/');
                    dirParti = partsi{end-1};  % ----------------------------------------------1 - for BLSA, 2 - for HCP
                    partsj = strsplit(densityLDir(j).folder, '/');
                    dirPartj = partsj{end-1};
                    
                    if diceL(i,j) < .1
                        if i ~= j && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4))

                            imL1 = densityL(:,:,:,i);
                            imL2 = densityL(:,:,:,j);

                            figure(2)
                            subplot(2,2,1);
                            L = squeeze(sum(imL1,3));
                            L(:,:,2) = squeeze(sum(imL2,3));
                            L(:,:,3) = (L(:,:,1) + L(:,:,2))/2;
                            L = log(L);
                            image(L/max(L(:)))
                            ylabel('\bf Axial');
                            name = densityDir(1).name(1:end-15);
                            title([strrep(dirParti, '_', ' ') ' vs ' strrep(dirPartj, '_', ' ') ' ' name])
                            subplot(2,2,2);
                            L = squeeze(sum(imL1,2));
                            L(:,:,2) = squeeze(sum(imL2,2));
                            L(:,:,3) = (L(:,:,1) + L(:,:,2))/2;
                            L = log(L);
                            image(L/max(L(:)))
                            title(['Dice: ' num2str(diceL(i,j))])
                            ylabel('\bf Coronal')
                            subplot(2,2,3);
                            L = squeeze(sum(imL1,1));
                            L(:,:,2) = squeeze(sum(imL2,1));
                            L(:,:,3) = (L(:,:,1) + L(:,:,2))/2;
                            L = log(L);
                            image(L/max(L(:)))
                            ylabel('\bf Sagital')

                            set(figure(2),'Position', [1 1 1680 1050]);
                            saveas(figure(2),['/home-local/bayrakrg/Dropbox (VUMC)/BLSA/lessThan10PercentOverlap/' dirParti '_vs_' dirPartj '_' name '_overlay.jpg']); 
                            close all;
                            

                        end
                    end
                end
            end

        end
        
        % for right side
        if length(strfind(densityDir(2).name,'_R')) == 1
            densityRDir = dir(fullfile(subDir, [abbList{l} '_R_density.nii.gz'])); % not every folder has separate density files (left & right)
            dr = length(densityRDir);
            densityR = load_density(densityRDir);
            [nameMe, diceR] = dice(densityRDir, densityR, threshold, dr);
            
            %loop to overlay to same subject images
            for i = 1:dr
                for j = i:dr
                    % Getting the names of compared files
                    partsi = strsplit(densityRDir(i).folder, '/');
                    dirParti = partsi{end-1};  % ----------------------------------------------1 - for BLSA, 2 - for HCP
                    partsj = strsplit(densityRDir(j).folder, '/');
                    dirPartj = partsj{end-1};
                    
                    if diceR(i,j) < .1
                        if i ~= j && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4))

                            imR1 = densityR(:,:,:,i);
                            imR2 = densityR(:,:,:,j);

                            figure(3)
                            subplot(2,2,1);
                            R = squeeze(sum(imR1,3));
                            R(:,:,2) = squeeze(sum(imR2,3));
                            R(:,:,3) = (R(:,:,1) + R(:,:,2))/2;
                            R = log(R);
                            image(R/max(R(:)))
                            ylabel('\bf Axial')
                            name = densityDir(1).name(1:end-15);
                            title([strrep(dirParti, '_', ' ') ' vs ' strrep(dirPartj, '_', ' ') ' ' name])                            
                            subplot(2,2,2);
                            R = squeeze(sum(imR1,2));
                            R(:,:,2) = squeeze(sum(imR2,2));
                            R(:,:,3) = (R(:,:,1) + R(:,:,2))/2;
                            R = log(R);
                            image(R/max(R(:)))
                            ylabel('\bf Coronal')
                            title(['Dice: ' num2str(diceR(i,j))])
                            subplot(2,2,3);
                            R = squeeze(sum(imR1,1));
                            R(:,:,2) = squeeze(sum(imR2,1));
                            R(:,:,3) = (R(:,:,1) + R(:,:,2))/2;
                            R = log(R);
                            image(R/max(R(:)))
                            ylabel('\bf Sagital')

                            set(figure(3),'Position', [1 1 1680 1050]);
                            saveas(figure(3),['/home-local/bayrakrg/Dropbox (VUMC)/BLSA/lessThan10PercentOverlap/' dirParti '_vs_' dirPartj '_' name '_overlay.jpg']); 
                            close all;

                        end
                    end
                end
            end
        end   
    end
end

