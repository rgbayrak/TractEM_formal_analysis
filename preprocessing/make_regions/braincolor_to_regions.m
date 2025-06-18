function braincolor_to_regions(seg_file,out_dir,code_dir)

%% Make regions ROIs from the braincolor segmentation

labels = readtable([code_dir '/make_Regions/braincolor_hierarchy_STAPLE.txt'], ...
	'ReadVariableNames',true);

% For each label in the full set (133), assign it to one of our 8 Regions
% depending on the 47 values.
Regionnames = table(categorical({ ...
	'R_Frontal', ...
	'L_Frontal', ...
	'R_Parietal', ...
	'L_Parietal', ...
	'R_Occipital', ...
	'L_Occipital', ...
	'R_Temporal', ...
	'L_Temporal' ...
	})','VariableNames',{'Region'});
Regionnames.Label = (1:height(Regionnames))';
writetable(Regionnames,fullfile(out_dir,'Regions_labels.csv'));
labels.Regions = zeros(size(labels.x133));
for k = 1:height(labels)
	switch labels.x47(k)
		case {5,33,35,43}
			labels.Regions(k) = find(Regionnames.Region=='R_Frontal');
		case {6,34,36,44}
			labels.Regions(k) = find(Regionnames.Region=='L_Frontal');
		case {37}
			labels.Regions(k) = find(Regionnames.Region=='R_Parietal');
		case {38}
			labels.Regions(k) = find(Regionnames.Region=='L_Parietal');
		case {39,45}
			labels.Regions(k) = find(Regionnames.Region=='R_Occipital');
		case {40,46}
			labels.Regions(k) = find(Regionnames.Region=='L_Occipital');
		case {41}
			labels.Regions(k) = find(Regionnames.Region=='R_Temporal');
		case {42}
			labels.Regions(k) = find(Regionnames.Region=='L_Temporal');
			
	end
end

% Fix the hippocampus
labels.Regions(ismember(labels.x133,[31 47])) = ...
	find(Regionnames.Region=='R_Temporal');
labels.Regions(ismember(labels.x133,[32 48])) = ...
	find(Regionnames.Region=='L_Temporal');

% Fix the insula
labels.Regions(ismember(labels.x133,[102 112])) = ...
	find(Regionnames.Region=='R_Frontal');
labels.Regions(ismember(labels.x133,[103 113])) = ...
	find(Regionnames.Region=='L_Frontal');

% Fix the cuneus
labels.Regions(ismember(labels.x133,[166 168])) = ...
	find(Regionnames.Region=='R_Parietal');
labels.Regions(ismember(labels.x133,[167 169])) = ...
	find(Regionnames.Region=='L_Parietal');


% One image per Region
V = spm_vol(seg_file);
Yseg = spm_read_vols(V);
for k = 1:height(Regionnames)
	Yout = zeros(size(Yseg));
	Yout(YRegions(:)==k) = 1;
	Vout = V;
	Vout.fname = fullfile(out_dir,['Region_' char(Regionnames.Region(k)) '.nii']);
	spm_write_vol(Vout,Yout);
end
