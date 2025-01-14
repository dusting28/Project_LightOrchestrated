%% Dustin Goetz
clc; clear; close all;

%% Load Data
addpath("Measurements/Data")
addpath("COMSOL/COMSOL_Data")
inductorID = "11";
movingMass = "BigMagnet";
load(strcat("Measurements/Data/Inductor",inductorID,"_",movingMass,".mat"))
comsol_data = readmatrix(strcat("COMSOL/COMSOL_Data/Inductor",inductorID,"_",movingMass,".csv"));

current = comsol_data(1:3,2);
location = comsol_data(1:3:end,1);
force = zeros(length(current),length(location));
for iter1 = 1:3
    force(iter1,:) = 1000*comsol_data(iter1:3:end,3)';
end

x = (0:ForceData.numMeasurements-1)*ForceData.spacing;

stable_voltage = zeros(ForceData.numMeasurements,3);
for iter1 = 1:ForceData.numMeasurements
    for iter2 = 1:3
        stable_voltage(iter1,iter2) = mean(ForceData.measurements{iter1,iter2}(end-10000:end));
    end
end

figure;
subplot(2,1,1)
plot(x(9:end),-stable_voltage(9:end,1))
hold on;
plot(location(2:end), force(2,2:end))
hold off;
ylim([0,5500])
ylabel("Force (mN)")
xlabel("Distance from Magnet (mm)")
title("Magnet-Core Interaction")
legend("Measurement","COMSOL")

subplot(2,1,2)
coil_force = -(stable_voltage(:,2) - stable_voltage(:,3))/2;
plot(x(9:end),coil_force(9:end))
hold on;
plot(location(2:end), (force(3,2:end)-force(1,2:end))/2)
hold off;
ylim([0,220])
ylabel("Force (mN)")
xlabel("Distance from Magnet (mm)")
title("Magnet-Coil Interaction")
legend("Measurement","COMSOL")
