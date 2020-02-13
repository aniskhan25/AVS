function labels = segment_v2 (imgs)

len = length(imgs);
if len > 1, [h,w] = size(imgs{1}); end

alllabels = zeros(h,w,len);

fprintf(['\n' repmat('.',1,len/10) '\n\n']);

%for imgindx = 1 : length(imgs),
tic;
for imgindx = 1 : length(imgs),
    
    %if ~mod(imgindx,10), fprintf([int2str(imgindx) '/300\r']); end;
    if ~mod(imgindx,10), fprintf('\b|\n'); end
    
    im = imgs{imgindx};
    
    %[im, storedColorMap] = imread([inDir imgs(imgindx).name]);
    
    BW = im2bw(im,0.1);
    cc = bwconncomp(BW);
    labels = labelmatrix(cc);
    %RGB_label = label2rgb(labeled, @copper, 'c', 'shuffle');
    %imshow(RGB_label,'InitialMagnification','fit')

    %% COMPUTE labels
    
    %[~,labels,~,~,~,~] = edison_wrapper(im, @RGB2Luv, ...
    %    'SpatialBandWidth',13,'RangeBandWidth',13,'MinimumRegionArea',400);
    
    mxLabel = max(labels(:));
    
    if mxLabel == 0, % if no labels returned
        region_merged_label = ones( size(labels) );        
    else
        %% COMPUTE deltaE labels
        
        deltaE_label = zeros(h,w);
                
        for indx = 1 : mxLabel,
            cur_mask = labels == indx;
            label = DeltaE_Copy( im, [], cur_mask);
            deltaE_label( label == 1 ) = indx;
        end
                
        LABEL_label = LABEL( deltaE_label, 4);         
        %LABEL_label = deltaE_label;
    
        %% DISCARD small regions
        
        %se = strel('disk',2);
        %LABEL_label = imclose(imopen(LABEL_label,se),se);

        t1 = LABEL_label ~= 1;
        t2 = bwareaopen(t1,400);
        t3 = LABEL_label; t3(~t2) = 1;
        
        se = strel('disk',1);

        regions = regionprops(t3,'all'); 

        t4 = false(size(t3));
        for i = 1 : numel(regions),
            if regions(i).Area < 400 && regions(i).Area > 0,
                pixels = regions(i).PixelIdxList;        
        
                t4(:) = 0;
                t4(pixels) = 1;
        
                t5 = imdilate(t4,se);
                t6 = xor(t4,t5);
        
                ids = unique(t3(t6 == 1));
                t3(pixels) = ids(1);
            end    
        end

        t7 = t3;
        
        %% POST-PROCESS labels
                
        % Make label numbers in a series starting from 1        
        ids = unique(t3(:));
        id  = 1;
        while id <= numel(ids)
            if ids(id)~=id
                t7(t3 == ids(id)) = id;
            end
            id = id + 1;
        end
        
        region_merged_label = t7;
    end
    
    alllabels(:,:,imgindx) = region_merged_label;
end
toc;

fprintf('\n');

labels = alllabels;
%save([outDir 'labels.mat'],'labels');
end