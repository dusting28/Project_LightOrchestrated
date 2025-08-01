% Set parameters
fps = 144;           % Frames per second
duration = 4;       % Duration in seconds (1-second loop)
numFrames = fps * duration;
whiteFrames = 3;
frameSize = [1080, 1920]; % Resolution (height, width)
numReps = 40;
deltaPixel = 3;

% Create video writer object
videoName = 'DecreasingPulses_144Hz.avi';
v = VideoWriter('flashing_video.avi', 'Motion JPEG AVI');  
v.FrameRate = fps;
open(v);

% Generate frames
for iter1 = 1:numReps
    for frame = 1:numFrames
        if and((frame <= numFrames-1),(frame >= numFrames-whiteFrames))  % Only the last frame is white
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

system('"C:\Program Files\VideoLAN\VLC\vlc.exe" flashing_video.avi --fullscreen --qt-fullscreen-screennumber=2 --play-and-exit');
