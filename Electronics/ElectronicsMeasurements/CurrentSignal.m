clc; clear; close all;

filename = "Inductor_20VPulse.csv";

voltage = readmatrix(filename);

figure;
plot(voltage(:,11)-voltage(:,23));

