function scores = AVS_EvalModel_v1(videoname)

addpath('code_forMetrics');

event_dir = ['/home/anis/avs/Data/GT/' videoname '/event_data/'];
sal_dir   = ['/home/anis/avs/Results/AV_Saliency/' videoname '/gbvs/'];

load([event_dir 'eye_data']);
load([sal_dir 'avSaliency']);

[h,w,no_of_frames] = size(eye_data);

H = AVS_LowPassFilter(h,w);

gF = 8;
sm = zeros(1,4);

fprintf(['\n' repmat('.',1,no_of_frames/10) '\n\n']);
for i = 1 : no_of_frames,
    %if ~mod(i,10), fprintf([int2str(i) '/300\r']); end;
    if ~mod(i,10), fprintf('\b|\n'); end;
    
    m_sal   = imresize(avSaliency(:,:,i),[h w]);
    m_fix   = eye_data(:,:,i);
    %m_fix_g = AVS_GaussFilter(m_fix,gF);
    m_fix_g = AVS_GaussFilterFreq(m_fix,H,gF);
    
    score =   AUC_Judd( m_sal, m_fix   ); if ~isnan(score), sm(1) = sm(1) + score; end;       
    score = real(KLdiv( m_sal, m_fix_g)); if ~isnan(score), sm(2) = sm(2) + score; end;
    score =        NSS( m_sal, m_fix   ); if ~isnan(score), sm(3) = sm(3) + score; end;
    score =         CC( m_sal, m_fix_g ); if ~isnan(score), sm(4) = sm(4) + score; end;
end
scores = sm / no_of_frames;

disp(['AUC: ' num2str(scores(1)) ' KLD: ' num2str(scores(2)) ' NSS: ' num2str(scores(3)) ' CC: ' num2str(scores(4))]);
