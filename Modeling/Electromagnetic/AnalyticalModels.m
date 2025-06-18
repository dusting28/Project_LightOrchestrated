%% Dustin Goetz
clc; clear; close all;

%% Parameters
n_c = 170; % turns
B_r = 1.32; % T
mu = 1.26*(10^-6); % H/m
M = B_r/mu;
r_m = 1.5 * (10^-3); % m
r_c = 1.825 * (10^-3); % m
h_m = 4 *(10^-3); % m
h_c = 3.55 *(10^-3); % m
z_0 = 4.275 *(10^-3); % m
z = linspace(.25,6,100) * (10^-3);
I = 4.6; % A

%% Magnet-Coil Force
F_coil = -(.5*mu*n_c*M*pi*r_m^2*I)*((z+z_0+h_c/2+h_m/2)./((z+z_0+h_c/2+h_m/2).^2 + r_c^2).^.5 - ...
    (z+z_0+h_c/2-h_m/2)./((z+z_0+h_c/2-h_m/2).^2 + r_c^2).^.5 - ...
    (z+z_0-h_c/2+h_m/2)./((z+z_0-h_c/2+h_m/2).^2 + r_c^2).^.5 + ...
    (z+z_0-h_c/2-h_m/2)./((z+z_0-h_c/2-h_m/2).^2 + r_c^2).^.5); 

%% Magnet-Core Force
F_core = -((1/8)*mu*M^2*pi*r_m^2) * ((z+h_m)./((z+h_m).^2+r_m^2).^.5 - z./(z.^2+r_m^2).^.5).^2;


%% Figures
figure;
plot(z*10^3, F_coil);

figure;
plot(z*10^3, F_core);
