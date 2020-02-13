function parOF( video )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% read all images in current directory
clearvars -except video frameRate;% clc;

[idir,~,~] = fileparts(video);

if exist([idir '/OFoutput/'], 'dir')
else
    mkdir([idir '/OFoutput/'])
end
if exist([idir '/OFthoutput/'], 'dir')
else
    mkdir([idir '/OFthoutput/'])
end

inDir = [idir '/'];
outDir = [idir '/OFoutput/'];
thoutDir = [idir '/OFthoutput/'];
origImgs = dir([inDir '*.jpg']);
ImgsBefore = circshift(origImgs,1);
ImgsAfter = circshift(origImgs,-1);

addpath(genpath('./OF'));

%% for first image
im1=imread([inDir origImgs(1).name]);
im2=imread([inDir origImgs(2).name]);

% write img
img = flowToColor((optical_flow( im2,im1)-optical_flow( im1,im2))/2);
n=strcat(sprintf('%06d',1),'.jpg');
imwrite(img,[outDir n]);
% threshold and write
i1=img(:,:,1);
i2=img(:,:,2);
i3=img(:,:,3);
a1=bradley(i1, [125 125], 10);
a2=bradley(i2, [125 125], 10);
a3=bradley(i3, [125 125], 10);
a=a1+a2+a3;
binary=zeros(size(a));
pixels=find(a>0);
binary(pixels)=1;
binary=imfill(binary,'holes');
binary=double(binary);
imgth=cat(3,im2double(img(:,:,1)).*binary,im2double(img(:,:,2)).*binary,im2double(img(:,:,3)).*binary);
imwrite(imgth,[thoutDir n]);
clearvars im1 im2 img n i1 i2 i3 a1 a2 a3 a binary pixels imgth;

%%

fprintf(['\n' repmat('.',1,300/10) '\n\n']);

tic;
parfor imgindx=2:length(origImgs)-1,
%for imgindx=2:length(origImgs)-1
    %if ~mod(imgindx,10), fprintf([int2str(imgindx) '/300\r']); end;
    if ~mod(imgindx,10), fprintf('\b|\n'); end;
    
    im1=imread([inDir ImgsBefore(imgindx).name]);
    im2=imread([inDir origImgs(imgindx).name]);
    im3=imread([inDir ImgsAfter(imgindx).name]);
    
    % write img
    img=zeros(size(im2));
    imgth=zeros(size(im2));
    img = flowToColor((optical_flow( im2,im1)-optical_flow( im2,im3))/2);
    n=strcat(sprintf('%06d',imgindx),'.jpg');
    imwrite(img,[outDir n]);
    % threshold and write
    i1=img(:,:,1);
    i2=img(:,:,2);
    i3=img(:,:,3);
    a1=bradley(i1, [125 125], 10);
    a2=bradley(i2, [125 125], 10);
    a3=bradley(i3, [125 125], 10);
    a=a1+a2+a3;
    binary=zeros(size(a));
    pixels=find(a>0);
    binary(pixels)=1;
    binary=imfill(binary,'holes');
    binary=double(binary);
    imgth=cat(3,im2double(img(:,:,1)).*binary,im2double(img(:,:,2)).*binary,im2double(img(:,:,3)).*binary);
    imwrite(imgth,[thoutDir n]);
end
eltime=toc;

fprintf('\n');

timePerFrame=eltime/(length(origImgs)-2);
save([outDir 'timePerFrame'], 'timePerFrame');
clearvars im1 im2 im3 img n i1 i2 i3 a1 a2 a3 a binary pixels imgth;
%% for last image
im1=imread([inDir origImgs(length(origImgs)-1).name]);
im2=imread([inDir origImgs(length(origImgs)).name]);

% write img
img = flowToColor((optical_flow( im2,im1)-optical_flow( im1,im2))/2);
n=strcat(sprintf('%06d',length(origImgs)),'.jpg');
imwrite(img,[outDir n]);
% threshold and write
i1=img(:,:,1);
i2=img(:,:,2);
i3=img(:,:,3);
a1=bradley(i1, [125 125], 10);
a2=bradley(i2, [125 125], 10);
a3=bradley(i3, [125 125], 10);
a=a1+a2+a3;
binary=zeros(size(a));
pixels=find(a>0);
binary(pixels)=1;
binary=imfill(binary,'holes');
binary=double(binary);
imgth=cat(3,im2double(img(:,:,1)).*binary,im2double(img(:,:,2)).*binary,im2double(img(:,:,3)).*binary);
imwrite(imgth,[thoutDir n]);
end