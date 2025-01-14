%% Dustin Goetz
clc; clear; close all;

%% Load Data
addpath("Data")
inductorIDs = ["11","12","03"];
movingMass = ["BigMagnet", "BigMagnet","Magnet"];

inductorData = cell(1,3);
for iter1 = 1:length(inductorIDs)
    inductorData{iter1} = load(strcat("Data/Inductor",inductorIDs(iter1),"_",movingMass(iter1),".mat"));
end

x = (0:inductorData{1}.ForceData.numMeasurements-1)*inductorData{1}.ForceData.spacing;
fs = inductorData{1}.ForceData.fs;

coilForce = zeros(length(inductorIDs),length(x));

for iter1 = 1:length(inductorIDs)
    for iter2 = 1:length(x)
        negativeForce = mean(inductorData{iter1}.ForceData.measurements{iter2,2}(end-fs:end));
        positiveForce = mean(inductorData{iter1}.ForceData.measurements{iter2,3}(end-fs:end));
        coilForce(iter1,iter2) = (positiveForce-negativeForce)/2;
    end
end

figure;
plot(x(9:end),coilForce(1,9:end),'r')
hold on;
plot(x,coilForce(2,:),'b')
hold on;
plot(x,-coilForce(3,:),'g')
hold off;
ylabel("Force (mN)")
xlabel("Distance from Magnet (mm)")
legend("11","12","03")