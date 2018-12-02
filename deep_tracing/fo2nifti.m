function fo2nifti(file_name)
    if ~exist('file_name')
        file_name =  uigetfile('*.fib.gz');
    end
    if file_name == 0
        image = [];
        return
    end
    gunzip(file_name);
    [pathstr, name, ext] = fileparts(file_name);
    movefile(name,strcat(name,'.mat'));
    fib = load(strcat(name,'.mat'));

    odf_vertices = fib.odf_vertices;
    odf_faces = fib.odf_faces;
    delete(strcat(name,'.mat'));
    
    index0 = reshape(fib.index0, fib.dimension);
    fo = zeros([fib.dimension 3]);
    
    for x = 1:fib.dimension(1)
        for y = 1:fib.dimension(2)
            for z = 1:fib.dimension(3)
                fo(x,y,z,:) = odf_vertices(:, index0(x,y,z)+1);
            end
        end
    end
    
    name_parts = strsplit(name, '_');
    
    if length(name_parts) > 2
        out_name = [name_parts{1} '_' name_parts{2} '_fo.nii'];
    elseif length(name_parts) > 2
        out_name = [name_parts{1} '_fo.nii'];
    else
        out_name = 'fo.nii'
    end
    
    out_path = fullfile(pathstr, out_name);
    niftiwrite(fo, out_path);
end
