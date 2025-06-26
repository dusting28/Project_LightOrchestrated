MeasurementSignal.pulseLen = .5;
for iter = 11
    disp(strcat("Trial ", num2str(iter), ": ", num2str(1000*(MeasurementSignal.pulseLen+(iter-1)*MeasurementSignal.pulseRamp)),"ms Pulse"));
    recordedData=MeasurementSignal.signals{iter};
   
    figure;
    ts = (1:length(recordedData))/MeasurementSignal.fs;
    currents = recordedData(:,1)/.22;
    plot(ts,currents)
    title(['trial # = '  num2str(iter) ]);
  
    fprintf('Completed Trial %i\n',iter);
    
    rs = 20./currents(48231:52033);
    rRef = 4.558;
    tempRef = 0;
    alpha = 0.0081;

    tempts = ts(1:3803);%ts(48231:52033);
    
    simData = readmatrix('750pulse.csv');
    
    figure;
    hold on;
    temps = tempRef+(1/alpha)*((rs/rRef)-1);
    plot(tempts,temps+simData(1,3)-273.15,'DisplayName', 'experimental')
    plot(simData(1:900,1),simData(1:900,3)-273.15,'DisplayName', 'simulation');

    ylabel("temp, C")
    xlabel("time, s")
    legend('location', 'southeast');
end