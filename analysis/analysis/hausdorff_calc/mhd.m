function [nameMe, temp_hd, temp_hdmean, temp_modHausdd, temp_hd90] = mhd(labelDir, label, d)
    mhdMatrix = [];
    nameMe = [];
    init = 0;

    % Modified Hausdorff Distance implementation
    for i = 1:d
        for j = i:d
            im1 = label(:,:,:,i);
            im2 = label(:,:,:,j); 

            if sum(im1(:)) > 0 && sum(im2(:)) > 0
            
                % Getting the ids and the names of compared files
                partsi = strsplit(labelDir(i).folder, '/');
                subj1 = strsplit(partsi{end-1}, '_');
                subj1_id = subj1{1};
                subj1_in = subj1{2};
                partsj = strsplit(labelDir(j).folder, '/');
                subj2 = strsplit(partsj{end-1}, '_');
                subj2_jd = subj2{1};
                subj2_jn = subj2{2};

                dirParti = partsi{end-1}; % ---------------------------------------------- 1 - for BLSA, 2 - for HCP
                dirPartj = partsj{end-1}; % ---------------------------------------------- 1 - for BLSA, 2 - for HCP


                if strcmp(subj1_id,subj2_jd) %&& ~strcmp(subj1_in, subj2_jn)
                    tprintf(subj1_in)
                    tprintf(subj2_jn)
                    tprintf('\n')

    %                 mhd = ModHausDist(im1, im2);
    %                 mhd = bwModHausDist(im1, im2);

                    [hd, hdmean, modHausdd, hd90] = HD(im1, im2);

                    % Initialization
                    if ~init
                        temp_hd = Inf([length(labelDir) length(labelDir)]);
                        temp_hdmean = Inf([length(labelDir) length(labelDir)]);
                        temp_modHausdd = Inf([length(labelDir) length(labelDir)]);
                        temp_hd90 = Inf([length(labelDir) length(labelDir)]);
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
        end
        % Subject names
        parts = strsplit(labelDir(i).folder, '/');
        subjPart = parts{end-1}; % ---------------------------------------------- 1 - for BLSA, 2 - for HCP
        nameMe = [nameMe convertCharsToStrings(subjPart)]; % getting the subject names
    end
end