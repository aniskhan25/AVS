function compute_audioVisualSaliency( video_name, audio )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Usage
% video_name='Baksetball';
% audio='Basketball.wav';
% compute_audioVisual_saliency( video, audio )

%%%v = VideoReader(['../Data/Video/' video_name '/' video_name '.mp4']);
%%%frameRate = v.FrameRate;

%% Audio features
display 'Extracting audio features ...'
%%%audio_feature_extraction( audio, video_name);

%% Video features

display 'Extracting frames ...'
%%%extractFrames(video_name);

display 'Compute optical flow ...'
%OF( video_name );
%%%parOF( video_name );
%delete(gcp); % to shut down parallel pool

display 'Compute segmentation ...'
%%%segment_v1 (video_name);

display 'Tracking regions ...'
%%%track (video_name);

display 'Compute acceleration ...'
%%%calc_acceleration_v1( video_name );

%% AV-correlation - Audio Saliency

display 'Computing correlation ...'
%%%audio_visual_correlation_v1 (video_name, frameRate);

%% Motion Map

display 'Compute motion maps ...'
compute_motionMaps_v1( video_name );

%% Spatiotemporal Saliency

% Note: try any other, if code is protected and only save result images:
% read them in matlab, resize as needed and save in visualSaliency struct
%cd simpsal
%visualSaliency( video_name );
%%%gbvsVisualSaliency( video_name );
%cd ..

%% audioVisual Saliency
display 'Compute audio visual saliency maps ...'

audioSaliencyDir = strcat('../Results/audioSaliency/',video_name, '/');
motioMapsDir = strcat('../Results/motionMaps/',video_name, '/');
%visualSaliencyDir = strcat('./visualSaliency/',video_name, '/');
visualSaliencyDir = strcat('../Results/visualSaliency/',video_name, '/gbvs/');

load([audioSaliencyDir video_name]);
load([motioMapsDir 'motionMaps']);
load([visualSaliencyDir  'visualSaliency']);

% put empty maps at start and end of audioSaliency to match its total frames
% to other maps
tmp=struct('map',{});
tmp(1).map=zeros(size(audioSaliency(:,:,1)));
for id=1:size(audioSaliency,3)
[tmp(id+1).map]=audioSaliency(:,:,id);
end
tmp(numel(tmp)+1).map=zeros(size(audioSaliency(:,:,1)));
audioSaliency=tmp;

len = numel(visualSaliency);

fprintf(['\n' repmat('.',1,len/10) '\n\n']);

%h= fspecial('gaussian',15,15);
for indx=1:len,
    if ~mod(indx,10), fprintf('\b|\n'); end;
    
    t1 = audioSaliency(indx).map;
    [h,w] = size(t1);

    t2 = t1;
    
    %if sum(t1(:)) == 0,
    %    t2 = t1;
    %else        
    %    t2 = 1 - t1; 
    %    mn = min(t2(:));
    %    mx = max(t2(:));
    %    t2 = (t2 - mn)/(mx-mn);
    %    t2(1:10,:) = 0;
    %    t2(h-10:h,:) = 0;
    %    t2(:,1:10) = 0;
    %    t2(:,w-10:w,:) = 0;
    %end
 
    % equal weighted linear combination
    %finalMap=(2*audioSaliency(indx).map)+motionMaps(:,:,indx)+visualSaliency(indx).map; % think about 2*
    %finalMap=(2*t2)+motionMaps(:,:,indx)+visualSaliency(indx).map; % think about 2*
    finalMap=t2+motionMaps(:,:,indx)+visualSaliency(indx).map; % think about 2*
    t1 = (finalMap - min(min(finalMap)))/(max(max(finalMap)) - min(min(finalMap)));
    % mapnorm=imfilter(mapnorm,h); %it made results poor in last run
    if sum(~isnan(t1)) == 0,
        avSaliency(:,:,indx)=zeros(size(t1));
    else
        avSaliency(:,:,indx)=t1;
    end
end

fprintf('\n');

% if exist(['./AV_Saliency/' video_name], 'dir')
% else
%     mkdir(['./AV_Saliency/' video_name])
% end
% outDir=strcat('./AV_Saliency/',video_name, '/');

if exist(['../Results/AV_Saliency/' video_name '/gbvs'], 'dir')
else
    mkdir(['../Results/AV_Saliency/' video_name '/gbvs'])
end
outDir=strcat('../Results/AV_Saliency/',video_name, '/gbvs/');
save([outDir 'avSaliency'],'avSaliency');

end
