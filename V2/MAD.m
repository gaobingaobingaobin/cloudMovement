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

real_seg = int16(seg);
real_com_seg = int16(com_seg);

msqr = true;
if (msqr == true)
    temp_matrix = abs(real_seg - real_com_seg);
    temp_matrix = temp_matrix.^2;
    diff.value = sum(sum(temp_matrix));
    
else
    diff.value = sum(sum(abs(real_seg - real_com_seg)));
end

diff.x = position.dx;
diff.y = position.dy;

end

