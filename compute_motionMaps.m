function compute_motionMaps( video_name )
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

img=imread([inDir Imgs(1).name]);
motionMaps=zeros(size(img,1),size(img,2));

h = fspecial('gaussian',15,15);

fprintf(['\n' repmat('.',1,length(Imgs)/10) '\n\n']);

tic;
for imgindx=1:length(Imgs)
    %fprintf('%s%d', 'Computing Motion Map for frame ',imgindx); fprintf('\n');
    if ~mod(imgindx,10), fprintf('\b|\n'); end;
    
    img=imread([inDir Imgs(imgindx).name]);
    map=im2bw(img(:,:,1))+im2bw(img(:,:,2))+im2bw(img(:,:,3));
    
    % reverse map values bcz highest flow gets lowest label (first)- think
    % more aboout it
    bg=max(map(:))+1;
    map(find(map(:)==0))=bg;
    tmp=zeros(size(map));
    u=unique(map(:));
    for i=0:floor(numel(u)/2)
        minimum=find(map==u(i+1));
        maximum=find(map==u(numel(u)-i));
        tmp(minimum)=u(numel(u)-i);
        tmp(maximum)=u(i+1);
    end
    map=tmp-1;
    % normalize to [0..1]
    mapnorm = (map - min(min(map)))/(max(max(map)) - min(min(map)));
    t1 = imfilter(mapnorm,h);
    if sum(~isnan(mapnorm(:))) == 0,
        motionMaps(:,:,imgindx) = zeros(size(t1));
    else
        motionMaps(:,:,imgindx) = t1;
    end
end
eltime=toc;

fprintf('\n');

timePerFrame=eltime/length(Imgs);
save([outDir 'timePerFrame'], 'timePerFrame');

save([outDir 'motionMaps'], 'motionMaps');
end

