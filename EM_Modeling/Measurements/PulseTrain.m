%% Dustin Goetz
format longg
clc; clear; close all;

%% Params
pulseLen = 1/60;
dutyCycle = .05;
fs = 5000; % Hz
len = 10; % Sec
triggerAmp = 10; % V

%% NI Card Setup
dev_num = 'Dev1';

daq_out = daq('ni');
daq_out.Rate = fs;

analogOutput = addoutput(daq_out,dev_num,"ao0",'Voltage');

%% Set Up DC Power Supply
write(daq_out,0)
input('Configure power supply. Press any key to continue: ', 's'); 

%% Generate Square Wave Sweep
t = linspace(0, len, len*fs);
signal = zeros(length(t),1);

cycleLen = round((pulseLen/dutyCycle)*fs);
changeIdx = [];
for iter1 = 1:length(t)
    if mod(iter1,cycleLen) < round(pulseLen*fs) 
        signal(iter1,:) = triggerAmp;
    end
    if or(mod(iter1,cycleLen) == 1, mod(iter1,cycleLen) == round(pulseLen*fs))
        changeIdx = [changeIdx, iter1];
    end
end

%% Plot Signal
figure;
plot(t,signal)

figure;
spectrogram(signal, hamming(1280), 640, 5120, fs)
xlim([0,.5])

%% Output Signal to NI Card
tic
for iter1 = 1:length(changeIdx)
    triggerTime = t(changeIdx(iter1));
    while toc < triggerTime
        % Blocking Command
    end  
    write(daq_out, signal(changeIdx(iter1)));
end
while toc < len
     % Blocking Command
end 
write(daq_out,0)
toc
