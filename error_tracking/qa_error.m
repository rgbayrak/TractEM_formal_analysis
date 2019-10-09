clc 
clear all
path_to_old = '/nfs/masi/bayrakrg/tractem_data/corrected';
path_to_new = '/nfs/masi/wangx41/auto_tracked_from_corrected_regions';
path_to_t1 = '/share4/bayrakrg/tractEM/postprocessing/tal_T1';
path_to_list = '/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg/tractem/error_tracking/mat_files';

project = {'BLSA', 'BLSA18', 'HCP'};
t1_project = {'BLSA', 'BLSA', 'HCP'};

for p = 2:length(project)
    
    list = load([path_to_list filesep project{p} '_below40.mat']);
    list = list.list_of_low;
%     old = dir([path_to_old filesep project{p}]);
%     new = dir([path_to_new filesep project{p}]);
    t1 = dir([path_to_t1 filesep t1_project{p}]);
    for j=2:length(list) 
        old = dir(fullfile(path_to_old, project{p}, list(j).subject_rater, '*', [list(j).tract '*density.nii.gz']));
        new = dir(fullfile(path_to_new, project{p}, list(j).subject_rater, '*', [list(j).tract '*density.nii.gz']));
            
        for f = 1:length(old)
            q = load_nii(fullfile(old(f).folder, old(f).name));
            parts = strsplit(old(f).folder, '/');
            id_rater = parts{end-1};
            tract = parts{end};

            q2 = load_nii(fullfile(path_to_new, project{p}, id_rater, tract, old(f).name));

            id_parts = strsplit(id_rater, '_');
            id = id_parts{1};
            t1_dir = dir(fullfile(path_to_t1, t1_project{p}, [id '*.nii']));
            t1 = load_nii(fullfile(t1_dir.folder, t1_dir.name)); 

            disp(id_rater)
            
            figure(1)
            z = sum(sum(q.img,1),2);
            sl = find(z==max(z));
            rgb = repmat(t1.img(:,:,sl(1)),[1 1 3])/max(max(t1.img(:,:,sl(1))))*.75;
            overlay = sum(double(q.img(:,:,:)),3);
            rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
            rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
            imagesc(rgb)
            h = title(['old ' old(f).name]);
            set(h,'Interpreter','none')

            figure(2)
            z = sum(sum(q2.img,1),2);
            sl = find(z==max(z));
            rgb = repmat(t1.img(:,:,sl(1)),[1 1 3])/max(max(t1.img(:,:,sl(1))))*.75;
            overlay = sum(double(q2.img(:,:,:)),3);
            rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
            rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
            imagesc(rgb)
            h = title(['new ' old(f).name]);
            set(h,'Interpreter','none')

            pause

            figure(3)
            z = sum(sum(q.img,1),3);
            sl = find(z==max(z));
            rgb = repmat(squeeze(t1.img(:,sl(1),:)),[1 1 3])/max(max(t1.img(:,sl(1),:)))*.75;
            overlay = squeeze(sum(double(q.img(:,:,:)),2));
            rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
            rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
            imagesc(imrotate(rgb,90))
            axis equal
            h = title(['old ' old(f).name]);
            set(h,'Interpreter','none')

            figure(4)
            z = sum(sum(q2.img,1),3);
            sl = find(z==max(z));
            rgb = repmat(squeeze(t1.img(:,sl(1),:)),[1 1 3])/max(max(t1.img(:,sl(1),:)))*.75;
            overlay = squeeze(sum(double(q2.img(:,:,:)),2));
            rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
            rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
            imagesc(imrotate(rgb,90))
            axis equal
            h = title(['new ' old(f).name]);
            set(h,'Interpreter','none')

            pause

            figure(5)
            z = sum(sum(q.img,2),3);
            sl = find(z==max(z));
            rgb = repmat(squeeze(t1.img(sl(1),:,:)),[1 1 3])/max(max(t1.img(sl(1),:,:)))*.75;
            overlay = squeeze(sum(double(q.img(:,:,:)),1));
            rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
            rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
            imagesc(imrotate(rgb,90))
            h = title(['old ' old(f).name]);
            set(h,'Interpreter','none')

            figure(6)
            z = sum(sum(q2.img,2),3);
            sl = find(z==max(z));
            rgb = repmat(squeeze(t1.img(sl(1),:,:)),[1 1 3])/max(max(t1.img(sl(1),:,:)))*.75;
            overlay = squeeze(sum(double(q2.img(:,:,:)),1));
            rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
            rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
            imagesc(imrotate(rgb,90))
            h = title(['new ' old(f).name]);
            set(h,'Interpreter','none')

            pause

        end
    end
end