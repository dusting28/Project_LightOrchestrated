% Set parameters
fps = 60;           % Frames per second
duration = 2;       % Duration in seconds (1-second loop)
numFrames = fps * duration;
frameSize = [1080, 1920]; % Resolution (height, width)
numReps = 40;
deltaPixel = 3;

% Create video writer object
videoName = 'flashing_video.avi';
v = VideoWriter('flashing_video.avi', 'Motion JPEG AVI');  
v.FrameRate = fps;
open(v);

% Generate frames
for iter1 = 1:numReps
    for frame = 1:numFrames
        if frame == numFrames-1 % Only the last frame is white
            img = ones(frameSize) * (255-(iter1-1)*deltaPixel); % White frame
        else
            img = zeros(frameSize); % Black frame
        end
        writeVideo(v, uint8(img)); % Write frame to video
    end
end

% Close video file
close(v);
disp(['Video saved as ', videoName]);
