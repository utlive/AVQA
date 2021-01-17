function overall_mssim_1D = MS_SSIM_1D(audio1, audio2)
% MS-SSIM_1D - measure the audio quality of distorted audio 'audio2' with the reference audio 'audio1'.
% 
% inputs:
% audio1 - the reference audio (singe channel audio with size 'samples x 1', double type, -1~1)
% audio2 - the distorted audio (singe channel audio with size 'samples x 1', double type, -1~1)
% 
% output:
% overall_mssim_1D: distortion degree of the distorted audio

% This is an implementation of the MS-SSIM_1D algorithm described in:
% Xiongkuo Min, Guangtao Zhai, Jiantao Zhou, Mylène C. Q. Farias, and  Alan Conrad Bovik, 
% "Study of Subjective and Objective Quality Assessment of Audio-Visual Signals," 
% IEEE Transactions on Image Processing, vol. 29, pp. 6054-6068, 2020.

K = [0 0];
winSize = 11;
win = fspecial('gaussian', [1 winSize], 1.5);
level = 5;
weight = [0.0448 0.2856 0.3001 0.2363 0.1333];

method = 'product';

downsample_filter = fspecial('average',[1 2]);
audio1 = double(audio1);
audio2 = double(audio2);
for l = 1:level
    [mssim_array(l) ssim_map_array{l} mcs_array(l) cs_map_array{l}] = ssim_index_new(audio1, audio2, K, win);
    filtered_audio1 = conv(audio1, downsample_filter, 'same');
    filtered_audio2 = conv(audio2, downsample_filter, 'same');
    clear audio1 audio2;
    audio1 = filtered_audio1(1:2:end, 1:2:end);
    audio2 = filtered_audio2(1:2:end, 1:2:end);
end

if (strcmp(method,'product'))
    overall_mssim_1D = prod(mcs_array(1:level-1).^weight(1:level-1))*(mssim_array(level).^weight(level));
else
    weight = weight./sum(weight);
    overall_mssim_1D = sum(mcs_array(1:level-1).*weight(1:level-1)) + mssim_array(level).*weight(level);
end

function [mssim, ssim_map, mcs, cs_map] = ssim_index_new(audio1, audio2, K, win)

C1 = (K(1)*1)^2;
C2 = (K(2)*1)^2;
win = win/sum(sum(win));

mu1   = conv(audio1, win, 'valid');
mu2   = conv(audio2, win, 'valid');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = conv(audio1.*audio1, win, 'valid') - mu1_sq;
sigma2_sq = conv(audio2.*audio2, win, 'valid') - mu2_sq;
sigma12 = conv(audio1.*audio2, win, 'valid') - mu1_mu2;

ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));
cs_map = (2*sigma12 + C2)./(sigma1_sq + sigma2_sq + C2);

mssim = nanmean(ssim_map);
mcs = nanmean(cs_map);

return
