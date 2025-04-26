%% By: Dustin Goetz
clear; clc, close all;

% Params
freq = 0:500;
omega = freq*2*pi;
mass = 8*(10^(-6));
stiffness = 12.4;
damping_ratio = [0, .2, .5]; 
damping = damping_ratio*2*(mass*stiffness)^.5;

figure;
x = zeros(length(damping),length(freq));
iter1 = 0;
for c = damping
    iter1 = iter1+1;
    x(iter1,:) = abs(.4./(-8*10^(-6)*omega.^2 + 1i*c*omega + 12.4));
    plot(freq,x(iter1,:))
    hold on;
end
hold off;

ylim([0,0.5]);
title("Frequency Response")
xlabel("Frequency (Hz)")
ylabel("Oscillation Amplitude (mm)")
legend("Damping Ratio = 0", "Damping Ratio = 0.2", "Damping Ratio = 0.5")