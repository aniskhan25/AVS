function compute_avSaliencyMap(video_name)

%% audioVisual Saliency
display 'Compute audio visual saliency maps ...'

audioSaliencyDir = strcat('../Results/audioSaliency/',video_name, '/');
motioMapsDir = strcat('../Results/motionMaps/',video_name, '/');
%visualSaliencyDir = strcat('./visualSaliency/',video_name, '/');
visualSaliencyDir = strcat('../Results/visualSaliency/',video_name, '/gbvs/');

load([audioSaliencyDir video_name]);
load([motioMapsDir 'motionMaps']);
load([visualSaliencyDir  'visualSaliency']);

[ImgH,ImgW,~] = size(audioSaliency(:,:,1));

% put empty maps at start and end of audioSaliency to match its total frames
% to other maps
tmp = struct('map',{});
tmp(1).map = zeros(ImgH,ImgW);
for id = 1 : size(audioSaliency,3),
    [tmp(id+1).map] = audioSaliency(:,:,id);
end
tmp(numel(tmp)+1).map = zeros(size(audioSaliency(:,:,1)));
audioSaliency = tmp;

sigma = 2.5;
center_bias = (gausswin(ImgH,sigma) * gausswin(ImgW,sigma)');

len = numel(visualSaliency);

fprintf(['\n' repmat('.',1,len/10) '\n\n']);

%h= fspecial('gaussian',15,15);
for indx=1:len,
    if ~mod(indx,10), fprintf('\b|\n'); end;
    
    a = 0.34;
    b = 0.33;
    g = 0.33;
    
    mA = audioSaliency(indx).map;
    mD = motionMaps(:,:,indx);
    mS = visualSaliency(indx).map;

    mD(isnan(mD)) = 0;
    
%     %alpha
%     %g = max(mA(:));
%     if sum(mA(:)) == 0, 
%         a = 0;
%     else        
%         sk = abs(AVS_skewness(mA)); sk(isnan(sk)) = 0;
%         
%         a = sk / 2;
%         if sk > 2, b = 1.0; else b = sk / 2; end;
%     end
%     
%     %beta
%     if sum(mD(:)) == 0, 
%         b = 0;
%     else        
%         sk = abs(AVS_skewness(mD)); sk(isnan(sk)) = 0;
%         
%         b = sk / 2;
%         %if sk > 2, b = 1.0; else b = sk / 2; end;
%     end
%     
%     % gamma
%     t1 = mS > mean(mS(:)); g = 1-sum(t1(:))/numel(t1);
%         
%     tot = a + b + g;
%     
%     a = a / tot; b = b / tot; g = g / tot;
    
    %mF = a.*mA + b.*mD + g.*mS + a*b.*mA.*mD + a*g.*mA.*mS + b*g.*mD.*mS;
    mF = a.*mA + b.*mD + g.*mS;
    
    mN = (mF - min(mF(:))) / (max(mF(:)) - min(mF(:)));
    
    
    if sum(~isnan(mN)) == 0, mN = zeros(size(mN)); end
    
    %avSaliency(:,:,indx) = mN;
    avSaliency(:,:,indx) = mN .* center_bias;
    %avSaliency(:,:,indx) = center_bias;
    
end

fprintf('\n');

% if exist(['./AV_Saliency/' video_name], 'dir')
% else
%     mkdir(['./AV_Saliency/' video_name])
% end
% outDir=strcat('./AV_Saliency/',video_name, '/');

if exist(['../Results/AV_Saliency/' video_name '/gbvs'], 'dir')
else
    mkdir(['../Results/AV_Saliency/' video_name '/gbvs'])
end
outDir=strcat('../Results/AV_Saliency/',video_name, '/gbvs/');
save([outDir 'avSaliency'],'avSaliency');
