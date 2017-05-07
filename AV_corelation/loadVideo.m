%% Load sequence of image frames
function video_buffer = loadVideo(video_path)
files = dir(sprintf('%s/*.*p*', video_path));
height = size(imread(sprintf('%s/%s', video_path, files(1).name)), 1);
width = size(imread(sprintf('%s/%s', video_path, files(1).name)), 2);
nChannels = size(imread(sprintf('%s/%s', video_path, files(1).name)), 3);
video_buffer = uint8(zeros(height, width, nChannels, length(files)));
for j = 1:length(files)
    im = imread(sprintf('%s/%s', video_path, files(j).name));
    video_buffer(:, :, :, j) = im;
end

