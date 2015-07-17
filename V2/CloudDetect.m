function [gt_r,gt_c,num] = CloudDetect(gt_r,gt_c,CloudLabel)
%CloudLabel:320*1
%gt_c,gt_r要取整吗？
cloud = CloudLabel(1:160);
cloud = reshape(cloud,16,10);
cloud= cloud';
count = zeros(10,16);
sumdetectcloud = 0;%待处理的无速度白云数
num = 0;%本次填充的无速度白云数
for i=2:9
    for j=2:15
        if (cloud(i,j)==1)&&(gt_r(i,j)==0)&&(gt_c(i,j)==0)
            sumdetectcloud = sumdetectcloud + 1;
            if (gt_r(i-1,j-1)~=0)||(gt_c(i-1,j-1)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i-1,j)~=0)||(gt_c(i-1,j)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i-1,j+1)~=0)||(gt_c(i-1,j+1)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i,j-1)~=0)||(gt_c(i,j-1)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i,j+1)~=0)||(gt_c(i,j+1)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i+1,j-1)~=0)||(gt_c(i+1,j-1)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i+1,j)~=0)||(gt_c(i+1,j)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i+1,j+1)~=0)||(gt_c(i+1,j+1)~=0)
                count(i,j) = count(i,j) + 1;
            end
        end  
    end
end

if sumdetectcloud~=0
    std = max(max(count));
    for i=2:9
        for j=2:15
            if count(i,j)==std
                num = num + 1;
                gt_r(i,j) = gt_r(i-1,j-1)+gt_r(i-1,j)+gt_r(i-1,j+1)...
                           +gt_r(i,j-1)+gt_r(i,j+1)...
                           +gt_r(i+1,j-1)+gt_r(i+1,j)+gt_r(i+1,j+1);
                gt_r(i,j) = round(gt_r(i,j)/std);
                gt_c(i,j) = gt_c(i-1,j-1)+gt_c(i-1,j)+gt_c(i-1,j+1)...
                           +gt_c(i,j-1)+gt_c(i,j+1)...
                           +gt_c(i+1,j-1)+gt_c(i+1,j)+gt_c(i+1,j+1);
                gt_c(i,j) = round(gt_c(i,j)/std);       
            end
        end
    end
end

