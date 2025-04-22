%% Dustin Goetz
clc; clear; close all;

%% Gate Resistor Analysis

Rg470 = load("LED_470ohmGate.mat");
Rg10k = load("LED_10kohmGate.mat");

t_470 = (1:size(Rg470.MeasurementSignal.signals{1},1))/Rg470.MeasurementSignal.fs;
t_10k = (1:size(Rg10k.MeasurementSignal.signals{1},1))/Rg10k.MeasurementSignal.fs;

figure;
plot(t_470,Rg470.MeasurementSignal.signals{1}(:,3))
hold on;
plot(t_10k,Rg10k.MeasurementSignal.signals{1}(:,3))

%% Show Overlay
figure;
plot(t_470,Rg470.MeasurementSignal.signals{1}(:,1))
hold on;
plot(t_470,Rg470.MeasurementSignal.signals{1}(:,2))
plot(t_470,Rg470.MeasurementSignal.signals{1}(:,3))