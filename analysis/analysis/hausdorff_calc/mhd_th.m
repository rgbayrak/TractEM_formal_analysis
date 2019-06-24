function [nameMe, temp_hd, temp_hdmean, temp_modHausdd, temp_hd90] = mhd_th(tractDir, tract, threshold, d)
    mhdMatrix = [];
    nameMe = [];
    init = 0;

    
    for n = 1:length(tractDir)
            tr_img = tract(:,:,:,n);
            %normalize everything into [0,1]
            tract(:,:,:,n) = tract(:,:,:,n) ./ max(tr_img(:));
    end
    
    % Setting threshold to avoid outliers
    tract(tract == threshold) = 0;
    tract(tract > threshold) = 1;  
    
    
    % Modified Hausdorff Distance implementation
    for i = 1:d
        for j = i:d
            im1 = tract(:,:,:,i);
            im2 = tract(:,:,:,j); 

            % Getting the ids and the names of compared files
            partsi = strsplit(tractDir(i).folder, '/');
            subj1 = strsplit(partsi{end-1}, '_');
            subj1_id = subj1{1};
            subj1_in = subj1{2};
            partsj = strsplit(tractDir(j).folder, '/');
            subj2 = strsplit(partsj{end-1}, '_');
            subj2_jd = subj2{1};
            subj2_jn = subj2{2};
            
            dirParti = partsi{end-1}; % ---------------------------------------------- 1 - for BLSA, 2 - for HCP
            dirPartj = partsj{end-1}; % ---------------------------------------------- 1 - for BLSA, 2 - for HCP
            

            if strcmp(subj1_id,subj2_jd) && ~strcmp(subj1_in, subj2_jn)
                tprintf(subj1_in)
                tprintf(subj2_jn)
                tprintf('\n')

%                 mhd = ModHausDist(im1, im2);
%                 mhd = bwModHausDist(im1, im2);
                [hd, hdmean, modHausdd, hd90] = HD(im1, im2);

                % Initialization
                if ~init
                    temp_hd = zeros([length(tractDir) length(tractDir)]);
                    temp_hdmean = zeros([length(tractDir) length(tractDir)]);
                    temp_modHausdd = zeros([length(tractDir) length(tractDir)]);
                    temp_hd90 = zeros([length(tractDir) length(tractDir)]);
                    init = 1;
                end

                % Converting it into a symmetric matrix form
                temp_hd(i,j) = hd;
                temp_hd(j,i) = hd;
                
                temp_hdmean(i,j) = hdmean;
                temp_hdmean(j,i) = hdmean;
                
                temp_modHausdd(i,j) = modHausdd;
                temp_modHausdd(j,i) = modHausdd;
                
                temp_hd90(i,j) = hd90;
                temp_hd90(j,i) = hd90;
            end
        end
        % Subject names
        nameMe = [nameMe convertCharsToStrings(dirParti)]; % getting the subject names
    end
end