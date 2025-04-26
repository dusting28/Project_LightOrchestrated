%% By: Dustin Goetz
clear; clc, close all;
addpath("Electromagnetic/COMSOL/EM_COMSOL_Data")
addpath("Electromagnetic/Measurements/EM_Measurement_Data")
addpath("ElasticMember/Elastic_COMSOL_Data")
addpath("ElasticMember/Elastic_Measurement_Data")

%% Options
EM_Data = "COMSOL";
% EM_Data = "Measured";

% Elastic_Data = "COMSOL";
Elastic_Data = "Measured";

%% Stroke
x_spacing = 0.05;
x = 0.5:x_spacing:6;
heatSink_height = 3.175;
tactorHeight = 3.175;
x_finger = 12.7+1+heatSink_height-4.8-4-tactorHeight;

%% EM Forces
if EM_Data == "COMSOL"
    EM_COMSOL_Data = readmatrix("Electromagnetic/COMSOL/EM_COMSOL_Data/LightTouch_Shielded.csv");
    EM_x = EM_COMSOL_Data(1:3:end,1);
    core_force = 1000*EM_COMSOL_Data(2:3:end,3)';
    core_force = interp1(EM_x,core_force,x);
    coil_force = 1000*EM_COMSOL_Data(1:3:end,3)' - 1000*EM_COMSOL_Data(2:3:end,3)';
    coil_force = interp1(EM_x,coil_force,x);
elseif EM_Data == "Measured"
end

%% Spring Force
if Elastic_Data == "COMSOL"
    elastic_force = zeros(1,length(x));
elseif Elastic_Data == "Measured"
    Elastic_Measurement_Data = load("ElasticMember/Elastic_Measurement_Data/Elastomer_CompressionTest.mat");
    elastic_force = zeros(Elastic_Measurement_Data.ForceData.numMeasurements,1);
    for iter1 = 1:size(elastic_force,1)
        elastic_force(iter1) = mean(Elastic_Measurement_Data.ForceData.measurements{iter1});
    end
    elastic_force = [flipud(elastic_force(1:41));zeros(length(x)-41,1)]';
end

%% Finger Force
k_finger = (10^5)*(10^-6)*(pi*(2/2)^2)/(5*10^-3); 
finger_force = (x_finger-x)*k_finger;
finger_force = min(finger_force,0);

%% Moving Mass
magnetDiam = 3; %mm
magnetHeight = 4; %mm
magnetDensity = 7; %g/cm^3
magnetMass = magnetDensity*(10^(-6))*((magnetDiam/2)^2)*pi*magnetHeight; % g

tactorDiam = 1.5875; % mm
tactorDensity = 1.41; % g/cm^3
tactorMass = tactorDensity*(10^(-6))*((tactorDiam/2)^2)*pi*tactorHeight; % g
moving_mass = magnetMass + tactorMass;
gravity_force = -1000*9.81*moving_mass;

off_force = elastic_force+finger_force+core_force+gravity_force;
on_force = elastic_force+finger_force+coil_force+core_force+gravity_force;

%% Equilibria Points
idx_1 = find(diff(sign(off_force)));
idx_2 = find(diff(sign(on_force)));

if length(idx_2)>1
    idx_1 = idx_2(1);
    idx_2 = idx_2(2);
end

%% Plot Data
figure;
plot(x,coil_force);
hold on;
plot(x,core_force);
plot(x,elastic_force);
plot(x,finger_force);
plot(x,gravity_force);
hold off;
xlim([x(1),x(end)]);
legend(["F_{coil}","F_{core}","F_{elastic}","F_{finger}","F_g"])
title("Static Forces")
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")

figure;
plot(x,off_force);
hold on;
plot(x,on_force);
xline(x(idx_1))
xline(x(idx_2))
hold off;
xlim([x(1),x(end)]);
legend(["Up Stroke","Down Stroke"])
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")


sum(on_force(idx_1:idx_2)*x_spacing/1000)
sum(off_force(idx_1:idx_2)*x_spacing/1000)
