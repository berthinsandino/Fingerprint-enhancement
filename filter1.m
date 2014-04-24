function [theta dist fq_I coor_DC valu_DC] = filter1(sp_I, sz_k)

sz_I = size(sp_I, 1); %because it is a square, it's not necessary to know the second parameter
fq_I = fftshift(fft2(sp_I));

%Find out the first brightness point (which is the center)
%[row, col] = find(real(fq_I) == max(max(real(fq_I))));
[row, col] = find(abs(fq_I) == max(max(abs(fq_I))));

coor_DC = [row col];
valu_DC = fq_I(row, col);
fq_I(row, col) = 0; %turn off the maximum

%Find out the second brightness point (which actually are two points)
%[row, col] = find(real(fq_I) == max(max(real(fq_I))));
[row, col] = find(abs(fq_I) == max(max(abs(fq_I))));
row = row(1);
col = col(1);

theta = atan2(col - coor_DC(2), row - coor_DC(1)); 
dist = sqrt((coor_DC(2) - col) ^ 2 + (coor_DC(1) - row) ^ 2);
