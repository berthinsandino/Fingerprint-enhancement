function [NP_b] = filter2(fq_J, coor_DC, fr, w)

%{
  fq_J : image in the frequency domain
  coor_DC : coordinates of the DC component
  fr : frequency of the ridges in fq_J
  w : the width of the annel considered for the filter
%}

%Obtain the distance between those two maximum points
d0 = fr;
d1 = d0 + w; %stablish the width of the anel

%Look for points that are inner/outer the anel
sz_J = size(fq_J, 1);
mask = zeros(sz_J, sz_J);

lst_h = [];
for row = 1 : sz_J
  for col = 1 : sz_J
    rr = row - coor_DC(1);
    cc = col - coor_DC(2);
    d = sqrt(rr^2 + cc^2);
    if ((d0 <= d && d <= d1) || (rr == 0 && cc == 0))
      mask(row, col) = 1;
    else
      mag = abs(fq_J(row, col));
      %mag = real(fq_J(row, col));
      lst_h = [lst_h, mag];
    end
  end
end

%Get the %5 of the brightness points that are not considered within the anel or the center
T95 = prctile(lst_h(:), 95);
NP_b = max(lst_h(find(lst_h < T95)));
