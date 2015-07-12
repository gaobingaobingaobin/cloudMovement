% clear all
% clc
% 
% p1 = imread('f1.jpg');
% p1 = rgb2gray(p1);
% 
% p2 = imread('f2.jpg');
% p2 = rgb2gray(p2);
% 
% p3 = imread('f3.jpg');
% p3 = rgb2gray(p3);
% 
% figure(1)
% 
% rgb = p1
% imshow(rgb)
% 
% hold on;
% 
% M = size(rgb,1);
% N = size(rgb,2);
% 
% for k = 1:60:M
%     x = [1 N];
%     y = [k k];
%     plot(x,y,'Color','w','LineStyle','-');
%     plot(x,y,'Color','k','LineStyle',':');
% end
% 
% for k = 1:60:N
%     x = [k k];
%     y = [1 M];
%     plot(x,y,'Color','w','LineStyle','-');
%     plot(x,y,'Color','k','LineStyle',':');
% end
% 
% hold off
% 
% figure(2)
% 
% rgb = p2
% imshow(rgb)
% 
% hold on;
% 
% M = size(rgb,1);
% N = size(rgb,2);
% 
% for k = 1:60:M
%     x = [1 N];
%     y = [k k];
%     plot(x,y,'Color','w','LineStyle','-');
%     plot(x,y,'Color','k','LineStyle',':');
% end
% 
% for k = 1:60:N
%     x = [k k];
%     y = [1 M];
%     plot(x,y,'Color','w','LineStyle','-');
%     plot(x,y,'Color','k','LineStyle',':');
% end
% 
% hold off
% 
% 

close all;

figure
[X,Y] = meshgrid(-2:.2:2);
Z = X.*exp(-X.^2 - Y.^2);
[DX,DY] = gradient(Z,.2,.2);
contour(X,Y,Z)
% hold on
% quiver(X,Y,DX,DY)
% colormap hsv
% hold off
