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
[~,decouple_idx] = min(abs(x-elasticHeight));

%% EM Forces
EM_COMSOL_Data = readmatrix("Electromagnetic/COMSOL/EM_COMSOL_Data/LightTouch_Unshielded_CurrentSweep.csv");

numCurrent = 47;
EM_x = EM_COMSOL_Data(1:numCurrent:end,1);
current = EM_COMSOL_Data(1:numCurrent,2);

EM_force = zeros(numCurrent,length(x));
for iter1 = 1:numCurrent
    EM_force_raw = 1000*EM_COMSOL_Data(iter1:numCurrent:end,3)';
    EM_force(iter1,:) = interp1(EM_x,EM_force_raw,x);
end


%% Shield Force
Shield_Data = readmatrix("Electromagnetic/COMSOL/EM_COMSOL_Data/LightTouch_ShieldOnly.csv");
shield_force = interp1(Shield_Data(:,1)',1000*Shield_Data(:,2)',x);

%% Spring Force
elastic_idx = (elasticHeight-x(1))/x_spacing + 1;
area = (10^-6)*(pi*(3/2)^2);
k_elastic = (.5*(1278+80.28)*10^3)*area/(1.5*10^-3);
elastic_force = zeros(1,length(x));
elastic_force(1:elastic_idx-1) = k_elastic*(elasticHeight-x(1:elastic_idx-1));

%% Moving Mass
magnetDiam = 3; %mm
magnetHeight = 4; %mm
magnetDensity = 7; %g/cm^3
magnetMass = magnetDensity*(10^(-3))*((magnetDiam/2)^2)*pi*magnetHeight; % g

tactorDiam = 1.5875; % mm
tactorDensity = 1.41; % g/cm^3
tactorMass = tactorDensity*(10^(-3))*((tactorDiam/2)^2)*pi*tactorHeight; % g
moving_mass = magnetMass + tactorMass;

%% Equilibria Points
off_force = elastic_force+EM_force(1,:)+shield_force;

%% Equilibria Points
start_idx = find(diff(sign(off_force)));

z_eq = cell(numCurrent,1);
start_force = zeros(numCurrent,1);
end_force = zeros(numCurrent,1);
for iter1 = 1:numCurrent
    total_force = elastic_force+EM_force(iter1,:)+shield_force;
    z_eq{iter1} = find(diff(sign(total_force)));
    start_force(iter1) = total_force(decouple_idx);
    end_force(iter1) = total_force(finger_idx);
end

figure;
plot(current,start_force);
hold on;
plot(current,end_force);
yline(0)

%% Dynamic Modeling
response_time = zeros(numCurrent,1);
energy = zeros(numCurrent,1);
for iter1 = 1:numCurrent
    total_force = elastic_force+EM_force(iter1,:)+shield_force;
    dt = 1/100000;
    t = 0;
    magnet_x = x(start_idx)/1000;
    magnet_v = 0;
    nanFlag = false;
    
    while magnet_x < x_finger/1000
        t = t+dt;
        F = interp1(x/1000,total_force/1000,magnet_x);
        if F < 0
            response_time(iter1) = NaN;
            energy(iter1) = NaN;
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
plot(current, energy);
xlim([current(1),current(end)])
ylim([0,.2])
xlim([2.3,4.6])
xlabel("Current (A)")
ylabel("Tactor Energy (mJ)")

figure;
plot(current, response_time);
xlim([current(1),current(end)])
ylim([0,5])
xlim([2.3,4.6])
xlabel("Current (A)")
ylabel("Response Time (ms)")
