%% By: Dustin Goetz
clear; clc, close all;

%% Static Forces
addpath("COMSOL_Data")
inductorID = "Inductor11";
movingMass = "BigMagnet";
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
plot(location(2:end), abs(force(1,2:end)-force(3,2:end)))
hold on;

%% Static Equilibrium Analysis

% magnetDiam = 3; %mm
% magnetHeight = 4; %mm
% k_membrane = 788; %N/m
% k_finger = (10^5)*(10^-6)*(pi*(2/2)^2)/(5*10^-3); 
% x_0 = 6.35+0.381-3.2;
% x_finger = x_0 - (10-7.9375);

magnetDiam = 6.35; %mm
magnetHeight = 2; %mm
k_membrane = (.55*10^5)*(10^-6)*(pi*(7.5/2)^2)/(5*10^-3); 
k_finger = (10^5)*(10^-6)*(pi*(2.15/2)^2)/(5*10^-3);
x_0 = 5;
x_finger = x_0;

membrane_force = (x_0-location)*k_membrane;
membrane_force = max(membrane_force,0);
finger_force = (x_finger-location)*k_finger;
finger_force = min(finger_force,0);
elastic_force = finger_force + membrane_force;

magnet_mass = 7*(10^(-6))*((magnetDiam/2)^2)*pi*magnetHeight;
% tactor_mass = 7*(10^(-6))*((2/2)^2)*pi*6;
tactor_mass = 1.25*(10^(-6))*68.2;
moving_mass = magnet_mass + tactor_mass;
gravity_force = 1000*9.81*moving_mass;

figure;
subplot(2,1,1)
plot(location(2:end),-force(2,2:end)');
hold on;
plot(location(2:end), elastic_force(2:end));
plot(location(2:end), -gravity_force*location(2:end)./location(2:end))
hold off;
xlim([0,5]);
legend(["F_{core}","F_{finger} + F_{membrane}", "F_g"])
title("Static Forces")
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")

subplot(2,1,2)
plot(location(2:end), elastic_force(2:end)-force(2,2:end)'-gravity_force)
hold on;
plot(location(2:end), elastic_force(2:end)-force(1,2:end)'-gravity_force)
yline(0)
xlim([0,5]);
title("Cumulative Static Force")
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")

%% Linear Dynamics

% Params
freq = 0:500;
omega = freq*2*pi;
damping_ratio = [.3, .4, .5]; 
damping = damping_ratio*2*(moving_mass*k_membrane)^.5;

input_force = interp1(location,abs(force(1,:)-force(3,:)),x_0)/1000;

figure;
x = zeros(length(damping),length(freq));
iter1 = 0;
for c = damping
    iter1 = iter1+1;
    x(iter1,:) = abs(input_force./(-moving_mass*omega.^2 + 1i*c*omega + k_membrane));
    plot(freq,(10^6)*x(iter1,:))
    hold on;
end
hold off;

%ylim([0,60]);
ylim([0,300]);
title("Frequency Response")
xlabel("Frequency (Hz)")
ylabel("Oscillation Amplitude (microns)")
legend(strcat("Damping Ratio = ",num2str(damping_ratio(1))),...
    strcat("Damping Ratio = ",num2str(damping_ratio(2))),...
    strcat("Damping Ratio = ",num2str(damping_ratio(3))))
