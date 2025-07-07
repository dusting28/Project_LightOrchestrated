%% By: Dustin Goetz
clear; clc, close all;
addpath("EM_COMSOL_Data")


%% Static Forces
numCurrent = 47;
off_idx = 1;
on_idx = numCurrent;

comsol_data = readmatrix("EM_COMSOL_Data/LightTouch_Unshielded_CurrentSweep.csv");

x1 = comsol_data(1:numCurrent:end,1)';
core_force_1 = 1000*comsol_data(off_idx:numCurrent:end,3)';
coil_force_1 = 1000*comsol_data(on_idx:numCurrent:end,3)' - 1000*comsol_data(off_idx:numCurrent:end,3)';

comsol_data = readmatrix("EM_COMSOL_Data/LightTouch_Shielded_CurrentSweep.csv");

x2 = comsol_data(1:numCurrent:end,1)';
core_force_2 = 1000*comsol_data(off_idx:numCurrent:end,3)';
coil_force_2 = 1000*comsol_data(on_idx:numCurrent:end,3)' - 1000*comsol_data(off_idx:numCurrent:end,3)';

Shield_Data = readmatrix("Electromagnetic/COMSOL/EM_COMSOL_Data/LightTouch_ShieldOnly.csv");
shield_force = 1000*Shield_Data(:,2)';
%%

figure;
plot(x1(2:end),core_force_1(2:end));
hold on;
plot(x1(2:end),coil_force_1(2:end));

figure;
plot(x2(2:end),core_force_2(2:end));
hold on;
plot(x2(2:end),coil_force_2(2:end));

figure;
plot(x1(2:end),coil_force_1(2:end));
hold on;
plot(x2(2:end),coil_force_2(2:end));

figure;
plot(x1(2:end),core_force_1(2:end)+coil_force_1(2:end));
hold on;
plot(x2(2:end),core_force_1(2:end)+coil_force_1(2:end)+shield_force(2:end));
plot(x2(2:end),core_force_2(2:end)+coil_force_2(2:end));

