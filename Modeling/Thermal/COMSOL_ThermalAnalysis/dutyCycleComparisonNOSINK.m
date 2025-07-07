folderName = "COMSOL_ThermalData";

dutyCycles = 10:1:25; %enter spacings here

extractedValuesNOSINK = zeros(length(dutyCycles),4); %time constant, asym temp, max temp, failure time

pulseLength = 0.100/6; %s
failureTemp = 150;% C

for i = 1:length(dutyCycles)
    dutyCycle = dutyCycles(i); %0-100
    
    filename = strcat(folderName,'\NOSINKdutyCycle', num2str(dutyCycle), '.csv');
    data = readmatrix(filename);
    t=data(:,1);   
    coilTemp=data(:,3);
    
    dutyCycle=dutyCycle/100; %0-1
    spacing = (1-dutyCycle)*pulseLength/dutyCycle; %s

    period = pulseLength + spacing/1000; %ms

    index = find(coilTemp > failureTemp+273.15, 1, 'first');

    if ~isempty(index)
        failureTime = t(index);
    else
        failureTime = NaN;
    end
    
    chunkStarts = 0:period:max(t);
    maxes = zeros(length(chunkStarts),2);
    
        for j = 1:length(chunkStarts)
           chunkStart = chunkStarts(j);
           chunkEnd = chunkStart+period;
           [~, chunkStartIndex] = min(abs(t - chunkStart));
           [~, chunkEndIndex] = min(abs(t - chunkEnd));
            
           maxTemp = max(coilTemp(chunkStartIndex:chunkEndIndex));
           [~, maxTempIndex] = min(abs(coilTemp-maxTemp));
           maxTime = t(maxTempIndex);
    
           maxes(j,:) = [maxTime, maxTemp];
        end
    %-----fitting-------%
    
    heatingModel = fittype('T0 + A*(1 - exp(-x/tau))', ...
            'independent', 'x', 'coefficients', {'T0', 'A', 'tau'});
    
    T0_guess = coilTemp(1);  % Actual starting temp for this pulse
    A_guess = max(coilTemp) - T0_guess;
    tau_guess = 2;
    
    startPointsHeat = [T0_guess, A_guess, tau_guess];

    fitHeat = fit(maxes(:,1), maxes(:,2), heatingModel, ...
    'Start', startPointsHeat);
    
    timeConstant=fitHeat.tau;
    asymTemp = fitHeat.T0+fitHeat.A;
    maxTemp = max(coilTemp);
    
    extractedValuesNOSINK(i,:) = [timeConstant (asymTemp-273.15) (maxTemp-273.15) failureTime];

    %-----end fitting------%
    
    %---plot fits and raw data---%
    % figure;
    % hold on;
    % plot(t, coilTemp-273.15, 'DisplayName', ['raw data, max temp = ' num2str(maxTemp-273.15,3)]);
    % plot(maxes(:,1), fitHeat(maxes(:,1))-273.15, 'r-', 'DisplayName', ['exp fit, \tau = ' num2str(timeConstant, 3) ' s, asymptote temp = ' num2str(asymTemp-273.15, 3) ' C']);
    % yline(failureTemp,'DisplayName','failure point')
    % title(['temp vs t, duty cycle = '  num2str(dutyCycle*100, 2)]);
    % ylabel("temp, C")
    % xlabel("time, s")
    % legend('location', 'southeast');
end

%--plot extracted parameters--%
hold off;
figure;
scatter(dutyCycles, extractedValuesNOSINK(:,1), 'DisplayName', '\tau');
title('\tau (s) vs pulse spacing (s) (no sink)');
ylabel("\tau, s")
xlabel("duty cycle")

figure;
hold on;
scatter(dutyCycles, extractedValuesNOSINK(:,2), 'DisplayName', 'asymptote temp');
scatter(dutyCycles, extractedValuesNOSINK(:,3), 'DisplayName', 'max temp over 45s');
ylabel("temp, C")
xlabel("duty cycle")
legend('location','southwest')
title('no sink')

hold off;
figure;
hold on;
scatter(dutyCycles, extractedValues(:,4), 'DisplayName', 'with heatsink','Marker','.')
scatter(dutyCycles, extractedValuesNOSINK(:,4), 'DisplayName', 'no heatsink','Marker','.')
legend('location','northeast')
ylabel("failure time, s")
xlabel("duty cycle")
title('failure time vs duty cycle')