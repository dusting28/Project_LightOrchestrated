%% Generate a test signal for the piezo array
% Written by Gregory Reardon (reardon@ucbs.edu)

function yOut = PiezoSequentialSignal(yIn, nActuators, delta, fs, peakAmp, optRefVoltage)
%----------------------------------------------------------
% inputs:
%       yIn (array): test signal to be played through each piezo
%       nActuators (int): number of piezo actuators in array
%       delta (float): time between each test signal (in seconds)
%       fs (int): sa mpling rate
%       peakAmp (float): peak amplitude of driving signal (in volts)
%                    piezo amp multiplies this by 15...
%       optDC (float): add optional DC offset to output Signal
% outputs:
%       yOut (2D array): test signal to be played to the piezo actuators
%----------------------------------------------------------

    nSamps = length(yIn); %number of samples per test signal
    nDelta = delta*fs; %number of samples between each test signal
    signalIncrement = nSamps+nDelta;
    
    yOut = zeros(nDelta+signalIncrement*nActuators, nActuators+1); % Bipolar (updated on 09/23/2019)
    
    s = 0;
    for i = 2:nActuators+1
        yOut(s+nDelta:s+nSamps+nDelta-1,i) = yIn*peakAmp; % Bipolar (updated on 09/23/2019)    
        s = s+signalIncrement;
    end
    
    % optional reference voltage
    if exist('optRefVoltage','var')
        refVoltage = optRefVoltage;
    else
        refVoltage = 0.2;
    end
    
    %reference pulses
    yOut(:,1) = 0;
    refInd = nDelta+(signalIncrement*(0:nActuators-1));
    for i = 1:length(refInd)
        yOut(refInd(i):refInd(i)+500,1) = refVoltage; % one reference pulse for each actuator
    end

end
