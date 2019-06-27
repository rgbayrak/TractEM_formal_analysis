function [image] = load_only_nii_img(labelDir)
    image = [];
    init = 0;
    for d = 1:length(labelDir)
        % Load nifti density .gz files 
        nii = load_nii(fullfile(labelDir(d).folder, labelDir(d).name));

        if ~init
            image = zeros([size(nii.img) length(labelDir)]);
            init = 1;
        end
        image(:,:,:,d) = nii.img;
    end
end