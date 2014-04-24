%function filter0(fileName, sz_n, sz_k, w, BW, sigma)
%filter0(fileName, 32, 5, 2, 2, 1)
%temporal
%fileName = '../8.Lecture/Fingerprints/fin2.tiff';%1_1.tif';
%fileName = '../8.Lecture/Fingerprints/fin.tiff';%1_1.tif';
%fileName = '../8.Lecture/Fingerprints/1_1.tif';
%fileName = 'fin.tiff';
%fileName = 'finv2.tif';
%fileName = '1_1.tif';
%fileName = 'fig.png';
fileName = '7_2.tif';
sz_n = 32;
sz_k = 16;
w = 2;
BW = 2;
sigma = 1;
path2Image = strcat('../8.Lecture/Fingerprints/', fileName);
%path2Image = fileName;
graphics_toolkit('gnuplot');

sp_I = imread(path2Image);
sz_I = size(sp_I);

sp_J = zeros(sz_I(1), sz_I(2));

for row = sz_k + 1 : sz_n : sz_I(1) - sz_k
  for col = sz_k + 1 : sz_n : sz_I(2) - sz_k
    if (row + sz_n + sz_k - 1 <= sz_I(1) && col + sz_n + sz_k - 1 <= sz_I(2))
      [theta fr fq_J coor_DC valu_DC] = filter1(sp_I(row - sz_k : row + sz_n + sz_k - 1, col - sz_k : col + sz_n + sz_k - 1), sz_k);

      NP_b = filter2(fq_J, coor_DC, fr, w);
      fq_J(coor_DC(1), coor_DC(2)) = valu_DC;
      if(min(size(NP_b)) == 0)
        NP_b = 0.1;
      end
      H_Mb = abs(fq_J .* (abs(fq_J) > NP_b));

      PRNR_b = abs(valu_DC) / NP_b;
      Q_b = 1 - (PRNR_b ** -1);

      H_Bb = filter3(size(fq_J, 1), coor_DC, fr, BW);

      G_theta = getGaussianMask(5, sigma, theta);
      
      H_GMb = conv2((H_Mb .* H_Bb), G_theta, 'same');
      
      %{
      if (Q_b >= 0.5 || PRNR_b >= 2)
        F_b = fq_J .* H_GMb;
      else
        F_b = fq_J;
        printf ('some');
      end
      %}
      
      tmp = real(ifft2(fftshift(F_b)));
      
      tmp = tmp(sz_k + 1 : sz_k + sz_n, sz_k + 1 : sz_k + sz_n);
      count = 0;
      for r1 = 1 : sz_n
        for c1 = 1 : sz_n
          if (tmp(r1, c1) >= 255)
            tmp(r1, c1) = 255;
            count = count + 1;
          elseif (tmp(r1, c1) < 0)
            tmp(r1, c1) = 0;
          end
        end
      end
      if (count > sz_n**2 * 0.8)
        tmp = sp_I(row : row + sz_n - 1, col : col + sz_n - 1);
      end
            
      sp_J(row : row + sz_n - 1, col : col + sz_n - 1) = tmp;
    end
  end
end

figure(1), imshow(sp_J);
