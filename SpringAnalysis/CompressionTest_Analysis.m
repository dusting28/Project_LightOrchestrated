load("Elastomer_CompressionTest1.mat")

x = (0:ForceData.numMeasurements-1)*ForceData.spacing;
force = zeros(length(x),1);
for iter1 = 1:length(x)
    force(iter1) = mean(ForceData.measurements{iter1});
end

plot(x,force);
hold on;

load("Elastomer_CompressionTest2.mat")

x = (0:ForceData.numMeasurements-1)*ForceData.spacing;
force = zeros(length(x),1);
for iter1 = 1:length(x)
    force(iter1) = mean(ForceData.measurements{iter1});
end

plot(x,force);

load("Elastomer_CompressionTest3.mat")

x = (0:ForceData.numMeasurements-1)*ForceData.spacing;
force = zeros(length(x),1);
for iter1 = 1:length(x)
    force(iter1) = mean(ForceData.measurements{iter1});
end

plot(x,force);

load("Elastomer_CompressionTest.mat")

x = (0:ForceData.numMeasurements-1)*ForceData.spacing;
force = zeros(length(x),1);
for iter1 = 1:length(x)
    force(iter1) = mean(ForceData.measurements{iter1});
end

plot(x,force);