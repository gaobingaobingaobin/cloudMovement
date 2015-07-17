function [gt_r,gt_c] = CloudDetect(gt_r,gt_c,CloudLabel)
%CloudLabel:320*1
cloud = CloudLabel(1:160);
cloud = reshape(cloud,16,10);
cloud= cloud';
for i=2:9
    for j=2:15
        if (cloud(i,j)==1)&&(gt_r(i,j)==0)&&(gt_c(i,j)==0)
            gt_r(i,j) = gt_r(i-1,j);
            gt_c(i,j) = gt_c(i-1,j);
        end
    end
end
            


