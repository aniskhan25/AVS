function softSegs = videoPCA_softSegs(inSoftSegs, frames)

% refine soft-segmentation by projection on the subspace of prev
% soft-segmentations
%
% [in] inSoftSegs           - initial soft-segmentations
% [in] frames               - RGB frames
%
% [out] softSegs            - refined soft-segmentations

    K = 8;                   % number of PCA dimensions used at reconstruction

    nFrames = length(inSoftSegs);
    [nRows, nCols, nCh] = size(inSoftSegs{1});
 
    Data = zeros(nFrames, nRows * nCols * nCh);

    for i = 1 : nFrames
        inSoftSegs{i} = ni(inSoftSegs{i});    
        Data(i,:) = inSoftSegs{i}(:)';
    end

    % PCA 
    Data        = single(Data');
    meanData    = mean(Data);
    Data        = bsxfun(@minus, Data, meanData);
    
    
    M       = Data'*Data;
    [v,~]   = eig(M);
    k       = min(K, size(v, 2));
    v       = v(:,size(M,1):-1:(size(M,1) - k + 1));
    recFrames = bsxfun(@plus, (Data*v(:,1:k))*v(:,1:k)', meanData);
        
    clear Data

    % compute reconstruction errors and initial object cues
    recDiff = zeros(nFrames, nRows, nCols);
    for i = 1:nFrames
        recFrame = reshape(recFrames(:,i), [nRows, nCols, 1]);   
        recDiff(i,:,:) = ni(recFrame);     
    end
    clear recFrame
    recDiff = ni(recDiff); 

    images      = single(zeros([nRows, nCols * nFrames, nCh])); 
    binaryMasks = zeros([nRows, nCols * nFrames]);
    
    gCenter =  fspecial('gaussian', [nRows, nCols], min(nRows, nCols)/3);

    last = 1;
    for i = 1 : nFrames
        aux = reshape(recDiff(i,:,:), [nRows, nCols]);

        aux = ni(aux .* gCenter);                % consider preference for central objects

        hsv = rgb2hsv(ni(frames{i}));
        images(:, last : last + nCols - 1, 1) = hsv(:, :, 1);
        images(:, last : last + nCols - 1, 2) = hsv(:, :, 2);
        images(:, last : last + nCols - 1, 3) = hsv(:, :, 3);
        binaryMasks(:, last : last + nCols - 1) = ni(aux)>0.5;          % get binary foreground-background separation
        last = last + nCols;
    end

    % compute soft-segmentation
    segs = getSeg(binaryMasks, images);
    
    softSegs = cell(1, nFrames);
    for i = 1:nFrames     
        seg = segs(:,(i-1)*nCols+1:i*nCols); 
        softSegs{i} = seg;
    end

end
