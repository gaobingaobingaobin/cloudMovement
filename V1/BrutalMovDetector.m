function [ res_r, res_c ] = BrutalMovDetector( pixel1, pixel2, seg_num, BlurFlag, blur_index)
%BRUTALMOVDETECTOR Summary of this function goes here
%   Detailed explanation goes here


    if( sum( size(pixel2) == size(pixel1)) == 2)

        [height, width] = size(pixel1);
    else
        disp('two frames have different size, abort!')
        assert(sum( size(pixel2) == size(pixel1)) == 2)
    end
    
    num = seg_num;
    rows = height/num; %240 and 320 should be changed 
    cols = width/num;
    blk_num = rows*cols;
    nframes = 2; %we only have two frames here

    pixel(:,:,1) = pixel1;
    pixel(:,:,2) = pixel2;


    %seg is the two frames
    %seg(:,:,:,1) is frame1; seg(:,:,:,2) is frame2
    for i = 1:nframes
    %for i = 1:1
        for j = 1:rows
            for m = 1:cols
                index = m + (j-1)*num;
                seg(:,:,index,i) = pixel((((j-1)*num+1):(j*num)),(((m-1)*num+1):(m*num)),i);
            end
        end   
    end
    
    for i = 1:rows
        for j = 1:cols
            position.segr = i;
            position.segc = j;
%             BlockNum = position.segc + (position.segr-1)*num;
            opt_r = 0;
            opt_c = 0;
            
            if(i ~=1 && i~=rows && j ~=1 && j ~= cols)

                if(BlurFlag == true)
                    I = pixel(:,:,2);
                    H = fspecial('disk',blur_index);
                    pixel_n = imfilter(I,H,'replicate');

                    I = seg(:,:,(position.segc + (position.segr-1)*num),1);
                    H = fspecial('disk',blur_index);
                    test_seg = imfilter(I,H,'replicate');
                else
                    pixel_n = pixel(:,:,2);
                    test_seg = seg(:,:,(position.segc + (position.segr-1)*num),1);
                end

                numCounter = num;
                for m = -numCounter:numCounter
                    for n = -numCounter:numCounter       
                        position.dx = m;
                        position.dy = n;
                        diff = MAD(test_seg, pixel_n, position,num);
                        v(m+numCounter+1,n+numCounter+1) = diff.value;
                        x(m+numCounter+1,n+numCounter+1) = diff.x;
                        y(m+numCounter+1,n+numCounter+1) = diff.y;
                    end
                end
                [cx,cy] = find(v == min(min(v)));

                opt_r = x(min(abs(cx)),min(abs(cy)));
                opt_c = y(min(abs(cx)),min(abs(cy)));
            end
            
%             disp(i)
%             disp(j)
            
            res_r(i,j) = opt_r;
            res_c(i,j) = opt_c;
        end
    end
    
end

