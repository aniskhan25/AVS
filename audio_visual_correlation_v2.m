        %% Perform audio-visual correlation analysis (assuming audio-visual features are already available)
% Kai Li
% Univ. of Central Florida
% May, 2014
% All rights reserved

% Note: confidenceMaps are the result maps; save line is 190-Maryam Qamar
function audioSaliency = audio_visual_correlation_v2 (audio_features, allLabels,allTracks, frameRate)
%% STEP 0: Load spatial-temporal segmentation data
%video_name = 'basketball_of_sorts_960x720';
% load video segmentation data 
% allTracks = load(sprintf('Video/%s/allTracks', video_name)); allTracks = allTracks.allTracks;
% allLabels = load(sprintf('Video/%s/allLabels', video_name)); allLabels = allLabels.allLabels;
addpath('./AV_corelation');

% get video parameters
nFrames = size(allLabels, 3);
[height, width] = size(allLabels(:, :, 1));
%% ========================================================================

%% STEP 1: Set algorithm parameters
% set save path
%avc_path = sprintf('Results/%s', video_name);
%avc_path = sprintf('../Results/audioSaliency/%s', video_name);
%if ~isequal(exist(avc_path, 'dir'), 7)
%    mkdir(avc_path);
%end
% % set frame rate
% switch video_name
%     case 'Violin_Yanni'
%         frameRate = 25.000000;
%     case 'Basketball'
%         frameRate = 29.970000;    
%     case 'Guitar_Street'
%         frameRate = 25.000000;
%     case 'Wooden_Horse'
%         frameRate = 24.870000;
%     case 'Guitar_Solo'
%         frameRate = 23.976000;
%     case 'basketball_of_sorts_960x720'
%         frameRate = 30.000000;
% end       
% set general parameters
delta = 0.000001;           % avoid dividing by zeros 
nPerms = 2000;              % WTA number of permutations
K = 5;%4                    % WTA hash parameters
maxKernelSize = 6;          % maximum spatial kernel size
minKernelSize = 2;          % minimum spatial kernel size
pho_s = 0.2;                % spatial kernel size coefficient
pho_t = 0.5;                % temporal kernel size coefficent
% m=15;                     % number of top regions in terms std
m = size(allTracks.Acceleration,1);                     
%% ========================================================================
tic;
%% STEP 2: Preprocessing audio and visual features
%% STEP 2.1: Proecess visual features
% vel = allTracks.Velocities;
acc = allTracks.Acceleration;
nSTRtracks = size(acc, 1);

% if nSTRtracks < m
%     m=nSTRtracks;
% end

% vstd = std(vel, 0, 2);
astd = std(acc, 0, 2);
% mv = mean(vel, 2);
% ma = mean(acc, 2);
% [~, vidx] = sort(mv, 'descend');
% [~, aidx] = sort(ma, 'descend');
% [~, vidx] = sort(vstd, 'descend');
[~, aidx] = sort(astd, 'descend');
% visual_features_all = [vel;acc];
visual_features_raw = acc(aidx(1:m), :);
idx = aidx(1:m);
% filtering
GAUSS_1D = gaussFilter1D(5, 2);
visual_features_raw = conv2(visual_features_raw, GAUSS_1D, 'same');
% normalize each row 
visual_features = visual_features_raw ./ (repmat(max(visual_features_raw, [], 2)+delta, 1, nFrames));
vfframes = size(visual_features, 2);
%% ========================================================================
%% STEP 2.2: Process audio features
%faudio = load(['../Data/Audio/', video_name]);


% switch_end=0;
% while(length(faudio.audio_features)>size(allLabels,3)-2)
% if switch_end==0
% faudio.audio_features(1)=[];
% else
% faudio.audio_features(length(faudio.audio_features))=[];
% switch_end=1;
% end
% end

audio_features_raw = abs(audio_features);
audio_features_raw = conv2(audio_features_raw, GAUSS_1D, 'same');
% normalize each row
audio_features = audio_features_raw ./ (repmat(max(audio_features_raw, ...
    [], 2)+delta, 1, size(audio_features_raw, 2)));
%audio_features = double(audio_features_raw > threshold);
afframes = size(audio_features, 2);

% audio-visual feature alignment
fframes = min(afframes, vfframes);

vf = visual_features(:, 1:fframes);
af = audio_features(:, 1:fframes);
%%=========================================================================

%% STEP 3: Audio-visual correlation analysis
% compute Winner-Take-All hashing code and compute hamming distance
theta = myRandperm(fframes, nPerms);
visual_code = WTAHash(vf, K, theta);
audio_code = WTAHash(af, K, theta);
wv1 = syncAnalysis(visual_code, audio_code, @computeHammingDist);
% wv1 = max(wv1(1:end/2), wv1(end/2+1:end));
%wv1(idx == 1) = min(wv1);
wv1 = (wv1 - min(wv1)) / (max(wv1) - min(wv1));
%wv1 = (wv1 > 0.95) .* wv1;
% [~, idx] = sort(wv1, 'descend');
% wv1(idx(2:end)) = 0;
[~, id_max] = max(wv1);

%if idx(id_max) == 1, 
%    [~, t1] = sort(wv1,'descend');    
%    id_max = t1(2);
%end
%%========================================================================

%% STEP 3: Post-processing by spatial-temporal smoothing
%% STEP 4.1 Spatial smoothing
confidence = zeros(nSTRtracks, 1);
% compute spatial kernel size
mSize = computeObjectSize(allLabels, idx(id_max));
sKernelSize = (mSize^0.5)*pho_s;
sKernelSize = min(sKernelSize, maxKernelSize);
sKernelSize = max(sKernelSize, minKernelSize);

confidence(idx(id_max)) = 1.0;
%confidence = wv1;
%confidence(idx == 1) = min(wv1);
% create confidence map and apply 2D smoothing to each frame
cmapCells = cellfun(@(x)(computeConfidenceMap(x, confidence, sKernelSize)), ...
    reshape(mat2cell(allLabels, height, width, ones(1, nFrames)), 1, nFrames),... 
    'UniformOutput', false);
cmapMat = reshape(cell2mat(cmapCells), [height, width, nFrames]);
%imshow(cmapMat(:,:,5),[])
%%=========================================================================
%% STEP 4.2: Temporal smoothing
% compute temporal kernel size
mv = mean(visual_features_raw(id_max, :));
tKernelSize = (frameRate/mv)*pho_t;
tKernelSize = min(tKernelSize, maxKernelSize);
tKernelSize = max(tKernelSize, minKernelSize);
% create 1D gaussian filters
GAUSS_1D = gaussFilter1D(2*tKernelSize, tKernelSize);
% reorgnize confidence map, put each strand of the same pixel into a cell
strandCells = cellfun(@(x)reshape(x, 1, nFrames), mat2cell(cmapMat, ones(1, height),...
    ones(1, width), nFrames), 'UniformOutput', false);
% compute temporal convolution in parallel for all pixel strands
tmpCmapCells = cellfun(@(x)conv(x, GAUSS_1D, 'same'), strandCells, 'UniformOutput', false);
confidenceMaps = reshape(cell2mat(reshape(tmpCmapCells, width*height, 1)),...
    [height, width, nFrames]);
% renormalize each confidence map 
cMax = max(max(confidenceMaps), [], 2);
cMax = 1 / (cMax + double(cMax == 0));
confidenceMaps = bsxfun(@times, confidenceMaps, cMax);
% reorganize confidence maps to put each frame in a cell
confidenceMapsCell = reshape(mat2cell(confidenceMaps, height, width, ones(1, nFrames)), ...
    1, nFrames);
audioSaliency=confidenceMaps;

eltime=toc;
timePerFrame=eltime/nFrames;
%save([avc_path '/', 'timePerFrame'], 'timePerFrame');

%save([avc_path '/' video_name], 'audioSaliency');
%% ========================================================================

% %% STEP 5: Visualization
% % load blue-to-red color map
% colormap = load('colormap', 'map'); colormap = uint8(255*colormap.map);
% % convert all confidence maps to color images using color coding
% imCmapCells = cellfun(@(x)labelToRGB(x, colormap), confidenceMapsCell, ...
%     'UniformOutput', false);
% % load orginal video into a cell array
% imOrgCells = reshape(mat2cell(loadVideo(['Video/', video_name]), ...
%     height, width, 3, ones(1, nFrames+2)), 1, nFrames+2);
% % blend the video and the correlation results for visulization
% imFuseCells = cellfun(@(x, y)imfuse(x, y, 'blend'), imOrgCells(2:end-1), imCmapCells, ...
%     'UniformOutput', false);
% % save files
% saveLabels(imFuseCells, avc_path, 2);
% % demo
% playVideo(imFuseCells, 24);
%% ========================================================================

%% STEP 6: compute statistics and save results
% groundTruth = load(['GroundTruth/', video_name, '/', video_name]); groundTruth = groundTruth.ground_truth;
% 
% for i=1:9
%  g(:,:,i)=groundTruth(:,:,i);
%  end
% for i=12:20
%  g(:,:,i-2)=groundTruth(:,:,i);
% end
%  perfMetrics = quantStat(confidenceMaps, g);
% 
% %perfMetrics = quantStat(confidenceMaps, groundTruth); % original
% save(avc_path, 'perfMetrics','confidenceMaps');
%% ========================================================================

%% Compute precision and recall w.r.t ground truth
function perfMetrics = quantStat(allCMaps, groundTruth)

[height, width, nFrames] = size(allCMaps);

if isa(groundTruth, 'cell')
    nCells = numel(groundTruth);
    groundTruth = cell2mat(groundTruth);
    groundTruth = permute(reshape(groundTruth', width, height, nCells), [2 1 3]);
end
% discard the first and the last frame
groundTruth = groundTruth(:, :, 2:end-1);

if size(groundTruth, 3) ~= nFrames
    error('Dimension mismatch!');
end

step = 0.02;
th = (0:step:1)';
N = numel(th);
perfMetrics = zeros(N, 5);
perfMetrics(:, 1) = th;

precision = zeros(N, nFrames);
recall = zeros(N, nFrames);
hit = false(N, nFrames);
for i = 1 : nFrames
    truth = find(groundTruth(:, :, i));
    for j = 1 : N
%         idx = (w >= th(j));
        %cmap = computeConfidenceMap(allLabels(:, :, i), idx, false);
        cmap = allCMaps(:, :, i); %cmap = cmap / max(cmap(:));
        positive = find(cmap >= th(j));
        truePositive = intersect(positive, truth);
        
        % I inserted to calculate FPR for AUC
        falsePositive=numel(positive)-numel(truePositive);
        trueNegative=numel(groundTruth(:,:,i))-numel(truth);
        FPR(j,i)=falsePositive/trueNegative;
        
        recall(j, i) = numel(truePositive) / numel(truth);
        if numel(positive) > 0
            precision(j, i) = numel(truePositive) / numel(positive);
        else
            precision(j, i) = 0;
        end
        
        hit(j, i) = precision(j, i) >= 0.5;
    end
end
perfMetrics(:, 2) = mean(precision, 2);
perfMetrics(:, 3) = mean(recall, 2);
perfMetrics(:, 4) = sum(hit, 2) / nFrames;
perfMetrics(:, 5) = mean(FPR, 2);

perfMetrics = perfMetrics';
%% ========================================================================

%% Compute average object size
function objSize = computeObjectSize(allLabels, id)
nFrames = size(allLabels, 3);
nPixels = 0;
for i = 1 : nFrames
    nPixels = nPixels + numel(find(allLabels(:, :, i) == id));
end
objSize = nPixels / nFrames;
%% ========================================================================

%% Apply spatial gaussian smoothing to confidence map
function cmap = computeConfidenceMap(label, coef, sKernelSize, isFilter)
if nargin == 3
    isFilter = true;
end
dims = size(label);
cmap = zeros(dims(1), dims(2));
for i = 1 : numel(coef)
    cmap(label == i) = double(coef(i));
end

if isFilter
    winSize = 2*floor(sKernelSize) + 1;
    % create 2-D gaussian filter
    GAUSS_2D = fspecial('gaussian', [winSize winSize], sKernelSize);
    % filter the confidence map
    cmap = imfilter(cmap, GAUSS_2D);
end
%% ========================================================================

%% Generate 2D Gaussian filter
function GAUSS = gaussFilter1D(size, sigma)
step = ceil((size-1)/2);
x = -step:step;
GAUSS = 1/(sqrt(2*pi)*sigma)*exp(-0.5*x.^2/(sigma^2));
GAUSS = GAUSS / sum(GAUSS);
%% ========================================================================

%% Generate random permutations 
function theta = myRandperm(length, N)
theta = zeros(N, length);
rng(0);
for i = 1 : N
    theta(i, :) = randperm(length);
end
%% ========================================================================

%% Compute Winner-Take-All hashing
function c = WTAHash(X, K, theta)
row = size(X, 1);
N = size(theta, 1);
c = zeros(row, N);
for r = 1 : row
    for i = 1 : N
        [~, c(r, i)] = max(X(r, theta(i, 1:K)));
    end
end
c = c - 1;
%% ========================================================================

%% Compute Hamming distance
function HM = computeHammingDist(X, Y)
if numel(X) ~= numel(Y)
    error('Input dimensions does not match.');
end
HM = sum(X == Y) / numel(X);
%% ========================================================================

%% Synchronization analysis using given function
function w = syncAnalysis(vec1, vec2, simfunc)
if size(vec1, 2) ~= size(vec2, 2)
    error('Input feature length does not match.');
end
vecLength = size(vec1, 2);
vec1dim = size(vec1, 1); % visual
vec2dim = size(vec2, 1); % audio
windSize = 5;
wv = zeros(vec1dim, vec2dim);
for i = 1 : vec2dim
    wt = zeros(vec1dim, windSize);
    for t = 0:windSize-1
       vec = bsxfun(@times, vec1(:, 1), zeros(vec1dim, vecLength));
       vec(:, t+1:end) = vec1(:, 1:end-t);
       vec1Cell = mat2cell(vec, ones(1, vec1dim), vecLength);
       wt(:, t+1) = cellfun(@(x)simfunc(x, vec2(i, :)), vec1Cell);
    end
    wv(:, i) = max(wt, [], 2);
end
w = max(wv, [], 2);
%w = wv(:, vec2dim/2+1);
%% ========================================================================
