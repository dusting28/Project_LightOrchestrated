%% Dustin Goetz
clc; clear; close all;

%% Inductor 32 - 20 V

load("Data/PulsedBig_Inductor32_Magnet3x4.mat")

x = (0:ForceData.numMeasurements-1)*ForceData.spacing;
    
coil_force = zeros(length(x),1);
core_force = zeros(length(x),1);
total_force = zeros(length(x),1);
for iter2 = 1:size(ForceData.measurements,1)
    initialForce = median(ForceData.measurements{iter2,1}(1:5000));
    maxForce = max(ForceData.measurements{iter2,1}(10005:10165));
    minForce = min(ForceData.measurements{iter2,1}(10005:10165));
    total_force(iter2) = (maxForce+minForce)/2;
    core_force(iter2) = -initialForce;
    coil_force(iter2) = total_force(iter2)-initialForce;
end


figure;
plot(movmean(ForceData.measurements{1,1},1))
title("Inductor 32 - Impulse Response")

figure;
plot(x,core_force);
hold on;
plot(x,coil_force);
title("Inductor 32 - Interaction Forces")

figure;
plot(x,total_force);
title("Inductor 32 - Accumulated Force")
