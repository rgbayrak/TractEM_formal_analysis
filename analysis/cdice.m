function [nameMe, diceMatrix] = cdice(densityDir, density, threshold, d)
    diceMatrix = [];
    nameMe = [];
    init = 0;

    % Continuous Dice implementation
    for i = 1:d
        for j = i:d
            im1 = density(:,:,:,i);
            im1(im1 < threshold) = 0; 
            im1(im1 >= threshold) = 1;

            im2 = density(:,:,:,j); 
            is = sum(im1(:).*im2(:));
            d1 = sum(im1(:));
            d2 = sum(im2(:));

            if (is > 0)
                cont = sum(im1(:).*im2(:))/sum(im1(:).*sign(im2(:)));
            else
                cont = 1;
            end
            cdice = (2*is)/(cont*d1+d2);
            
            
            % Getting the names of compared files
            partsi = strsplit(densityDir(i).folder, '/');
            dirParti = partsi{end-1}; % ----------------------------------------------1 - for BLSA, 2 - for HCP
            partsj = strsplit(densityDir(j).folder, '/');
            dirPartj = partsj{end-1}; % ----------------------------------------------1 - for BLSA, 2 - for HCP
            
            %             % print errors if dice is less than %10-30
%             if (cdice < .5) && (dice > .09) && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % -----------------------BLSA subjects have 4 digit ids
% %             if (cdice < .3) && convertCharsToStrings(dirParti(1:6)) == convertCharsToStrings(dirPartj(1:6)) %------------------------HCP subjects have 6 digit ids
% %                 disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
%                 fprintf(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name(1:end-15)), ',' ; ]);
%                 fprintf('Error type: low dice! Dice similarity is %0.4f\n: ', cdice);
%                 fprintf('\n');
%             end
            
            % print errors if dice is less than %5
            if (cdice < .09) && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % -----------------------BLSA subjects have 4 digit ids
%             if (cdice < .05) && convertCharsToStrings(dirParti(1:6)) == convertCharsToStrings(dirPartj(1:6)) %------------------------HCP subjects have 6 digit ids
%                 disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
                fprintf(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name(1:end-15)), ',' ; ]);
                fprintf('Error type: possible mislabeling as L/R. Dice similarity is %0.4f\n: ', cdice);
                fprintf('\n');
            end
            
            % print errors if dice is %100
            if (cdice == 1) && convertCharsToStrings(dirParti(1:4)) ~= convertCharsToStrings(dirParti(1:4)) && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % -----------------------BLSA subjects have 4 digit ids
%             if (cdice == 1) && convertCharsToStrings(dirParti(1:6)) == convertCharsToStrings(dirPartj(1:6)) %------------------------HCP subjects have 6 digit ids
%                 disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
                fprintf(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name(1:end-15)), ',' ; ]);
                fprintf('Error type: possible dublicate! Dice similarity is %0.4f\n: ', cdice);
                fprintf('\n');
            end
            
            % Initialization
            if ~init
                diceMatrix = zeros([length(densityDir) length(densityDir)]);
                init = 1;
            end
            
            % Converting it into a symmetric matrix form
            diceMatrix(i,j) = cdice;
            diceMatrix(j,i) = cdice;
        end
           % Subject names
           nameMe = [nameMe convertCharsToStrings(dirParti)]; % getting the subject names
    end
end