%% By: Dustin Goetz
clear; clc, close all;
addpath("COMSOL_Data")


%% Static Forces
inductorID = "32";
movingMass = "Magnet3x4";
comsol_data = readmatrix(strcat("COMSOL_Data/Inductor",inductorID,"_",movingMass,".csv"));

x = comsol_data(1:3:end,1);
force = zeros(3,length(x));
for iter1 = 1:3
    force(iter1,:) = 1000*comsol_data(iter1:3:end,3)';
end

coil_force_1 = force(1,:)-force(2,:);
core_force_1 = -force(2,:);
total_force_1 = force(1,:);

inductorID = "32";
movingMass = "Magnet3x4_Design9";
comsol_data = readmatrix(strcat("COMSOL_Data/Inductor",inductorID,"_",movingMass,".csv"));

x = comsol_data(1:3:end,1);
force = zeros(3,length(x));
for iter1 = 1:3
    force(iter1,:) = 1000*comsol_data(iter1:3:end,3)';
end

coil_force_2 = force(1,:)-force(2,:);
core_force_2 = -force(2,:);
total_force_2 = force(1,:);

figure;
plot(x(2:end),core_force_1(2:end));
hold on;
plot(x(2:end),coil_force_1(2:end));

figure;
plot(x(2:end),core_force_2(2:end));
hold on;
plot(x(2:end),coil_force_2(2:end));

figure;
plot(x(2:end),coil_force_1(2:end));
hold on;
plot(x(2:end),coil_force_2(2:end));

figure;
plot(x(2:end),total_force_1(2:end));
hold on;
plot(x(2:end),total_force_2(2:end));
