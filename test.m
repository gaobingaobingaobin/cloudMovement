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

%IM = cat(4,video.cIM);

clear avi;

% for i = 1:nframes
%     imshow(IM(:,:,:,i))
% end


for f = 1:nframes
    pixel(:,:,f) = (rgb2gray(IM(:,:,:,f)));  
end

%clear IM;
% imshow(pixel(:,:,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for each frame, segment as 20 by 20 small blocks%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rows = 240/20;
cols = 320/20;
blk_num = rows*cols;

for i = 1:nframes
%for i = 1:1
    for j = 1:rows
        for m = 1:cols
            index = m + (j-1)*20;
            seg(:,:,index,i) = pixel((((j-1)*20+1):(j*20)),(((m-1)*20+1):(m*20)),i);
        end
    end   
 end

%imshow(seg(:,:,1,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for the small white node the locations are:
% 1st frame: row 4, col 11, index = 11 + 3*20;
% 2nd frame: row 4, col 11, index = 11 + 3*20;
%       and: row 3, col 11, index = 11 + 2*20;
% the direction is from left-down to right-up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(1);
% imshow(seg(:,:,(11 + 3*20),1));
% figure(2);
% imshow(seg(:,:,(11 + 3*20),2));
% figure(3);
% imshow(seg(:,:,(11 + 2*20),2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% motion detection by using minimum absolute difference
%link:http://books.google.com/books?id=adv71MkRIWYC&pg
%=PT329&lpg=PT329&dq=mean+absolute+difference+matlab&source=
%bl&ots=g9cuvPSBUX&sig=ZuFS-okBg15Xcm_KjsXmxVtMA68&hl=
%en&sa=X&ei=qwKcUbGbKqH6iwKm4YDAAw&ved=0CH0Q6AEwCQ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testing for the MAD function
% working!!!!!!!!!!!!!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test_seg = seg(:,:,(11 + 3*20),1);
% position.segr = 4;
% position.segc = 11;
% position.dx = 2;
% position.dy = 1;
% pixel_n = pixel(:,:,2);
% 
% diff = MAD(test_seg, pixel_n, position);
% diff.value


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% using brutal force to search for the max matching
% position becomes drift from frame 5, so in this case, we don't need such
% high shooting rate
%%%%%%%%%% can be used as test bench%%%%%%%%%%%%%%%%%
%%%%%%%%%% test HEXBS in the following %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% by using blurring, it will still get the same result
%%% by brutle force, but HEXBS will not stuck at local optimal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

position.segr = 4;
position.segc = 11;
%pixel_n = pixel(:,:,4);
%using bluring
I = pixel(:,:,7);
H = fspecial('disk',3);
pixel_n = imfilter(I,H,'replicate');

%test_seg = seg(:,:,(11 + 3*20),1);
I = seg(:,:,(11 + 3*20),1);
H = fspecial('disk',3);
test_seg = imfilter(I,H,'replicate');

num = 10;
for i = -num:num
    for j = -num:num       
        position.dx = i;
        position.dy = j;
        diff = MAD(test_seg, pixel_n, position);
        v(i+num+1,j+num+1) = diff.value;
        x(i+num+1,j+num+1) = diff.x;
        y(i+num+1,j+num+1) = diff.y;
    end
end
[cx,cy] = find(v == min(min(v)));
vmin = min(min(v))

dx = 3*20+x(cx,cy);
dy = 10*20+y(cx,cy);
% dx = 3*20;
% dy = 10*20;
com_seg = pixel_n((dx:dx+19),(dy:dy+19));
figure(2);
subplot(2,1,1);
imshow(com_seg)
subplot(2,1,2);
imshow(test_seg)
x(cx,cy)
y(cx,cy)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEXBS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% para_pos are the six hexgonal points of the big pattern
% sub_pos are the four diamond points of the small pattern
% we use the blur image to achive local optimal equals global optimal
%

clear x;
clear y;
clear v;

%%%%%%%% setups %%%%%%%%%%%%%%%

%%%%%%% the block we are comparing is 4,11
position.segr = 4;
position.segc = 11;
%%%%%%% next frame we are comparing
%pixel_n = pixel(:,:,4);
%using bluring
I = pixel(:,:,7);
H = fspecial('disk',3);
pixel_n = imfilter(I,H,'replicate');
I = seg(:,:,(11 + 3*20),1);
H = fspecial('disk',3);
test_seg = imfilter(I,H,'replicate');
%%%%%%% seven checking points positions
center_pos.r = 0;
center_pos.c = 0;
optflag = 0;

while optflag == 0
    
    %%% the big pattern search
    para_pos(1).r = center_pos.r;
    para_pos(1).c = center_pos.c + 2;

    para_pos(2).r = center_pos.r + 2;
    para_pos(2).c = center_pos.c + 1;

    para_pos(3).r = center_pos.r + 2;
    para_pos(3).c = center_pos.c - 1;

    para_pos(4).r = center_pos.r;
    para_pos(4).c = center_pos.c - 2;

    para_pos(5).r = center_pos.r - 2;
    para_pos(5).c = center_pos.c - 1;

    para_pos(6).r = center_pos.r - 2;
    para_pos(6).c = center_pos.c + 1;

    for i = 1:7
        if( i == 1)
            position.dx = center_pos.r;
            position.dy = center_pos.c;
            diff = MAD(test_seg, pixel_n, position);
            v(i) = diff.value;
            x(i) = diff.x;
            y(i) = diff.y;
        else
            j = i-1;
            position.dx = para_pos(j).r;
            position.dy = para_pos(j).c;
            diff = MAD(test_seg, pixel_n, position);
            v(i) = diff.value;
            x(i) = diff.x;
            y(i) = diff.y;
        end
    end

    subopt = find (v == min(v));

    if (subopt == 1)
        %%% start small pattern search %%%%
        clear v;
        clear x;
        clear y;
        
        sub_pos(1).r = center_pos.r;
        sub_pos(1).c = center_pos.c + 1;
        sub_pos(2).r = center_pos.r - 1;
        sub_pos(2).c = center_pos.c;
        sub_pos(3).r = center_pos.r;
        sub_pos(3).c = center_pos.c - 1;
        sub_pos(4).r = center_pos.r + 1;
        sub_pos(4).c = center_pos.c;

        for i = 1:5
            if(i == 1)
                position.dx = center_pos.r;
                position.dy = center_pos.c;
                diff = MAD(test_seg, pixel_n, position);
                v(i) = diff.value;
                x(i) = diff.x;
                y(i) = diff.y; 
            else
                j = i-1;
                position.dx = sub_pos(j).r;
                position.dy = sub_pos(j).c;
                diff = MAD(test_seg, pixel_n, position);
                v(i) = diff.value;
                x(i) = diff.x;
                y(i) = diff.y;
            end
        end
        %%%% locate the optimal solution %%%%%%%%
        optflag = 1;
        opt_ind = find(v == min(v));
        opt_value = min(v);
        opt_r = x(opt_ind);
        opt_c = y(opt_ind);


    else
        %%%% change the search center of the big pattern and restart the
        %%%% search
        center_pos.r = para_pos(subopt - 1).r;
        center_pos.c = para_pos(subopt - 1).c;

    end

end

opt_r
opt_c












