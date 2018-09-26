function [] = overlap_plots(im1, im2, background)


%     subplot(2,2,1);
%     A = squeeze(sum(im1,3));
%     A(:,:,2) = squeeze(sum(im2,3));
%     A = log(A);
%     A(:,:,3) = (A(:,:,1) + A(:,:,2))/2;
%     image(A/max(A(:)))
%     ylabel('\bf Axial');
%     name = densityDir(1).name(1:end-15);
%     title([strrep(dirParti, '_', ' ') ' vs ' strrep(dirPartj, '_', ' ') ' ' name])
%     subplot(2,2,2);
%     B = squeeze(sum(im1,2));
%     B(:,:,2) = squeeze(sum(im2,2));
%     B(:,:,3) = (B(:,:,1) + B(:,:,2))/2;
%     B = log(B);
%     image(B/max(B(:)))
%     title(['Dice: ' num2str(diceMatrix(i,j))])
%     ylabel('\bf Coronal')
%     subplot(2,2,3);
%     C = squeeze(sum(im1,1));
%     C(:,:,2) = squeeze(sum(im2,1));
%     C(:,:,3) = (C(:,:,1) + C(:,:,2))/2;
%     C = log(C);
%     image(C/max(C(:)))
%     ylabel('\bf Sagital')
        
        % Load the FA image. 
        basevol = load_nii(background);
        basevol = basevol.img(:,:,:,1);
        % From Dr. Landman's QA script
        subplot(3,3,3)
        overlay1 = squeeze(sum(im1,3));
        overlay2 = squeeze(sum(im2,3));

        baseimg = squeeze(basevol(:,:,floor(end/2)));

        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay1/max(overlay1(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay1/max(overlay1(:)));
        imagesc(rgb)

        title('axial', 'Interpreter', 'none')

        subplot(3,3,2)
        overlay1 = squeeze(sum(im1,2));
        overlay2 = squeeze(sum(im2,2));

        baseimg = squeeze(basevol(:,floor(end/2),:));

        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay1/max(overlay1(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay1/max(overlay1(:)));
        imagesc(imrotate(rgb, 90))
        title('coronal', 'Interpreter', 'none')


        subplot(3,3,1)
        overlay1 = squeeze(sum(im1,1));
        overlay2 = squeeze(sum(im2,1));

        baseimg = squeeze(basevol(floor(end/2),:,:));

        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay2/max(overlay2(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay1/max(overlay1(:)));
        imagesc(imrotate(rgb, 90))
        ylabel('Auto Rater')
        title('sagittal', 'Interpreter', 'none')  


        % second image an axial plane
        subplot(3,3,6)
        overlay1 = squeeze(sum(im1,3));
        overlay2 = squeeze(sum(im2,3));
        baseimg = squeeze(basevol(:,:,floor(end/2)));

        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay2/max(overlay2(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay2/max(overlay2(:)));
        imagesc(rgb)

        title('axial', 'Interpreter', 'none')

        % second image an coronal plane
        subplot(3,3,5)
        overlay1 = squeeze(sum(im1,2));
        overlay2 = squeeze(sum(im2,2));
        baseimg = squeeze(basevol(:,floor(end/2),:));

        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay2/max(overlay2(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay2/max(overlay2(:)));
        imagesc(imrotate(rgb, 90))
        title('coronal', 'Interpreter', 'none')

        % second image an sagittal plane
        subplot(3,3,4)
        overlay1 = squeeze(sum(im1,1));
        overlay2 = squeeze(sum(im2,1));
        baseimg = squeeze(basevol(floor(end/2),:,:));

        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay2/max(overlay2(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay2/max(overlay2(:)));
        imagesc(imrotate(rgb, 90))
        ylabel('Human Rater')
        title('sagittal', 'Interpreter', 'none')

        % Overlap the background FA image and the density map on an axial plane
        subplot(3,3,9)
        overlay1 = squeeze(sum(im1,3));
        overlay2 = squeeze(sum(im2,3));

        baseimg = squeeze(basevol(:,:,floor(end/2)));

        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay2/max(overlay2(:))+overlay1/max(overlay1(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay1/max(overlay1(:))+overlay2/max(overlay2(:)));
        imagesc(rgb)
        title('axial', 'Interpreter', 'none')

        % Overlap the background FA image and the density map on an coronal plane
        subplot(3,3,8)
        overlay1 = squeeze(sum(im1,2));
        overlay2 = squeeze(sum(im2,2));

        baseimg = squeeze(basevol(:,floor(end/2),:));

        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay2/max(overlay2(:))+overlay1/max(overlay1(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay1/max(overlay1(:))+overlay2/max(overlay2(:)));
        imagesc(imrotate(rgb, 90))
        title('coronal', 'Interpreter', 'none')

        % Overlap the background FA image and the density map on an sagittal plane
        subplot(3,3,7)
        overlay1 = squeeze(sum(im1,1));
        overlay2 = squeeze(sum(im2,1));

        baseimg = squeeze(basevol(floor(end/2),:,:));

        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay2/max(overlay2(:))+overlay1/max(overlay1(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay1/max(overlay1(:))+overlay2/max(overlay2(:)));
        imagesc(imrotate(rgb, 90))
        ylabel('overlap')
        title('sagittal', 'Interpreter', 'none')
end