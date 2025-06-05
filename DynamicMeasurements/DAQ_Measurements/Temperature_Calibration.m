%% Dustin Goetz
clc; clear; close all;
addpath("DAQ_Data")

%% Proportional Control
num_pulses = 100;
num_trials = 3;
pulse_len = .03;
spacing = .9992;
start_vec = [3.015*10^4, 2.65*10^4, 2.55*10^4];
contact_height = 2.4250;

gateVoltage = zeros(num_pulses,num_trials);
inductorCurrent = zeros(num_pulses,num_trials);
tactorEnergy = zeros(num_pulses,num_trials);

measurementData = load(strcat("ThermalPulse_120s_2000mV.mat"));
voltageData = measurementData.MeasurementSignal.signals{1};
% voltageData = voltageData(5*10^4:end,:);
fs = measurementData.MeasurementSignal.fs;
t = (1:size(voltageData,1))/fs;

figure;
plot(voltageData(:,1));

chop_idx = find(voltageData(:,1)>.02);
chop1_idx = chop_idx(1);
chop2_idx = chop_idx(end);

window_t = .05;
num_samples = round(window_t*fs);
space_t = .01;
num_space = round(space_t*fs);
    
figure;
plot(t,voltageData(:,1)/.22);
hold on;
xline(t(chop1_idx));
xline(t(chop2_idx));

avg_start = mean(voltageData(chop1_idx+num_space:chop1_idx+num_samples,1))/.22;
avg_end = mean(voltageData(chop2_idx-num_samples:chop2_idx-num_space,1))/.22;

yline(avg_start,'r');
yline(avg_end,'b');


disp(avg_start)
disp(avg_end)
