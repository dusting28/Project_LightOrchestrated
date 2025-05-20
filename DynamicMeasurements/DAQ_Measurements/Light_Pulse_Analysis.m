%% Dustin Goetz
clc; clear; close all;
addpath("DAQ_Data")

%% Proportional Control
proportionalData = load("DAQ_Data\OLED_DecreasingPulses_SinglePixel.mat");
voltageData = proportionalData.MeasurementSignal.signals{1};
fs = proportionalData.MeasurementSignal.fs;
t = (1:size(voltageData,1))/fs;

figure;
subplot(1,3,1);
plot(t,voltageData(:,3));
subplot(1,3,2);
plot(t,voltageData(:,1)/.22);
subplot(1,3,3);
plot(t,-voltageData(:,2));

% Overlay
chop_idx = ChopSignal(voltageData(:,3),1.96,1,fs);
figure;
plot(chop_idx,".");


chop_idx = chop_idx(50:105);
window_len = round(.025*fs);

control_mag = zeros(1,length(chop_idx));
power_mag = control_mag;
vel_mag = control_mag;

iter0 = 0;
for iter1 = chop_idx
    iter0 = iter0+1;
    begin_chop = iter1-window_len;
    end_chop = iter1+window_len;
    controlSig = voltageData(begin_chop:end_chop,3);
    powerSig = voltageData(begin_chop:end_chop,1)/.22;
    displacementSig = -(2.13)*(voltageData(begin_chop:end_chop,2)-voltageData(begin_chop,2));
    velSig = (fs)*diff(smooth(displacementSig,5));
    t_chop = t(begin_chop:end_chop)-t(begin_chop);
    
    control_mag(iter0) = max(controlSig)-controlSig(1);
    power_mag(iter0) = max(powerSig)-powerSig(1);
    vel_mag(iter0) = max(velSig);

    if iter0 == 1
        figure;
        subplot(1,2,1)
        plot(displacementSig)
        hold on;
        plot(smooth(displacementSig,20))
        hold off;
        subplot(1,2,2)
        plot(fs*diff(smooth(displacementSig,20)))
    end
end

figure;
plot(control_mag,'.');
hold on;
plot(power_mag,'.');
% plot(vel_mag,'.');

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