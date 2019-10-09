function dice = dice_func(im1, im2)

    is = sum(im1(:).*im2(:));
    d1 = sum(im1(:));
    d2 = sum(im2(:));
    dice = (2*is)/(d1+d2);
    
end