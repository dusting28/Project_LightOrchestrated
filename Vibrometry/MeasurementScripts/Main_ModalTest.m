%% LDV Measurements on EM Actuator 
% Written by Dustin Goetz
%------------------------------------------------------------------------
%% Load the params file - MAKE CHANGES IN PARAMS.M!
clc; clear; close all;
warning('off', 'all');

addpath(genpath(fullfile(pwd, '..', 'ParamsScripts')))
addpath(genpath(fullfile(pwd, '..', 'Utils')))
Params_Sinepulse;

%% Setup the NI measurement device
dev_num = 'Dev1';
daq_in = daq('ni');
daq_in.Rate = MeasurementSignal.fs;

analogInput = addinput(daq_in,dev_num,MeasurementSignal.ldvCh,'Voltage');
analogInput.TerminalConfig = 'Differential';
analogInput = addinput(daq_in,dev_num,MeasurementSignal.refCh,'Voltage');
analogInput.TerminalConfig = 'Differential';

%% MAIN LOOP
MeasurementSignal.RawVoltage = MeasurementLoop_ModalTest(MeasurementSignal,TestSignal,daq_in);

%% Save
save(strcat(filename,".mat"),'TestSignal','MeasurementSignal','-v7.3');