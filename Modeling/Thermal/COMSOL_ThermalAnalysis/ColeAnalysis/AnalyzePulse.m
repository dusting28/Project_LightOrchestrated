%%
% By Dustin Goetz
clc; clear; close all;

%% Load Data
pulse_20V = readmatrix("750pulse20.csv");
pulse_24V = readmatrix("750pulse24.csv");

%% Plot Data
figure;
plot(pulse_20V(:,1), pulse_20V(:,3)-273);
hold on;
plot(pulse_24V(:,1), pulse_24V(:,3)-273);
ylabel("Temperature (C)");
xlabel("Time (s)")

