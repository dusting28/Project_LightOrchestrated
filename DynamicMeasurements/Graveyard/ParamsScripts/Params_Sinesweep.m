%% Filename
filename = input('Enter the filename to save data: ', 's');

%% Measurement Info
MeasurementSignal.fs = 2500;
MeasurementSignal.ldvCh = "ai1"; % ldv channels on NI card
MeasurementSignal.refCh = "ai0"; % reference channels on NI card
MeasurementSignal.nRepetitions = 5;
MeasurementSignal.LDVScaleFactor = 25; % *Replace with velocity setting used on SLDV
MeasurementSignal.MotuScaleFactor = 13.33; % 30 Volt per MOTU Volt (1-1) (might be different if you measure with audio interface)
MeasurementSignal.MeasurementType = 'LDV_SinglePoint'; %'Single-Point vs SLDV';

%% Test Signal

% signal params
TestSignal.fs = 48000;
TestSignal.refChannel = 1; %channel in which reference signal is connected
TestSignal.refVoltage = 0.5; % 0.1 volt ref
TestSignal.nActuators = 1; %number of actuators (not including reference)
% TestSignal.PeakAmp = 2.45*0.25; %peak amp
TestSignal.PeakAmp = .8*.25;
TestSignal.delay = 2; %time before stim start and end
TestSignal.bitDepth = 24; %bit depth of signal sent to Max
TestSignal.udpmessage = 'sweep';

TestSignal.f0 = 1; %start frequency
TestSignal.f1 = 500; %end frequency
TestSignal.sigLength = 10; % signal length in seconds
TestSignal.sweepType = 'linear'; %type of sine sweep ('log' or 'linear')
TestSignal.winLen = round(.1*TestSignal.fs); %20000 sample window ramp in/ramp out (10k each)

% generate test signal
TestSignal.y  = sineSweep(TestSignal.f0, TestSignal.f1, TestSignal.sigLength,...
    TestSignal.fs, TestSignal.sweepType, TestSignal.winLen); 

% add multiple actuators and reference Ch
TestSignal.piezoSignals = PiezoSequentialSignal(TestSignal.y, TestSignal.nActuators,...
    TestSignal.delay, TestSignal.fs, TestSignal.PeakAmp, TestSignal.refVoltage);

%% generate max test signals
%construct .wav file 
parentDir = fileparts(pwd);
fullPath = fullfile(parentDir, 'Utils', 'MaxUtils', 'LightOrchestrated.wav');
audiowrite(fullPath, TestSignal.piezoSignals, TestSignal.fs, 'BitsPerSample', TestSignal.bitDepth);
%GenerateTestSignals_9_2(fullPath, TestSignal.piezoSignals, TestSignal.fs, TestSignal.bitDepth, TestSignal.actuatorChannels);

%send message to max to load signal into buffer
MaxMSPLoadTestSignals('sweep');


