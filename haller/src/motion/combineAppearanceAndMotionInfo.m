function softSegs = combineAppearanceAndMotionInfo(softSegs, motion)

% combine appearance soft-segmentation with motion soft-segmentation
%
% [in] softSegs     - appearance soft-segmentation
% [in] motion       - motion soft-segmentation
%
% [out] softSegs    - combined soft-segmentation
    
    minV = realmax;
    maxV = realmin;
    for frameIdx = 1 : numel(softSegs)
        softSegs{frameIdx} = motion{frameIdx} .* softSegs{frameIdx};
        minV = min(minV, min(softSegs{frameIdx}(:)));
        maxV = max(maxV, max(softSegs{frameIdx}(:)));
    end
    
    for frameIdx = 1 : numel(softSegs)
        softSegs{frameIdx} = (softSegs{frameIdx} - minV) / (maxV - minV);
    end
        
end