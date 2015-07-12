function  Y = Avi2Matrix( filename)

% This function convert the avifile into
% 3D Matlab matrix for numerical processing.
% July, 24,2012
% KHMOU Youssef.

info=aviinfo(filename);
width=info.Width;
height=info.Height;
nframes=info.NumFrames;
Y=uint8(zeros(height,width,nframes));

video=aviread(filename);

for i=1:nframes
    Y(:,:,i)=video(i).cdata;
end

Y=im2double(Y);
