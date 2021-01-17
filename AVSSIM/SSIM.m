function mssim = SSIM(img1,img2)
[M N] = size(img1);
f = max(1,round(min(M,N)/256));
if(f>1)
lpf = ones(f,f);
lpf = lpf/sum(lpf(:));
img1 = imfilter(img1,lpf,'symmetric','same');
img2 = imfilter(img2,lpf,'symmetric','same');
img1 = img1(1:f:end,1:f:end);
img2 = img2(1:f:end,1:f:end);
end
%%
window = fspecial('gaussian',11,1.5);	
K(1) = 0.01;
K(2) = 0.03;
L = 255;
C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;
mu1 = filter2(window, img1, 'valid');
mu2 = filter2(window, img2, 'valid');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = filter2(window, img1.*img1, 'valid') - mu1_sq;
sigma2_sq = filter2(window, img2.*img2, 'valid') - mu2_sq;
sigma12 = filter2(window, img1.*img2, 'valid') - mu1_mu2;
ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));
mssim = mean(ssim_map(:));
