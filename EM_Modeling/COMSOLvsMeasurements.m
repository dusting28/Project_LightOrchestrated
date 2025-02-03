%% Dustin Goetz
clc; clear; close all;

%% Load Data
addpath("Measurements/Data")
addpath("COMSOL/COMSOL_Data")
inductorID = "12";
COMSOLmovingMass = "Magnet3x4";
movingMass = "1007Magnetx4";
load(strcat("Measurements/Data/Inductor",inductorID,"_",movingMass,".mat"))
comsol_data = readmatrix(strcat("COMSOL/COMSOL_Data/Inductor",inductorID,"_",COMSOLmovingMass,".csv"));

current = comsol_data(1:3,2);
location = comsol_data(1:3:end,1);
force = zeros(length(current),length(location));
for iter1 = 1:3
    force(iter1,:) = 1000*comsol_data(iter1:3:end,3)';
end

x = (0:ForceData.numMeasurements-1)*ForceData.spacing;

stable_voltage = zeros(ForceData.numMeasurements,3);
for iter1 = 1:ForceData.numMeasurements
    for iter2 = 1:3
        stable_voltage(iter1,iter2) = -mean(ForceData.measurements{iter1,iter2}(end-10000:end));
    end
end

xDecay = 400./(location(2:end).^2);

figure;
subplot(3,1,1)
plot(x(2:end),stable_voltage(2:end,1))
hold on;
plot(location(2:end), force(2,2:end))
plot(location(2:end), xDecay)
hold off;
ylim([0,2500])
xlim([0,2.5])
ylabel("Force (mN)")
xlabel("Distance Between Magnet and Inductor (mm)")
title("Magnet-Core Interaction")
legend("Measurement","COMSOL", "F(x) = 400/x^2")

subplot(3,1,2)
coil_force = (stable_voltage(:,1) - stable_voltage(:,3));
plot(x(2:end),coil_force(2:end))
hold on;
plot(location(2:end), (force(2,2:end)-force(1,2:end)))
hold off;
ylim([0,100])
xlim([0,2.5])
ylabel("Force (mN)")
xlabel("Distance Between Magnet and Inductor (mm)")
title("Magnet-Coil Interaction")
legend("Measurement","COMSOL")

subplot(3,1,3)
coil_force = -(stable_voltage(:,1) - stable_voltage(:,2));
plot(x(2:end),coil_force(2:end))
hold on;
plot(location(2:end), -(force(2,2:end)-force(3,2:end)))
hold off;
ylim([-25,30])
xlim([0,2.5])
ylabel("Force (mN)")
xlabel("Distance Between Magnet and Inductor (mm)")
title("Magnet-Coil Interaction")
legend("Measurement","COMSOL")

figure

subplot(2,1,1)
plot(location(2:end), (force(2,2:end)-force(1,2:end)))
hold on;
plot(location(2:end), -(force(2,2:end)-force(3,2:end)))
hold off;
ylim([0,30])
xlim([0,2.5])
ylabel("Force (mN)")
xlabel("Distance Between Magnet and Inductor (mm)")
title("Magnet-Coil Interaction")
legend("Measurement","COMSOL")

subplot(2,1,2)
coil_force = (stable_voltage(:,1) - stable_voltage(:,3));
plot(x(2:end),coil_force(2:end))
hold on;
coil_force = -(stable_voltage(:,1) - stable_voltage(:,2));
plot(x(2:end),coil_force(2:end))
hold off;
ylim([-25,100])
xlim([0,2.5])
ylabel("Force (mN)")
xlabel("Distance Between Magnet and Inductor (mm)")
title("Magnet-Coil Interaction")
legend("Measurement","COMSOL")

