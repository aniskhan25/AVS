function compute_audioVisualSaliency( video_name, audio )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Usage
% video_name='Baksetball';
% audio='Basketball.wav';
% compute_audioVisual_saliency( video, audio )

v = VideoReader(['../Data/Video/' video_name '/' video_name '.mp4']);
frameRate = v.FrameRate;

%% Audio features
display 'Extracting audio features ...'
audio_feature_extraction( audio, video_name);

%% Video features

display 'Extracting frames ...'
extractFrames(video_name);

display 'Compute optical flow ...'
%OF( video_name );
parOF( video_name );
%delete(gcp); % to shut down parallel pool

display 'Compute segmentation ...'
segment_v1 (video_name);

display 'Tracking regions ...'
track (video_name);

display 'Compute acceleration ...'
calc_acceleration_v1( video_name );

%% AV-correlation - Audio Saliency

display 'Computing correlation ...'
audio_visual_correlation_v1 (video_name, frameRate);

%% Motion Map

display 'Compute motion maps ...'
compute_motionMaps_v1( video_name );

%% Spatiotemporal Saliency

% Note: try any other, if code is protected and only save result images:
% read them in matlab, resize as needed and save in visualSaliency struct
%cd simpsal
%visualSaliency( video_name );
gbvsVisualSaliency( video_name );
%cd ..

%% audioVisual Saliency
display 'Compute audio visual saliency maps ...'
compute_avSaliencyMap(video_name);

end
