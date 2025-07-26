%% Dustin Goetz
clc; clear; close all;

participant_IDs = ["02","03","04","05","06","07"];
nParticipants = length(participant_IDs);

%% Load Data
nStim = 7;
nReps = 5;

nPractice = nStim;
nTrials = nStim*nReps;

responses = zeros(nParticipants, nStim, nReps);

for iter1 = 1:nParticipants
    study_data = load(strcat("MagnitudeScaling_Data\Subj_",participant_IDs(iter1),".mat"));
    response_vector = study_data.uData.Response(nPractice+1:end);
    stimuli_vector = study_data.uData.Stimuli(nPractice+1:end);

    for iter2 = 1:nStim
        idx = find(stimuli_vector == iter2);
        responses(iter1,iter2,:) = response_vector(idx);
    end
end

%% Plot Data
averaged_over_trials = geomean(responses,3);
normalized = averaged_over_trials./mean(averaged_over_trials,2);
median_data = median(normalized,1);
iqr_data = prctile(normalized,[25,75],1);
stimuli = 1:nStim;


figure;
% for iter1 = 1:nParticipants
%     % plot(normalized(iter1,:), ".", 'Color', [.7, .7, .7]);
%     hold on;
% end
for iter1 = 1:nStim
    line([iter1, iter1], [iqr_data(1,iter1), iqr_data(2,iter1)], 'Color', [.7, .7, .7], 'LineWidth', 2)
    hold on;
end
plot(median_data, "k.");

p = polyfit(1:nStim, median_data, 1);   % Linear fit (1st-degree polynomial)
linear_fit = polyval(p,stimuli);

SS_res = sum((median_data-linear_fit).^2);
SS_tot = sum((median_data-mean(median_data)).^2);
r_squared = 1-SS_res/SS_tot;

plot(linear_fit, 'k');
% ylim([0.4,1.5]);


