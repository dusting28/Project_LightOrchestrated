%% By: Dustin Goetz
clear; clc, close all;

%% Load Data
addpath("COMSOL_Data")
inductorID = "Custom";
movingMass = "RailGun";
comsol_data = readmatrix(strcat("COMSOL_Data/",inductorID,"_",movingMass,".csv"));

current = comsol_data(1:3,2);
location = comsol_data(1:3:end,1);
force = zeros(length(current),length(location));

color = ["b","k","r"];
figure;
for iter1 = 1:3
    force(iter1,:) = 1000*comsol_data(iter1:3:end,3)';
    plot(location(2:end), force(iter1,2:end),strcat(color(iter1),"."))
    hold on;
end
hold off;

figure;
plot(location(2:end), abs(force(1,2:end)))
hold on;

work1 = abs(sum(force(1,:))*location(2)*10^-6);
k = 25; 
deltaX = (work1*2/k)^.5;
totalForce = k*deltaX+abs((force(1,end)*10^-3));

%% Comparison
inductorID = "Custom";
movingMass = "Pin";
comsol_data = readmatrix(strcat("COMSOL_Data/",inductorID,"_",movingMass,".csv"));

current = comsol_data(1:3,2);
location = 1000*comsol_data(1:3:end,1);
force = zeros(length(current),length(location));

for iter1 = 1:3
    force(iter1,:) = 1000*comsol_data(iter1:3:end,3)';
end

figure;
plot(location(2:end), abs(force(1,2:end)))
hold off;
xlabel("Stroke Position (mm)")
ylabel("Force (mN)")

color = ["b","k","r"];
figure;
for iter1 = 1:3
    plot(location(2:end), force(iter1,2:end),strcat(color(iter1),"."))
    hold on;
end
hold off;

%% Metrics
finger_idx = 21;
stroke_length = location(finger_idx)/1000;
k_finger = (10^5)*(10^-6)*(pi*(2/2)^2)/(5*10^-3); 
pin_mass = (7.9*6*pi*(1.5/2)^2 + 7*3*pi*(3/2)^2 + 2.7*9*pi*(2/2)^2)*10^-6;
work = abs(sum(force(1,1:finger_idx))*location(2)*10^-6);
potential_energy = pin_mass*stroke_length*9.81;
kinetic_energy = work-potential_energy;
velocity = (2*kinetic_energy/pin_mass)^.5;
avg_acc = abs(mean(force(1,1:finger_idx)*10^-3)/pin_mass);
stroke_time = (2*stroke_length/avg_acc)^.5;
max_frequency = .5/stroke_time;
power_output = max_frequency*kinetic_energy;
power_input = 7.72*(.4)^2;
efficiency = 100*power_output/power_input;
end_force = abs((force(1,finger_idx)*10^-3));
deltaX = (work*2/k_finger)^.5;
total_force = k_finger*deltaX+end_force;