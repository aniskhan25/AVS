fclose all; close all; clear all; clc; %#ok<CLSCR>

% set video path
% the test video is part of YouTube-Objects dataset v2.2 
videoPath = 'testVideo_YTO.avi'; 

addpath(genpath('src'));

% extract video frames
frames      = extractFrames(videoPath, 300, 300);

% compute foreground soft-segmentations
% softSegs is a cell array with nFrames elements
%      ( nFrames = number of frames in the considered video )
softSegs    = getVideoSoftSegmentation(frames);

rmpath(genpath('src'));


% save results 
outPath = 'out'; 
if (~exist(outPath, 'dir'))
    mkdir(outPath);
end
for frameIdx = 1 : numel(softSegs)
    str     = sprintf('%05d.png', frameIdx);
    softSeg = uint8(softSegs{frameIdx} * 255);
    imwrite([frames{frameIdx}, softSeg(:,:,[1,1,1])], fullfile(outPath, str));
end

