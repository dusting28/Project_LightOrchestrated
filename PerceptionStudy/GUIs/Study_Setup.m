%% Dustin Goetz
clc; clear; close all;

% Clean up previous video objects
imaqreset;
delete(imaqfind);

addpath("GUI_Functions\")

%% Setup Camera

% Create video input object
camFormat = 'BGR8';  % Use exact format from imaqhwinfo
vid = videoinput('gentl', 1, camFormat);
src = getselectedsource(vid);

% Set trigger mode, acquisition, exposure time, etc.
triggerconfig(vid, 'immediate');  % Use 'immediate' for debugging
vid.FramesPerTrigger = 1;
vid.TriggerRepeat = 0;
src.ExposureTime = 20000;  % in microseconds
src.Gain = 4;

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

disp("Reminder: Turn on Power Supply and Adjust Participant Number")