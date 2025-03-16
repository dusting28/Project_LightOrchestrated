%% Dustin Goetz
clear; clc; close all;

% Flat and Corrugated Diaphragm Design Handbook by Mario Giovanni

force = 0:.001:5;
hole_rad = (7/2)*(10^-3);
shaft_rad = (4/2)*(10^-3);

% Marian HT-6210 Extra Soft Silicone: https://www.rogerscorp.com/elastomeric-material-solutions/bisco-silicones/bisco-ht-6000-series-performance-solid-silicones
% membrane_thickness = 0.381*(10^-3);
% elasticity = 0.584*(10^6);
% poisson = .5;

% McMaster - 8611K222: https://www.mcmaster.com/8611K222/
membrane_thickness = 0.305*(10^-3);%0.254*(10^-3); %0.1524*(10^-3);
elasticity = 3*(10^6);
poisson = .5;

solidarity_ratio = hole_rad/shaft_rad;

k = ((hole_rad^2/(elasticity*membrane_thickness^3))*...
    (3*(1-poisson^2)/pi)*((solidarity_ratio^2-1)/(4*solidarity_ratio^2)...
    -(log(solidarity_ratio)^2)/(solidarity_ratio^2-1)))^(-1);

displacement = force/k;

figure;
plot(displacement*1000,force)