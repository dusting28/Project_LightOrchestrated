function [signals] = MeasurementLoop_ModalTest(MeasurementSignal, TestSignal, daq_in)
    
    %% Changed by Dustin
    u = udp('127.0.0.1',8000);  
    fopen(u);
    
    signals = cell(MeasurementSignal.nRepetitions,1);

    for j = 1:MeasurementSignal.nRepetitions
        
        %send udp message to Max
        oscsend(u, '/sigType','s', TestSignal.udpmessage);
        
        % Measure Response
        duration = size(TestSignal.piezoSignals,1)/TestSignal.fs; %TestSignal.sigLength+2*TestSignal.delay;
        start(daq_in,'Duration',round(duration*MeasurementSignal.fs));
        pause(duration)
        recordedData = read(daq_in,'all','OutputFormat','Matrix');
        stop(daq_in);
       
        signals{j} = recordedData;
       
        figure(1);
        subplot(1,2,1);
        plot((1:size(recordedData,1))/MeasurementSignal.fs,recordedData(:,1));
        subplot(1,2,2);
        plot((1:size(recordedData,1))/MeasurementSignal.fs,recordedData(:,2));

        fprintf('Completed Trial %i\n',j);
    end
    
    fclose(u);
    
end

