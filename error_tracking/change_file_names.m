clc
clear all

path_to_new = '/nfs/masi/wangx41/auto_tracked_from_corrected_regions';

project = {'HCP', 'BLSA', 'BLSA18'};

for p = 1:length(project)
    
    project_dir = dir(fullfile(path_to_new, project{p}, '*/*/*tdi.nii.gz'));
    
    for pd = 1:length(project_dir)
        file = fullfile(project_dir(pd).folder, project_dir(pd).name);
        file_parts = strsplit(project_dir(pd).name, '_');
        
        if length(file_parts) == 3
            new_parts = [file_parts{1} '_' file_parts{2}];
            new_file = [project_dir(pd).folder '/' new_parts '_density.nii.gz'];
            if ~isfile(new_file)
                system([ 'cp ' file ' ' new_file]);
            end
            
        elseif length(file_parts) == 2
            new_parts = file_parts{1};
            new_file = [project_dir(pd).folder '/' new_parts '_density.nii.gz'];
            if ~isfile(new_file)
                system([ 'cp ' file ' ' new_file]);
            end
        end       
    end
end