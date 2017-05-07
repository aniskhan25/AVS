function calc_acceleration_v1( video_name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

clearvars -except video_name frameRate; %clc;

inDir = strcat('../Results/tracked/',video_name, '/'); % allLabels directory
inOFDir = strcat('../Results/OFthoutput/',video_name, '/');
outDir= strcat('../Data/Video/',video_name, '/');
load([inDir 'allLabels.mat']);

% pixel list for each label in allLabels
pixel_list=struct('list', {});
allTracks = struct('Acceleration', {});
for frameindx=1:size(allLabels,3)
    nLbl = max(max(allLabels(:,:,frameindx)));
    for lbl = 1:nLbl
        pixel_list(frameindx,lbl).list=find(allLabels(:,:,frameindx)==lbl);
    end
end

allLabels(:,:,size(allLabels,3))=[];
allLabels(:,:,1)=[];

imgs = dir([inOFDir '*.jpg']);

% acceleration
for frameindxx=1:size(allLabels,3) % !check how indexing should be !later: i think its right
    im = imread([inOFDir imgs(frameindxx).name]);
    for lbll = 1:size(pixel_list,2)
        if ~isempty(pixel_list(frameindxx,lbll).list)
            acc = mean2( im(pixel_list(frameindxx,lbll).list));
            allTracks(1).Acceleration(lbll,frameindxx) = acc;
        end
    end
end

save([outDir 'allLabels.mat'],'allLabels');
save([outDir 'allTracks.mat'],'allTracks');
end