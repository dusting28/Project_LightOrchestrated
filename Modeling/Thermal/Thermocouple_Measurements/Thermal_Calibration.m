%% By: Dustin Goetz
clear; clc, close all;

%% Raw Data

ThermalData = readmatrix("Temperature_Calibration.xlsx");

initial_temp = ThermalData(3:9,3); 
initial_res = ThermalData(3:9,8); 

final_temp = ThermalData(3:9,4); 
final_res = ThermalData(3:9,9); 

figure;
plot(initial_temp,initial_res,'r.')
hold on;
plot(final_temp,final_res,'b.');

%% Find Alpha

delta_T = final_temp-initial_temp;
ratio_R = final_res./initial_res;

alpha = (ratio_R-1)./delta_T;

disp(alpha)
disp(mean(alpha))

T_0 = 21.7;

figure;
plot(final_res, (ratio_R-1)/mean(alpha) + T_0, 'r.');
hold on;
plot(final_res, final_temp,'b.');