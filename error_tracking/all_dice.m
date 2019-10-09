function output = all_dice(newdensDir, threshold)

    new_density = load_density(newdensDir);            
    Nl = length(newdensDir); 
    new_density = norm_func(new_density, Nl);
    
    % Binarize   
    new_density(new_density <= threshold) = 0;
    new_density(new_density > threshold) = 1;  
    
    % Dice calculation
    init = 0;
    scoreMatrix = [];
    nameMe = [];
    second_name = [];
    
    for i = 1:Nl
        % Getting the names of compared files
        partsi = strsplit(newdensDir(i).folder, '/');
        dirParti = partsi{end-1};
        parts_id = strsplit(dirParti, '_');
        dirParti_id = parts_id{1};
        for j = i:Nl
            
            partsj = strsplit(newdensDir(j).folder, '/');
            dirPartj = partsj{end-1};   
            parts_jd = strsplit(dirPartj, '_');
            dirPartj_id = parts_jd{1};
            % Initialization
            if ~init
                scoreMatrix = zeros([Nl Nl]);
                init = 1;
            end
                
            if strcmp(dirParti_id, dirPartj_id) == 1
            
                im1 = new_density(:,:,:,i);
                im2 = new_density(:,:,:,j); 
                score = dice_func(im1, im2);
%                 score2 = icc_func(im1, im2);
                
%                 % debugging, if  the score is zero make sure it actually
%                 % is
%                 if score == 0
%                     pause
%                 end

                % Converting it into a symmetric matrix form
                if isnan(score)
                	scoreMatrix(i, j) = 0;
                else
                    scoreMatrix(i, j) = score;
                end
                second_name = [second_name convertCharsToStrings([dirParti])];
            end  
        end
    end
    output = [unique(second_name)' scoreMatrix];
end