%% Dustin Goetz
clc; clear; close all;

%% Load Data
addpath("Data")
inductorID = "12";
movingMass = "MediumMagnet";
load(strcat("Data/Inductor",inductorID,"_",movingMass,".mat"))

x = (0:ForceData.numMeasurements-1)*ForceData.spacing;

stable_voltage = zeros(ForceData.numMeasurements,3);
for iter1 = 1:ForceData.numMeasurements
    for iter2 = 1:3
        stable_voltage(iter1,iter2) = mean(ForceData.measurements{iter1,iter2}(end-10000:end));
    end
end

color = ["k","b","r"];
figure;
for iter1 = 1:3
    signal = lowpass(-ForceData.measurements{2,iter1},.1,ForceData.fs,Steepness=0.95);
    signal = movmean(signal,1000);
    plot(signal,color(iter1))
    hold on;
end
hold off;

figure;
for iter1 = 1:3
    plot(x,-stable_voltage(:,iter1),strcat(color(iter1),"."))
    hold on;
end
hold off;

%% Effect sizes
thermal_effect = -stable_voltage(:,1) + (stable_voltage(:,2)+stable_voltage(:,3))/2;
polarity_effect = (stable_voltage(:,2) - stable_voltage(:,3))/2;

figure;
plot(x,thermal_effect)
hold on;
plot(x,polarity_effect)