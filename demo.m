clc
clear

addpath('AVSSIM')
addpath('AVMSSSIM')
addpath('AVIFP')
addpath('AVGMSM')
addpath('AVGMSD')
addpath('AVMAF')

% Path of the LIVE-SJTU A/V-QA Database
DatabasePath = '/Users/mxk/Project/AVquality/LIVE-SJTU_AVQA/';

% Load the reference and distorted video sequences
refVideoName = [DatabasePath 'Reference/Boxing.yuv'];
disVideoName = [DatabasePath 'Distorted/Boxing_QP16.yuv'];
refID = fopen(refVideoName);
disID = fopen(disVideoName);

resolution = [1080 1920];
iFrame = 0;
while 1
    
    [refY, refCb, refCr] = readframeyuv420(refID, resolution(1), resolution(2));
    [disY, disCb, disCr] = readframeyuv420(disID, resolution(1), resolution(2));
    if feof(refID) || feof(disID)
        break
    end
    refY = reshape(refY, [resolution(2) resolution(1)])';
    disY = reshape(disY, [resolution(2) resolution(1)])';
    
    iFrame = iFrame+1;
    refVideo(:,:,iFrame) = refY;
    disVideo(:,:,iFrame) = disY;
        
end
fclose(refID);
fclose(disID);

% Load the reference and distorted audio sequences
refAudioName = [DatabasePath 'Reference/Boxing.wav'];
disAudioName = [DatabasePath 'Distorted/Boxing_128kbps.wav'];
refAudio = audioread(refAudioName);
disAudio = audioread(disAudioName);
refAudio = refAudio(:,1);
disAudio = disAudio(:,1);


% Measure the audio-visual quality
score_avssim = AVSSIM(refVideo,disVideo,refAudio,disAudio);
score_avmsssim = AVMSSSIM(refVideo,disVideo,refAudio,disAudio);
score_avifp = AVIFP(refVideo,disVideo,refAudio,disAudio);
score_avgmsm = AVGMSM(refVideo,disVideo,refAudio,disAudio);
score_avgmsd = AVGMSD(refVideo,disVideo,refAudio,disAudio);
score_avmaf = AVMAF(refVideo,disVideo,refAudio,disAudio);


