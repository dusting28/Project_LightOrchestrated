displacementData = load("Displacement_Default2_Top.mat");

t = (1:size(displacementData.MeasurementSignal.signals{1},1))/displacementData.MeasurementSignal.fs;

figure;
plot(t(1:3001),displacementData.MeasurementSignal.signals{1}(21575:24575,2))
hold on;
plot(t(1:3001),displacementData.MeasurementSignal.signals{1}(47000:50000,2))
