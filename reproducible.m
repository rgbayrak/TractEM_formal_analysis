  
function reproducible(im1, im2)

%     % Normalization
%     aic_l1 = aic_l1./max(aic_l1(:));
%     aic_l2 = aic_l2./max(aic_l2(:));

%     % Difference Absolute
%     diff_density = abs(im1 - im2);
% 
%     % Mean
%     mean_density = (im1 + im2)/2;
% 
%     slice_num = 90;
% 
%     % Figure
%     figure
%     subplot(2,2,1)
%     imagesc(squeeze(im1(:,:,slice_num)));
%     axis equal
%     colorbar
%     title('Rater1 aic')
% 
%     subplot(2,2,2)
%     imagesc(squeeze(im2(:,:,slice_num)));
%     axis equal
%     colorbar
%     title('Rater2 aic')
% 
%     subplot(2,2,3)
%     imagesc(squeeze(diff_density(:,:,slice_num)));
%     axis equal
%     colorbar
%     title('Absolute Difference')
% 
%     subplot(2,2,4)
%     imagesc(squeeze(mean_density(:,:,slice_num)));
%     axis equal
%     colorbar
%     title('Mean of the tracts')
    
    % OVERLAP BASED METRICS
    % Dice Coefficient & Jaccard Index
    % Since both of the metrics measures the same aspects, does not
    % provide additional information. 
    
    % Setting a threshold to avoid outliers
    threshold = 0.05;
    im1(im1 < threshold) = 0;
    im1(im1 >= threshold) = 1;

    im2(im2 < threshold) = 0;
    im2(im2 >= threshold) = 1;


    intersection = (im1 & im2);
    is = sum(intersection(:));
    d1 = sum(im1(:));
    d2 = sum(im2(:));

    Dice = 2*is/(d1+d2);
    fprintf('\n Dice similarity is %0.4f\n', Dice);
    
    % JAC = Dice/(2-Dice);
    JAC = 2*is / (2*(d1+d2-is));
    fprintf('\n Jaccard index is %0.4f\n', JAC);
     
    
    
    % VOLUME BASED METRICS
    % Volumetric Similarity | 
    VS = 1- (abs(abs(d1)-abs(d2))/(abs(d1)+abs(d2)));
    fprintf('\n Volumetric similarity is %0.4f\n', VS);
    
     % MSE
    MSE = immse(im1, im2);
    fprintf('\n The mean-squared error is %0.4f\n', MSE);

    
     
%     % ICC 
%     dims = size(im1);
%     temp_icc = [];        
%     redens1 = reshape(im1,[dims(1)*dims(2)*dims(3) 1]);
%     redens2 = reshape(im2,[dims(1)*dims(2)*dims(3) 1]);
% 
%     M = cat(2,redens1,redens2);
% 
%     icc = ICC(M,'1-1');
% 
%     temp_icc = [temp_icc,icc];

end