%% Dustin
clear; clc; close all;

%% Fitted Params from Calibration
% R_0 = 4.5568;
alpha = 0.0081;
% alpha = 0.00393;
Rs = 0.22;

%% Load Long Pulses
type = ["HeatSink", "Air"];
color = ["r","b"];
pulseLen = .3;
temperatures = cell(length(type),1);

figure;
for iter1 = 1:length(type)
    singlePulse = load(strcat("ThermalPulse_",type(iter1),"_300ms_24V.mat"));
    voltageData = singlePulse.MeasurementSignal.signals;
    fs = singlePulse.MeasurementSignal.fs;

    numDataPoints = round(pulseLen*fs);
    temperatures{iter1} = zeros(length(voltageData),numDataPoints);
    t = (1:numDataPoints)/fs;
    for iter2 = 1:length(voltageData)

        start_idx = find(voltageData{iter2}(:,3)>1,1,'first')+3;
        end_idx = start_idx + numDataPoints-1;


        current = voltageData{iter2}(start_idx:end_idx,1)./Rs;
        resistance = 24./current - Rs;

        R_initial = resistance(50);
        R_0 = R_initial/(21.7*alpha + 1);

        temperatures{iter1}(iter2,:) = (resistance/R_0 - 1)/alpha;
    end
    plot(t,median(temperatures{iter1},1),color(iter1))
    hold on;
end
ylabel("Temperature (C)")
xlabel("Time (s)")
title("Reponse to 300 ms Pulse");
legend(["Heat Sink","Air"])

%% Load Pulse Train Data
type = ["HeatSink"];
color = ["r"];
pulseLen = .017;
pulseGap = .149875;
numPulses = 600;
temperatures = cell(length(type),1);

t = (1:600)*(pulseLen+pulseGap) - pulseGap;

figure;
for iter1 = 1:length(type)
    singlePulse = load(strcat("ThermalPulseTrain_",type(iter1),"_150msSpacing_24V.mat"));
    voltageData = singlePulse.MeasurementSignal.signals;
    fs = singlePulse.MeasurementSignal.fs;

    numDataPoints = round(pulseLen*fs);
    temperatures{iter1} = zeros(length(voltageData),numPulses);
    for iter2 = 1:length(voltageData)
        
        start_idx = find(voltageData{iter2}(:,3)>1,1,'first')+3;
        max_voltage = zeros(numPulses,1);
        for iter3 = 1:numPulses
            current_idx = start_idx + round((iter3-1)*(pulseGap+pulseLen)*fs);
            chop_voltage = voltageData{iter2}(current_idx:current_idx+numDataPoints,1);
            max_voltage(iter3) = max(chop_voltage);
        end
        current = max_voltage/Rs;
        resistance = 24./current - Rs;

        R_initial = resistance(1);
        R_0 = R_initial/(21.7*alpha + 1);

        temperatures{iter1}(iter2,:) = (resistance/R_0 - 1)/alpha;
    end
    plot(t,temperatures{iter1}(1,:))
    hold on;
end
ylabel("Temperature (C)")
xlabel("Time (s)")
title("Pulse Train: 17 ms pulses with 150 ms spacing");



