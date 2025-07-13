% Set random seed for reproducibility
rng(42);  % Change the number to get a different sequence

% Parameters
fs = 1000;              % Sampling frequency (Hz)
T = 2;                  % Duration (seconds)
t = 0:1/fs:T-1/fs;      % Time vector
n = length(t);          % Number of samples

nSignals = 5;           % Number of signals
yOffset = 12;           % Vertical offset between signals

nPulses = 10;                       % Number of square pulses per signal
minWidth = 0.01; maxWidth = 0.1;    % Pulse width range (seconds)
minAmp = 1; maxAmp = 5;             % Pulse amplitude range
noiseLevel = 0.2/2;                   % Noise amplitude

% Generate and plot signals
figure; hold on;
for s = 1:nSignals
    signal = zeros(size(t));
    
    % Generate random pulse positions, widths, and amplitudes
    pulseStarts = sort(rand(1, nPulses) * (T - maxWidth));
    pulseWidths = minWidth + rand(1, nPulses) * (maxWidth - minWidth);
    pulseAmps = minAmp + rand(1, nPulses) * (maxAmp - minAmp);

    % Construct pulses
    for k = 1:nPulses
        idx = t >= pulseStarts(k) & t < (pulseStarts(k) + pulseWidths(k));
        signal(idx) = signal(idx) + pulseAmps(k);
    end

    % Add noise and vertical offset
    noisySignal = signal + noiseLevel * randn(size(signal)) + (s - 1) * yOffset;

    % Plot in black
    plot(t, noisySignal, 'k', 'LineWidth', 1.2);
end

xlabel('Time (s)');
ylabel('Amplitude + Offset');
title('Random Square Pulse Signals (Reproducible)');
