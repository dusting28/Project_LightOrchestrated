%% Dustin Goetz
clear; clc; close all;


%% Read Video Frames

% Load video
videoFile = 'Thermocouple_HeatSink.MOV';
vid = VideoReader(videoFile);

% Initialize outputs
timestamps = [];
readings = {};

roiRect = [260, 520, 480, 320];  % Modify this

% Select timesteps
startTime = 1;
stopTime = 63;
stepTime = 1;

times = startTime:stepTime:stopTime;
for t = times 
    vid.CurrentTime = t;
    frame = readFrame(vid);

    % Crop to the number display area
    croppedFrame = fliplr(flipud(imcrop(frame, roiRect)));
    
    % Preprocess: grayscale and enhance
    grayFrame = rgb2gray(croppedFrame);
    enhancedFrame = imadjust(grayFrame);
    
    % Run OCR with digit and decimal point filtering
    ocrResult = ocr(enhancedFrame, 'CharacterSet', '0123456789', 'TextLayout', 'Word');
    
    % Clean and extract numeric text
    rawText = strtrim(ocrResult.Text);
    if strlength(rawText) > 3
        rawText = extractBefore(rawText, 4);  % Keep only first 3 characters
    end
    readings{end+1} = rawText; 

    figure(1);
    imshow(enhancedFrame);
    title(rawText)

    clc
    userInput = input('Correct value if needed: ', 's');  % Always read as string
    if ~isempty(userInput)
        readings{end} = userInput;  % Convert to number
    end
end

save('ThermocoupleData_HeatSink.mat', 'times', 'readings');