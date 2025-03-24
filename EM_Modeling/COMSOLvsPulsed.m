%% Dustin Goetz
clc; clear; close all;

%%
addpath("Measurements/Data")
addpath("COMSOL/COMSOL_Data")

inductorID = "32";
movingMass = "Magnet3x4";

%% Load Measurement Data

load(strcat("Measurements/Data/PulsedBig_Inductor",inductorID,"_",movingMass,".mat"))
measurement_data = ForceData;

x_measurement = (0:measurement_data.numMeasurements-1)*measurement_data.spacing;
    
coil_force = zeros(length(x_measurement),1);
core_force = zeros(length(x_measurement),1);
total_force = zeros(length(x_measurement),1);
for iter2 = 1:size(measurement_data.measurements,1)
    initialForce = median(measurement_data.measurements{iter2,1}(1:5000));
    maxForce = max(measurement_data.measurements{iter2,1}(10005:10165));
    minForce = min(measurement_data.measurements{iter2,1}(10005:10165));
    total_force(iter2) = (maxForce+minForce)/2;
    core_force(iter2) = -initialForce;
    coil_force(iter2) = total_force(iter2)-initialForce;
end

%% Load COMSOL Data
comsol_data = readmatrix(strcat("COMSOL/COMSOL_Data/Inductor",inductorID,"_",movingMass,"_Shielded.csv"));

current = comsol_data(1:3,2);
x_comsol = comsol_data(1:3:end,1);
force = zeros(length(current),length(x_comsol));
for iter1 = 1:3
    force(iter1,:) = -1000*comsol_data(iter1:3:end,3)';
end

%% Plot 
figure;
plot(x_measurement(2:end),core_force(2:end));
hold on;
plot(x_measurement(2:end),coil_force(2:end));
title("Inductor 32 - Measurements")

figure;
plot(x_comsol(2:end), force(2,2:end))
hold on;
plot(x_comsol(2:end), force(2,2:end)-force(1,2:end))
title("Inductor 32 - COMSOL")
