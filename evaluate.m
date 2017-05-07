function evaluate( video_name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

clearvars -except video_name frameRate; clc;

if exist(['../Results/performance/' video_name '/gbvs'], 'dir')
else
    mkdir(['../Results/performance/' video_name '/gbvs'])
end

salDir = strcat('../Results/AV_Saliency/',video_name, '/gbvs/');
GTDir = strcat('../Data//GT/',video_name, '/');
outDir=strcat('../Results/performance/',video_name, '/gbvs/');

load([salDir 'avSaliency']);
load([GTDir 'GT']);
load([GTDir 'GTg']);
load([GTDir 'GTgaussian']);

addpath('code_forMetrics');

calAUC(outDir,GT,avSaliency);
calKLD(outDir,GT,avSaliency);
calNSS(outDir,GT,avSaliency);
calCC(outDir,GT,avSaliency);
end

function calAUC(outDir,GT,avSaliency)
totalFrames=size(GT,3);
sumAuc=0;
for id=1:totalFrames
    % AUC_Judd
      score = AUC_Judd(avSaliency(:,:,id), GT(:,:,id));
      if ~isnan(score)
        sumAuc=sumAuc+score;
      end
end
AUC=sumAuc/totalFrames;
save([outDir 'AUC'],'AUC');
end

function calKLD(outDir,GT,avSaliency)
totalFrames=size(GT,3);
sumKLD=0;
for id=1:totalFrames
    % KLD
      score = KLdiv(avSaliency(:,:,id), GT(:,:,id));
      if ~isnan(score)
        sumKLD=sumKLD+score;
      end
end
KLD=sumKLD/totalFrames;
save([outDir 'KLD'],'KLD');
end

function calNSS(outDir,GTg,avSaliency)
totalFrames=size(GTg,3);
sumNSS=0;
for id=1:totalFrames
    % NSS
      score = NSS(avSaliency(:,:,id), GTg(:,:,id));
      if ~isnan(score)
        sumNSS=sumNSS+score;
      end      
end
nSS=sumNSS/totalFrames;
save([outDir 'nSS'],'nSS');
end

function calCC(outDir,GTgaussian,avSaliency)
totalFrames=size(GTgaussian,3);
sumCC=0;
for id=1:totalFrames
    % CC
      score = CC(avSaliency(:,:,id), GTgaussian(:,:,id));
      if ~isnan(score)
        sumCC=sumCC+score;
      end      
end
correlationC=sumCC/totalFrames;
save([outDir 'correlationC'],'correlationC');
end