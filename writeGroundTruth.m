function writeGroundTruth( video_name )

% each ground truth video should be placed in its named folder inside
% code/GT
Dir=strcat('../Data/GT/',video_name,'/');

h = fspecial('gaussian',15,15);
obj = VideoReader([Dir video_name '_output' '.mp4']);

k=0;
while k<300
%while hasFrame(obj) && k<300
   k=k+1;
   
   this_frame=read(obj,k);
   %this_frame=readFrame(obj);
   % resize
   if min(size(this_frame,1),size(this_frame,2))>400
       this_frame=imresize(this_frame,[400 NaN]);
   end
   GTgaussian(:,:,k)=rgb2gray(this_frame);
   % binarize
   this_frame=medfilt2(im2bw(this_frame));
   GT(:,:,k)=this_frame;
   GTg(:,:,k)=imfilter(this_frame,h);
   %n=strcat(sprintf('%06d',k),'.jpg');
   %imwrite(this_frame,[Dir n]);
 end
 save([Dir 'GTg'],'GTg');
 save([Dir 'GT'],'GT');
 save([Dir 'GTgaussian.mat'],'GTgaussian');
end
