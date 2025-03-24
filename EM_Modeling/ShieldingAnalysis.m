%% Load COMSOL Data
inductorID = "32";
movingMass = "Magnet3x4";
unshielded_data = readmatrix(strcat("COMSOL/COMSOL_Data/Inductor",inductorID,"_",movingMass,".csv"));

current = unshielded_data(1:3,2);
x_comsol = unshielded_data(1:3:end,1);
unshielded_force = zeros(length(current),length(x_comsol));
for iter1 = 1:3
    unshielded_force(iter1,:) = -1000*unshielded_data(iter1:3:end,3)';
end

shielded_data = readmatrix(strcat("COMSOL/COMSOL_Data/Inductor",inductorID,"_",movingMass,"_Shielded.csv"));

current = shielded_data(1:3,2);
x_comsol = shielded_data(1:3:end,1);
shielded_force = zeros(length(current),length(x_comsol));
for iter1 = 1:3
    shielded_force(iter1,:) = -1000*shielded_data(iter1:3:end,3)';
end

%% Plot 

figure;
plot(x_comsol(2:end), unshielded_force(2,2:end))
hold on;
plot(x_comsol(2:end), shielded_force(2,2:end))
title("Inductor 32 - Off Force")

figure;
plot(x_comsol(2:end), unshielded_force(1,2:end))
hold on;
plot(x_comsol(2:end), shielded_force(1,2:end))
title("Inductor 32 - On Force")