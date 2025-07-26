%% Dustin Goetz
clc; clear; close all;
addpath("DAQ_Data")

%% Proportional Control
proportionalData = load(strcat("LCD_DecreasingPulses_SinglePixel.mat"));


plot(proportionalData.MeasurementSignal.signals{1,1}(:,3))

num_pulses = 100;
num_trials = proportionalData.MeasurementSignal.nReps;
fs = proportionalData.MeasurementSignal.fs;
pulse_len = .017;
spacing = .9992;
contact_height = 2.4250;

gateVoltage = zeros(num_pulses,num_trials);
inductorCurrent = zeros(num_pulses,num_trials);
displacement = zeros(num_pulses,num_trials); 
tactorEnergy = zeros(num_pulses,num_trials);  

valid_points = [10:80];

for iter0 = 1:num_trials
    voltageData = proportionalData.MeasurementSignal.signals{iter0};
    t = (1:size(voltageData,1))/fs;

    start_idx = find(voltageData(:,3) > 1, 1, 'first') - round(pulse_len*fs);
    period = (spacing+pulse_len)*fs;

    chop_idx = linspace(start_idx,start_idx+period*(num_pulses-1),num_pulses);
    chop_width = round(3*pulse_len*fs);
    
    chopped_data = zeros(3,num_pulses,chop_width);
    
    for iter1 = 1:3
        for iter2 = 1:num_pulses
            chop = round(chop_idx(iter2));
            chopped_data(iter1,iter2,:) = voltageData(chop:chop+chop_width-1,iter1);
            if iter1 == 1
                chopped_data(iter1,iter2,:) = chopped_data(iter1,iter2,:)/.22;
            end
            if iter1 == 2
                % chopped_data(iter1,iter2,:) = -(2.13)*(chopped_data(iter1,iter2,:)-chopped_data(iter1,iter2,1));
                chopped_data(iter1,iter2,:) = .125*chopped_data(iter1,iter2,:);
            end
        end
    end
    
    t_chop = t(1:chop_width);
    
    plot_idx = 5*(iter0-1)+50;
    
    figure;
    subplot(3,1,1);
    plot(t_chop,squeeze(chopped_data(3,plot_idx ,:)));
    subplot(3,1,2);
    plot(t_chop,squeeze(chopped_data(1,plot_idx ,:)));
    subplot(3,1,3);
    plot(t_chop,squeeze(chopped_data(2,plot_idx ,:)));
    yline(contact_height)
    
    delta_sample = 5;
    tactor_mass = ((1.5875*2.5^2*pi)*1.18 + (12.7*0.79375^2*pi)*1.41 + (4*1.5^2*pi)*7.01)*10^-3; %g
    
    for iter1 = 1:num_pulses
        flipped_iter = num_pulses-iter1+1;
        gateVoltage(iter1,iter0) = max(chopped_data(3,flipped_iter,:));
        inductorCurrent(iter1,iter0) = max(chopped_data(1,flipped_iter,:));
        finger_intercept = find(diff(sign(chopped_data(2,flipped_iter,:)-contact_height)));
        if finger_intercept
            velocity = fs*(chopped_data(2,flipped_iter,finger_intercept(1)+delta_sample)-...
                chopped_data(2,flipped_iter,finger_intercept(1)-delta_sample))/(2*delta_sample);
        else
            velocity = 0;
        end
        tactorEnergy(iter1,iter0) = (velocity/1000)^2*tactor_mass;
        displacement(iter1,iter0) = max(chopped_data(2,flipped_iter,:));
    end
end

figure;
for iter1 = 1:num_trials
    plot(gateVoltage(:,iter1),"k.");
    hold on;
end
plot(median(gateVoltage,2),"r.");
xlabel("LED Intensity*")
ylabel("Gate Voltage (V)")


lux = 20*median(gateVoltage(valid_points,:),2);

figure;
for iter1 = 1:num_trials
    plot(lux, inductorCurrent(valid_points,iter1),"k.");
    hold on;
end
plot(lux, median(inductorCurrent(valid_points,:),2),"r.");
xlabel("LED Intensity*")
ylabel("Inductor Current (A)")

figure;
for iter1 = 1:num_trials
    plot(lux, displacement(valid_points,iter1),"k.");
    hold on;
end
plot(lux, median(displacement(valid_points,:),2),"r.");
xlabel("LED Intensity*")
ylabel("Displacement (mm)")
