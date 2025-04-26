%% By: Dustin Goetz
clear; clc, close all;
addpath("Elastic_Measurement_Data")

% Plot Data
load("Elastomer_CompressionTest.mat")

x = (0:ForceData.numMeasurements-1)*ForceData.spacing;
force = zeros(length(x),1);
for iter1 = 1:length(x)
    force(iter1) = mean(ForceData.measurements{iter1});
end

plot(x,force);