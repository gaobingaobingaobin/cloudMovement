function [  ] = plot2Segs( image1, r1, c1, image2, r2, c2, seg_size)
%PLOT2SEGS Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Plot two segment on a same figure %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


seg1 = image1((r1:r1+seg_size-1), (c1:c1+seg_size-1));
seg2 = image2((r2:r2+seg_size-1), (c2:c2+seg_size-1));

figure;
subplot(1,3,1);
imshow(seg1);
subplot(1,3,2);
imshow(seg2);
subplot(1,3,3);
C = imfuse(seg1,seg2,'blend','Scaling','joint');
imshow(C);


end

