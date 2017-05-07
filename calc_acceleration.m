function calc_acceleration( video_name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

clearvars -except video_name frameRate; clc;


inDir = strcat('../Results/tracked/',video_name, '/'); % allLabels directory
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

% optical flow
obj=vision.OpticalFlow('ReferenceFrameSource','Input port');
for kk=2:size(allLabels,3)-1
        fwdflow = step(obj, allLabels(:,:,kk), allLabels(:,:,kk-1));
        bckflow = step(obj, allLabels(:,:,kk), allLabels(:,:,kk+1));
        avgflow(:,:,kk-1)=(fwdflow-bckflow)/2;
end

allLabels(:,:,size(allLabels,3))=[];
allLabels(:,:,1)=[];


% acceleration
for frameindxx=1:size(allLabels,3) % !check how indexing should be !later: i think its right
    for lbll = 1:size(pixel_list,2)
        if ~isempty(pixel_list(frameindxx,lbll).list)
            allTracks(1).Acceleration(lbll,frameindxx) = mean2( avgflow(pixel_list(frameindxx,lbll).list) );        
        end
    end
end
save([outDir 'allLabels.mat'],'allLabels');
save([outDir 'allTracks.mat'],'allTracks');
end

