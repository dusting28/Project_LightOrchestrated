%% Dustin Goetz
clc; clear; close all;

%% Load Data
addpath("Data")
inductorIDs = ["10","12","31","32","33","34","35"];
movingMass = "Magnet3x4";

idx = 13;

for iter1 = 1:length(inductorIDs)
    load(strcat("Data/Pulsed_Inductor",inductorIDs(iter1),"_",movingMass,".mat"))

    x = (0:ForceData.numMeasurements-1)*ForceData.spacing;
    
    coil_force = zeros(length(x),1);
    core_force = zeros(length(x),1);
    for iter2 = 1:size(ForceData.measurements,1)
        initialForce = ForceData.measurements{iter2,1}(1);
        maxForce = max(ForceData.measurements{iter2,1});
        core_force(iter2) = -initialForce;
        coil_force(iter2) = maxForce-initialForce;
    end

    
    figure;
    plot(movmean(ForceData.measurements{idx,1},50))
    title(strcat("Inductor ",num2str(inductorIDs(iter1))," - Impulse Response"))

    figure;
    plot(x,core_force);
    hold on;
    plot(x,coil_force);
    title(strcat("Inductor ",num2str(inductorIDs(iter1))," - Interaction Forces"))

end

disp(x(idx))
