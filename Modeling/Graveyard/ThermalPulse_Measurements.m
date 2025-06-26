%% LDV Measurements on EM Actuator 
% Written by Dustin Goetz
%------------------------------------------------------------------------
%% Load the params file - MAKE CHANGES IN PARAMS.M!
clc; clear; close all;
warning('off', 'all');

MeasurementSignal.nReps = 50;
MeasurementSignal.pulseLen = .5;
MeasurementSignal.pulseRamp = .025;
MeasurementSignal.fs = 5000;
MeasurementSignal.len = 30;
% MeasurementSignal.videoFile = "LED_Pulse";
filename = "ThermalPulse_HeatSink_500ms";

% filename = strcat("Displacement_",MeasurementSignal.videoFile);

%% Setup the NI measurement device
dev_num = 'Dev1';
daq_in = daq('ni');
daq_in.Rate = MeasurementSignal.fs;

pulseInput = addinput(daq_in,dev_num,"ai0",'Voltage');
pulseInput.TerminalConfig = 'Differential';

MeasurementSignal.signals = cell(MeasurementSignal.nReps,1);

for iter = 1:MeasurementSignal.nReps
    disp(strcat("Trial ", num2str(iter), ": ", num2str(1000*(MeasurementSignal.pulseLen+(iter-1)*MeasurementSignal.pulseRamp)),"ms Pulse"));

    % Measure Response
    start(daq_in,'Duration',round(MeasurementSignal.len*MeasurementSignal.fs));
    pause(MeasurementSignal.len)
    recordedData = read(daq_in,'all','OutputFormat','Matrix');
    stop(daq_in);
   
    MeasurementSignal.signals{iter} = recordedData;
   
    figure(1);
    plot((1:length(recordedData))/MeasurementSignal.fs,recordedData(:,1)/.22);

    save(strcat(filename,".mat"), 'MeasurementSignal');

    fprintf('Completed Trial %i\n',iter);

    pause(90)

end