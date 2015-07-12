function [ diff ] = MAD( seg, pixel_n, position )
%MAD Summary of this function goes here
%   Detailed explanation goes here
x = (position.segr-1)*20+1 + position.dx;
y = (position.segc-1)*20+1 + position.dy;

com_seg = pixel_n((x:x+19),(y:y+19));

diff.value = sum(sum(abs(seg-com_seg)));
diff.x = position.dx;
diff.y = position.dy;

end

