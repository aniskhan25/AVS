[im,storedColorMap]=imread('2.jpg');
[fimage labels modes regSize grad conf] = edison_wrapper(im, @RGB2Luv, 'SpatialBandWidth',13,'RangeBandWidth',13,'MinimumRegionArea',400);
for indx=1:max(max(labels))
    mask(:,:,indx)=labels==indx;
end
save('mask.mat','mask');

%labels=zeros(size(im,1),size(im,2),size(mask,3));
temp_label=zeros(size(im,1),size(im,2));
pixel_list=struct('list',{});
for indx=1:size(mask,3)
cur_mask=mask(:,:,indx);
    % compare old lists with current mask and shrink mask if pixels are
    % already assigned to some label
    if indx>1
        mask_list=find(cur_mask==1);
        for index=1:size(pixel_list,2)
            common=intersect(mask_list,pixel_list(index).list);
            if isempty(common)==0
                cur_mask(common)=0;
            end
        end
    end
    label=DeltaE_Copy(im, storedColorMap,cur_mask);
    pixel_list(indx).list=find(label==1);
    if isempty(pixel_list(indx).list)==0
        temp_label(pixel_list(indx).list)=indx;
        %labels(:,:,indx)=temp_label;
    end
end
save('labels.mat','labels');