function overall_mssim = MS_SSIM(img1, img2, K, win, level, weight, method)

% Multi-scale Structural Similarity Index (MS-SSIM)
% Z. Wang, E. P. Simoncelli and A. C. Bovik, "Multi-scale structural similarity
% for image quality assessment," Invited Paper, IEEE Asilomar Conference on
% Signals, Systems and Computers, Nov. 2003

if (nargin < 2 || nargin > 7)
   overall_mssim = -Inf;
   return;
end

if (~exist('K'))
   K = [0.01 0.03];
end

if (~exist('win'))
   win = fspecial('gaussian', 11, 1.5);
end

if (~exist('level'))
   level = 5;
end

if (~exist('weight'))
   weight = [0.0448 0.2856 0.3001 0.2363 0.1333];
end

if (~exist('method'))
   method = 'product';
end

if (size(img1) ~= size(img2))
   overall_mssim = -Inf;
   return;
end

[M N] = size(img1);
if ((M < 11) || (N < 11))
   overall_mssim = -Inf;
   return
end

if (length(K) ~= 2)
   overall_mssim = -Inf;
   return;
end

if (K(1) < 0 || K(2) < 0)
   overall_mssim = -Inf;
   return;
end
  
[H W] = size(win);

if ((H*W)<4 || (H>M) || (W>N))
   overall_mssim = -Inf;
   return;
end
   
if (level < 1)
   overall_mssim = -Inf;
   return
end


min_img_width = min(M, N)/(2^(level-1));
max_win_width = max(H, W);
if (min_img_width < max_win_width)
   overall_mssim = -Inf;
   return;
end

if (length(weight) ~= level || sum(weight) == 0)
   overall_mssim = -Inf;
   return;
end

if (method ~= 'wtd_sum' & method ~= 'product')
   overall_mssim = -Inf;
   return;
end

downsample_filter = ones(2)./4;
im1 = double(img1);
im2 = double(img2);
for l = 1:level
   [mssim_array(l) ssim_map_array{l} mcs_array(l) cs_map_array{l}] = ssim_index_new(im1, im2, K, win);
%   [M N] = size(im1);
   filtered_im1 = imfilter(im1, downsample_filter, 'symmetric', 'same');
   filtered_im2 = imfilter(im2, downsample_filter, 'symmetric', 'same');
   clear im1, im2;
   im1 = filtered_im1(1:2:end, 1:2:end);
   im2 = filtered_im2(1:2:end, 1:2:end);
end

if (method == 'product')
%   overall_mssim = prod(mssim_array.^weight);
   overall_mssim = prod(mcs_array(1:level-1).^weight(1:level-1))*(mssim_array(level).^weight(level));
else
   weight = weight./sum(weight);
   overall_mssim = sum(mcs_array(1:level-1).*weight(1:level-1)) + mssim_array(level).*weight(level);
end

function [mssim, ssim_map, mcs, cs_map] = ssim_index_new(img1, img2, K, win)

if (nargin < 2 || nargin > 4)
   mssim = -Inf;
   ssim_map = -Inf;
   return;
end

if (size(img1) ~= size(img2))
   mssim = -Inf;
   ssim_map = -Inf;
   return;
end

[M N] = size(img1);

if (nargin == 2)
   if ((M < 11) || (N < 11))
	   mssim = -Inf;
	   ssim_map = -Inf;
      return
   end
   win = fspecial('gaussian', 11, 1.5);	%
   K(1) = 0.01;										% default settings
   K(2) = 0.03;										%
end

if (nargin == 3)
   if ((M < 11) || (N < 11))
	   mssim = -Inf;
	   ssim_map = -Inf;
      return
   end
   win = fspecial('gaussian', 11, 1.5);
   if (length(K) == 2)
      if (K(1) < 0 || K(2) < 0)
		   mssim = -Inf;
   		ssim_map = -Inf;
	   	return;
      end
   else
	   mssim = -Inf;
   	ssim_map = -Inf;
	   return;
   end
end

if (nargin == 4)
   [H W] = size(win);
   if ((H*W) < 4 || (H > M) || (W > N))
	   mssim = -Inf;
	   ssim_map = -Inf;
      return
   end
   if (length(K) == 2)
      if (K(1) < 0 || K(2) < 0)
		   mssim = -Inf;
   		ssim_map = -Inf;
	   	return;
      end
   else
	   mssim = -Inf;
   	ssim_map = -Inf;
	   return;
   end
end

C1 = (K(1)*255)^2;
C2 = (K(2)*255)^2;
win = win/sum(sum(win));

mu1   = filter2(win, img1, 'valid');
mu2   = filter2(win, img2, 'valid');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = filter2(win, img1.*img1, 'valid') - mu1_sq;
sigma2_sq = filter2(win, img2.*img2, 'valid') - mu2_sq;
sigma12 = filter2(win, img1.*img2, 'valid') - mu1_mu2;

if (C1 > 0 & C2 > 0)
   ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));
   cs_map = (2*sigma12 + C2)./(sigma1_sq + sigma2_sq + C2);
else
   numerator1 = 2*mu1_mu2 + C1;
   numerator2 = 2*sigma12 + C2;
	denominator1 = mu1_sq + mu2_sq + C1;
   denominator2 = sigma1_sq + sigma2_sq + C2;
   
   ssim_map = ones(size(mu1));
   index = (denominator1.*denominator2 > 0);
   ssim_map(index) = (numerator1(index).*numerator2(index))./(denominator1(index).*denominator2(index));
   index = (denominator1 ~= 0) & (denominator2 == 0);
   ssim_map(index) = numerator1(index)./denominator1(index);
   
   cs_map = ones(size(mu1));
   index = denominator2 > 0;
   cs_map(index) = numerator2(index)./denominator2(index);
end

mssim = mean2(ssim_map);
mcs = mean2(cs_map);

return
