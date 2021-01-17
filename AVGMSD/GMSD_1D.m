function GMSD_1D_score = GMSD_1D(audio1,audio2)
% GMSM_1D - measure the audio quality of distorted audio 'audio2' with the reference audio 'audio1'.
% 
% inputs:
% audio1 - the reference audio (singe channel audio with size 'samples x 1', double type, -1~1)
% audio2 - the distorted audio (singe channel audio with size 'samples x 1', double type, -1~1)
% 
% output:
% GMSD_1D_score: distortion degree of the distorted audio measured by GMSD_1D

% This is an implementation of the GMSD_1D algorithm described in:
% Xiongkuo Min, Guangtao Zhai, Jiantao Zhou, Mylène C. Q. Farias, and  Alan Conrad Bovik, 
% "Study of Subjective and Objective Quality Assessment of Audio-Visual Signals," 
% IEEE Transactions on Image Processing, vol. 29, pp. 6054-6068, 2020.

Down_step = 64;
aveKernel = fspecial('average',[1 Down_step]);
audio1 = conv(audio1, aveKernel,'valid');
audio2 = conv(audio2, aveKernel,'valid');
audio1 = audio1(1:Down_step:end,1:Down_step:end);
audio2 = audio2(1:Down_step:end,1:Down_step:end);

dx = [1 0 -1];
G1 = conv(audio1, dx, 'valid');
G2 = conv(audio2, dx, 'valid');
GM1 = abs(G1);
GM2 = abs(G2);

quality_map = (2*GM1.*GM2) ./ (GM1.^2+ GM2.^2);
GMSD_1D_score = nanstd(quality_map);

