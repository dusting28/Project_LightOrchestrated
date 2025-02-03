%% By: Dustin Goetz
clear; clc, close all;

%% Load Data
addpath("COMSOL_Data")
inductorID = "12";
magnetDiam = 3;
magnetHeight = 4;
movingMass = strcat("Magnet",num2str(magnetDiam),"x",num2str(magnetHeight));
comsol_data = readmatrix(strcat("COMSOL_Data/Inductor",inductorID,"_",movingMass,".csv"));

current = comsol_data(1:3,2);
location = comsol_data(1:3:end,1);
force = zeros(length(current),length(location));
for iter1 = 1:3
    force(iter1,:) = 1000*comsol_data(iter1:3:end,3)';
    hold on;
end

k_membrane = 500;
k_finger = 25;
x_0 = 4.7625+0.381-3.18;
membrane_force = (x_0-location)*k_membrane;
membrane_force = max(membrane_force,0);
finger_force = (x_0+.3-location)*k_finger;
finger_force = min(finger_force,0);
elastic_force = finger_force + membrane_force;

gravity_force = 1000*7*(10^(-6))*((magnetDiam/2)^2)*pi*magnetHeight*9.81;


figure;
subplot(2,1,1)
plot(location(2:end),-force(2,2:end)');
hold on;
plot(location(2:end), elastic_force(2:end));
plot(location(2:end), -gravity_force*location(2:end)./location(2:end))
hold off;
xlim([0,2.5]);
legend(["F_{core}","F_{finger} + F_{membrane}", "F_g"])
title("Static Forces")
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")

subplot(2,1,2)
plot(location(2:end), elastic_force(2:end)-force(2,2:end)'-gravity_force)
yline(0)
xlim([0,2.5]);
title("Cumulative Static Force")
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")