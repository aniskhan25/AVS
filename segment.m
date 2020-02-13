function segment (video_name)

clearvars -except video_name frameRate; clc;

if exist(['../Results/segment_output/' video_name], 'dir')
else
    mkdir(['../Results/segment_output/' video_name])
end

%inDir = stracat('./output/',video_name, '/');
inDir = strcat('../Results/OFthoutput/',video_name, '/');
%inDir = strcat('./Video/',video_name, '/');
outDir = strcat('../Results/segment_output/',video_name, '/');
imgs = dir([inDir '*.jpg']);

%alllabels=struct('label',{});

alllabels = zeros(400,712,300);

tic;
for imgindx=1:length(imgs)
    fprintf('%s%d', 'Segmenting frame ',imgindx); fprintf('\n');
    
    [im,storedColorMap]=imread([inDir imgs(imgindx).name]);
    
    [h,w,~] = size(im);
    
    %[fimage labels modes regSize grad conf] = edison_wrapper(im, @RGB2Luv, 'SpatialBandWidth',13,'RangeBandWidth',13,'MinimumRegionArea',400);
    [~,labels,~,~,~,~] = edison_wrapper(im, @RGB2Luv, 'SpatialBandWidth',13,'RangeBandWidth',13,'MinimumRegionArea',400);
        
    % if no labels returned
    maxLabel = max(max(labels));
        
    if maxLabel ~= 0
        
        mask = false(h,w,maxLabel);
        
        for indx = 1:maxLabel
            mask(:,:,indx) = ( labels==indx);
        end
        
        temp_label = zeros(h,w);
        %pixel_list = struct('list',{});
        
        for indx=1:maxLabel
            
            %cur_mask = mask(:,:,indx);
            label = DeltaE_Copy(im, storedColorMap, mask(:,:,indx));
            
            temp_label(label==1) = indx;
            
            %pixel_list(indx).list = find(label==1);            
            %if ~isempty(pixel_list(indx).list)
            %    temp_label(pixel_list(indx).list) = indx;                
            %end
            
        end
        
        %meanshift_label = labels;
        deltaE_label = temp_label;
        L=LABEL(deltaE_label,4);
        LABEL_label=L;
        
        %% Note either use medfilt2 or next block of code for small region elimination;
        % LABEL_label=medfilt2(LABEL_label,[15 15]);
        
        %% code from eliminate small regions
        %props = struct('label_id',{},'centroid_x',{},'centroid_y',{},'area',{});

        t1 = LABEL_label ~=1;
        t2 = bwareaopen(t1,400);
        t3 = LABEL_label; t3(~t2) = 1;
        
        % Make label numbers in a series starting from 1
        ids = unique(t3(:));
        id  = 1;
        while id <= numel(ids)
            if ids(id)~=id
                t3(t3 == ids(id)) = id;
            end
            id = id + 1;
        end
        region_merged_label = t3;
        
%         p = regionprops(LABEL_label);
%         
%         props = struct( ...
%             'label_id'    , zeros(1,size(p,1)) ...
%             , 'centroid_x', zeros(1,size(p,1)) ...
%             , 'centroid_y', zeros(1,size(p,1)) ...
%             , 'area'      , zeros(1,size(p,1)) ...
%             );
%         
%         for i = 1:size(p,1)
%             props(i).label_id   = i;
%             props(i).centroid_x = p(i).Centroid(1);
%             props(i).centroid_y = p(i).Centroid(2);
%             props(i).area       = p(i).Area;
%         end
%         
%         [v,indx] = min([props.area]);
%         
%         iter = 0;
%         while v < 200
%             iter = iter + 1;
%             
%             dist = zeros(2,size(props,2));
%             
%             for id = 1:size(props,2)
%                 dist(1,id) = props(id).label_id;
%                 dist(2,id) = sqrt( ...
%                     ( props(indx).centroid_x - props(id).centroid_x)^2 + ...
%                     ( props(indx).centroid_y - props(id).centroid_y)^2);
%             end
%             
%             same_label_indx = (find(dist==0))/2;
%             %same_label = dist(1,same_label_indx);
%             dist(:,same_label_indx) = [];
%             [~,min_val_id] = min(dist(2,:));
%             label_id=dist(1,min_val_id);
%             %pixel_list=find(LABEL_label==props(indx).label_id);
%             %LABEL_label(pixel_list)=label_id;
%             LABEL_label(LABEL_label==props(indx).label_id)=label_id;
%             
%             props(indx) = [];
%             p=regionprops(LABEL_label);
%             %remove props rows with NaN centroid value
%             for idd=size(p,1):-1:1
%                 if isnan(p(idd).Centroid(1))
%                     p(idd)=[];
%                 end
%             end
%             
%             for i=1:size(p,1)
%                 props(i).centroid_x=p(i).Centroid(1);
%                 props(i).centroid_y=p(i).Centroid(2);
%                 props(i).area=p(i).Area;
%             end
%             
%             [v,indx]=min([props.area]);
%         end
%         
%         disp(['#iters : ' num2str(iter)]);
%         
%         % Make label numbers in a series starting from 1
%         u=unique(unique(LABEL_label));
%         id=1;
%         while id<=numel(u)
%             if u(id)==id
%             else
%                 %list=find(LABEL_label==u(id));
%                 %LABEL_label(list)=id;
%                 LABEL_label(LABEL_label==u(id)) = id;
%             end
%             u=unique(unique(LABEL_label));
%             id=id+1;
%         end
%         region_merged_label=LABEL_label;
%         %LABEL_label=L;
    else
        region_merged_label=ones(size(labels));
    end
    %alllabels(imgindx).label=region_merged_label;
    %alllabels(:,:,imgindx) = region_merged_label;
    
    %save([outDir 'labels.mat'],'region_merged_label');
    save([outDir sprintf('%06d',imgindx) '.mat'],'region_merged_label');
    
    % % save and write label imgz
    % cd ./segment_output
    % save(num2str(imgindx),'meanshift_label','deltaE_label','LABEL_label','region_merged_label');
    % imwrite(im2double(label2rgb(meanshift_label)),[num2str(imgindx) '_meanshift_label.jpg']);
    % imwrite(im2double(label2rgb(deltaE_label)),[num2str(imgindx) '_deltaE_label.jpg']);
    % imwrite(im2double(label2rgb(LABEL_label)),[num2str(imgindx) '_LABEL_label.jpg']);
    % imwrite(im2double(label2rgb(region_merged_label)),[num2str(imgindx) '_region_merged_label.jpg']);
    % cd ..
    
    clearvars -except inDir imgs outDir video_name frameRate imgindx alllabels;
end
eltime=toc;
timePerFrame=eltime/(length(imgs));
save([outDir 'timePerFrame'], 'timePerFrame');

labels = alllabels;
% % used this code when didn't get optical flow for 1st and last images
% labels=struct('label',{});
% labels(1).label=alllabels(1).label;
% [labels(2:numel(alllabels)+1).label]=alllabels(1:numel(alllabels)).label;
% labels(numel(labels)+1).label=labels(numel(labels)).label;
%save([outDir 'labels.mat'],'labels');
end