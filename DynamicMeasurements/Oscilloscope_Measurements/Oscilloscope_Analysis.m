clc; clear; close all;

div_width = .01; %s

filename = "Inductor_LEDDriven_100nFGate.csv";
voltage = readmatrix(filename);
t = (1:length(voltage))*10*div_width/length(voltage);

figure;
plot(t,voltage(:,11));
hold on;

filename = "Inductor_LEDDriven_470ohmGate.csv";
voltage = readmatrix(filename);
t = (1:length(voltage))*10*div_width/length(voltage);

plot(t,voltage(:,11));

filename = "Inductor_DAQDriven_100nFGate.csv";
voltage = readmatrix(filename);
t = (1:length(voltage))*10*div_width/length(voltage);

plot(t,voltage(:,11));


filename = "Inductor_DAQDriven_470ohmGate.csv";
voltage = readmatrix(filename);
t = (1:length(voltage))*10*div_width/length(voltage);

plot(t,voltage(:,11));
hold off;