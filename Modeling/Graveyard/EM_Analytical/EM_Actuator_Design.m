%% By Dustin Goetz
close all
clc
clear

%% Old Design
coil_radius = .5/2;
coil_height = .4;
gap = .175;
gap = gap - coil_height/2; % Assume no loss in core
magnet_radius = .5/2;
magnet_height = .2;
current = .13;
turns = 100;

force = EM_force(coil_radius,coil_height,magnet_radius,magnet_height,gap,turns,current);