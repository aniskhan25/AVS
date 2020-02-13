
addpath('./OF');
addpath('./OF/mex');

addpath(genpath('./edison_matlab_interface'));

addpath('./audioread');

addpath(genpath('./haller/src'));

% demo script av saliency

datapath = ['/home/anis/Documents/datasets/DIEM/'];

videoFiles = dir(datapath);
str = {videoFiles.name};
str(1:2) = [];

scores = [];

while(1)
    [selection_idx, selection] = listdlg( 'PromptString','Select a video to run AV Saliency code:','SelectionMode','single','ListSize',[300,300],'Name','Select Video','ListString',str);
    
    if selection ~= 0
        videofolder_= str( selection_idx);
        
        video_name = cell2mat( videofolder_);
        
        video = [datapath video_name '/video/' video_name '.mp4'];
        audio = [datapath video_name '/audio/' video_name '.wav'];
        
        display 'Compute audio visual saliency';
        %avSaliency = compute_audioVisualSaliency( video, audio);
        
        %outDir = [datapath video_name '/'];
        %save([outDir 'avSaliency'],'avSaliency');
        
        display 'Preparing ground truth ...';
        writeGroundTruth( video_name);
        
        display 'Evaluate ...';
        %evaluate( video_name);
        score = AVS_EvalModel_v1(datapath,video_name)
        scores = [scores; score];        
    end
    m = input( 'Do you want to run code for another video, Y/N [Y]:','s');
    if m == 'N'
        break
    else
        videoFiles = dir( '../Data/Video/' );
        str = {videoFiles.name};
        str(1:2) = [];
    end
end

scores