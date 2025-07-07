%% Dustin Goetz
clc; clear; close all;
addpath("DAQ_Data")

%% Proportional Control
displacementData = load(strcat("DAQ_Data/LED_DecreasingPulses_Displacement_24V.mat"));
velocityData = load(strcat("DAQ_Data/LED_DecreasingPulses_Velocity_24V.mat"));

num_pulses = 100;
num_trials = displacementData.MeasurementSignal.nReps;
fs = displacementData.MeasurementSignal.fs;
pulse_len = .017;
spacing = .9992;
contact_height = 2.4250+1.3;
chop_width = round(3*pulse_len*fs);

chopped_displacement = zeros(num_trials,3,num_pulses,chop_width);
chopped_velocity = zeros(num_trials,3,num_pulses,chop_width);

gateVoltage = zeros(num_pulses,num_trials);
inductorCurrent = zeros(num_pulses,num_trials);
displacement = zeros(num_pulses,num_trials); 
velocity = zeros(num_pulses,num_trials);  

for iter0 = 1:num_trials
    voltageData = displacementData.MeasurementSignal.signals{iter0};
    t = (1:size(voltageData,1))/fs;

    start_idx = find(voltageData(:,3) > 1, 1, 'first') - round(pulse_len*fs);
    period = (spacing+pulse_len)*fs;

    chop_idx = linspace(start_idx,start_idx+period*(num_pulses-1),num_pulses);

    for iter1 = 1:3
        for iter2 = 1:num_pulses
            chop = round(chop_idx(iter2));
            chopped_displacement(iter0,iter1,iter2,:) = voltageData(chop:chop+chop_width-1,iter1);
            if iter1 == 1
                chopped_displacement(iter0,iter1,iter2,:) = chopped_displacement(iter0,iter1,iter2,:)/.22;
            end
            if iter1 == 2
                chopped_displacement(iter0,iter1,iter2,:) = -(2.13)*(chopped_displacement(iter0,iter1,iter2,:)-chopped_displacement(iter0,iter1,iter2,1)) + 1.3;
            end
        end
    end

    voltageData = velocityData.MeasurementSignal.signals{iter0};

    start_idx = find(voltageData(:,3) > 1, 1, 'first') - round(pulse_len*fs);
    period = (spacing+pulse_len)*fs;

    chop_idx = linspace(start_idx,start_idx+period*(num_pulses-1),num_pulses);
    chop_width = round(3*pulse_len*fs);
    
    for iter1 = 1:3
        for iter2 = 1:num_pulses
            chop = round(chop_idx(iter2));
            chopped_velocity(iter0,iter1,iter2,:) = voltageData(chop:chop+chop_width-1,iter1);
            if iter1 == 1
                chopped_velocity(iter0,iter1,iter2,:) = chopped_velocity(iter0,iter1,iter2,:)/.22;
            end
            if iter1 == 2
                chopped_velocity(iter0,iter1,iter2,:) = 125*chopped_velocity(iter0,iter1,iter2,:);
            end
        end
    end
    
    for iter1 = 1:num_pulses
        flipped_iter = num_pulses-iter1+1;
        gateVoltage(iter1,iter0) = max(chopped_displacement(iter0,3,flipped_iter,:));
        inductorCurrent(iter1,iter0) = max(chopped_displacement(iter0,1,flipped_iter,:));
        displacement(iter1,iter0) = max(chopped_displacement(iter0,2,flipped_iter,:));
        velocity(iter1,iter0) = max(chopped_velocity(iter0,2,flipped_iter,round(end/3):round(2*end/3)));
    end
end

%% Plot Signals over Time
    
plot_idx = [22, 67, 73];
rep_idx = [3, 3, 3];
color = ["r","g","b"];
t_chop = t(1:chop_width);

figure;
for iter1 = 1:length(plot_idx)
    subplot(3,1,1);
    plot(t_chop,squeeze(chopped_displacement(rep_idx(iter1),1,plot_idx(iter1),:)),'Color',color(iter1));
    hold on;
    subplot(3,1,2);
    plot(t_chop,squeeze(chopped_displacement(rep_idx(iter1),2,plot_idx(iter1),:)),'Color',color(iter1));
    hold on;
    yline(contact_height)
    subplot(3,1,3);
    plot(t_chop,squeeze(chopped_velocity(rep_idx(iter1),2,plot_idx(iter1),:)),'Color',color(iter1));
    hold on;
end

%% Plot Max Signal with Light Intensity

valid_points = [10:80];
lux = 20*median(gateVoltage,2);

grayColor = [.7 .7 .7];

plot_idx = num_pulses-plot_idx+1;

figure;
for iter1 = 1:num_trials
    plot(lux(valid_points), inductorCurrent(valid_points,iter1),".",'Color',grayColor);
    hold on;
end
plot(lux(valid_points), median(inductorCurrent(valid_points,:),2),"k.");
for iter1 = 1:length(plot_idx)
    plot(lux(plot_idx(iter1)),inductorCurrent(plot_idx(iter1),rep_idx(iter1)),".",'Color',color(iter1));
end
xlabel("LED Intensity")
ylabel("Inductor Current (A)")

figure;
for iter1 = 1:num_trials
    plot(lux(valid_points), displacement(valid_points,iter1),".",'Color',grayColor);
    hold on;
end
plot(lux(valid_points), median(displacement(valid_points,:),2),"k.");
for iter1 = 1:length(plot_idx)
    plot(lux(plot_idx(iter1)),displacement(plot_idx(iter1),rep_idx(iter1)),".",'Color',color(iter1));
end
xlabel("LED Intensity")
ylabel("Displacement (mm)")

figure;
for iter1 = 1:num_trials
    plot(lux(valid_points), velocity(valid_points,iter1),".",'Color',grayColor);
    hold on;
end
plot(lux(valid_points), median(velocity(valid_points,:),2),"k.");
for iter1 = 1:length(plot_idx)
    plot(lux(plot_idx(iter1)),velocity(plot_idx(iter1),rep_idx(iter1)),".",'Color',color(iter1));
end
xlabel("LED Intensity")
ylabel("Velocity (mm/s)")