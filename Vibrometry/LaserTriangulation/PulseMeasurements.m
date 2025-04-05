%% LDV Measurements on EM Actuator 
% Written by Dustin Goetz
%------------------------------------------------------------------------
%% Load the params file - MAKE CHANGES IN PARAMS.M!
clc; clear; close all;
warning('off', 'all');

MeasurementSignal.nReps = 1;
MeasurementSignal.fs = 5000;
MeasurementSignal.len = 10;
MeasurementSignal.videoFile = "Default2";
MeasurementSignal.offset = 3.25; % mm

if MeasurementSignal.offset > 0
    topbottom = "Top";
else
    topbottom = "Bottom";
end

filename = strcat("Displacement_",MeasurementSignal.videoFile,"_",topbottom);

%% Setup the NI measurement device
dev_num = 'Dev1';
daq_in = daq('ni');
daq_in.Rate = MeasurementSignal.fs;

pulseInput = addinput(daq_in,dev_num,"ai0",'Voltage');
pulseInput.TerminalConfig = 'Differential';
laserInput = addinput(daq_in,dev_num,"ai1",'Voltage');
laserInput.TerminalConfig = 'Differential';

MeasurementSignal.signals = cell(MeasurementSignal.nReps,1);

for iter = 1:MeasurementSignal.nReps
    
    % Measure Response
    start(daq_in,'Duration',round(MeasurementSignal.len*MeasurementSignal.fs));
    pause(MeasurementSignal.len)
    recordedData = read(daq_in,'all','OutputFormat','Matrix');
    stop(daq_in);
   
    MeasurementSignal.signals{iter} = recordedData;
   
    figure(1);
    subplot(1,2,1);
    plot((1:size(recordedData,1))/MeasurementSignal.fs,recordedData(:,1));
    subplot(1,2,2);
    plot((1:size(recordedData,1))/MeasurementSignal.fs,recordedData(:,2));

    fprintf('Completed Trial %i\n',iter);
end

%% Save
save(strcat(filename,".mat"),'MeasurementSignal','-v7.3');