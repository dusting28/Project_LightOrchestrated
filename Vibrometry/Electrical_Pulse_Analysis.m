clc; clear; close all;

load("LightTouch_Proportional_10V.mat")

figure;
plot(readTimes,readValues(:,1)/.22)

figure;
plot(readTimes,readValues(:,2))

figure;
plot(readTimes,readValues(:,3))