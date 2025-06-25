%% By: Dustin Goetz
clear; clc, close all;
addpath("Electromagnetic/COMSOL/EM_COMSOL_Data")
addpath("Electromagnetic/Measurements/EM_Measurement_Data")
addpath("ElasticMember/Elastic_COMSOL_Data")
addpath("ElasticMember/Elastic_Measurement_Data")

%% Filenames
COMSOL_EM = "LightTouch_Unshielded_CurrentSweep";
Measured_EM = "PulsedBig_Inductor32_MagnetD1020";
COMSOL_Elastic = "CompressionTest_Ecoflex10_1.5mm";
Measured_Elastic = "Elastomer_1.5mm_CompressionTest";

%% Stroke
x_spacing = 0.05;
x = 1:x_spacing:6;
elasticHeight = 1.5;

%% EM Forces
EM_COMSOL_Data = readmatrix(strcat("Electromagnetic/COMSOL/EM_COMSOL_Data/",COMSOL_EM,".csv"));
numCurrent = 47;
off_idx = 1;
on_idx = numCurrent;
EM_x = EM_COMSOL_Data(1:numCurrent:end,1);
COMSOL_core_force = 1000*EM_COMSOL_Data(off_idx:numCurrent:end,3)';
COMSOL_core_force = interp1(EM_x,COMSOL_core_force,x);
COMSOL_coil_force = 1000*EM_COMSOL_Data(on_idx:numCurrent:end,3)' - 1000*EM_COMSOL_Data(off_idx:numCurrent:end,3)';
COMSOL_coil_force = interp1(EM_x,COMSOL_coil_force,x);

EM_Measured_Data = load(strcat("Electromagnetic/Measurements/EM_Measurement_Data/",Measured_EM,".mat"));
EM_x = (0:EM_Measured_Data.ForceData.numMeasurements-1)*EM_Measured_Data.ForceData.spacing;
Measured_coil_force = zeros(length(EM_x),1);
Measured_core_force = zeros(length(EM_x),1);
for iter2 = 1:size(EM_Measured_Data.ForceData.measurements,1)
    initialForce = median(EM_Measured_Data.ForceData.measurements{iter2,1}(1:5000));
    maxForce = max(EM_Measured_Data.ForceData.measurements{iter2,1}(10005:10165));
    minForce = min(EM_Measured_Data.ForceData.measurements{iter2,1}(10005:10165));
    Measured_core_force(iter2) = initialForce;
    Measured_coil_force(iter2) = (maxForce+minForce)/2-initialForce;
end
Measured_core_force = interp1(EM_x,Measured_core_force,x);
Measured_coil_force = interp1(EM_x,Measured_coil_force,x);

%% Spring Force
elastic_idx = (elasticHeight-x(1))/x_spacing + 1;
elastic_force = zeros(1,length(x));
area = (10^-6)*(pi*(3/2)^2);
lambda = x(1:elastic_idx-1)/elasticHeight;

k_elastic = (.5*(1278+80.28)*10^3)*area/(1.5*10^-3);
elastic_force(1:elastic_idx-1) = k_elastic*(elasticHeight-x(1:elastic_idx-1));

% mu = .02264*10^6;
% elastic_force(1:elastic_idx-1) = -(10^3)*(area./lambda).*mu.*(lambda.^2-1./lambda);

mu = [.7363, .8074, -1.526]*10^6;
alpha = [2.858, 2.604, 2.740];

for iter1 = 1:length(mu)
    elastic_force(1:elastic_idx-1) = elastic_force(1:elastic_idx-1) - (10^3)*(2*area*mu(iter1)./lambda).*...
        (lambda.^(alpha(iter1)-1)-lambda.^-(.5*alpha(iter1)+1));
end

% c10 = 2.18*10^4;
% c01 = -7.22*10^4;
% c20 = 1.26*10^1;
% elastic_force(1:elastic_idx-1) = -(10^3)*(area./lambda).*2.*(lambda.^2-1./lambda).*(c10+c01./lambda+2*c20*(lambda.^2+2./lambda-3));

% C = [10^3, 1.31*10^4, 2.056*10^1];
% I_1 = lambda.^2+2./lambda;
% 
% for iter1 = 1:length(C)
%     elastic_force(1:elastic_idx-1) = elastic_force(1:elastic_idx-1) - (10^3)*(area./lambda).*...
%         2.*(lambda.^2-1./lambda).*iter1.*C(iter1).*(I_1-3).^(iter1-1);
% end

% C1 = 9.028*(10^6);
% C2 = 1.73*(10^-3);
% I_1 = lambda.^2+2./lambda;
% 
% elastic_force(1:elastic_idx-1) = -(10^3)*(area./lambda).*...
%     2.*(lambda.^2-1./lambda).*C1.*C2.*(exp(C2.*(I_1-3))-1./(2*lambda));

% alpha = 2.09;
% gamma = 12.31*(10^3);
% 
% elastic_force(1:elastic_idx-1) = -(10^3)*(area./lambda).*...
%     (gamma/(alpha+1)).*(lambda.*exp(alpha*(lambda.^2-1))-(1./lambda.^2).*exp(alpha*(1./lambda - 1)));

Elastic_Measurement_Data = load(strcat("ElasticMember/Elastic_Measurement_Data/",Measured_Elastic,".mat"));
Measured_elastic_force = zeros(Elastic_Measurement_Data.ForceData.numMeasurements,1);
for iter1 = 1:length(Measured_elastic_force)
    Measured_elastic_force(iter1) = mean(Elastic_Measurement_Data.ForceData.measurements{iter1});
end
Measured_elastic_force = [flipud(Measured_elastic_force(1:elastic_idx));zeros(length(x)-elastic_idx,1)]';


%% Plot Data
grayColor = [.6 .6 .6];

figure;
plot(x,COMSOL_core_force,'Color', grayColor);
hold on;
plot(x,Measured_core_force,'k');
legend("COMSOL","Measured");
xlabel("Distance From Magnet to Inductor (mm)")
ylabel("Force (mN)")
title("Core-Magnet Interaction Force")

figure;
plot(x,COMSOL_coil_force,'Color', grayColor);
hold on;
plot(x,Measured_coil_force,'k');
xlabel("Distance From Magnet to Inductor (mm)")
ylabel("Force (mN)")
title("Coil-Magnet Interaction Force (I = 4.6 A)")

figure;
plot(fliplr(x),fliplr(elastic_force),'Color', grayColor);
hold on;
plot(fliplr(x),fliplr(Measured_elastic_force),'k');
xlim([1,2])
ylim([0,2000])
xlabel("Distance From Magnet to Inductor (mm)")
ylabel("Force (mN)")
title("Elastic Compression Force")

