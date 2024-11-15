%% Dustin Goetz
clc; clear; close all;

%% Load Data
Component = "LQW15CN3R3M10D";
load(strcat(Component,".mat"))
load(strcat(Component,"_Measurements.mat"))

stable_voltage = zeros(ForceData.numMeasurements,3);
for iter1 = 1:ForceData.numMeasurements
    for iter2 = 1:3
        stable_voltage(iter1,iter2) = mean(forceData.measurements{iter1,iter2}(end-10000:end));
        hold on;
    end
    hold off
end

color = ["k","b","r"];
figure;
for iter1 = 1:3
    signal = lowpass(-forceData.measurements{2,iter1},.1,ForceData.fs,Steepness=0.95);
    signal = movmean(signal,1000);
    plot(signal,color(iter1))
    hold on;
end
hold off;

x = (1:50)*((5.4006)/50)*(150/5450);
figure;
for iter1 = 1:3
    plot(x,-stable_voltage(:,iter1),strcat(color(iter1),"."))
    hold on;
end
hold off;

%% Effect sizes
thermal_effect = -stable_voltage(:,1) + (stable_voltage(:,2)+stable_voltage(:,3))/2;
polarity_effect = -stable_voltage(:,2) + stable_voltage(:,3);

figure;
plot(thermal_effect,'.')

figure;
plot(polarity_effect,'.')

disp(median(thermal_effect./-stable_voltage(:,1)))
disp(median(polarity_effect./-stable_voltage(:,1)))