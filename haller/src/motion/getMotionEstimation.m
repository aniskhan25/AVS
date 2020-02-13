function motionSoftSegs = getMotionEstimation(frames, softSegs)

% compute motion soft-segmentation 
%
% [in] frames       - RGB frames 
% [in] softSegs     - appearance soft-segmentation 
%
% [out] motionSoftSegs - motion soft-segmentation

warning('off') %#ok<WNOFF>

    for i = 1 : numel(frames);
        frames{i} = rgb2gray(frames{i});
    end
    
    [nRows, nCols]      = size(frames{1});
    [xs, ys]            = meshgrid(1:nCols, 1:nRows);
    nFrames             = numel(frames);
    
    motionSoftSegs              = cell(nFrames, 1);
    
    for i = 2 : nFrames-1
        bg = 1 - softSegs{i};
        bg(bg < 0.8)    = 0;
        bg(bg >=  0.8)  = 1;
        bgPos = find(bg);
               
        i0 = (double(ni(frames{i-1})));
        i1 = (double(ni(frames{i})));
        i2 = (double(ni(frames{i+1})));
                
        [ix, iy] =  gradient(i1);
        it = i2-i0;
        
        ix_bg = ix(bgPos);
        iy_bg = iy(bgPos);
        it_bg = it(bgPos);
        [ys_bg, xs_bg] = ind2sub([nRows, nCols], bgPos);
    
        D = [ix_bg(:), iy_bg(:), xs_bg(:).*ix_bg(:), ys_bg(:).*iy_bg(:), xs_bg(:).*iy_bg(:), ys_bg(:).*ix_bg(:)];
        
        lambda = 0;
        v = inv(D'*D + lambda*eye(size(D,2)))*D'*it_bg(:); %#ok<MINV>
    
        D = [ix(:), iy(:), xs(:).*ix(:), ys(:).*iy(:), xs(:).*iy(:), ys(:).*ix(:)];
        rasp = abs(D*v - it(:));
        rasp = reshape(rasp, [nRows, nCols]);

        motionSoftSegs{i} = ni(rasp);
    end
    
    motionSoftSegs{1}         = motionSoftSegs{2};
    motionSoftSegs{nFrames}   = motionSoftSegs{nFrames-1};


end