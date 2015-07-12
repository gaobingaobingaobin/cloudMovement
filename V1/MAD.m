function [ diff ] = MAD( seg, pixel_n, position, num)
%MAD Summary of this function goes here
%   Detailed explanation goes here
% position.segr
% position.segc
% position.dx
% position.dy
x = (position.segr-1)*num+1 + position.dx;
y = (position.segc-1)*num+1 + position.dy;

com_seg = pixel_n((x:x+num-1),(y:y+num-1));


diff.value = sum(sum(abs(seg-com_seg)));
diff.x = position.dx;
diff.y = position.dy;

end

