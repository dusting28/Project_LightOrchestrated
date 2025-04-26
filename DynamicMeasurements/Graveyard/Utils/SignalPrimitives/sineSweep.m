%% Generates a sine sweep test signal
% Written by Gregory Reardon (reardon@ucsb.edu)

function y = sineSweep(f0, f1, T, fs, type, winLen)
%----------------------------------------
% inputs:
%       f0 (int): start frequency
%       f1 (int): end frequency
%       T (float): length of signal (in seconds)
%       fs (int): sampling rate
%       type (string): either 'log' or 'linear' for type of sine sweep
%                      desired
% outputs:
%       y (array): time-domain sine sweep signal
%----------------------------------------

% Equations from: IMPULSE RESPONSE MEASUREMENT WITH SINE SWEEPS AND AMPLITUDE
% MODULATION SCHEMES - Meng, Sen, Wang, and Hayes

if nargin < 6
    winLen = 10000;
end

t = (0:(fs*T)-1) / fs;
w1 = 2*pi*f0;
w2 = 2*pi*f1;

% sine sweep equations
if strcmp(type,'log')    
    K = (T * w1) / log(w2/w1);
    L = T / log(w2/w1);
    y = sin(K * (exp(t/L)-1));
elseif strcmp(type,'linear')
    y = sin(w1*t + (((w2 - w1)/T) * (t.^2 / 2)));
else
    error('Sweep Type not recognized, expects log or linear. See SineSweep.m'); 
end

win = hanning(winLen);
if (mod(winLen,2) ~= 0) 
    error('Window length must be even');
end
halfWinLen = winLen/2;
y(1:halfWinLen) = y(1:halfWinLen).*win(1:halfWinLen)';
y(end-halfWinLen+1:end) = y(end-halfWinLen+1:end).*win(halfWinLen+1:end)';

end