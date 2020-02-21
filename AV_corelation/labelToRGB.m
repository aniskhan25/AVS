%% Convert a labeled matrix into color image using specified colormap
% Input -   label : m by n matrix of integer labels
%           colormap: k by 3 matrix of colormap
% Output-   imcolor: colorcoded image
% By Kai Li
% Univ. of Central Florida
% May, 2014
% All rights reserved
function imcolor = labelToRGB(label, colormap)
if isa(label, 'double') && max(label(:)) <= 1.0001
    label = im2uint8(label);
end

height = size(label, 1);
width = size(label, 2);
rmap = zeros(height, width);
gmap = zeros(height, width);
bmap = zeros(height, width);
nLabels = max(max(label));
for i = 1 : nLabels
    lindex = find(label == i);
    if size(lindex, 1)
        rmap(lindex) = colormap(i, 1);
        gmap(lindex) = colormap(i, 2);
        bmap(lindex) = colormap(i, 3);
    end
end
% handle negative and zero index
lindex = find(label <= 0);
if size(lindex, 1)
    rmap(lindex) = 0;
    gmap(lindex) = 0;
    bmap(lindex) = 0;
end
imcolor = uint8(cat(3, rmap, gmap, bmap));