%% By: Dustin Goetz
clear; clc, close all;
addpath("Electromagnetic/COMSOL/EM_COMSOL_Data")
addpath("Electromagnetic/Measurements/EM_Measurement_Data")
addpath("ElasticMember/Elastic_COMSOL_Data")
addpath("ElasticMember/Elastic_Measurement_Data")

%% Options
EM_Data = "COMSOL";
% EM_Data = "Measured";

% Elastic_Data = "Rigid";
Elastic_Data = "COMSOL";
% Elastic_Data = "Measured";

%% Stroke
x_spacing = 0.05;
x = 1:x_spacing:6;
heatSink_height = 14.7;
tactorHeight = 3.175;
elasticHeight = 1.5;
x_finger = heatSink_height+1-4.8-4-tactorHeight;
x_stop = heatSink_height-4.8-4;

%% EM Forces
if EM_Data == "COMSOL"
    EM_COMSOL_Data = readmatrix("Electromagnetic/COMSOL/EM_COMSOL_Data/LightTouch_Unshielded_CurrentSweep.csv");
    numCurrent = 78;
    off_idx = numCurrent;
    on_idx = 1;
    EM_x = EM_COMSOL_Data(1:numCurrent:end,1);
    core_force = 1000*EM_COMSOL_Data(off_idx:numCurrent:end,3)';
    core_force = interp1(EM_x,core_force,x);
    coil_force = 1000*EM_COMSOL_Data(on_idx:numCurrent:end,3)' - 1000*EM_COMSOL_Data(off_idx:numCurrent:end,3)';
    coil_force = interp1(EM_x,coil_force,x);
elseif EM_Data == "Measured"
    EM_Measured_Data = load("Electromagnetic/Measurements/EM_Measurement_Data/LightTouch_PulsedEMData.mat");
    EM_x = (0:EM_Measured_Data.ForceData.numMeasurements-1)*EM_Measured_Data.ForceData.spacing;
    coil_force = zeros(length(EM_x),1);
    core_force = zeros(length(EM_x),1);
    for iter2 = 1:size(EM_Measured_Data.ForceData.measurements,1)
        initialForce = median(EM_Measured_Data.ForceData.measurements{iter2,1}(1:5000));
        maxForce = max(EM_Measured_Data.ForceData.measurements{iter2,1}(10005:10165));
        minForce = min(EM_Measured_Data.ForceData.measurements{iter2,1}(10005:10165));
        core_force(iter2) = initialForce;
        coil_force(iter2) = (maxForce+minForce)/2-initialForce;
    end
    core_force = interp1(EM_x,core_force,x);
    coil_force = interp1(EM_x,coil_force,x);
end

%% Spring Force
elastic_idx = (elasticHeight-x(1))/x_spacing + 1;
if Elastic_Data == "Rigid"
    elastic_force = zeros(1,length(x));
    elastic_force(1:elastic_idx-1) = -core_force(1:elastic_idx-1);
elseif Elastic_Data == "COMSOL"
    Elastic_COMSOL_Data = readmatrix("ElasticMember/Elastic_COMSOL_Data/CompressionTest_Ecoflex10_1.5mm.csv");
    elastic_force = [-1000*flipud(Elastic_COMSOL_Data(1:elastic_idx,2));zeros(length(x)-elastic_idx,1)]';
elseif Elastic_Data == "Measured"
    Elastic_Measurement_Data = load("ElasticMember/Elastic_Measurement_Data/Elastomer_1.5mm_CompressionTest.mat");
    elastic_force = zeros(Elastic_Measurement_Data.ForceData.numMeasurements,1);
    for iter1 = 1:length(elastic_force)
        elastic_force(iter1) = mean(Elastic_Measurement_Data.ForceData.measurements{iter1});
    end
    elastic_force = [flipud(elastic_force(1:elastic_idx));zeros(length(x)-elastic_idx,1)]';
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
gravity_force = -9.81*moving_mass; % mN

off_force = elastic_force+finger_force+core_force+gravity_force;
on_force = elastic_force+finger_force+coil_force+core_force+gravity_force;

%% Equilibria Points
idx_1 = find(diff(sign(off_force)));
idx_2 = find(diff(sign(on_force)));

if length(idx_2)>1
    idx_1 = idx_2(1);
    idx_2 = idx_2(2);
end

% idx_1 = 16;
% idx_2 = 38;

%% Dynamic Modeling
dt = 1/1000000;
t_off = 1/120;
t = 0:dt:.0002;
magnet_x = zeros(length(t),1);
magnet_v = magnet_x;
magnet_x(1) = x(idx_1-1)/1000;

for iter1 = 2:length(t)

    x_prev = magnet_x(iter1-1);

    % Define the force as a function of time
    if x_prev <= x(idx_2)/1000
        if t(iter1) < t_off
            F = interp1(x/1000,on_force/1000,x_prev);
        else
            F = interp1(x/1000,off_force/1000,x_prev);
        end
        a = F / (moving_mass/1000);
        magnet_v(iter1) = magnet_v(iter1-1) + a * dt;
        magnet_x(iter1) = x_prev + magnet_v(iter1-1) * dt;
    else
        magnet_v(iter1) = 0;
        magnet_x(iter1) = x(idx_2)/1000;
        break;
    end
end

disp(strcat("Response Time: ", num2str(1000*t(iter1)), " ms"))

figure;
plot(t,1000*magnet_x);

%% Plot Data
figure;
plot(x,coil_force);
hold on;
plot(x,core_force);
plot(x,elastic_force);
%plot(x,finger_force);
%plot(x,gravity_force);
hold off;
xlim([x(1),x(end)]);
%legend(["F_{coil}","F_{core}","F_{elastic}","F_{finger}","F_g"])
legend(["F_{coil}","F_{core}","F_{elastic}"])
title("Primary Forces on Magnet")
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")

% figure;
% plot(x,off_force);
% hold on;
% plot(x,on_force);
% xline(x(idx_1))
% xline(x(idx_2),'r--')
% xline(x_stop)
% hold off;
% xlim([x(1),x(end)]);
% legend(["F_{off}","F_{on}"])
% xlabel("Distance Between Magnet and Inductor (mm)")
% ylabel("Force (mN)")
% title("Cumulative Force on Magnet")

figure;
plot(x,core_force+elastic_force);
hold on;
plot(x,coil_force+core_force+elastic_force);
xline(x(idx_1))
xline(x_finger,'r--')
xline(x_stop)
hold off;
xlim([x(1),x(end)]);
legend(["F_{off}","F_{on}"])
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")
title("Cumulative Force on Magnet")


disp(strcat("Upstroke Energy: ",num2str(sum(on_force(idx_1:idx_2)*x_spacing/1000))," mJ"));
disp(strcat("Downstroke Energy: ",num2str(sum(off_force(idx_1:idx_2)*x_spacing/1000))," mJ"));
