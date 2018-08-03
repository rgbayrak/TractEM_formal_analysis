%% brain mask
clear all;
overlay = squeeze(sum(im1,3));
baseimg = squeeze(basevol(:,:,floor(end/2)));
baseimg = log(baseimg);

rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:));
rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:)));

imagesc(rgb)