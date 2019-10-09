clc
clear all

outDir = dir('/nfs/masi/bayrakrg/tractem_data/tract_similarity/HCP'); %'/nfs/masi/bayrakrg/tractem_data/tract_similarity/BLSA18'; '/nfs/masi/bayrakrg/tractem_data/tract_similarity/HCP'};
low_dice = struct;    
list_of_low = [];

for n = 3:length(outDir)
    
    mat_file = load(fullfile(outDir(n).folder, outDir(n).name));
    mat_file = struct2array(mat_file);

    for m = 1:length(mat_file)
        dice = str2double(mat_file(m, 2));
        if 0 <= dice && dice < 0.4
%         if dice == 0      
            parts = strsplit(outDir(n).name, '_');
            low_dice.tract = parts{1};
            low_dice.subject_rater = mat_file(m, 1);
            low_dice.dice = dice;
            list_of_low = [list_of_low low_dice];
        end  
    end
end

save('HCP_below40.mat', 'list_of_low');
