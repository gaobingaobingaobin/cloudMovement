clc;
clear all;

info=aviinfo('test.avi');
width = info.Width;
height = info.Height;
nframes = info.NumFrames;

IM=uint8(zeros(height,width,3,nframes));


video = aviread('test.avi');

for i=1:nframes
    IM(:,:,:,i)=video(i).cdata;
end


clear avi;


for f = 1:nframes
    pixel(:,:,f) = (rgb2gray(IM(:,:,:,f)));  
end

clear IM;


I = pixel(:,:,1);
figure(1);
subplot(2,1,1);
imshow(pixel(:,:,1));
H = fspecial('disk',3);
blurred = imfilter(I,H,'replicate');
subplot(2,1,2);
imshow(blurred)