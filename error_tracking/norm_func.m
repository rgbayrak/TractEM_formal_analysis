% normalize everything between [0,1]

function all_density = norm_func(all_density, length_of_dir)
    for n = 1:length_of_dir
            dens_img = all_density(:,:,:,n);
            all_density(:,:,:,n) = all_density(:,:,:,n) ./ max(dens_img(:));
    end
end