inDir = './output/';
outDir='./output/';

load([inDir 'polarflow.mat']);

for i=1:size(polarflow,2)
    rgb_imgz(:,:,:,i)=flowToColor(polarflow(i).p_flow);
end

save([outDir 'rgb_imgz.mat'],'rgb_imgz');

for i=1:size(rgb_imgz,4)
    luv_imgz(:,:,:,i)=RGB2Luv(rgb_imgz(:,:,:,i));
end

save([outDir 'luv_imgz.mat'],'luv_imgz');

% write luv imgz images
for k=1:size(luv_imgz,4)
    imwrite(luv_imgz(:,:,:,k),[outDir num2str(k+1) '.jpg']);
end