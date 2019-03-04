t1 = load_nii('/home-local/bayrakrg/Dropbox (VUMC)/BLSA/BLSA_1834/BLSA_1834_05-0_10/MPRAGE-x-MPRAGE-x-T1wStructuralMRI/NIFTI/wcrmBLSA_1834_05-0_10_MPRAGE.nii');
path = '/home-local/bayrakrg/Dropbox (VUMC)/tractEM/AVG/';
% path = '/share4/bayrakrg/tractEM/postprocessing/M-tracts/BLSA/';
D = dir(path);
for j=30:length(D)
    ff = dir([path filesep D(j).name]);
    for jj = 5:5 %length(ff)
        q = load_nii([ff(jj).folder filesep ff(jj).name]);
%         figure(1)
%         z = sum(sum(q.img,1),2);
%         sl = find(z==max(z));
%         rgb = repmat(t1.img(:,:,sl(1)),[1 1 3])/max(max(t1.img(:,:,sl(1))))*.75;
%         overlay = sum(double(q.img(:,:,:)),3);
%         rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
%         rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
%         imagesc(rgb)
%         h = title(ff(jj).name);
%         set(h,'Interpreter','none')
%         
%         figure(2)
%         z = sum(sum(q.img,1),3);
%         sl = find(z==max(z));
%         rgb = repmat(squeeze(t1.img(:,sl(1),:)),[1 1 3])/max(max(t1.img(:,sl(1),:)))*.75;
%         overlay = squeeze(sum(double(q.img(:,:,:)),2));
%         rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
%         rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
%         imagesc(imrotate(rgb,90))
%         axis equal
%         h = title(ff(jj).name);
%         set(h,'Interpreter','none')
        
        figure(3)
        z = sum(sum(q.img,2),3);
        sl = find(z==max(z));
        rgb = repmat(squeeze(t1.img(sl(1),:,:)),[1 1 3])/max(max(t1.img(sl(1),:,:)))*.75;
        overlay = squeeze(sum(double(q.img(:,:,:)),1));
        rgb(:,:,1) = min(1,rgb(:,:,1) + overlay/max(max(overlay)));
        rgb(:,:,2) = min(1,rgb(:,:,1) + overlay/max(max(overlay))/2);
        imagesc(imrotate(rgb,90))
        h = title(ff(jj).name);
        set(h,'Interpreter','none')
        pause(1)
   end
end