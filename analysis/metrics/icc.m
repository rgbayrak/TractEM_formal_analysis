function [nameMe, iccMatrix, intersubject] = icc(densityDir, density, d)
    iccMatrix = [];
    nameMe = [];
    init = 0;
    for n = 1:length(densityDir)
            dens_img = density(:,:,:,n);
            %normalize everything into [0,1]
            density(:,:,:,n) = density(:,:,:,n) ./ max(dens_img(:));
    end
    
    % icc implementation
    for i = 1:d
        for j = i:d
            
            im1 = density(:,:,:,i);
            im2 = density(:,:,:,j); 
            im12 = cat(2, im1(:), im2(:));
            icc = ICC(im12, '1-1');

            % Getting the names of compared files
            partsi = strsplit(densityDir(i).folder, '/');
            dirParti = partsi{end-1};  % ----------------------------------------------1 - for HCP, 2 - for HCP
            partsj = strsplit(densityDir(j).folder, '/');
            dirPartj = partsj{end-1};
            
            % Initialization
            if ~init
                iccMatrix = zeros([length(densityDir) length(densityDir)]);
                init = 1;
            end
            
            % Converting it into a symmetric matrix form
            iccMatrix(i,j) = icc;
            iccMatrix(j,i) = icc;
            
            % Keep the inter subject 
            mask = zeros(size(iccMatrix));
            if convertCharsToStrings(dirParti(1:4)) == convertCharsToStrings(dirPartj(1:4)) % for HCP
                mask(i,j) = 1;
            end
            intersubject = iccMatrix(logical(mask));
            
        end
        nameMe = [nameMe convertCharsToStrings(dirParti)]; % getting the subject names
    end
end