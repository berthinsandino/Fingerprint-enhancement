function H_Bb = filter3(sz_J, coor_DC, fr, BW)
%{
  sz_J ~: size of the image fq_J
  [row col] ~: position of the DC component in fq_J
  fr ~: the number of ridges in fq_J
  BW ~: witdh of the band
      1 for 2m = 16,
      2 for 2m = 32
%}
row = coor_DC(1);
col = coor_DC(2);
[u v] = meshgrid(1:sz_J);
D = sqrt((u - row) .^ 2 + (v - col) .^ 2); %distance from DC component to each point

fr = max(fr, 0.1);
H_Bb = exp(-0.5 * (D.^2./((fr + BW)^2))) .* (1 - exp(-0.5 * (D.^2./fr^2)));
