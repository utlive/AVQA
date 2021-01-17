function AVIFP_score = AVIFP(video1,video2,audio1,audio2)
% AVIFP - measure the A/V quality of distorted A/V signals '(video2,audio2)'
% with the reference A/V signals '(video1,audio1)'.
%
% inputs:
% video1 - the reference video (gray scale video with size 'height x width x frames', double type, 0~255)
% audio1 - the reference audio (singe channel audio with size 'samples x 1', double type, -1~1)
% video2 - the distorted video (gray scale video with size 'height x width x frames', double type, 0~255)
% audio2 - the distorted audio (singe channel audio with size 'samples x 1', double type, -1~1)
%
% output:
% AVIFP_score: distortion degree of the distorted A/V signals measured by AVIFP

% This is an implementation of the AVIFP algorithm described in:
% Xiongkuo Min, Guangtao Zhai, Jiantao Zhou, Mylène C. Q. Farias, and  Alan Conrad Bovik,
% "Study of Subjective and Objective Quality Assessment of Audio-Visual Signals,"
% IEEE Transactions on Image Processing, vol. 29, pp. 6054-6068, 2020.

% Measure the video frame quality
frameNum = size(video1,3);
for i = 1:frameNum
    ref_frame = video1(:,:,i);
    dis_frame = video2(:,:,i);
    vifp_frame(i) = VIFP(ref_frame,dis_frame);
end
vifp_video = mean(vifp_frame);

% Measure the audio quality
if size(audio1,2) == 2
    audio1 = audio1(:,1);
end
if size(audio2,2) == 2
    audio2 = audio2(:,1);
end
vifp_audio = VIFP_1D(audio1,audio2);

% Fuse the A/V qualties
weight = 0.7;
AVIFP_score = vifp_video^weight * vifp_audio^(1-weight);
