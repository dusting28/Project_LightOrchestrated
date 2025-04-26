%% By: Dustin Goetz
clear; clc, close all;

%% Load Data
addpath("COMSOL_Data")
inductorID = "12";
filename = "CurrentSweep";
comsol_data = readmatrix(strcat("COMSOL_Data/Inductor",inductorID,"_",filename,".csv"));

current = -comsol_data(:,1);
force = -comsol_data(:,2);

coil_force = 1000*(force-force(1));

linear_model = current*25;

figure;
plot(current,coil_force);
hold on;
plot(current, linear_model);
ylabel("Force (mN)")
xlabel("Current (A)")
title("Magnet-Coil Interaction")
legend("COMSOL","F_{coil} = 25I")
