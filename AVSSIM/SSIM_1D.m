function mssim_1D = SSIM_1D(audio1,audio2)
% SSIM_1D - measure the audio quality of distorted audio 'audio2' with the reference audio 'audio1'.
% 
% inputs:
% audio1 - the reference audio (singe channel audio with size 'samples x 1', double type, -1~1)
% audio2 - the distorted audio (singe channel audio with size 'samples x 1', double type, -1~1)
% 
% output:
% mssim_1D: distortion degree of the distorted audio

% This is an implementation of the SSIM_1D algorithm described in:
% Xiongkuo Min, Guangtao Zhai, Jiantao Zhou, Mylène C. Q. Farias, and  Alan Conrad Bovik, 
% "Study of Subjective and Objective Quality Assessment of Audio-Visual Signals," 
% IEEE Transactions on Image Processing, vol. 29, pp. 6054-6068, 2020.

window = fspecial('gaussian',[1 60],10)';	
K(1) = 0;
K(2) = 0;
L = 1;
C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;
mu1 = conv(audio1, window, 'same');
mu2 = conv(audio2, window, 'same');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = conv(audio1.*audio1, window, 'same') - mu1_sq;
sigma2_sq = conv(audio2.*audio2, window, 'same') - mu2_sq;
sigma12 = conv(audio1.*audio2, window, 'same') - mu1_mu2;
ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));
mssim_1D = nanmean(ssim_map(:));