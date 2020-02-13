function seg2 = classify_color_patches_ipfp(Ihsv, seg, param)

warning('off') %#ok<WNOFF>

    dW = param.dW;
    lambda = param.lambda;

    dimH = param.dimH;
    dimS = param.dimS;
    dimV = param.dimV;

    Ihsv = rgb2hsv(Ihsv);
    [nRows, nCols, ~] = size(Ihsv);

    % pre-process color info

    h = Ihsv(:,:,1);
    s = Ihsv(:,:,2);
    v = ni(Ihsv(:,:,3));

    h = ni(h);
    s = ni(s);

    h = round(h*(dimH-1)+1);
    v = round(v*(dimV-1)+1);
    s = round(s*(dimS-1)+1);

    im_col = h + (s-1)*dimH + (v-1)*dimH*dimS;

    xs0 = (1+dW):8:(nCols-dW);
    ys0 = ((1+dW):8:(nRows-dW))';

    xs = repmat(xs0, length(ys0), 1);
    ys = repmat(ys0, 1, length(xs0));

    xs = xs(:);
    ys = ys(:);

    nPatches = length(xs);

    X = zeros(nPatches, 1+dimH*dimS*dimV); 
    y = zeros(nPatches, 1);

    X(:,1) = 1;

    for i = 1:nPatches
    
        c = im_col(ys(i)-dW:ys(i)+dW, xs(i)-dW:xs(i)+dW);
   
        y(i)    = seg(ys(i),xs(i));
    
        X(i,1+c(:)) = 1;
    
    end
    
    global NFeatures    
    
    samples = X(:, 2:end);
    mu          = mean(samples);
    samples     = bsxfun(@minus, samples, mu);
   
    selection = featuresSelection_ipfp(samples, NFeatures);
    selection = logical(selection);
    selection = [true; selection];
    
    X = X(:, selection);

    % learn patch classifier based on color using regularized least squares
    nFeatures = sum(selection);
    w = inv(X'*X + lambda*eye(nFeatures))*X'*y;

    % generate segmentations by classifying color patches

    dStep = 1;

    xs0 = (1+dW):dStep:(nCols-dW);
    ys0 = ((1+dW):dStep:(nRows-dW))';

    xs = repmat(xs0, length(ys0), 1);
    ys = repmat(ys0, 1, length(xs0));

    xs = xs(:);
    ys = ys(:);

    nTrials = length(xs);
    
    im_col_aux = zeros(size(im_col));
    pos = find(selection(2:end) == 1)+1;
    for i = 1 : numel(pos)
        im_col_aux(im_col == pos(i)-1) = i;
    end
    im_col = single(im_col_aux); clear im_col_aux;

    seg2    = zeros(size(seg));
    c       = zeros(sum(selection), 1);
    
    for i = 1:nTrials
        
        x0  = xs(i);
        y0  = ys(i);
        
        c = 0 * c;
        auxI = im_col(y0-dW:y0+dW, x0-dW:x0+dW);
        pos = auxI>0;
        c(auxI(pos)+1)    = 1;
        c(1)            = 1;
    
        seg2(y0, x0) = c'*w;
    end

    seg2 = ni(seg2);

end


