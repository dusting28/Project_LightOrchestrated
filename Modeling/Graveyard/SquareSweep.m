%% Dustin Goetz
format longg
clc; clearvars -except zero_force; close all;

%% Params
f1 = 10;
f2 = 60;
fs = 10000; % Hz
len = 10; % Sec

%% NI Card Setup
dev_num = 'Dev1';

daq_out = daq('ni');
daq_out.Rate = fs;

polarityPort1 = "Port0/Line1";
polarityPort2 = "Port0/Line2";
polarityPort3 = "Port0/Line3";
polarityPort4 = "Port0/Line4";
polarityTrigger1 = addoutput(daq_out,dev_num,polarityPort1,'Digital');
polarityTrigger2 = addoutput(daq_out,dev_num,polarityPort2,'Digital');
polarityTrigger3 = addoutput(daq_out,dev_num,polarityPort3,'Digital');
polarityTrigger4 = addoutput(daq_out,dev_num,polarityPort4,'Digital');

%% Set Up DC Power Supply
write(daq_out,[0,0,0,0])
input('Configure power supply. Press any key to continue: ', 's'); 

%% Generate Square Wave Sweep
t = linspace(0, len, len*fs);
fSweep = linspace(f1, f2, length(t));
signal = zeros(length(t),4);
positive = [1,1,0,0];
negative = [0,0,1,1];

periodCount = 0;
polarityCount = 0;
changeIdx = [];
for iter1 = 1:length(t)
    if periodCount <= 0
        periodCount = fs/fSweep(iter1)/2;
        polarityCount = polarityCount+1;
        changeIdx = [changeIdx, iter1];
    end

    if mod(polarityCount,2)
        signal(iter1,:) = positive;
    else
        signal(iter1,:) = negative;
    end
    periodCount = periodCount-1;
end

%% Plot Signal
figure;
subplot(2,1,1)
plot(t,signal(:,end))
subplot(2,1,2)
plot(t,signal(:,end-2))

figure;
spectrogram(signal(:,end)-signal(:,end-2), hamming(1280), 640, 5120, fs)
xlim([0,.5])

%% Output Signal to NI Card
tic
for iter1 = 1:length(changeIdx)
    triggerTime = t(changeIdx(iter1));
    while toc < triggerTime
        % Blocking Command
    end  
    write(daq_out, signal(changeIdx(iter1),:));
end
while toc < len
     % Blocking Command
end 
write(daq_out,[0,0,0,0])
toc
