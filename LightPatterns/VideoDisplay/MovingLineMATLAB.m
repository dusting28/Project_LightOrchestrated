%% Dustin Goetz
clc; clear; close all;
addpath("GUI_Functions\")

%% Pixel Information
screens = get(0, 'MonitorPositions');
monitorID = 2;  % Adjust as needed
figPos = screens(monitorID, :); 

figureHandle = figure(1);
set(figureHandle, ... 
    'Color', 'k', ...
    'MenuBar', 'none', ...
    'ToolBar', 'none', ...
    'NumberTitle', 'off', ...
    'Position', figPos, ...
    'Units', 'pixels');

ax = axes('Parent', figureHandle, ...
          'Position', [0 0 1 1], ...
          'Color', 'k', ...
          'XColor', 'none', ...
          'YColor', 'none');
axis(ax, 'off');
hold(ax, 'on');
xlim(ax, [0 figPos(3)]);
ylim(ax, [0 figPos(4)]);
axis(ax, 'manual');

drawnow;

input("Turn On Power Supply and Press Enter:")

%% Loop Through Pixels
line_width = 43;
for iter1 = 1:100
    % Draw current rectangle
    cla(ax);  % Clear previous
    linePos = [iter1*line_width, 0, 35.84, 1500];
    rectangle('Parent', ax, 'Position', linePos, 'FaceColor', 'w', 'EdgeColor', 'none');
    pause(.02);
end