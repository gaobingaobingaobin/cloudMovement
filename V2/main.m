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
% 
% p3 = imread('f3.jpg');
% p3 = rgb2gray(p3);
% 

figure(1)
v1 = zeros(10,16);
v2 = zeros(10,16);
ImagePlot(p1,40,v1,v2);

figure(2)
v1 = zeros(10,16);
v2 = zeros(10,16);
ImagePlot(p2,40,v1,v2);


seg_num = 40;
blur_index = 6;
blur_flag = false;

%% brutal force
 disp('brutal')
 tic
 blur_flag = false;
 [e,f] = BrutalMovDetector(p1,p2,seg_num,blur_flag,blur_index);
 figure(3)
 ImagePlot(p1,seg_num,e,f);


pixel(:,:,1) = p1;
pixel(:,:,2) = p2;
energy = [];

%% get the coordinates of the cloud
[height, width] = size(pixel(:,:,1));
num = seg_num;
rows = height/num; %240 and 320 should be changed 
cols = width/num;
blk_num = rows*cols;
nframes = 2; %we only have two frames here

for j = 1:rows
    for m = 1:cols
        %index = m + (j-1)*num;
        index = m + (j-1)*cols;
        seg(:,:,index,1) = pixel((((j-1)*num+1):(j*num)),(((m-1)*num+1):(m*num)),1);
        normalized_energy = sum(sum(seg(:,:,index,1)))/num/num;
        energy(j,m) = normalized_energy;
        
    end
end

threshold = 125;
cloud = zeros(10,16);
for i = 1:rows
    for j = 1:cols
        if(energy(i,j) > threshold && i ~=1 && i~=rows && j ~=1 && j ~= cols)
            cloud(i,j) = 1;
        end
    end
end



%gt = load('gt.mat');
%gt_x = gt.e;
%gt_y = gt.f;
%figure(3)
%ImagePlot(p1,seg_num,gt_x,gt_y);

disp('Normal HEXBS')
[hex_x, hex_y] = HexMovDetector(p1,p2,seg_num,blur_flag,blur_index);
figure(4)
ImagePlot(p1,seg_num,hex_x,hex_y);

disp('SA')
%[hexsa_x, hexsa_y] = HexMovDetectorSA(p1,p2,seg_num,false,blur_index);
[hexsa_x, hexsa_y] = HexMovDetector(p1,p2,seg_num,true,2);
figure(5)
ImagePlot(p1,seg_num,hexsa_x,hexsa_y);

len_hex = [];
angle_hex = [];
len_hexsa = [];
angle_hexsa = [];

for i = 1:rows
    for j = 1:cols
        if (cloud(i,j) == 1)
            gt_vec = [gt_x(i,j),gt_y(i,j)];
            hex_vec = [hex_x(i,j),hex_y(i,j)];
            hexsa_vec = [hexsa_x(i,j),hexsa_y(i,j)];
            
            t_angle_hex = acos(sum(gt_vec.*hex_vec,2)/(norm(gt_vec,2)*norm(hex_vec,2)));
            t_length_hex = abs((norm(hex_vec,2) - norm(gt_vec,2)))/norm(gt_vec,2);
            len_hex = [len_hex,t_length_hex];
            angle_hex = [angle_hex, t_angle_hex];
            
            t_angle_hexsa = acos(sum(gt_vec.*hexsa_vec,2)/(norm(gt_vec,2)*norm(hexsa_vec,2)));
            t_length_hexsa = abs((norm(hexsa_vec,2) - norm(gt_vec,2)))/norm(gt_vec,2);    
            len_hexsa = [len_hexsa,t_length_hexsa];
            angle_hexsa = [angle_hexsa, t_angle_hexsa];
        end
    end
end

mean(len_hex)
mean(angle_hex)

mean(len_hexsa)
mean(angle_hexsa)



% a1 = toc
% disp(a1)
% disp('Hex')
% tic
% [a, b] = HexMovDetector(p1,p2,seg_num,blur_flag,blur_index);
% a2 = toc
% disp(a2)
% % [c, d] = HexMovDetector(p1,p2,seg_num,false,blur_index);
% tic
% [c, d] = HexMovDetectorSA(p1,p2,seg_num,false,blur_index);
% a3 = toc
% disp(a3)
% 
% % res_r - a
% 
% figure(2)
% ImagePlot(p1,seg_num,a,b);
% figure(3)
% ImagePlot(p1,seg_num,c,d);
% 
% figure(4)
% ImagePlot(p1,seg_num,e,f);

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


