%% Dustin Goetz
clc; clear; close all;

calibration_image = load("calibration_img.mat");

% Load the calibration image
I = imrotate(calibration_image.img,270); 


iptsetpref('ImshowAxesVisible', 'on');  % Ensure axes show up
hFig = figure('Name', 'Calibration Grid', ...
              'Units', 'normalized', ...
              'Position', [0.1 0.1 0.8 0.8]);  % large figure

% Display image
hIm = imshow(I, 'InitialMagnification', 'fit');  % zoom in initially

% Make it scrollable
hPanel = imscrollpanel(hFig, hIm);
set(hPanel, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

api = iptgetapi(hPanel);
pause(0.1);  % brief pause to ensure scroll panel is rendered
imageSize = size(I);  % [rows, cols, ...]
api.setVisibleLocation([1, imageSize(1)]);  % [X, Y] → bottom-left

% Enable pixel info display and data cursor
impixelinfo(hIm);
hold on;

% Define physical grid parameters
numRows = 5;              % vertical direction (top to bottom)
numCols = 2;              % horizontal direction (left to right)
xSize = 15; 
ySize = 5;           % cm spacing

worldPoints = zeros(numRows * numCols, 2);
imagePoints = zeros(numRows * numCols, 2);

pointIdx = 1;

for row = 0:numRows-1      % Y increases downwards
    for col = 0:numCols-1  % X increases left to right
        % Physical coordinates
        physX = col * xSize;
        physY = row * ySize;
        worldPoints(pointIdx, :) = [physX, physY];

        % Prompt user
        fprintf('Click point %d at physical location (%.1f mm, %.1f mm)\n', ...
                pointIdx, physX, physY);
        
        % On-image instruction
        txt = text(10, 20, ...
            sprintf('Click on (%.1f mm, %.1f mm)', physX, physY), ...
            'Color', 'y', 'FontSize', 14, 'BackgroundColor', 'k');
        
        % Wait for user click
        [x, y] = ginput(1);
        imagePoints(pointIdx, :) = [x, y];

        % Mark the clicked point
        plot(x, y, 'ro');
        text(x + 5, y, sprintf('%d', pointIdx), 'Color', 'r');

        % Cleanup
        delete(txt);
        pointIdx = pointIdx + 1;
    end
end

% Fit projective transform
tform = fitgeotrans(imagePoints, worldPoints, 'projective');

% Save the mapping
save('image_to_physical_mapping.mat', 'tform', 'imagePoints', 'worldPoints');