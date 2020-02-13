function frames = extractFrames(videoPath, width, height)

% get video frames, at fix size (frames will be resized)
%
% [in] videoPath        - path to the video file
% [in] width            - final width of an extracted frame
% [in] height           - final height of an extracted frame
%
% [out] frames          - cell array containing the frames

    videoInfo = VideoReader(videoPath);

    nFrames = round(videoInfo.Duration * videoInfo.FrameRate);
    frames  = cell(nFrames, 1);
    
    nFrames = 0;
    
    while (hasFrame(videoInfo))
        frame   = readFrame(videoInfo);
        frame   = imresize(frame, [height, width]);
        nFrames = nFrames+1;
        frames{nFrames} = frame;
    end
 
    frames = frames(1:nFrames);    
end

