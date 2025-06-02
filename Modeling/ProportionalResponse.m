%% By: Dustin Goetz
clear; clc, close all;
addpath("Electromagnetic/COMSOL/EM_COMSOL_Data")
addpath("Electromagnetic/Measurements/EM_Measurement_Data")
addpath("ElasticMember/Elastic_COMSOL_Data")
addpath("ElasticMember/Elastic_Measurement_Data")


%% Stroke
x_spacing = 0.05;
x = 1:x_spacing:6;
heatSink_height = 14.7;
tactorHeight = 3.175;
elasticHeight = 1.5;
x_finger = heatSink_height+1-4.8-4-tactorHeight;
x_stop = heatSink_height-4.8-4;

[~,finger_idx] = min(abs(x-x_finger));
[~,elastic_idx] = min(abs(x-elasticHeight));

%% EM Forces
EM_COMSOL_Data = readmatrix("Electromagnetic/COMSOL/EM_COMSOL_Data/LightTouch_Unshielded_CurrentSweep.csv");

numCurrent = 78;
EM_x = EM_COMSOL_Data(1:numCurrent:end,1);
current = -EM_COMSOL_Data(1:numCurrent,2);

EM_force = zeros(numCurrent,length(x));
for iter1 = 1:78
    EM_force_raw = 1000*EM_COMSOL_Data(iter1:numCurrent:end,3)';
    EM_force(iter1,:) = interp1(EM_x,EM_force_raw,x);
end

%% Spring Force
elastic_idx = (elasticHeight-x(1))/x_spacing + 1;
Elastic_COMSOL_Data = readmatrix("ElasticMember/Elastic_COMSOL_Data/CompressionTest_Ecoflex10_1.5mm.csv");
elastic_force = [-1000*flipud(Elastic_COMSOL_Data(1:elastic_idx,2));zeros(length(x)-elastic_idx,1)]';

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

%% Equilibria Points
off_force = elastic_force+EM_force(numCurrent,:);

%% Equilibria Points
start_idx = find(diff(sign(off_force)));

start_force = zeros(numCurrent,1);
end_force = zeros(numCurrent,1);
for iter1 = 1:numCurrent
    total_force = elastic_force+EM_force(iter1,:);
    start_force(iter1) = total_force(elastic_idx);
    end_force(iter1) = total_force(finger_idx);
end

figure;
plot(current,start_force);
hold on;
plot(current,end_force);

%% Dynamic Modeling
response_time = zeros(numCurrent,1);
energy = zeros(numCurrent,1);
for iter1 = 1:numCurrent
    total_force = elastic_force+EM_force(iter1,:);
    dt = 1/1000000;
    t = 0;
    magnet_x = x(start_idx);
    magnet_v = 0;
    nanFlag = false;
    
    while magnet_x < x_finger
        t = t+dt;
        F = interp1(x/1000,total_force/1000,magnet_x);
        if F < 0
            response_time(iter1) = Nan;
            energy(iter1) = Nan;
            nanFlag = true;
            break;
        end
        a = F / (moving_mass/1000);
        magnet_v = magnet_v + a * dt;
        magnet_x = magnet_x + magnet_v * dt;
    end
    if not(nanFlag)
        response_time(iter1) = 1000*t;
        energy(iter1) = sum(total_force(start_idx:finger_idx)*x_spacing/1000);
    end
end

figure;
plot(current(1:38), energy(1:38));

figure;
subplot(2,1,1)
plot(current, energy);
subplot(2,1,2)
plot(current, response_time);
