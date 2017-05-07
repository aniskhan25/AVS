function compute_motionMaps_v1( video_name )

clearvars -except video_name frameRate;

if exist(['../Results/motionMaps/' video_name], 'dir')
else
    mkdir(['../Results/motionMaps/' video_name])
end

inDir=strcat('../Results/OFthoutput/',video_name, '/');
outDir=strcat('../Results/motionMaps/',video_name, '/');

Imgs = dir([inDir '*.jpg']);

img=imread([inDir Imgs(1).name]);
motionMaps=zeros(size(img,1),size(img,2));

h = fspecial('gaussian',15,15);

fprintf(['\n' repmat('.',1,length(Imgs)/10) '\n\n']);

tic;
for imgindx=1:length(Imgs)
    %fprintf('%s%d', 'Computing Motion Map for frame ',imgindx); fprintf('\n');
    if ~mod(imgindx,10), fprintf('\b|\n'); end;
    
    %t1 = rgb2gray(imread([inDir Imgs(imgindx).name]));    
    t1 = rgb2gray(hsv2rgb(im2double(imread([inDir Imgs(imgindx).name]))));
    
    t2 = (t1 - min(t1(:))) / (max(t1(:)) - min(t1(:)));
    motionMaps(:,:,imgindx) = imfilter(t2,h);
    
    %motionMaps(:,:,imgindx) = t1/255;
end
eltime=toc;

fprintf('\n');

timePerFrame=eltime/length(Imgs);
save([outDir 'timePerFrame'], 'timePerFrame');

save([outDir 'motionMaps'], 'motionMaps');
end

