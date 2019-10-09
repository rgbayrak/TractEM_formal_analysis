
clear all

files = {'/nfs/masi/bayrakrg/tractem_data/tract_similarity/BLSA'};% '/nfs/masi/bayrakrg/tractem_data/tract_similarity/BLSA'; '/nfs/masi/bayrakrg/tractem_data/tract_similarity/BLSA18'};

for f = 1:length(files)
    all_tracts = zeros(28, 61);
    file_name = {};
    init = 0;
    tract_sim = dir(files{f});
    
    for t = 3:length(tract_sim)
        mat_file = load(fullfile(tract_sim(t).folder, tract_sim(t).name));
        mat_file = struct2array(mat_file);
        name_parts = strsplit(tract_sim(t).name, '/');
        file = name_parts{:};
        
        if init == 0
            all_tracts = str2double(mat_file(:, 2));
%             file_name = file(1:end-9);
            init = 1;
        else
            tmp_all_tracts = str2double(mat_file(:, 2));
            if length(mat_file(:,2)) < size(all_tracts, 1)
                tmp_all_tracts = [tmp_all_tracts; nan(size(all_tracts, 1) - size(tmp_all_tracts, 1), 1)];
            else
                all_tracts = [all_tracts; nan(size(tmp_all_tracts, 1) - size(all_tracts, 1), size(all_tracts, 2))];
            end
            all_tracts = [all_tracts tmp_all_tracts];
        end
    end
    
    all_tracts(all_tracts == 0) = NaN;
    % convert to cell array
    all_cell = num2cell(all_tracts, 1)';
   
    
    tractList61 = {'Anterior Commissure'; 'Anterior Corona Radiata Left';'Anterior Corona Radiata Right'; 'Anterior Limb Internal Capsule Left';'Anterior Limb Internal Capsule Right';'Body Corpus Callosum';...
            'Cingulum Cingulate Gyrus Left';'Cingulum Cingulate Gyrus Right'; 'Cingulum Hippocampal Left'; ...
            'Cingulum Hippocampal Right';'Cerebral Peduncle Left';'Cerebral Peduncle Right';...
            'Corticospinal Tract Left';'Corticospinal Tract Right';'Frontal Lobe Left';'Frontal Lobe Right';'Fornix Left';'Fornix Right';'Fornix Stria Terminalis Left';'Fornix Stria Terminalis Right';...
            'Genu Corpus Callosum';'Inferior Cerebellar Peduncle Left';'Inferior Cerebellar Peduncle Right'; ...
            'Inferior Fronto Occipital Fasciculus Left';'Inferior Fronto Occipital Fasciculus Right';'Inferior Longitudinal Fasciculus Left';'Inferior Longitudinal Fasciculus Right';...
            'Midbrain';'Middle Cerebellar Peduncle';'Medial Lemniscus Left';'Medial Lemniscus Right';'Occipital Lobe Left';'Occipital Lobe Right'; ...
            'Olfactory Radiation Left';'Olfactory Radiation Right';'Optic Tract';...
            'Posterior Corona Radiata Left';'Posterior Corona Radiata Right';'Pontine Crossing Tract';...
            'Posterior Limb Internal Capsule Left';'Posterior Limb Internal Capsule Right';'Parietal Lobe Left';'Parietal Lobe Right';...
            'Posterior Thalamic Radiation Left';'Posterior Thalamic Radiation Right';'Splenium Corpus Callosum';...
            'Superior Cerebellar Peduncle Left';'Superior Cerebellar Peduncle Right';'Superior Corona Radiata Left';'Superior Corona Radiata Right'; ...
            'Superior Fronto Occipital Fasciculus Left';'Superior Fronto Occipital Fasciculus Right';'Superior Longitudinal Fasciculus Left';'Superior Longitudinal Fasciculus Right';...
             'Sagittal Stratum Left';'Sagittal Stratum Right';'Tapetum Corpus Callosum';'Temporal Lobe Left';'Temporal Lobe Right';'Uncinate Fasciculus Left';'Uncinate Fasciculus Right'};

    figure;
    pirateplot(all_cell, tractList61, .95)
    ylim([-0.1 1.1])
    xticks(1:1:61)
    xticklabels(tractList61);
    xtickangle(45);
    ylabel('DICE (th > 0.05)')
    title('Similarity between before and after (density normalized by max)')
    grid minor;
end

