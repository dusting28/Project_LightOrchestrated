%% Dustin
clear; clc; close all;

%% Fitted Params from Calibration
% R_0 = 4.5568;
alpha = 0.0065;
% alpha = 0.00393;
Rs = 0.22;
T_0 = 21.7;
Vcc = 24;

%% Load Pulse Train Data
pulseLen = .017;
pulseGap = [.14983, .14983, .1498795, .1498795, .1498795];
numPulses = 600;

pulseTrainData = load(strcat("ThermalPulseTrain_HeatSink_150msSpacing_24V.mat"));
voltageData = pulseTrainData.MeasurementSignal.signals;

numReps = length(voltageData);
fs = pulseTrainData.MeasurementSignal.fs;
numDataPoints = round(pulseLen*fs);
avg_temperatures = zeros(numReps,numPulses);
chop_temp = zeros(numReps,numPulses,numDataPoints);
chop_t = zeros(numReps,numPulses,numDataPoints);

for iter1 = 1:numReps
    
    t = (1:length(voltageData{iter1}))/fs;
    start_idx = find(voltageData{iter1}(:,3)>1,1,'first')+3;
    chop_voltage = zeros(numPulses, numDataPoints);
    for iter2 = 1:numPulses
        current_idx = start_idx + round((iter2-1)*(pulseGap(iter1)+pulseLen)*fs);
        trigger_idx = find(voltageData{iter1}(current_idx-numDataPoints:current_idx+2*numDataPoints,3)>1,1,'first')+3;
        trigger_idx = trigger_idx + current_idx-numDataPoints;
        chop_voltage(iter2,:) = voltageData{iter1}(trigger_idx:trigger_idx+numDataPoints-1,1);
        chop_t(iter1,iter2,:) = t(trigger_idx:trigger_idx+numDataPoints-1);
    end

    current = voltageData{iter1}(:,1)/Rs;

    resistance = Rs*Vcc./chop_voltage - Rs;
    R_0 = median(resistance(1,:));

    chop_temp(iter1,:,:) = (resistance/R_0 - 1)/alpha + T_0;
    avg_temperatures(iter1,:) = squeeze(median(chop_temp(iter1,:,:),3));
end

%% Plot Average Over Time
figure;
temp_avg = squeeze(median(chop_temp,3));
t_avg = (1:600)*(pulseLen+mean(pulseGap)) - mean(pulseGap);
grayColor = [.7 .7 .7];
for iter1 = 1:numReps
    plot(t_avg,temp_avg(iter1,:),'Color',grayColor)
    hold on;
end
plot(t_avg,median(temp_avg,1),'k')

ylabel("Temperature (C)")
xlabel("Time (s)")
title("Pulse Train: 17 ms pulses with 150 ms spacing");

%% Fit equilibrium point
T = median(temp_avg);

% Define model
model = @(b, t) b(1) + (b(2) - b(1)) * exp(-t / b(3));  % b = [T_inf, T_0, tau]

% Initial guess: [final, initial, time constant]
b0 = [T(end), T_0, (t_avg(end) - t_avg(1))/5];

% Fit using nonlinear least squares
b_fit = lsqcurvefit(model, b0, t_avg, T);

% Extract steady-state value
T_eq = b_fit(1);


%% Plot All Pulses Over Time
figure;
t_reshape = permute(chop_t, [1, 3, 2]);
t_reshape = reshape(t_reshape, numReps, numDataPoints*numPulses);
t_shift = t_reshape(:,1);
t_reshape = t_reshape - t_shift;
temp_reshape = permute(chop_temp, [1, 3, 2]);
temp_reshape = reshape(temp_reshape, numReps, numDataPoints*numPulses);
grayColor = [.7 .7 .7];
for iter1 = 1:numReps
    plot(t_reshape(iter1,:),temp_reshape(iter1,:),'Color',grayColor)
    hold on;
end
plot(t_reshape(end,:),median(temp_reshape,1),'k')
yline(T_eq);

ylim([20,140]);
ylabel("Temperature (C)")
xlabel("Time (s)")
title("Pulse Train: 17 ms pulses with 150 ms spacing");

figure;

t_zoom= [94.5,96.5];
subplot(2,1,1)
for iter1 = 1:numReps
    zoom_idx = find(and(t_reshape(iter1,:)>t_zoom(1),t_reshape(iter1,:)<t_zoom(2)));
    plot(t_reshape(iter1,zoom_idx),temp_reshape(iter1,zoom_idx),'Color',grayColor)
    hold on;
end
plot(t_reshape(end,zoom_idx),median(temp_reshape(:,zoom_idx),1),'k')
yline(T_eq);
xlim([95,96]);

subplot(2,1,2)
t = t-t_shift(end);
zoom_idx = find(and(t>t_zoom(1),t<t_zoom(2)));
plot(t(zoom_idx),current(zoom_idx));
xlim([95,96]);
