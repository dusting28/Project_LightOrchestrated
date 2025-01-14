%% By: Dustin Goetz
clear; clc, close all;

%% Load Data
addpath("COMSOL_Data")
inductorID = "12";
movingMass = "MediumMagnet";
comsol_data = readmatrix(strcat("COMSOL_Data/Inductor",inductorID,"_",movingMass,".csv"));

current = comsol_data(1:3,2);
location = comsol_data(1:3:end,1);
force = zeros(length(current),length(location));

color = ["b","k","r"];
figure;
for iter1 = 1:3
    force(iter1,:) = 1000*comsol_data(iter1:3:end,3)';
    plot(location(2:end), force(iter1,2:end),strcat(color(iter1),"."))
    hold on;
end
hold off;

figure;
plot(location(2:end), (force(3,2:end)-force(1,2:end))/2)