function compute_motionMaps_v3( imgs )

img=imgs{1};
motionMaps=zeros(size(img,1),size(img,2));

h = fspecial('gaussian',15,15);

fprintf(['\n' repmat('.',1,length(imgs)/10) '\n\n']);

tic;
for imgindx=1:length(imgs)
    %fprintf('%s%d', 'Computing Motion Map for frame ',imgindx); fprintf('\n');
    if ~mod(imgindx,10), fprintf('\b|\n'); end;
    
    %t1 = rgb2gray(imread([inDir Imgs(imgindx).name]));    
    %t1 = rgb2gray(hsv2rgb(im2double(imread([inDir Imgs(imgindx).name]))));
    t1 = imgs{imgindx};
    
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

