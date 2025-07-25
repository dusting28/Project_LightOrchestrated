%% Setup
clc; clear; close all;

%% Display Parameters
screens = get(0, 'MonitorPositions');
monitorID = 2;  % Adjust as needed
figPos = screens(monitorID, :); 
screenWidth = figPos(3);
screenHeight = figPos(4);

figureHandle = figure(1);
set(figureHandle, ...
    'Color', 'k', ...
    'MenuBar', 'none', ...
    'ToolBar', 'none', ...
    'NumberTitle', 'off', ...
    'Position', figPos, ...
    'Units', 'pixels', ...
    'Visible', 'off');

ax = axes('Parent', figureHandle, ...
          'Position', [0 0 1 1], ...
          'Color', 'k', ...
          'XColor', 'none', ...
          'YColor', 'none');
axis(ax, 'off');
hold(ax, 'on');
xlim(ax, [0 screenWidth]);
ylim(ax, [0 screenHeight]);
axis(ax, 'manual');

%% Video Setup
videoName = 'moving_arrow.mp4';
v = VideoWriter(videoName, 'MPEG-4');
v.FrameRate = 60;
open(v);

%% Arrow Parameters
thickness = 43;                 % Shaft and edge thickness
shaftLength = 200;              % Length of vertical shaft
headLength = 100;               % Distance from shaft top to tip
centerX = screenWidth / 2;
halfT = thickness / 2;

% Diagonal leg (45 degrees)
diagLeg = headLength / sqrt(2);

% Range of Y positions
yPositions = 0:thickness:(screenHeight - shaftLength - headLength);

for y = yPositions
    cla(ax);

    %% Shaft rectangle
    shaftLeft = centerX - halfT;
    shaftRight = centerX + halfT;
    shaftBottom = y;
    shaftTop = y + shaftLength;

    fill(ax, ...
        [shaftLeft, shaftRight, shaftRight, shaftLeft], ...
        [shaftBottom, shaftBottom, shaftTop, shaftTop], ...
        'w', 'EdgeColor', 'none');

    %% Arrow tip
    tipX = centerX;
    tipY = shaftTop + headLength;

    %% Base of diagonals (left and right)
    baseX = centerX;
    baseY = shaftTop;

    % Unit direction for 45° up-left
    dx = -diagLeg;
    dy = diagLeg;

    % Unit perpendicular for thickness
    normX = dy / headLength * halfT;
    normY = -dx / headLength * halfT;

    % Left diagonal corners
    x_left = [ ...
        baseX, ...
        baseX, ...
        baseX + dx + normX, ...
        baseX + dx - normX];

    y_left = [ ...
        baseY + thickness/2, ...
        baseY - thickness/2, ...
        baseY - dy - normY,...
        baseY - dy + normY];

    % Mirror left edge across y-axis to get right edge
    x_right = 2 * centerX - x_left;
    y_right = y_left;  % same Y-coordinates

    % Draw both diagonals
    fill(ax, x_left, y_left, 'w', 'EdgeColor', 'none');
    fill(ax, x_right, y_right, 'w', 'EdgeColor', 'none');

    drawnow;
    frame = getframe(figureHandle);
    writeVideo(v, frame);
    writeVideo(v, frame);
end

close(v);
set(figureHandle, 'Visible', 'on');
disp(['Video saved to: ', fullfile(pwd, videoName)]);
