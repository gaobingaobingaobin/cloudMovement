    clc;
clear all;
close all;

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

pixel(:,:,1) = p1;
pixel(:,:,2) = p2;
energy = [];

[height, width] = size(pixel(:,:,1));
num = seg_num;
rows = height/num; %240 and 320 should be changed 
cols = width/num;
blk_num = rows*cols;
nframes = 2; %we only have two frames here
