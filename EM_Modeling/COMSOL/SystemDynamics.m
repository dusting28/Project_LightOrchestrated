%% By: Dustin Goetz
clear; clc, close all;
addpath("COMSOL_Data")

%% Static Forces
inductorID = "32";
movingMass = "Magnet3x4";
comsol_data = readmatrix(strcat("COMSOL_Data/Inductor",inductorID,"_",movingMass,"_Shielded.csv"));

x = comsol_data(1:3:end,1);
force = zeros(3,length(x));
for iter1 = 1:3
    force(iter1,:) = 1000*comsol_data(iter1:3:end,3)';
end

coil_force = force(1,:)-force(2,:);
core_force = -force(2,:);
total_force = force(1,:);

%% Static Equilibrium Analysis

magnetDiam = 3; %mm
magnetHeight = 4; %mm
k_finger = (10^5)*(10^-6)*(pi*(2/2)^2)/(5*10^-3); 
x_0 = 3.33; %6.2+0.305-3; %5.74
x_finger = x_0+.9375;

% Membrane model
hole_rad = (9/2)*(10^-3);
shaft_rad = (magnetDiam/2)*(10^-3);
% membrane_thickness = 0.305*(10^-3); % .012"
membrane_thickness = 0.254*(10^-3); % .010"
% membrane_thickness = 0.203*(10^-3); % .008"
% membrane_thickness = 0.1524*(10^-3); % .006"
young_mod = 2*(10^6);
poisson = .5;
solidarity_ratio = hole_rad/shaft_rad;
k_membrane = ((hole_rad^2/(young_mod*membrane_thickness^3))*...
    (3*(1-poisson^2)/pi)*((solidarity_ratio^2-1)/(4*solidarity_ratio^2)...
    -(log(solidarity_ratio)^2)/(solidarity_ratio^2-1)))^(-1);

k_membrane = 0;

% magnetDiam = 6.35; %mm
% magnetHeight = 2; %mm
% k_membrane = (.55*10^5)*(10^-6)*(pi*(7.5/2)^2)/(5*10^-3); 
% k_finger = (10^5)*(10^-6)*(pi*(2.15/2)^2)/(5*10^-3);
% x_0 = 5;
% x_finger = x_0;

k_total = k_membrane + k_finger;
membrane_force = (x_0-x)*k_membrane;
membrane_force = max(membrane_force,0);
finger_force = (x_finger-x)*k_finger;
finger_force = min(finger_force,0);
elastic_force = finger_force + membrane_force;

magnet_mass = 7*(10^(-6))*((magnetDiam/2)^2)*pi*magnetHeight;
tactor_mass = 7*(10^(-6))*((2/2)^2)*pi*3;
% tactor_mass = 1.25*(10^(-6))*68.2;
moving_mass = magnet_mass + tactor_mass;
gravity_force = 1000*9.81*moving_mass;

off_force = elastic_force-core_force'-gravity_force;
on_force = elastic_force+coil_force'-core_force'-gravity_force;

figure;
subplot(2,1,1)
plot(x(2:end),-core_force(2:end)');
hold on;
plot(x(2:end), elastic_force(2:end));
plot(x(2:end), -gravity_force*x(2:end)./x(2:end))
plot(x(2:end), coil_force(2:end)');
hold off;
xlim([0,6]);
legend(["F_{core}","F_{finger} + F_{membrane}", "F_g", "F_{coil}"])
title("Static Forces")
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")

subplot(2,1,2)
plot(x(2:end), on_force(2:end))
hold on;
plot(x(2:end), off_force(2:end))
yline(0)
xlim([0,6]);
title("Cumulative Static Force")
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")

figure;
plot(x, on_force)
hold on;
yline(0)
xlim([1.25,4.25]);
title("Up Stroke")
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")
disp(sum(on_force(6:18))*x(2)/1000);

figure;
plot(x, off_force)
hold on;
yline(0)
xlim([1.25,4.25]);
title("Down Stroke")
xlabel("Distance Between Magnet and Inductor (mm)")
ylabel("Force (mN)")
disp(sum(off_force(6:18))*x(2)/1000);
