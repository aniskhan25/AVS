function avSaliency = compute_audioVisualSaliency( video, audio )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Usage
% video_name='Baksetball';
% audio='Basketball.wav';
% compute_audioVisual_saliency( video, audio )

v = VideoReader(video);

num_frames = v.NumberOfFrames;
frame_rate = v.FrameRate;

%% Audio features
display 'Extracting audio features ...'
audio_features = audio_feature_extraction_v1( audio, num_frames);
%audio_feature_extraction( audio, num_frames);

%% Video features

display 'Extracting frames ...'
%extractFrames(video);
frames = extractFrames(video, 300, 300);

frames = frames(1:300);

display 'Compute optical flow ...'
%OF( video_name );
%parOF( video );
%delete(gcp); % to shut down parallel pool

global NFeatures

NFeatures  = 500;

softSegs        = videoPCA(frames);
    
softSegs        = videoPCA_softSegs(softSegs, frames); 
    
softSegs        = applyPatchBasedClassif(softSegs, frames);

motionSS        = getMotionEstimation(frames, softSegs);    
motionSS        = getBlurredMotionEstimation(motionSS);
    
display 'Compute segmentation ...'
%segment_v1 (video);
softSegs = combineAppearanceAndMotionInfo(softSegs, motionSS);

labels = segment_v2 (softSegs);

newimage = cell2mat(softSegs(100));
figure, imshow(newimage)

display 'Tracking regions ...'
allLabels = track_v1(softSegs,labels);

display 'Compute acceleration ...'
[allLabels,allTracks] = calc_acceleration_v2( softSegs,allLabels );
    
%% AV-correlation - Audio Saliency

display 'Computing correlation ...'
audioSaliency = audio_visual_correlation_v2 (audio_features, allLabels, allTracks, frame_rate);

%% Motion Map

display 'Compute motion maps ...'
%compute_motionMaps_v1( video_name );

%% Spatiotemporal Saliency

% Note: try any other, if code is protected and only save result images:
% read them in matlab, resize as needed and save in visualSaliency struct
%cd simpsal
%visualSaliency( video_name );
visualSaliency = gbvsVisualSaliency_v1( frames );
%cd ..

%% audioVisual Saliency
display 'Compute audio visual saliency maps ...'
%compute_avSaliencyMap(video_name);
avSaliency = compute_avSaliencyMap_v1(audioSaliency, visualSaliency, motionSS);

end
