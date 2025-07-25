%% Setup
clc; clear; close all;

%% Display Parameters
screens = get(0, 'MonitorPositions');
monitorID = 2;  % Change if needed
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
videoName = 'spiraling_circle.mp4';
v = VideoWriter(videoName, 'MPEG-4');
v.FrameRate = 60;
open(v);

%% Motion Parameters
circleRadius = 50;         % Radius of the visible circle
orbitRadius = 200;         % Radius of the circular orbit path
nCirclePoints = 100;       % Circle smoothness
nFrames = 300;             % Total frames
centerY = screenHeight / 2;
driftStartX = -orbitRadius;  % Off-screen start
driftEndX = screenWidth + orbitRadius;

% Horizontal drift over time
x_center_path = linspace(driftStartX, driftEndX, nFrames);

for i = 1:nFrames
    cla(ax);

    % Angle for circular orbit (faster rotation)
    theta_orbit = 2 * pi * (i / 20);  % 1 full orbit per second at 60 fps

    % Drifted center of orbit
    centerX = x_center_path(i);

    % Current circle center (moving in orbit)
    x_c = centerX + orbitRadius * cos(theta_orbit);
    y_c = centerY + orbitRadius * sin(theta_orbit);

    % Circle outline
    theta = linspace(0, 2*pi, nCirclePoints);
    x_circle = x_c + circleRadius * cos(theta);
    y_circle = y_c + circleRadius * sin(theta);

    % Draw circle
    fill(ax, x_circle, y_circle, 'w', 'EdgeColor', 'none');

    drawnow;
    frame = getframe(figureHandle);
    writeVideo(v, frame);
end

close(v);
set(figureHandle, 'Visible', 'on');
disp(['Video saved to: ', fullfile(pwd, videoName)]);