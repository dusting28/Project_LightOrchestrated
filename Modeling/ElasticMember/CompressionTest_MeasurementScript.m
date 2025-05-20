%% Dustin Goetz
format longg
clc; clearvars -except zero_force; close all;

%% Params
ForceData.fs = 10000; % Hz
ForceData.measLen = 1; % Sec
ForceData.numMeasurements = 20;
ForceData.spacing = 500; % Linear Stage Value
ForceData.spacing = ForceData.spacing * (1/10000);  % convert to mm

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
ForceData.measurements = cell(length(ForceData.numMeasurements));
for iter1 = 1:ForceData.numMeasurements
    
    % Take Measurements
    disp(strcat("Trial ",num2str(iter1)))
    recordedData = read(daq_in,round(ForceData.measLen*ForceData.fs),'OutputFormat','Matrix');

    force_data = 1000*(2.5/5)*(recordedData-zero_force);
    ForceData.measurements{iter1} = force_data;
    plot(movmean(force_data,50));
    hold on;
    write(daq_out,[0,0])
    pause(1)
    hold off;

    % Move Linear Stage 
    write(daq_out,[1,0])
    pause(.5)
    write(daq_out,[0,0])
    pause(3)
end

save("Elastomer_1.5mm_CompressionTest.mat", "ForceData")