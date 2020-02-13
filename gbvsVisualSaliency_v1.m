function visualSaliency = gbvsVisualSaliency_v1( origImgs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

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
    
    [out{i} motinfo] = gbvs( origImgs{i}, param , motinfo );
    visualSaliency(i).map=out{i}.master_map_resized;
end
eltime=toc;

fprintf('\n');
