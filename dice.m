function [nameMe, diceMatrix] = dice(densityDir, density, threshold, d)
    diceMatrix = [];
    nameMe = [];
    init = 0;
    for n = 1:length(densityDir)
            dens_img = density(:,:,:,n);
            %normalize everything into [0,1]
            density(:,:,:,n) = density(:,:,:,n) ./ max(dens_img(:));
    end
    % Setting a threshold to avoid outliers
    density(density < threshold) = 0;
    density(density >= threshold) = 1;  
    
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
            dirParti = partsi{end-1};
            partsj = strsplit(densityDir(j).folder, '/');
            dirPartj = partsj{end-1};
            if dice < .3
                disp(['Comparing: ', dirParti,'_', fullfile(densityDir(i).name) ' to ', dirPartj,'_', fullfile(densityDir(j).name)])
                fprintf('\n Dice similarity is %0.4f\n', dice);
                fprintf('\n');
            end

            % Initialization
            if ~init
                diceMatrix = zeros([length(densityDir) length(densityDir)]);
                init = 1;
            end
            
            % Converting it into a symmetric matrix form
            diceMatrix(i,j) = dice;
            diceMatrix(j,i) = dice;
        end
        nameMe = [nameMe convertCharsToStrings(dirParti)]; % getting the subject names
    end
end