function [ center_r, center_c ] = findBallCenter( p1 )
%FINDBALLCENTER Summary of this function goes here
%   Detailed explanation goes here

[n_row, n_col] = size(p1);

top1 = -1;
bot1 = -1;
left1 = -1;
right1 = -1;

for i = 1:n_row
    row = p1(i,:);
    find_res = find(row == 0);
    if (size(find_res,2) ~= 0)
        top1 = i;
        break;
    end
end

for i = n_row:-1:1
    row = p1(i,:);
    find_res = find(row == 0);
    if (size(find_res,2) ~= 0)
        bot1 = i;
        break;
    end
end

for i = 1:n_col
    col = p1(:,i);
    find_res = find(col == 0);
    if (size(find_res,1) ~= 0)
        left1 = i;
        break;
    end
end

for i = n_col:-1:1
    col = p1(:,i);
    find_res = find(col == 0);
    if (size(find_res,1) ~= 0)
        right1 = i;
        break;
    end
end

center_r = floor((top1 + bot1)/2);
center_c = floor((left1 + right1)/2);


end

