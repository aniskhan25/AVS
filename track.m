function track (video_name)

clearvars -except video_name frameRate; %clc;

if exist(['../Results/tracked/' video_name], 'dir')
else
    mkdir(['../Results/tracked/' video_name])
end

%inDir = './segmented/'; % labels directory
inDir = strcat('../Results/segment_output/',video_name, '/'); % labels directory
imginDir = strcat('../Data/Video/',video_name, '/');
outDir = strcat('../Results/tracked/',video_name, '/');
imgs = dir([imginDir '*.jpg']);
tracks=struct('track_id',{},'c_x',{},'c_y',{},'hl',{},'hu',{},'hv',{});

nbins=125;
search_radius=100; % for centroid
cT_thresh=0.6; % for appearence similarity

%load([inDir 'labels']);

%no_of_frames = 300;
%load([inDir sprintf('%06d',1)]);
%[h,w] = size(region_merged_label);

%allLabels = zeros(h,w,no_of_frames);
%for i=1:300,
%    load([inDir sprintf('%06d',i)]);
%    allLabels(:,:,i) = region_merged_label;
%end

load([inDir 'labels']);
%allLabels=zeros(size(labels));
allLabels = labels;
%save 1st label image (duplicate)
%allLabels(:,:,1)=labels(:,:,1);
%save('allLabels.mat','allLabels');

[h,w,no_of_frames] = size(labels);

tic;

%fprintf('Progress:\n');
fprintf(['\n' repmat('.',1,no_of_frames/10) '\n\n']);

for imgindx=2:length(imgs)-1
    %if ~mod(imgindx,10), fprintf([int2str(imgindx) '/300\r']); end;
    %disp(num2str(imgindx));
    if ~mod(imgindx,10), fprintf('\b|\n'); end;
    
    CosTheta=struct('id',{},'idx',{},'cTl',{},'cTu',{},'cTv',{},'avgcT',{});
    candidate=struct('track_id',{});
    unmatched=struct('track_id',{});
    matched=struct('track_id_c',{},'track_id_e',{});
    
    if imgindx==2
        img1=imread([imginDir imgs(imgindx-1).name]);
        img1=RGB2Luv(img1);
        %img1=rgb2hsv(img1);
        label1 = labels(:,:,imgindx-1);
        
        img2=imread([imginDir imgs(imgindx).name]);
        img2=RGB2Luv(img2);
        %img2=rgb2hsv(img2);
        %label2=labels(imgindx).label;
        label2=labels(:,:,imgindx);
        
        props1=regionprops(label1,'all');
        
        % initialize 'tracks' from 1st label
        for id=1:numel(props1)
            tracks(id).track_id=id;
            tracks(id).c_x=props1(id).Centroid(1);
            tracks(id).c_y=props1(id).Centroid(2);
            subImg=imcrop(img1, props1(id).BoundingBox);
            %hl=histcounts(subImg(:,:,1),nbins);
            
            
            t1 = subImg(:,:,1);
            t2 = histc(t1,linspace(min(t1(:)),max(t1(:)),nbins));
            if numel(t2) > nbins, hl = sum(t2,2)'; else hl = t2; end;
            
            t1 = subImg(:,:,2);
            t2 = histc(t1,linspace(min(t1(:)),max(t1(:)),nbins));
            if numel(t2) > nbins, hu = sum(t2,2)'; else hu = t2; end;
            
            t1 = subImg(:,:,3);
            t2 = histc(t1,linspace(min(t1(:)),max(t1(:)),nbins));
            if numel(t2) > nbins, hv = sum(t2,2)'; else hv = t2; end;
            
            tracks(id).hl = hl;            
            tracks(id).hu = hu;            
            tracks(id).hv = hv;
        end
        
        
    else
        % track after first two frames
        img2=imread([imginDir imgs(imgindx).name]);
        img2=RGB2Luv(img2);
        %img2=rgb2hsv(img2);
        label2=labels(:,:,imgindx);
        %label2=labels(imgindx).label;
        
    end
    
    props2=regionprops(label2,'all');
    % get percent_match
    for id=1:numel(props2)
        %disp(num2str(id));
        subImg=imcrop(img2, props2(id).BoundingBox);
        % distance similarity euclidean distance
        for idx=1:numel(tracks)
            dist=sqrt((tracks(idx).c_x-props2(id).Centroid(1)).^2+(tracks(idx).c_y-props2(id).Centroid(2)).^2);
            if dist<=search_radius
                candidate(numel(candidate)+1).track_id=idx;
            end
        end
        % appearence similarity
        if numel(candidate)>0
                        
            t1 = subImg(:,:,1);
            t2 = histc(t1,linspace(min(t1(:)),max(t1(:)),nbins));
            if numel(t2) > nbins, hl = sum(t2,2)'; else hl = t2; end;
            
            t1 = subImg(:,:,2);
            t2 = histc(t1,linspace(min(t1(:)),max(t1(:)),nbins));
            if numel(t2) > nbins, hu = sum(t2,2)'; else hu = t2; end;
            
            t1 = subImg(:,:,3);
            t2 = histc(t1,linspace(min(t1(:)),max(t1(:)),nbins));
            if numel(t2) > nbins, hv = sum(t2,2)'; else hv = t2; end;
            
            for indx=1:numel(candidate)
                %disp(['indx' num2str(indx)]);
                CosTheta(numel(CosTheta)+1).idx=candidate(indx).track_id;
                CosTheta(numel(CosTheta)).id=id;
                CosTheta(numel(CosTheta)).cTl = dot(tracks(candidate(indx).track_id).hl,hl)/(norm(tracks(candidate(indx).track_id).hl)*norm(hl));
                CosTheta(numel(CosTheta)).cTu = dot(tracks(candidate(indx).track_id).hu,hu)/(norm(tracks(candidate(indx).track_id).hu)*norm(hu));
                CosTheta(numel(CosTheta)).cTv = dot(tracks(candidate(indx).track_id).hv,hv)/(norm(tracks(candidate(indx).track_id).hv)*norm(hv));
                CosTheta(numel(CosTheta)).avgcT = (CosTheta(numel(CosTheta)).cTl+CosTheta(numel(CosTheta)).cTu+CosTheta(numel(CosTheta)).cTv)/3;
                %ThetaInDegrees = acosd(CosTheta);
            end
        else
            % keep track of unmatched labels in current label
            unmatched(numel(unmatched)+1).track_id=id;
        end
        clearvars candidate; candidate=struct('track_id',{});
    end
    
    
    % find closest segment and update current label image
    unique_id=unique([CosTheta.id]);
    closest_label=zeros(numel(unique_id),3);
    for id=1:numel(unique_id)
        same=find([CosTheta.id]==unique_id(id));
        if numel(same)>1
            [v, indx]=max([CosTheta(same).avgcT]);
            closest_label(id,1)=unique_id(id);
            closest_label(id,2)=CosTheta(same(indx)).idx;
            closest_label(id,3)=CosTheta(same(indx)).avgcT;
            %closest_label(id,3)=CosTheta(same(indx)).cTl;
            %closest_label(id,4)=CosTheta(same(indx)).cTu;
            %closest_label(id,5)=CosTheta(same(indx)).cTv;
        else
            closest_label(id,1)=unique_id(id);
            closest_label(id,2)=CosTheta(same).idx;
            closest_label(id,3)=[CosTheta(same).avgcT];
            %closest_label(id,3)=[CosTheta(same).cTl];
            %closest_label(id,4)=[CosTheta(same).cTu];
            %closest_label(id,5)=[CosTheta(same).cTv];
        end
    end
    
    for id=1:size(closest_label,1)
        % if cT value is <treshold update current label image
        if closest_label(id,3)>=cT_thresh
            %if closest_label(id,3)>=cT_thresh && closest_label(id,4)>=cT_thresh && closest_label(id,5)>=cT_thresh
            %                     pixels=find(label2==closest_label(id,1));
            %                     label2(pixels)=closest_label(id,2);
            matched(numel(matched)+1).track_id_c=closest_label(id,1);
            matched(numel(matched)).track_id_e=closest_label(id,2);
        else
            unmatched(numel(unmatched)+1).track_id=closest_label(id,1);
        end
    end
    
    % assign new labels to all unmatched segments
    new_label=max(numel(tracks),max(max(label2)))+1;
    for id=1:numel(unmatched)
        pixels=find(label2==unmatched(id).track_id);
        if isempty(pixels)==0
            label2(pixels)=new_label;
            new_label=new_label+1;
        end
    end
    
    for id=1:numel(matched)
        pixels=find(label2==matched(id).track_id_c);
        label2(pixels)=matched(id).track_id_e;
    end
    
    
    
    %% update tracks
    props2=regionprops(label2,'all');
    
    for id=1:numel(props2)
        if isnan(props2(id).Centroid(1))==0
            tracks(id).c_x=props2(id).Centroid(1);
            tracks(id).c_y=props2(id).Centroid(2);
            subImg=imcrop(img2, props2(id).BoundingBox);
            
            t1 = subImg(:,:,1);
            t2 = histc(t1,linspace(min(t1(:)),max(t1(:)),nbins));
            if numel(t2) > nbins, hl = sum(t2,2)'; else hl = t2; end;
            
            t1 = subImg(:,:,2);
            t2 = histc(t1,linspace(min(t1(:)),max(t1(:)),nbins));
            if numel(t2) > nbins, hu = sum(t2,2)'; else hu = t2; end;
            
            t1 = subImg(:,:,3);
            t2 = histc(t1,linspace(min(t1(:)),max(t1(:)),nbins));
            if numel(t2) > nbins, hv = sum(t2,2)'; else hv = t2; end;
            
            if isempty(find([matched.track_id_e]==id))==1
                tracks(id).track_id=id;
                tracks(id).hl=hl;
                tracks(id).hu=hu;
                tracks(id).hv=hv;
            else
                hl=(tracks(id).hl+hl)/2;  % check this logic
                tracks(id).hl=hl;
                hu=(tracks(id).hu+hu)/2;
                tracks(id).hu=hu;
                hv=(tracks(id).hv+hv)/2;
                tracks(id).hv=hv;
            end
        end
    end
    
    % compact tracks
    %         empty=0;
    id=1;
    while id<=numel(tracks)
        if isempty(tracks(id).track_id)==1
            tracks(id)=[];
            while isempty(tracks(id).track_id)==1
                tracks(id)=[];
            end
            %                     old_id=tracks(id).track_id;
            %                     tracks(id).track_id=id;
            %                     pixels=find(label2==old_id);
            %                     label2(pixels)=id;
            while id<=numel(tracks)
                while tracks(id).track_id~=id
                    old_id=tracks(id).track_id;
                    tracks(id).track_id=id;
                    pixels=find(label2==old_id);
                    label2(pixels)=id;
                    %                             id=id+1;
                end
                id=id+1;
            end
        else
            id=id+1;
        end
    end
    
    % save label images
    %         load('allLabels.mat');
    allLabels(:,:,imgindx)=label2;
    %         save('allLabels.mat','allLabels');
    
    clearvars -except tracks allLabels labels inDir imginDir imgs outDir video_name frameRate imgindx nbins search_radius cT_thresh;
end
eltime=toc;

fprintf('\n');

timePerFrame=eltime/(length(imgs)-2);
save([outDir 'timePerFrame'], 'timePerFrame');

% % duplicate last label: no need now
% allLabels(:,:,size(allLabels,3))=allLabels(:,:,size(allLabels,3)-1);
save([outDir 'allLabels'],'allLabels');
end