%RMSE is the distance, on average, of a data point from the fitted line, measured along a vertical line.
function [nameMe, rMSEMatrix, intersubject] = rMSE(densityDir, density, d)
    rMSEMatrix = [];
    nameMe = [];
    init = 0;
    for n = 1:length(densityDir)
            dens_img = density(:,:,:,n);
            %normalize everything into [0,1]
            density(:,:,:,n) = density(:,:,:,n) ./ max(dens_img(:));
    end
    
    % rMSE implementation
    for i = 1:d
        for j = i:d
            im1 = density(:,:,:,i);
            im2 = density(:,:,:,j); 
            % rMSE
            rMSE = sqrt(immse(im1(:), im2(:)));
            % fprintf('\n The mean-squared error is %0.4f\n', rMSE);    

            % Getting the names of compared files
            partsi = strsplit(densityDir(i).folder, '/');
            dirParti = partsi{end-1};  % ----------------------------------------------1 - for HCP, 2 - for HCP
            partsj = strsplit(densityDir(j).folder, '/');
            dirPartj = partsj{end-1};
            

%             % print errors if rMSE is less than %10-30
%             if (rMSE < .5) && (rMSE > .09) && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % -----------------------HCP subjects have 4 digit ids
% %             if (rMSE < .3) && convertCharsToStrings(dirParti(1:6)) == convertCharsToStrings(dirPartj(1:6)) %------------------------HCP subjects have 6 digit ids
% %                 disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
%                 fprintf(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name(1:end-15)), ',' ; ]);
%                 fprintf('Error type: low rMSE! rMSE similarity is %0.4f\n: ', rMSE);
%                 fprintf('\n');
%             end
            
%             % print errors if rMSE is less than %5
%             if (rMSE < .09) && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % -----------------------HCP subjects have 4 digit ids
% %             if (rMSE < .05) && convertCharsToStrings(dirParti(1:6)) == convertCharsToStrings(dirPartj(1:6)) %------------------------HCP subjects have 6 digit ids
% %                 disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
%                 fprintf(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name(1:end-15)), ',' ; ]);
%                 fprintf('Error type: possible mislabeling as L/R. rMSE similarity is %0.4f\n: ', rMSE);
%                 fprintf('\n');
%             end
            
%             % print errors if rMSE is %100
%             if (rMSE == 1) && convertCharsToStrings(dirParti(1:4)) ~= convertCharsToStrings(dirParti(1:4)) && convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % -----------------------HCP subjects have 4 digit ids
% %             if (rMSE == 1) && convertCharsToStrings(dirParti(1:6)) == convertCharsToStrings(dirPartj(1:6)) %------------------------HCP subjects have 6 digit ids
% %                 disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
%                 fprintf(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name(1:end-15)), ',' ; ]);
%                 fprintf('Error type: possible dublicate! rMSE similarity is %0.4f\n: ', rMSE);
%                 fprintf('\n');
%             end
            
            % Initialization
            if ~init
                rMSEMatrix = zeros([length(densityDir) length(densityDir)]);
                init = 1;
            end
            
            % Converting it into a symmetric matrix form
            rMSEMatrix(i,j) = rMSE;
            rMSEMatrix(j,i) = rMSE;
            
            % Keep the inter subject 
            mask = zeros(size(rMSEMatrix));
            if convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % for HCP
                mask(i,j) = 1;
            end
            intersubject = rMSEMatrix(logical(mask));
            
        end
        nameMe = [nameMe convertCharsToStrings(dirParti)]; % getting the subject names
    end
end