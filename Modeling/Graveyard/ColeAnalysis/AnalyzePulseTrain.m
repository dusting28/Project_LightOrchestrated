%%
% By Dustin Goetz
clc; clear; close all;

%% Load Data
pulseSpacing = 100;
pulsedData = readmatrix(strcat(num2str(pulseSpacing),"msSpacing.csv"));

%% Plot Data
figure;
plot(pulsedData(:,1), pulsedData(:,3)-273);
title(strcat("Pulse Train with ", num2str(pulseSpacing), " ms Spacing"));
ylabel("Temperature (C)");
xlabel("Time (s)")

