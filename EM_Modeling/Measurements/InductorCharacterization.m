%% Dustin Goetz
format longg
clc; clearvars -except zero_force; close all;

%% Params
ForceData.fs = 10000; % Hz
ForceData.len = 7; % Sec
ForceData.numMeasurements = 30;
ForceData.spacing = 500;
ForceData.spacing = ForceData.spacing * (1/10000);  % convert to mm
ForceData.polarity = ["None", "Positive", "Negative"];
ForceData.current = .35;
ForceData.inductorID = "11";
ForceData.movingMass = "Iron"; % Magnet or Iron

%% NI Card Setup
dev_num = 'Dev1';
daq_in = daq('ni');
daq_in.Rate = ForceData.fs;

analogInput = addinput(daq_in,dev_num,"ai0",'Voltage');
analogInput.TerminalConfig = 'Differential';

daq_out = daq('ni');
daq_out.Rate = ForceData.fs;

linearStagePort = "Port0/Line0";
polarityPort1 = "Port0/Line1";
polarityPort2 = "Port0/Line2";
polarityPort3 = "Port0/Line3";
polarityPort4 = "Port0/Line4";
linearStageTrigger = addoutput(daq_out,dev_num,linearStagePort,'Digital');
polarityTrigger1 = addoutput(daq_out,dev_num,polarityPort1,'Digital');
polarityTrigger2 = addoutput(daq_out,dev_num,polarityPort2,'Digital');
polarityTrigger3 = addoutput(daq_out,dev_num,polarityPort3,'Digital');
polarityTrigger4 = addoutput(daq_out,dev_num,polarityPort4,'Digital');

%% Set Up DC Power Supply
write(daq_out,[0,0,0,1,1])
input('Configure power supply. Press any key to continue: ', 's'); 
write(daq_out,[0,0,0,0,0])

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
digitOutput = [0,0,0,0,0; 0,1,1,0,0; 0,0,0,1,1];
ForceData.measurements = cell(length(ForceData.polarity),length(ForceData.numMeasurements));
for iter1 = 1:ForceData.numMeasurements
    % Take Measurements
    for iter2 = 1:3
        write(daq_out,digitOutput(iter2,:))
        disp(strcat("Trial ",num2str(iter1),": ",ForceData.polarity(iter2)))
        recordedData = read(daq_in,ForceData.len*ForceData.fs,'OutputFormat','Matrix');
        force_data = 1000*(2.5/5)*(recordedData(:,1)-zero_force);
        ForceData.measurements{iter1,iter2} = force_data;
        plot(movmean(force_data,1000));
        hold on;
        write(daq_out,[0,0,0,0,0])
        pause(5)
    end
    hold off;

    % Move Linear Stage 
    write(daq_out,[1,0,0,0,0])
    pause(.5)
    write(daq_out,[0,0,0,0,0])
    pause(1)
end

save(strcat("Inductor",ForceData.inductorID,"_",ForceData.movingMass,".mat"), "ForceData")
