% normalize everything between [0,1]

function all_density = normalize_one(all_density, length_of_dir)
    for n = 1:length(length_of_dir)
       all_density(:,:,:,n) = normalize(all_density(:,:,:,n), 'range');
    end
end