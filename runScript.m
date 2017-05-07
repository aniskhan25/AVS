
addpath('./OF');
addpath('./OF/mex');

addpath(genpath('./edison_matlab_interface'));

addpath('./audioread');


% demo script av saliency

videoFiles = dir( '../Data/Video/');
str = {videoFiles.name};
str(1:2) = [];

while(1)
    [selection_idx, selection] = listdlg( 'PromptString','Select a video to run AV Saliency code:','SelectionMode','single','ListSize',[300,300],'Name','Select Video','ListString',str);
    
    if selection ~= 0
        videofolder_= str( selection_idx);
        video_name  = cell2mat( videofolder_);
        audio       = strcat( video_name, '.wav');
        
        display 'Compute audio visual saliency';
        compute_audioVisualSaliency( video_name, audio);
        
        %%%display 'Preparing ground truth ...';
        %%%writeGroundTruth( video_name);
        
        display 'Evaluate ...';
        %evaluate( video_name);
        AVS_EvalModel(video_name);
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