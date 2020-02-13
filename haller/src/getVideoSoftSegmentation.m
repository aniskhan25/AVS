function softSegs = getVideoSoftSegmentation(frames)

% compute foreground soft-segmentations
%
% [in] frames       - RGB frames
%
% [out] softSegs    - computed foreground soft-segmentations

global NFeatures

    NFeatures  = 500;

    softSegs        = videoPCA(frames);
    
    softSegs        = videoPCA_softSegs(softSegs, frames); 
    
    softSegs        = applyPatchBasedClassif(softSegs, frames);

    motionSS        = getMotionEstimation(frames, softSegs);    
    motionSS        = getBlurredMotionEstimation(motionSS);
 
    softSegs        = combineAppearanceAndMotionInfo(softSegs, motionSS);
    
end