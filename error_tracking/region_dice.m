function [diceMatrix, nameMe] = region_dice(densityDir, density, threshold, d)
    diceMatrix = [];
    nameMe = [];
    init = 0;
    
    density = normalize(density, d);
    
    % Setting threshold to avoid outliers
    density(density == threshold) = 0;
    density(density > threshold) = 1;  
    
    % Dice implementation
    for i = 1:d
        for j = i:d
            
            im1 = density(:,:,:,i);
            im2 = density(:,:,:,j); 
            
            dice_score = dice_func(im1, im2);
            
            if dice_score == 1

                % Getting the names of compared files
                partsi = strsplit(densityDir(i).folder, '/');
                dirParti = partsi{end-1};  % ----------------------------------------------1 - for BLSA, 2 - for HCP
                partsj = strsplit(densityDir(j).folder, '/');
                dirPartj = partsj{end-1};

%                 % Initialization
%                 if ~init
%                     diceMatrix = zeros([length(densityDir) 1]);
%                     init = 1;
%                 end

%                 % Converting it into a symmetric matrix form
%                 diceMatrix(i,j) = dice_score;
%                 diceMatrix(j,i) = dice_score;

                if strcmp(dirParti(1:4), dirPartj(1:4)) ~= 1

                    % Converting it into a symmetric matrix form
                    diceMatrix(i) = dice_score;
                    nameMe = [nameMe convertCharsToStrings([dirParti ' ,' dirPartj])]; % getting the subject names 

                end  
            end
        end
    end
end