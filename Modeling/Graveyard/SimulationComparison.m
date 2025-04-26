%% By: Dustin Goetz
clear; clc, close all;

%% Load Data

% Testing

Component = "LQW15CN3R3M10D";
COMSOL_Data_Off = readmatrix(strcat("COMSOL_",Component,"_Magnet_0mA.csv"));
COMSOL_Data_On = readmatrix(strcat("COMSOL_",Component,"_Magnet_110mA.csv"));
COMSOL_Data_Coreless = readmatrix(strcat("COMSOL_Coreless_Magnet_110mA.csv"));
Measurement_Data = readmatrix("InductorCharacterization_ForceMeasurements.xlsx", "Sheet", Component);

figure;
plot(COMSOL_Data_Off(2:end,1)*10^3,-COMSOL_Data_Off(2:end,2));
hold on;
plot(Measurement_Data(3:end,1),Measurement_Data(3:end,2)-Measurement_Data(end,2));
hold off;

figure;
plot(Measurement_Data(3:end,1),Measurement_Data(3:end,2)-Measurement_Data(end,2));
hold on;
plot(Measurement_Data(3:end,4),Measurement_Data(3:end,5)-Measurement_Data(end,5));
hold off;

figure;
plot(Measurement_Data(3:end,1),Measurement_Data(3:end,2)-Measurement_Data(3:end,5));
hold on;
plot(COMSOL_Data_Off(2:end,1)*10^3,COMSOL_Data_Off(2:end,2)-COMSOL_Data_On(2:end,2));
plot(COMSOL_Data_Coreless(2:end,1)*10^3,-COMSOL_Data_Coreless(2:end,2));
hold off;

figure;
plot(COMSOL_Data_Coreless(2:end,1)*10^3,-COMSOL_Data_Coreless(2:end,2));


