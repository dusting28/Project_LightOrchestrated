%% By: Dustin Goetz
clear; clc, close all;

%% Load Data
addpath("COMSOL_Data")
membraneID = "1";
comsol_data = readmatrix(strcat("COMSOL_Data/Membrane",membraneID,"_SpringData.csv"));

force = comsol_data(:,2);
displacement = comsol_data(:,1);

figure;
plot(displacement,1000*force)