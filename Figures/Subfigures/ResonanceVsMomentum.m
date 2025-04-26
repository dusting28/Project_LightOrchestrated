clear; clc; close all;

%% Resonant System

% System Parameters (underdamped)
wn = 50;              % Natural frequency (rad/s)
zeta = 0.1;           % Damping ratio (underdamped: 0 < zeta < 1)
T_pulse = 0.2;        % Pulse duration (s)
t_start = 1.0;        % Pulse starts at t = 1s

% Time vector
t = linspace(0, 2, 1000);  % Time from 0 to 2s

% Square pulse input starting at t = 1s
u = double((t >= t_start) & (t < t_start + T_pulse));

% Transfer function of second-order system
num = [wn^2];
den = [1 2*zeta*wn wn^2];
sys = tf(num, den);

% System response to the square pulse
y = lsim(sys, u, t);

% Plotting
figure;

% Subplot 1: Input pulse
subplot(2,1,1);
plot(t, u, 'r', 'LineWidth', 2);
ylabel('Input');
title('Square Pulse Input');
grid on;

% Subplot 2: System response
subplot(2,1,2);
plot(t, y, 'b', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Response');
title('Underdamped System Response');
grid on;

%% Momentum Based System
% Parameters
dt = 0.0005;            % Time step (s)
t_end = 2;              % Total simulation time (s)
t = 0:dt:t_end;

% Mass and general parameters
m = 2*10^-4;                % mass (kg)
a_input = 80;           % upward acceleration during pulse (m/s^2)
g = 9.81;               % gravity (m/s^2)
pulse_on = @(t) (t >= 1.0) & (t < 1.2);  % pulse active from 1s to 1.2s

% Stroke limits
h_bottom = 0.0;
h_top = 0.005;

% Spring properties
k_top = 0.1;             % Softer top spring (N/m)
c_top = 0.005;            % More damping at top (N·s/m)

k_bottom = 0.5;         % Stiffer bottom spring (N/m)
c_bottom = 0.002;         % Less damping at bottom (N·s/m)

% Initial conditions
x = ones(size(t))*g*m/k_bottom;     % position
v = zeros(size(t));     % velocity

% Simulation loop
for i = 2:length(t)
    x_curr = x(i-1);
    v_curr = v(i-1);

    a = 0;

    % Override with spring force if at limits
    if x_curr >= h_top
        F_spring = -k_top * (x_curr - h_top) - c_top * v_curr;
        a = F_spring / m;
    elseif x_curr <= h_bottom
        F_spring = -k_bottom * (x_curr - h_bottom) - c_bottom * v_curr;
        a = F_spring / m;
    end

    % Default acceleration
    if pulse_on(t(i))
        a = a + a_input;
    else
        a = a - g;
    end

    % Euler integration
    v(i) = v_curr + a * dt;
    x(i) = x_curr + v(i) * dt;
end

% Plotting
figure;

subplot(2,1,1);
plot(t, double(pulse_on(t)), 'r', 'LineWidth', 1.5);
ylabel('Input Pulse');
xlabel('Time (s)');
grid on;

subplot(2,1,2);
plot(t, x, 'b', 'LineWidth', 1.5);
ylabel('Position (m)');
title('Nonlinear Mass-Spring Response (Asymmetric Springs)');
grid on;