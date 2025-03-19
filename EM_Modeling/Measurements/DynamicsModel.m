%% By: Dustin Goetz
clear; clc, close all;

%% Static Forces
addpath("Data")
load("Data/PulsedBig_Inductor32_Magnet3x4.mat")

x = (0:ForceData.numMeasurements-1)*ForceData.spacing;

coil_force = zeros(length(x),1);
core_force = zeros(length(x),1);
total_force = zeros(length(x),1);
for iter2 = 1:size(ForceData.measurements,1)
    initialForce = median(ForceData.measurements{iter2,1}(1:5000));
    maxForce = max(ForceData.measurements{iter2,1}(10005:10165));
    minForce = min(ForceData.measurements{iter2,1}(10005:10165));
    total_force(iter2) = (maxForce+minForce)/2;
    core_force(iter2) = -initialForce;
    coil_force(iter2) = total_force(iter2)-initialForce;
end

%% Static Equilibrium Analysis

magnetDiam = 3; %mm
magnetHeight = 4; %mm
k_finger = (10^5)*(10^-6)*(pi*(2/2)^2)/(5*10^-3); 
x_0 = 3.33; %6.2+0.305-3; %5.74
x_finger = x_0+.9375;

% Membrane model
hole_rad = (7/2)*(10^-3);
shaft_rad = (magnetDiam/2)*(10^-3);
% membrane_thickness = 0.305*(10^-3); % .012"
% membrane_thickness = 0.254*(10^-3); % .010"
% membrane_thickness = 0.203*(10^-3); % .008"
membrane_thickness = 0.1524*(10^-3); % .006"
young_mod = 5*(10^6);
poisson = .5;
solidarity_ratio = hole_rad/shaft_rad;
k_membrane = ((hole_rad^2/(young_mod*membrane_thickness^3))*...
    (3*(1-poisson^2)/pi)*((solidarity_ratio^2-1)/(4*solidarity_ratio^2)...
    -(log(solidarity_ratio)^2)/(solidarity_ratio^2-1)))^(-1);

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

%% Linear Dynamics

% Params
freq = 0:500;
omega = freq*2*pi;
damping_ratio = [.3, .4, .5]; 
damping = damping_ratio*2*(moving_mass*k_total)^.5;


x_up = linspace(x(2),x(end),1000);
baseline_force = interp1(x(2:end),elastic_force(2:end)-force(2,2:end)'-gravity_force,x_up);
operating_idx = and((baseline_force(2:end)<0),(baseline_force(1:end-1)>=0));
operating_point = x_up(operating_idx);

input_force = interp1(x,abs(force(1,:)-force(3,:)),operating_point)/1000;

figure;
x = zeros(length(damping),length(freq));
iter1 = 0;
for c = damping
    iter1 = iter1+1;
    x(iter1,:) = abs(input_force./(-moving_mass*omega.^2 + 1i*c*omega + k_total));
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
