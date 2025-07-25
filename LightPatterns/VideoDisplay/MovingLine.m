%% Setup
clc; clear; close all;

%% Display Parameters
screens = get(0, 'MonitorPositions');
monitorID = 2;  % Adjust for your external screen
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
    'Visible', 'off');  % Hide while rendering video

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
videoName = 'moving_line_60fps.mp4';
v = VideoWriter(videoName, 'MPEG-4');
v.FrameRate = 60;
open(v);

%% Render Frames
lineWidth = 43;
lineHeight = screenHeight;
lineXPositions = 0:lineWidth:(screenWidth - lineWidth);

for x = lineXPositions
    cla(ax);  % Clear previous line
    rectangle('Parent', ax, ...
              'Position', [x, 0, lineWidth, lineHeight], ...
              'FaceColor', 'w', ...
              'EdgeColor', 'none');
    drawnow;
    frame = getframe(figureHandle);
    writeVideo(v, frame);
    writeVideo(v, frame);
end

close(v);
set(figureHandle, 'Visible', 'on');  % Show after rendering
disp(['Video saved to: ', fullfile(pwd, videoName)]);