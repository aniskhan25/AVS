function compute_motionMaps_v2( video_name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

clearvars -except video_name frameRate;

if exist(['../Results/motionMaps/' video_name], 'dir')
else
    mkdir(['../Results/motionMaps/' video_name])
end

inDir=strcat('../Results/OFoutput/',video_name, '/');
outDir=strcat('../Results/motionMaps/',video_name, '/');

Imgs = dir([inDir '*.jpg']);

img = imread([inDir Imgs(1).name]);
motionMaps = zeros(size(img,1),size(img,2));

h = fspecial('gaussian',15,15);

fprintf(['\n' repmat('.',1,length(Imgs)/10) '\n\n']);

tic;
for imgindx=1:length(Imgs)
    %fprintf('%s%d', 'Computing Motion Map for frame ',imgindx); fprintf('\n');
    if ~mod(imgindx,10), fprintf('\b|\n'); end;
    
    img = imread([inDir Imgs(imgindx).name]);
    
    map = im2bw(img(:,:,1)) + im2bw(img(:,:,2)) + im2bw(img(:,:,3));
    
    % normalize to [0..1]
    mapnorm = (map - min(map(:))) / (max(map(:)) - min(map(:)));
    motionMaps(:,:,imgindx) = imfilter(mapnorm,h);
end
eltime=toc;

fprintf('\n');

timePerFrame = eltime/length(Imgs);
save([outDir 'timePerFrame'], 'timePerFrame');

save([outDir 'motionMaps'], 'motionMaps');
end

