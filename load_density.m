function [density] = load_density(densityDir)
    density = [];
    init = 0;
    for d = 1:length(densityDir)
        % Load nifti density .gz files 
        density_nii = load_nii(fullfile(densityDir(d).folder, densityDir(d).name));

        if ~init
            density = zeros([size(density_nii.img) length(densityDir)]);
            init = 1;
        end
        density(:,:,:,d) = density_nii.img;
    end
end
