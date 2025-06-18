%% Dustin Goetz
format longg
clc; clearvars -except zero_force; close all;

%% Params
ForceData.fs = 10000; % Hz
ForceData.prePause = 1; % Sec
ForceData.pulseLen = 1/60; % Sec
ForceData.postPause = 2; % Sec
ForceData.numMeasurements = 25;
ForceData.spacing = 2500;
ForceData.spacing = ForceData.spacing * (1/10000);  % convert to mm
ForceData.triggerVoltage = [10];
ForceData.powerVoltage = 24;
ForceData.inductorID = "32";
ForceData.movingMass = "Magnet3x4"; % Magnet or Iron

%% NI Card Setup
dev_num = 'Dev1';
daq_in = daq('ni');
daq_in.Rate = ForceData.fs;

analogInput = addinput(daq_in,dev_num,"ai2",'Voltage');
analogInput.TerminalConfig = 'Differential';

daq_out = daq('ni');
daq_out.Rate = ForceData.fs;

linearStagePort = "Port0/Line0";
linearStageTrigger = addoutput(daq_out,dev_num,linearStagePort,'Digital');
analogOutput = addoutput(daq_out,dev_num,"ao0",'Voltage');


%% Set Up DC Power Supply
write(daq_out,[0,0])
input('Configure power supply. Press any key to continue: ', 's'); 

%% Zero Force Sensor
if not(exist('zero_force', 'var'))
    input('Press any key to zero force sensor: ', 's'); 
    record_length = 2*ForceData.fs;
    recordedData = read(daq_in,record_length,'OutputFormat','Matrix');
    zero_force = recordedData(:,1);
    zero_force = mean(zero_force);
end
input('Force sensor zeroed. Press any key to continue: ', 's'); 

%% Zero Linear Stage
fig = figure;
while ishandle(fig)
    % Move linear stage position until force probe is barely touching PCB
    record_length = 2*ForceData.fs;
    recordedData = read(daq_in,record_length,'OutputFormat','Matrix');
    force_data = recordedData(:,1);
    force = (2.5/5)*(1000*(force_data-zero_force));

    plot(movmean(force,100));
    drawnow;
    disp(strcat("Mean Force:", num2str(mean(force))))
end
close all;


%% Main Measurement Loop
ForceData.measurements = cell(length(ForceData.triggerVoltage),length(ForceData.numMeasurements));
for iter1 = 1:ForceData.numMeasurements
    % Take Measurements
    for iter2 = 1:length(ForceData.triggerVoltage)
        disp(strcat("Trial ",num2str(iter1),": ",num2str(ForceData.triggerVoltage(iter2)),"V"))
        write(daq_out,[0,0])
        recordedData1 = read(daq_in,round(ForceData.prePause*ForceData.fs),'OutputFormat','Matrix');
        write(daq_out,[0,ForceData.triggerVoltage(iter2)]);
        recordedData2 = read(daq_in,round(ForceData.pulseLen*ForceData.fs),'OutputFormat','Matrix');
        write(daq_out,[0,0])
        recordedData3 = read(daq_in,round(ForceData.postPause*ForceData.fs),'OutputFormat','Matrix');

        recordedData = [recordedData1(:,1); recordedData2(:,1); recordedData3(:,1)];
        force_data = 1000*(2.5/5)*(recordedData-zero_force);
        ForceData.measurements{iter1,iter2} = force_data;
        plot(movmean(force_data,50));
        hold on;
        write(daq_out,[0,0])
        pause(1)
    end
    hold off;

    % Move Linear Stage 
    write(daq_out,[1,0])
    pause(.5)
    write(daq_out,[0,0])
    pause(3)
end

save(strcat("PulsedBig_Inductor",ForceData.inductorID,"_",ForceData.movingMass,".mat"), "ForceData")
