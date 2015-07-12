clc;
clear all;
close all;


%%%%% video process%%%%%%%%%%%
% info=aviinfo('test.avi');
% width = info.Width;
% height = info.Height;
% nframes = info.NumFrames;
% 
% IM=uint8(zeros(height,width,3,nframes));
% 
% 
% video = aviread('test.avi');
% 
% for i=1:nframes
%     IM(:,:,:,i)=video(i).cdata;
% end
% 
% clear avi;
% 
% for f = 1:nframes
%     pixel(:,:,f) = (rgb2gray(IM(:,:,:,f)));  
% end
% 
% blur_flag = true;
% blur_index = 5;
% seg_num = 20;
% [res_r, res_c] = BrutalMovDetector(pixel(:,:,1),pixel(:,:,7),seg_num,false,blur_index);
% [a, b] = HexMovDetector(pixel(:,:,1),pixel(:,:,7),seg_num,blur_flag,blur_index);
% % res_r - a
% 
% figure(1)
% ImagePlot(pixel(:,:,1),seg_num,a,b);
% figure(2)
% ImagePlot(pixel(:,:,1),seg_num,res_r,res_c);



%%%%%%% picture process%%%%%%%%%%%
p1 = imread('f1.jpg');
p1 = rgb2gray(p1);

p2 = imread('f2.jpg');
p2 = rgb2gray(p2);

p3 = imread('f3.jpg');
p3 = rgb2gray(p3);




seg_num = 40;
blur_index = 6;
blur_flag = true;

% disp('brutal')
tic
[e,f] = BrutalMovDetector(p1,p2,seg_num,true,blur_index);
a1 = toc
disp(a1)
disp('Hex')
tic
[a, b] = HexMovDetector(p1,p2,seg_num,blur_flag,blur_index);
a2 = toc
disp(a2)
% [c, d] = HexMovDetector(p1,p2,seg_num,false,blur_index);
tic
[c, d] = HexMovDetectorSA(p1,p2,seg_num,false,blur_index);
a3 = toc
disp(a3)

% res_r - a

figure(1)
ImagePlot(p1,seg_num,a,b);
figure(2)
ImagePlot(p1,seg_num,c,d);

% cor1 = [];
% cor2 = [];
% 
% for m = 1:9
%     for n = 1:15
%         if(m ~=1 && m~=9 && n ~=1 && n ~= 15)
%             bf = e(m,n)+j*f(m,n);
%             lp = a(m,n)+j*b(m,n);
%             sa = c(m,n)+j*d(m,n);
%             tbf = [e(m,n),f(m,n)];
%             tlp = [a(m,n),b(m,n)];
%             tsa = [c(m,n),d(m,n)];
%             temp1 = dot(tbf,tlp)/(max(norm(tbf),norm(tlp)))^2;
%             temp2 = dot(tbf,tsa)/(max(norm(tbf),norm(tsa)))^2;
%             cor1 = [cor1, temp1];
%             cor2 = [cor2,temp2];
%         end
%         
%     end
% end
% 
% %direction
% length(find(cor1>0))/length(cor1)
% length(find(cor2>0))/length(cor2)
% mean(abs(cor1))
% mean(abs(cor2))


