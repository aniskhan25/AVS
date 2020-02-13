function audio_features = audio_feature_extraction_v1( audio, numOfFrames)

% % usage
% audio='basketball_of_sorts_960x720.wav';
% video_name='basketball_of_sorts_960x720.mp4';
% audio_feature_extraction( input, video )

%clearvars -except audio numOfFrames;
%clc;

%read file; use any available short length file here
[f,~]=audioread(audio);

%no. of samples
totalNoOfSamples=length(f);

%no. of samples per frame
noOfSamplesPerFrame=floor(totalNoOfSamples/numOfFrames*2);

%overlapping samples
overlappingSamples=floor(noOfSamplesPerFrame*50/100);

%divide equal samples in given frames
frames=zeros(noOfSamplesPerFrame,numOfFrames);
n=1;
i=1;
while i < totalNoOfSamples-noOfSamplesPerFrame
    k=i+noOfSamplesPerFrame-1;
    frames(:,n)=f(i:k);
    n=n+1;
    i=i+overlappingSamples;
end

%deleting last zero column of frames
frames(:,numOfFrames)=[];

h = fspecial('gaussian');
audio_features=zeros(1,numOfFrames-1);

for i=1:numOfFrames-1
    audio_features(1,i)=conv2(trapz(trapz(abs(spectrogram(frames(:,i))))),h,'same');
end

%s=strsplit(audio,'.');
%s = strread(audio,'%s','delimiter','.');
%name=strcat(s(1),'.mat');

%[dir,name,~] = fileparts(audio);

%save([dir '/' name '.mat'],'audio_features');

end

