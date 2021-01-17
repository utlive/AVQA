function AVMAF_score = AVMAF(video1,video2,audio1,audio2)
% AVMAF - measure the A/V quality of distorted A/V signals '(video2,audio2)'
% with the reference A/V signals '(video1,audio1)'.
%
% inputs:
% video1 - the reference video (gray scale video with size 'height x width x frames', double type, 0~255)
% audio1 - the reference audio (singe channel audio with size 'samples x 1', double type, -1~1)
% video2 - the distorted video (gray scale video with size 'height x width x frames', double type, 0~255)
% audio2 - the distorted audio (singe channel audio with size 'samples x 1', double type, -1~1)
%
% output:
% AVMAF_score: distortion degree of the distorted A/V signals measured by AVMAF

% This is an implementation of the AVMAF algorithm described in:
% Xiongkuo Min, Guangtao Zhai, Jiantao Zhou, Mylène C. Q. Farias, and  Alan Conrad Bovik,
% "Study of Subjective and Objective Quality Assessment of Audio-Visual Signals,"
% IEEE Transactions on Image Processing, vol. 29, pp. 6054-6068, 2020.

% Note that this implementation is sightly different from the one used in the paper.
% First, VIFP rather than VIF is used in this implementation.
% Second, the detail loss metric (DLM) is exclueded from the feature set.

% The SVM in this released code is trained on the whole LIVE-SJTU A/V-QA Dataset.

% Measure the video frame quality using vifp
frameNum = size(video1,3);
for i = 1:frameNum
    ref_frame = video1(:,:,i);
    dis_frame = video2(:,:,i);
    vifp_feat_frame(i,:) = VIFP_feat(ref_frame,dis_frame);
end
vifp_feat_video = mean(vifp_feat_frame,1);

% Measure the adjacent frame difference
for i = 2:frameNum
    diff = video2(:,:,i-1)-video2(:,:,i);
    diff_frame(i,1) = mean2(abs(diff));
end
diff_frame(1,1) = diff_frame(2,1);
diff_video = mean(diff_frame);

% Measure the audio quality using vifp_1d
if size(audio1,2) == 2
    audio1 = audio1(:,1);
end
if size(audio2,2) == 2
    audio2 = audio2(:,1);
end
vifp_feat_audio = VIFP_1D_feat(audio1,audio2);

% Predict the A/V quality
feat = [vifp_feat_video diff_video vifp_feat_audio];

CurrentPath = pwd;
[AVMAFpath,~,~]=fileparts(which('AVMAF'));
cd(fullfile(AVMAFpath,'SVM'));
fid = fopen('test_ind.txt','w');
for itr_im = 1:size(feat,1)
    fprintf(fid,'%d ',1);
    for itr_param = 1:size(feat,2)
        fprintf(fid,'%d:%f ',itr_param,feat(itr_im,itr_param));
    end
    fprintf(fid,'\n');
end
fclose(fid);
delete test_ind_scaled
if isunix
    system('./svm-scale -r range test_ind.txt >> test_ind_scaled');
    system('./svm-predict -b 1 test_ind_scaled model output.txt>dump');
elseif ispc
    system('svm-scale -r range test_ind.txt >> test_ind_scaled');
    system('svm-predict -b 1 test_ind_scaled model output.txt>dump');
else
    disp('Platform not supported')
end
load output.txt;
cd(CurrentPath);

AVMAF_score = output;
