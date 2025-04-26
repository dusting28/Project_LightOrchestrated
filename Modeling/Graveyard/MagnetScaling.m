%% By: Dustin Goetz
clear; clc, close all;

%% Load Data
addpath("COMSOL_Data")
inductorID = "12";
filename = "MagnetSweep";
comsol_data = readmatrix(strcat("COMSOL_Data/Inductor",inductorID,"_",filename,".csv"));

diameter = comsol_data(1:2:16,2);
height = comsol_data(1:16:end,1);
force = zeros(2,length(diameter),length(height));

for iter1 = 1:length(diameter)
    force(1,iter1,:) = 1000*comsol_data(iter1*2-1:16:end,4)';
    force(2,iter1,:) = 1000*comsol_data(iter1*2:16:end,4)';
end
hold off;

[dMesh,hMesh] = meshgrid(diameter,height);

surf(dMesh,hMesh,squeeze(force(1,:,:))')

figure;
surf(dMesh,hMesh,abs(squeeze(force(2,:,:)-force(1,:,:))'))