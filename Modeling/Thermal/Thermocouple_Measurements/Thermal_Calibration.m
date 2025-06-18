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



%% Linear Regression

all_temp = [initial_temp;final_temp];
all_res = [initial_res;final_res];

A_matrix = [ones(length(all_temp),1),all_temp(:)];
params = A_matrix\all_res;

R_0 = params(1);
alpha = params(2)/R_0;

disp(R_0)
disp(alpha)

temp = 0:100;
res = R_0*(1+alpha*temp);

plot(temp,res,'k--');
legend("Beginning of Pulse", "End of Pulse", "Fitted Model")
xlabel("Temperature (C)")
ylabel("Resistance (ohms)")