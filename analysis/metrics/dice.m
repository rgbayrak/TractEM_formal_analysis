function [nameMe, diceMatrix, intersubject] = dice(densityDir, density, threshold, d)
    diceMatrix = [];
    nameMe = [];
    init = 0;
    for n = 1:length(densityDir)
            dens_img = density(:,:,:,n);
            %normalize everything into [0,1]
            density(:,:,:,n) = density(:,:,:,n) ./ max(dens_img(:));
    end
    
    % Setting threshold to avoid outliers
    density(density < threshold) = 0;
    density(density >= threshold) = 1;  
    
    % Dice implementation
    for i = 1:d
        for j = i:d
            
            im1 = density(:,:,:,i);
            im2 = density(:,:,:,j); 
            is = sum(im1(:).*im2(:));
            d1 = sum(im1(:));
            d2 = sum(im2(:));
            dice = (2*is)/(d1+d2);

            % Getting the names of compared files
            partsi = strsplit(densityDir(i).folder, '/');
            dirParti = partsi{end-1};  % ----------------------------------------------1 - for BLSA, 2 - for HCP
            partsj = strsplit(densityDir(j).folder, '/');
            dirPartj = partsj{end-1};
            

%             % print errors if dice is less than %10-30
%             if (dice < .5) && (dice > .09) && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % -----------------------BLSA subjects have 4 digit ids
% %             if (dice < .3) && convertCharsToStrings(dirParti(1:6)) == convertCharsToStrings(dirPartj(1:6)) %------------------------HCP subjects have 6 digit ids
% %                 disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
%                 fprintf(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name(1:end-15)), ',' ; ]);
%                 fprintf('Error type: low dice! Dice similarity is %0.4f\n: ', dice);
%                 fprintf('\n');
%             end
            
%             % print errors if dice is less than %5
%             if (dice < .09) && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % -----------------------BLSA subjects have 4 digit ids
% %             if (dice < .05) && convertCharsToStrings(dirParti(1:6)) == convertCharsToStrings(dirPartj(1:6)) %------------------------HCP subjects have 6 digit ids
% %                 disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
%                 fprintf(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name(1:end-15)), ',' ; ]);
%                 fprintf('Error type: possible mislabeling as L/R. Dice similarity is %0.4f\n: ', dice);
%                 fprintf('\n');
%             end
            
%             % print errors if dice is %100
%             if (dice == 1) && convertCharsToStrings(dirParti(1:4)) ~= convertCharsToStrings(dirParti(1:4)) && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % -----------------------BLSA subjects have 4 digit ids
% %             if (dice == 1) && convertCharsToStrings(dirParti(1:6)) == convertCharsToStrings(dirPartj(1:6)) %------------------------HCP subjects have 6 digit ids
% %                 disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
%                 fprintf(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name(1:end-15)), ',' ; ]);
%                 fprintf('Error type: possible dublicate! Dice similarity is %0.4f\n: ', dice);
%                 fprintf('\n');
%             end
            
            % Initialization
            if ~init
                diceMatrix = zeros([length(densityDir) length(densityDir)]);
                init = 1;
            end
            
            % Converting it into a symmetric matrix form
            diceMatrix(i,j) = dice;
            diceMatrix(j,i) = dice;
            
            % Keep the inter subject 
            mask = zeros(size(diceMatrix));
            if convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % for BLSA
                mask(i,j) = 1;
            end
            intersubject = diceMatrix(logical(mask));
            
        end
        nameMe = [nameMe convertCharsToStrings(dirParti)]; % getting the subject names
    end
end
