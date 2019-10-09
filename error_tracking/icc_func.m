function icc = icc_func(im1, im2)

     im12 = cat(2, im1(:), im2(:));
     icc = ICC(im12, '1-1');
    
end