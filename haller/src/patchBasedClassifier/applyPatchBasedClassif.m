function softSegs = applyPatchBasedClassif(softSegs, frames)

% compute patch-based appearance model
%
% [in] softSegs             - initial foreground soft-segmentations
% [in] frames               - RGB frames
%
% [out] softSegs            - final foreground soft-segmentations 

    param.dW = 8;
    param.dimH  = 15;  
    param.dimS  = 11;  
    param.dimV  = 7;   
    param.lambda = 20;
    
    nFrames = numel(frames);
    
    nRows = size(softSegs{1}, 1); 
    nCols = size(softSegs{1}, 2);
    
    nRows_2 = nRows/2; 
    nCols_2 = nCols/2;
    
    G_center =  fspecial('gaussian', [nRows_2, nCols_2], min(nRows_2, nCols_2)/3);
    images  = single(zeros([nRows_2, nCols_2 * nFrames, 3])); 
    seg_all = zeros([nRows_2, nCols_2 * nFrames]);
    last = 1;
    for i = 1 : nFrames
        frame = imresize(ni(frames{i}), [nRows_2, nCols_2]);    
        frame = ni(frame);
        hsv = rgb2hsv(frame);
        images(:, last : last + nCols_2 - 1, 1) = hsv(:, :, 1);
        images(:, last : last + nCols_2 - 1, 2) = hsv(:, :, 2);
        images(:, last : last + nCols_2 - 1, 3) = hsv(:, :, 3);
        
        seg = imresize(softSegs{i}, [nRows_2, nCols_2]);
        seg = ni(seg);
        seg = ni(seg.*hysthresh(ni(seg.*G_center), 0.8, 0.5)); 
        seg_all(:,last : last + nCols_2 - 1) = seg;  
               
        last = last + nCols_2;
    end

    seg_all2 = classify_color_patches_ipfp(images, seg_all, param);

    minV = realmax;
    maxV = realmin;
    for i = 1:nFrames
     
        seg2    = seg_all2(:,(i-1)*nCols_2+1:i*nCols_2);     
        seg     = ni(imresize(softSegs{i}, [nRows_2, nCols_2]));
    
        seg = seg2.*seg;
        seg = imresize(seg, [nRows, nCols]);
        softSegs{i} = seg;
        
        minV = min(minV, min(seg(:)));
        maxV = max(maxV, max(seg(:)));
    end
    
    for i = 1 : nFrames
        softSegs{i} = (softSegs{i} - minV) / (maxV-minV);
    end
end