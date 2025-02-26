%% Series of sinusoidal or square wave pulses

% Written by Dustin Goetz (dgoetz@ucsb.edu) - 10/6/2025
function y = pulseTrain(fs, freqs, nCycles, pulseGap, pulseType)

    nPulses = length(freqs);
    pulseLens = round(nCycles.*fs./freqs);
    sigLen = sum(pulseLens) + (nPulses-1)*round(pulseGap*fs);
    y = zeros(1,sigLen);
    
    idx = 0;
    for iter1 = 1:nPulses
        t = (0:pulseLens(iter1)-1)/fs;
        if strcmp(pulseType,"Sine")
            pulse = sin(2*pi*freqs(iter1)*t);
        elseif strcmp(pulseType,"Square")
            pulse = square(2*pi*freqs(iter1)*t);  
        else
            pulse = 0*t;
        end
        y(idx+1:idx+pulseLens(iter1)) = pulse;

        idx = idx+pulseLens(iter1)+pulseGap*fs-1;
    end
    
    plot(y);

end