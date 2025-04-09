clc; clear; close all;

filename = "Inductor_20VPulse_NewMOSFET.csv";
voltage = readmatrix(filename);
t = (1:length(voltage))/length(voltage);

figure;
plot(t,20-voltage(:,11));
hold on;


filename = "Inductor_20VPulse.csv";
voltage = readmatrix(filename);
t = (1:length(voltage))/length(voltage);

figure;
plot(t,20-voltage(:,11));
hold off;