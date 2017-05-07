function saveLabels(allLabels, dir, startFrame)
%SAVELABELS Summary of this function goes here
%   Detailed explanation goes here
nFrames = numel(allLabels);
for i = 1 : nFrames
    imwrite(allLabels{i}, sprintf('%s/image_%.6d.jpg', dir, i+startFrame-1));
end

