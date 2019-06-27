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
            

            % Initialization
            if ~init
                diceMatrix = zeros([length(densityDir) length(densityDir)]);
                init = 1;
            end
            
            % Converting it into a symmetric matrix form
            diceMatrix(i,j) = mhd;
            diceMatrix(j,i) = mhd;
        end
           % Subject names
           nameMe = [nameMe convertCharsToStrings(dirParti)]; % getting the subject names
    end
end