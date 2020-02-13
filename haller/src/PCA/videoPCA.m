% code based on paper: 
% O. Stretcu and M. Leordeanu, Multiple Frames Matching for Object Discovery In Video, BMVC 2015

function softSegs = videoPCA(frames)

% compute foreground soft-segmentation using PCA 
%
% [in] frames       - cell array containing RGB frames
%
% [out] video_seg   - foreground soft-segmentation

    sigmaBlur = 5;  % for image blurring 
    k = 3;          % number of PCA dimensions used at reconstruction

    nFrames = length(frames);
    [nRows, nCols, nCh] = size(frames{1});
 
    Data = zeros(nFrames, nRows * nCols * nCh);

    for i = 1 : nFrames
        frames{i} = ni(frames{i});
        Data(i,:) = frames{i}(:)';
    end

    % PCA 
    Data        = single(Data');
    meanData    = mean(Data);
    Data        = bsxfun(@minus, Data, meanData);
    
    M       = Data'*Data;
    [v,~]   = eig(M);
    v       = v(:,size(M,1):-1:(size(M,1) - k + 1));                    % select k dimensions
    recFrames = bsxfun(@plus, (Data*v(:,1:k))*v(:,1:k)', meanData);     % reconstructions
    
    clear Data
    
    % compute reconstruction errors and initial object cues
    recDiff = zeros(nFrames, nRows, nCols);
    
    for i = 1:nFrames
        recFrame        = reshape(recFrames(:,i), [nRows, nCols, nCh]);   
        
        aux = frames{i} - recFrame; 
        aux = sqrt(sum(aux(:,:,:).^2, 3)); 

        recDiff(i,:,:) = aux;     
    end
    clear recFrame
    recDiff = ni(recDiff);  

    images      = single(zeros([nRows, nCols * nFrames, nCh]));
    binaryMasks = zeros([nRows, nCols * nFrames]);
       
    g       =  fspecial('gaussian', [3*sigmaBlur, 3*sigmaBlur], sigmaBlur);
    gCenter =  fspecial('gaussian', [nRows, nCols], min(nRows, nCols)/3);

    last = 1;
    for i = 1 : nFrames
        aux = reshape(recDiff(i,:,:), [nRows, nCols]);

        aux = imfilter(aux, g);               % blur error map
        aux = ni(aux .* gCenter);             % consider preference for central objects
   
        hsv = rgb2hsv(frames{i});
        images(:, last : last + nCols - 1, 1) = hsv(:, :, 1);
        images(:, last : last + nCols - 1, 2) = hsv(:, :, 2);
        images(:, last : last + nCols - 1, 3) = hsv(:, :, 3);
        binaryMasks(:, last : last + nCols - 1) = ni(aux)>0.5;          % get binary foreground-background separation
        last = last + nCols;
    end

    % compute soft-segmentation
    segs = getSeg(binaryMasks, images);

    softSegs = cell(1, nFrames);
    for i = 1 : nFrames 
        seg = segs(:,(i-1)*nCols+1 : i*nCols); 
        aux = hysthresh(ni(seg .* gCenter), 0.8, 0.5);  
        softSegs{i} = ni(seg.*aux);  
    end

end
