function extractFrames(video_name)

idir = strcat('../Data/Video/',video_name,'/');

obj = VideoReader([idir video_name '.mp4']);

g = fspecial('gaussian',15,15); % guasssian smoothing

I = read(obj,1); [h,w,~] = size(I);

fprintf(['\n' repmat('.',1,300/10) '\n\n']);

for k = 1 : 300,
    %if ~mod(k,10), fprintf([int2str(k) '/300\r']); end;
    if ~mod(k,10), fprintf('\b|\n'); end;
    
    I = read(obj,k);
    
    if min(h,w) > 400, % resize
        I_r = imresize(I, [400 NaN]);
        
        I_c = imadjust(I_r, stretchlim(I_r),[]); % contrast stretching
    
        I_s = imfilter(I_c, g); % smoothing
    
        n = strcat(sprintf('%06d',k), '.jpg');
        imwrite(I_s, [idir n]);
    end
end

fprintf('\n');
end