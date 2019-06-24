function [hd, hdmean, modHausdd, hd90] = HausdorffDists(P,Q)
% Calculates the Hausdorff Distance between P and Q
% hd: Hausdorff distance
% hdmean: mean of min distances
% hd90: 90th percentile of in distances

% [c_x, c_y, c_z] = ind2sub(size(track_binary_s), find(track_binary_s));
% c_coords = cat(2, c_x, c_y, c_z); % Mx3
% dist_m = pdist2(h_coords, c_coords);% distrance matrix: distance b/t two voxels
% har = max(max(min(dist_m,[],1)), max(min(dist_m,[],2)));
% harmean = (mean(min(dist_m,[],1))+mean(min(dist_m,[],2)))/2;
% har90 = prctile([min(dist_m,[],1) min(dist_m,[],2)'],90);

sP = size(P); sQ = size(Q);

% loop through every point saving only min distances for each matrix
minPs = zeros(sP(1),1);
for p = 1:sP(1)
    % calculate the minimum distance from points in P to Q
    minPs(p) = sqrt(min(sum( bsxfun(@minus,P(p,:),Q).^2, 2)));
end

minQs = zeros(sQ(1),1);
for q = 1:sQ(1)
    % calculate the minimum distance from points in P to Q
    minQs(q) = sqrt(min(sum( bsxfun(@minus,Q(q,:),P).^2, 2)));
end

hd = max([minPs; minQs]);
hdmean = (mean(minPs) + mean(minQs))/2;
modHausdd = max([mean(minPs),mean(minQs)]);
hd90 = prctile([minPs; minQs],90);

end

