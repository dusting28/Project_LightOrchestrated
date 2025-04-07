clc; clear; close all;

filename = "Inductor_20VPulse_v2.csv";

voltage = readmatrix(filename);

% figure;
% plot(voltage(:,11)-voltage(:,23));

figure;
plot(20-voltage(:,11));

hold on;

filename = "Inductor_20VPulse.csv";

voltage = readmatrix(filename);
plot(20-voltage(:,11));