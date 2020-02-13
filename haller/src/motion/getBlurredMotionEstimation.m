function motionSoftSegs_blurred = getBlurredMotionEstimation(motionSoftSegs)

% blur motion soft-segmentation
%
% [in] motionSoftSegs           - motion soft-segmentation 
%
% [out] motionSoftSegs_blurred   - blurred motion soft-segmentation

    nFrames = numel(motionSoftSegs);
    [sigma, dimX, dimY] = approximateSigma(motionSoftSegs);
    
    if (sigma == 0)
        motionSoftSegs_blurred = cell(nFrames, 1);
        for i = 1 : nFrames
            motionSoftSegs_blurred{i} = ones(size(motionSoftSegs{i}));
        end
    else
        g = fspecial('gaussian', [dimY, dimX], sigma);
        motionSoftSegs_blurred = cell(nFrames, 1);
        for i = 1 : nFrames
            seg = motionSoftSegs{i};
            seg = ni(imfilter(seg, g));
            motionSoftSegs_blurred{i} = seg;
        end
    end

end

function [sigma, dimX, dimY] = approximateSigma(motionSoftSegs)

    nFrames = numel(motionSoftSegs);
    w = size(motionSoftSegs{1}, 2);
    h = size(motionSoftSegs{1}, 1);
    
    stdX = 0; stdY = 0; cnt = 0;   
    
    for i = 1 : nFrames
        
        seg = motionSoftSegs{i};
        seg = ni(seg);
        pos = find(seg > 0.75);
        
        if (~isempty(pos))
           [y, x] = ind2sub([h,w], pos);
           cnt = cnt + 1;
           stdX(cnt) = std(x, 1);
           stdY(cnt) = std(y, 1);
        end
    end
    
    dimX = round(mean(stdX) * 4);
    dimY = round(mean(stdY) * 4);
    
    sigma = 2 * round(mean([mean(stdX), mean(stdY)]));
end