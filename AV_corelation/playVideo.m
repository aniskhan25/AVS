%% Load sequence of image frames
function playVideo(video_buffer, nFps)
% Input -   video_buffer: n video frames in 3d matrix or 1d cell
%       -   nFps: target framerate
% By Kai Li
% Univ. of Central Florida
% May, 2014
% All rights reserved
if nargin < 2
    nFps = 25;
end
if isa(video_buffer, 'cell')
    nframes = numel(video_buffer);
    [height, width, ~] = size(video_buffer{1});
    video_buffer = permute(reshape(cell2mat(reshape(video_buffer, 1, nframes)), ...
        height, width, nframes, 3), [1 2 4 3]);
end

ndims = numel(size(video_buffer));
nframes = size(video_buffer, ndims);
gap = 1/nFps;

for i = 1 : nframes
    tStart = tic;
	figure(1)
    if ndims == 4
        imshow(video_buffer(:,:,:,i));
    else
        imshow(video_buffer(:,:,i));
    end
    elapsed_time = toc(tStart);
    if (elapsed_time < gap)
        pause(gap - elapsed_time);
    end
end
