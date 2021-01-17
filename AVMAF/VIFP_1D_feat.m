function vifp_1D_feat = VIFP_1D_feat(audio1,audio2)
% VIFP_1D_feat - compute the audio quality feature of distorted audio 'audio2' with the reference audio 'audio1'.
% 
% inputs:
% audio1 - the reference audio (singe channel audio with size 'samples x 1', double type, -1~1)
% audio2 - the distorted audio (singe channel audio with size 'samples x 1', double type, -1~1)
% 
% output:
% vifp_1D_feat: quality feature of the distorted audio

% This is an implementation of the VIFP_1D algorithm described in:
% Xiongkuo Min, Guangtao Zhai, Jiantao Zhou, Mylène C. Q. Farias, and  Alan Conrad Bovik, 
% "Study of Subjective and Objective Quality Assessment of Audio-Visual Signals," 
% IEEE Transactions on Image Processing, vol. 29, pp. 6054-6068, 2020.

sigma_nsq=2;

num=0;
den=0;
for scale=1:4
    
    N=2^(4-scale+1)+1;
    win=fspecial('gaussian',[1 N],N/5);
    
    if (scale >1)
        audio1=conv(audio1,win,'valid');
        audio2=conv(audio2,win,'valid');
        audio1=audio1(1:2:end,1:2:end);
        audio2=audio2(1:2:end,1:2:end);
    end
    
    
    mu1   = conv(audio1, win, 'valid');
    mu2   = conv(audio2, win, 'valid');
    mu1_sq = mu1.*mu1;
    mu2_sq = mu2.*mu2;
    mu1_mu2 = mu1.*mu2;
    sigma1_sq = conv(audio1.*audio1, win, 'valid') - mu1_sq;
    sigma2_sq = conv(audio2.*audio2, win, 'valid') - mu2_sq;
    sigma12 = conv(audio1.*audio2, win, 'valid') - mu1_mu2;
    
    sigma1_sq(sigma1_sq<0)=0;
    sigma2_sq(sigma2_sq<0)=0;
    
    g=sigma12./(sigma1_sq+1e-10);
    sv_sq=sigma2_sq-g.*sigma12;
    
    g(sigma1_sq<1e-10)=0;
    sv_sq(sigma1_sq<1e-10)=sigma2_sq(sigma1_sq<1e-10);
    sigma1_sq(sigma1_sq<1e-10)=0;
    
    g(sigma2_sq<1e-10)=0;
    sv_sq(sigma2_sq<1e-10)=0;
    
    sv_sq(g<0)=sigma2_sq(g<0);
    g(g<0)=0;
    sv_sq(sv_sq<=1e-10)=1e-10;
    
    
    num(scale) = sum(sum(log10(1+g.^2.*sigma1_sq./(sv_sq+sigma_nsq))));
    den(scale) = sum(sum(log10(1+sigma1_sq./sigma_nsq)));
end
vifp_1D_feat=num./den;
