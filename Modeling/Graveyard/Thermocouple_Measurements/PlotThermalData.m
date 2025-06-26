%% Dustin Goetz
clc; clear; close all;

%% Read data
noHeatSinkData = load("ThermocoupleData_NoHeatSink.mat");

noHeatSink_t = noHeatSinkData.times;
noHeatSink_temp = zeros(length(noHeatSink_t),1);
for iter1 = 1:length(noHeatSink_t)
    noHeatSink_temp(iter1) = str2double(noHeatSinkData.readings(iter1))/10;
end

heatSinkData = load("ThermocoupleData_HeatSink.mat");

heatSink_t = heatSinkData.times;
heatSink_temp = zeros(length(heatSink_t),1);
for iter1 = 1:length(heatSink_t)
    heatSink_temp(iter1) = str2double(heatSinkData.readings(iter1))/10;
end

%% Plot Data

figure;
plot(noHeatSink_t,noHeatSink_temp)
hold on;
plot(heatSink_t,heatSink_temp)


%% Fit exponential curve
idx1 = 33:250;  % No heat sink
idx2 = 11:40;   % With heat sink

y1 = log(noHeatSink_temp(idx1) - noHeatSink_temp(1));
t1 = noHeatSink_t(idx1);  % Zero-based time for fit

y2 = log(heatSink_temp(idx2) - heatSink_temp(1));
t2 = heatSink_t(idx2);

p1 = polyfit(t1, y1, 1);  % [slope, intercept]
p2 = polyfit(t2, y2, 1);

tau1 = -1 / p1(1);
tau2 = -1 / p2(1);

figure;
plot(t1, y1, 'b.'); hold on;
plot(t1, polyval(p1, t1), 'b-', 'DisplayName', ['No Heat Sink, \tau = ' num2str(tau1,3) ' s']);
plot(t2, y2, 'r.');
plot(t2, polyval(p2, t2), 'r-', 'DisplayName', ['Heat Sink, \tau = ' num2str(tau2,3) ' s']);
legend; xlabel('Time (s)'); ylabel('ln(\DeltaT)');
title('Log-Linear Fit to Extract Time Constant');


