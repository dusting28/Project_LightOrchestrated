%% By: Dustin Goetz
clear; clc, close all;
addpath("Electromagnetic/COMSOL/EM_COMSOL_Data")
addpath("Electromagnetic/Measurements/EM_Measurement_Data")
addpath("ElasticMember/Elastic_COMSOL_Data")
addpath("ElasticMember/Elastic_Measurement_Data")

%% Filenames
COMSOL_EM = "LightTouch_Unshielded_CurrentSweep";
Measured_EM = "LightTouch_PulsedEMData";
COMSOL_Elastic = "CompressionTest_Ecoflex10_1.5mm";
Measured_Elastic = "Elastomer_1.5mm_CompressionTest";

%% Stroke
x_spacing = 0.05;
x = 1:x_spacing:6;
elasticHeight = 1.5;

%% EM Forces
EM_COMSOL_Data = readmatrix(strcat("Electromagnetic/COMSOL/EM_COMSOL_Data/",COMSOL_EM,".csv"));
numCurrent = 78;
off_idx = numCurrent;
on_idx = 1;
EM_x = EM_COMSOL_Data(1:numCurrent:end,1);
COMSOL_core_force = 1000*EM_COMSOL_Data(off_idx:numCurrent:end,3)';
COMSOL_core_force = interp1(EM_x,COMSOL_core_force,x);
COMSOL_coil_force = 1000*EM_COMSOL_Data(on_idx:numCurrent:end,3)' - 1000*EM_COMSOL_Data(off_idx:numCurrent:end,3)';
COMSOL_coil_force = interp1(EM_x,COMSOL_coil_force,x);


EM_Measured_Data = load(strcat("Electromagnetic/Measurements/EM_Measurement_Data/",Measured_EM,".mat"));
EM_x = (0:EM_Measured_Data.ForceData.numMeasurements-1)*EM_Measured_Data.ForceData.spacing;
Measured_coil_force = zeros(length(EM_x),1);
Measured_core_force = zeros(length(EM_x),1);
for iter2 = 1:size(EM_Measured_Data.ForceData.measurements,1)
    initialForce = median(EM_Measured_Data.ForceData.measurements{iter2,1}(1:5000));
    maxForce = max(EM_Measured_Data.ForceData.measurements{iter2,1}(10005:10165));
    minForce = min(EM_Measured_Data.ForceData.measurements{iter2,1}(10005:10165));
    Measured_core_force(iter2) = initialForce;
    Measured_coil_force(iter2) = (maxForce+minForce)/2-initialForce;
end
Measured_core_force = interp1(EM_x,Measured_core_force,x);
Measured_coil_force = interp1(EM_x,Measured_coil_force,x);

%% Spring Force
elastic_idx = (elasticHeight-x(1))/x_spacing + 1;
Elastic_COMSOL_Data = readmatrix(strcat("ElasticMember/Elastic_COMSOL_Data/",COMSOL_Elastic,".csv"));
COMSOL_elastic_force = [-1000*flipud(Elastic_COMSOL_Data(1:elastic_idx,2));zeros(length(x)-elastic_idx,1)]';

Elastic_Measurement_Data = load(strcat("ElasticMember/Elastic_Measurement_Data/",Measured_Elastic,".mat"));
Measured_elastic_force = zeros(Elastic_Measurement_Data.ForceData.numMeasurements,1);
for iter1 = 1:length(Measured_elastic_force)
    Measured_elastic_force(iter1) = mean(Elastic_Measurement_Data.ForceData.measurements{iter1});
end
Measured_elastic_force = [flipud(Measured_elastic_force(1:elastic_idx));zeros(length(x)-elastic_idx,1)]';



%% Plot Data
grayColor = [.6 .6 .6];

figure;
plot(x,-COMSOL_core_force,'Color', grayColor);
hold on;
plot(x,-Measured_core_force,'k');
legend("COMSOL","Measured");
xlabel("Distance From Magnet to Inductor (mm)")
ylabel("Force (mN)")
title("Core-Magnet Interaction Force")

figure;
plot(x,COMSOL_coil_force,'Color', grayColor);
hold on;
plot(x,Measured_coil_force,'k');
xlabel("Distance From Magnet to Inductor (mm)")
ylabel("Force (mN)")
title("Coil-Magnet Interaction Force (I = 3.85 A)")

figure;
plot(x,COMSOL_elastic_force,'Color', grayColor);
hold on;
plot(x,Measured_elastic_force,'k');
xlabel("Distance From Magnet to Inductor (mm)")
ylabel("Force (mN)")
title("Elastic Compression Force")

