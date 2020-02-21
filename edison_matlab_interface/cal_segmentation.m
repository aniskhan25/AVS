inDir = './input/';
outDir='./output/';
pixel_labels=struct('label', {});

%% from images
% inputImgs = dir([inDir '*.jpg']);
% for inputimgindx=1:length(inputImgs)
%     rgbim=imread([inDir inputImgs(inputimgindx).name]);
%     [fimage labels modes regSize grad conf] = edison_wrapper(rgbim, @RGB2Luv,'SpatialBandWidth',7,'RangeBandWidth',7,'MinimumRegionArea',400);
%     pixel_labels(inputimgindx).label=double(labels);
% %     pixel_labels(inputimgindx).label=double(pixel_labels(inputimgindx).label);
% end
% 
% save([outDir 'segmented_frames.mat'],'pixel_labels');
% 
% for k=1:size(pixel_labels,2)
%     imwrite(label2rgb(pixel_labels(k).label),[outDir num2str(k+1) '.jpg']); % write permission problem:may move project or run as administrator
% end


%% from optical flow result

load([inDir 'rgb_imgz']);
for inputimgindx=1:size(rgb_imgz,4)
    im=rgb_imgz(:,:,:,inputimgindx);
    [fimage labels modes regSize grad conf] = edison_wrapper(im, @RGB2Luv, 'SpatialBandWidth',13,'RangeBandWidth',13,'MinimumRegionArea',400);
    pixel_labels(inputimgindx).label=double(labels);
%     pixel_labels(inputimgindx).label=double(pixel_labels(inputimgindx).label);
end

save([outDir 'segmented_frames.mat'],'pixel_labels');

for k=1:size(pixel_labels,2)
    imwrite(label2rgb(pixel_labels(k).label),[outDir num2str(k+1) '.jpg']); % write permission problem:may move project or run as administrator
end