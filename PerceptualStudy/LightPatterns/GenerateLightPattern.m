% Set parameters
fps = 60;           % Frames per second
duration = 5;       % Duration in seconds (1-second loop)
numFrames = fps * duration;
frameSize = [1080, 1920]; % Resolution (height, width)

% Create video writer object
videoName = 'flashing_video.mp4';
v = VideoWriter('flashing_video.avi', 'Motion JPEG AVI');  
v.FrameRate = fps;
open(v);

% Generate frames
for frame = 1:numFrames
    if frame == numFrames % Only the last frame is white
        img = ones(frameSize) * 255; % White frame
    else
        img = zeros(frameSize); % Black frame
    end
    writeVideo(v, uint8(img)); % Write frame to video
end

% Close video file
close(v);
disp(['Video saved as ', videoName]);
