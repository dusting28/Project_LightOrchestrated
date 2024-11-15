%% By: Dustin Goetz
clear; clc, close all;

%% Load Data
raw_data = readmatrix("COMSOL_MagnetForce.csv");

%% Plot Data
figure;
for iter1 = [5, 7]
    location = raw_data(iter1:9:end,1) - .35/2;
    force = raw_data(iter1:9:end,4);
    plot(location(2:end-1),force(2:end-1));
    disp(strcat("Work: ", num2str(mean(force(2:end-1))*.35), " mJ"));
    xline(0);
    yline(0);
    hold on;
end

raw_data = readmatrix("COMSOL_MagnetForce2.csv");
for iter1 = 7
    location = raw_data(iter1:9:end,1) - .35/2;
    force = raw_data(iter1:9:end,4);
    plot(location(2:end-1),force(2:end-1));
    disp(strcat("Work: ", num2str(mean(force(2:end-1))*.35), " mJ"));
    xline(0);
    yline(0);
    hold on;
end

figure;
raw_data = readmatrix("COMSOL_Reluctance10.csv");
for iter1 = 8
    location = raw_data(iter1:9:end,1) - .35/2;
    force = raw_data(iter1:9:end,4);
    plot(location(2:end-1),force(2:end-1));
    disp(strcat("Work: ", num2str(mean(force(2:end-1))*.35), " mJ"));
    xline(0);
    yline(0);
    hold on;
end

raw_data = readmatrix("COMSOL_Reluctance5000.csv");
for iter1 = 8
    location = raw_data(iter1:9:end,1) - .35/2;
    force = raw_data(iter1:9:end,4);
    plot(location(2:end-1),force(2:end-1));
    disp(strcat("Work: ", num2str(mean(force(2:end-1))*.35), " mJ"));
    xline(0);
    yline(0);
    hold on;
end