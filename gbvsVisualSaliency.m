function gbvsVisualSaliency( video_name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

clearvars -except video_name frameRate; clc;

addpath('./visualSal');

if exist(['../Results/visualSaliency/' video_name '/gbvs'], 'dir')
else
    mkdir(['../Results/visualSaliency/' video_name '/gbvs'])
end

inDir = strcat('../Data/Video/',video_name, '/');
outDir=strcat('../Results/visualSaliency/',video_name, '/gbvs/');
origImgs = dir([inDir '*.jpg']);
visualSaliency=struct('map',{})';

N=length(origImgs);
param = makeGBVSParams; % get default GBVS params
param.channels = 'IF';  % but compute only 'I' instensity and 'F' flicker channels
param.levels = 3;       % reduce # of levels for speedup

fprintf(['\n' repmat('.',1,N/10) '\n\n']);

motinfo = [];           % previous frame information, initialized to empty
tic;
for i = 1 : N
    %fprintf('%s%d', 'Computing Visual Saliency Map for frame ',i); fprintf('\n');
    if ~mod(i,10), fprintf('\b|\n'); end;
    
    [out{i} motinfo] = gbvs( [inDir origImgs(i).name], param , motinfo );
    visualSaliency(i).map=out{i}.master_map_resized;
end
eltime=toc;

fprintf('\n');

timePerFrame=eltime/N;
save([outDir 'timePerFrame'], 'timePerFrame');
save([outDir 'visualSaliency'],'visualSaliency');
