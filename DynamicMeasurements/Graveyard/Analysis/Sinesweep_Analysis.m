clc; clear; close all;

addpath(fullfile('..', 'Data'));

actuator = "10mm";
filename = strcat("Sinesweep_",actuator,".mat");

vibrometry_data = load(filename);

[signal_matrix,t] = chopSignals(vibrometry_data.MeasurementSignal.RawVoltage,...
    vibrometry_data.MeasurementSignal.fs, 1.05*vibrometry_data.TestSignal.sigLength,...
    2,vibrometry_data.TestSignal.nActuators, vibrometry_data.MeasurementSignal.LDVScaleFactor);

for iter1 = 1:size(signal_matrix,1)
    figure;
    for iter2 = 1:size(signal_matrix,2)
        plot(squeeze(signal_matrix(iter1,iter2,:)));
        hold on;
    end
    hold off;
end

mean_signal = squeeze(mean(signal_matrix,2));
figure;
plot(t,mean_signal);

lower_freq = 20;
upper_freq = 500;

[freq,coef] = fft_spectral(mean_signal,vibrometry_data.MeasurementSignal.fs);
[~,lower_idx] = min(abs(freq-lower_freq));
[~,upper_idx] = min(abs(freq-upper_freq));
scaling_factor = max(mean_signal)/max(abs(coef(lower_idx:upper_idx)));
figure;
semilogy(freq,scaling_factor*abs(coef));
figure;
plot(freq,1000*scaling_factor*abs(coef)./(2*pi*freq));
xlabel("Frequency (Hz)")
ylabel("Oscillation Amplitude (microns)")

xlim([lower_freq, upper_freq]);
