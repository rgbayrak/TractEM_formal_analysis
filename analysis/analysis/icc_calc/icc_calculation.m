function output_icc = icc_calculation(number_images,data)

    output_icc = [];
    for k = 1:6

        dice_pairs=nchoosek(1:number_images,2); % unique combinations
        length = size(dice_pairs); % number of rows, number of pairs
        temp_icc = [];

        % loop through however many number of dice pairs you have 
        for i = 1:length(1)
            pair_values = dice_pairs(i,:);  %ith pair

            % Implementation of ICC
            image_one = data(:,:,:,k,pair_values(1)); % first image in the pair
            image_two = data(:,:,:,k,pair_values(2)); % second image in the pair
            
            dims = size(image_one);
            
            one_re = reshape(image_one,[dims(1)*dims(2)*dims(3) 1]);
            two_re = reshape(image_two,[dims(1)*dims(2)*dims(3) 1]);
            
            M = cat(2,one_re,two_re);
            
            icc = ICC(M,'1-1');
            
            temp_icc = [temp_icc,icc];
            
        end
        output_icc = [output_icc;nanmean(temp_icc)];
    end        
    display(output_icc)
end