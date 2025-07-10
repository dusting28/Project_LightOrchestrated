%% Dustin Goetz
clc; clear; close all;

participant_IDs = ["03","04","05","06","07","08","09","10","11","12"];
nParticipants = length(participant_IDs);

%% Experiment 1

% Experiment Info
nPractice = 8;
nTrials = 40;
nReplays = 0;

% Load Data
responses = zeros(nParticipants, nTrials);
stimuli = zeros(nParticipants, nTrials);
for iter1 = 1:nParticipants
    study_data = load(strcat("Experiment1_Data\Subj_",participant_IDs(iter1),".mat"));
    responses(iter1,:) = study_data.uData.Response(nPractice+1:end);
    stimuli(iter1,:) = study_data.uData.Stimuli(nPractice+1:end);
    nReplays = nReplays + sum(study_data.uData.PlayCounter(nPractice+1:end))-nTrials;
end

% Confusion Matrix
figure;
response_vector = reshape(responses,1,[]);
stimuli_vector = reshape(stimuli,1,[]);
C = confusionmat(stimuli_vector, response_vector);
confusionchart(C);


%% Experiment 2
% Experiment Info
nPractice = 2;
nTrials = 10;

load('camera_calibration_exp2.mat', 'tform');

% Load Data
responses = strings(nParticipants, nTrials);
stimuli = strings(nParticipants, nTrials);
true_locations = zeros(nParticipants, nTrials,2);
reported_locations = zeros(nParticipants,nTrials,2);
for iter1 = 1:nParticipants
    study_data = load(strcat("Experiment2_Data\Subj_",participant_IDs(iter1),".mat"));
    order = study_data.experimentalData.Stimuli(nPractice+1:end);
    stimuli(iter1,:) = study_data.experimentalData.Symbols(order);
    responses(iter1,:) = string(study_data.experimentalData.Responses(nPractice+1:end));

    % Location Data from Images
    activated_cells = study_data.experimentalData.Locations(order,:);
    images = study_data.experimentalData.Images(nPractice+1:end);

    figure(10);
    for iter2 = 1:nTrials
        % Determine location of activated cell in real space
        true_locations(iter1,iter2,:) = [activated_cells(iter2,2)-1, activated_cells(iter2,1)-1];

        % Determine location of fingerpad marker in real space
        rotated_images = imrotate(images{iter2},270);

        centroid = findGreenDot(rotated_images);
        imshow(rotated_images);
        hold on;
        plot(centroid(1), centroid(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);  % red circle
        title(strcat("(",num2str(true_locations(iter1,iter2,1)),num2str(true_locations(iter1,iter2,2)),")"));
        hold off;

        [centroid_x, centroid_y] = transformPointsForward(tform, centroid(1), centroid(2));

        % pause(2);

        reported_locations(iter1,iter2,:) = [centroid_x, centroid_y];

        % adjust centroid based on origin location - (0,0) pixel?
    end
end

% Confusion Matrix
figure;
response_vector = reshape(responses,1,[]);
stimuli_vector = reshape(stimuli,1,[]);
C = confusionmat(stimuli_vector, response_vector);
confusionchart(C);

% Historgram with Errors
errors_x = reported_locations(:,:,1)-true_locations(:,:,1);
errors_y = reported_locations(:,:,2)-true_locations(:,:,2);

% Closest Pixel
closestPixel = round(reported_locations-true_locations);

xError_vector = reshape(errors_x,1,[]);
yError_vector = reshape(errors_y,1,[]);
totalError_vector = (xError_vector.^2 + yError_vector.^2).^.5;

figure;
edges = -1.5:.1:1.5;
histogram(xError_vector, edges);  % adjust number of bins as needed
xlabel('Error (cm)');
ylabel('Count');
title('Histogram of X Error');

figure;
edges = -1.5:.1:1.5;
histogram(yError_vector, edges);  % adjust number of bins as needed
xlabel('Error (cm)');
ylabel('Count');
title('Histogram of Y Error');

figure;
edges = 0:.1:1.5;
histogram(totalError_vector, edges);  % adjust number of bins as needed
xlabel('Error (cm)');
ylabel('Count');
title('Histogram of Total Error');

disp(strcat("Experiment 2 - Average Error: ", num2str(mean(totalError_vector))));


%% Experiment 3
% Experiment Info
nPractice = 1;
nTrials = 10;

load('camera_calibration_exp3.mat', 'tform');

% Load Data
true_locations = zeros(nParticipants, nTrials);
reported_locations = zeros(nParticipants,nTrials);
for iter1 = 1:nParticipants
    study_data = load(strcat("Experiment3_Data\Subj_",participant_IDs(iter1),".mat"));
    order = study_data.experimentalData.Stimuli(nPractice+1:end);

    true_locations(iter1,:) = 10-study_data.experimentalData.Locations(order)/10;

    images = study_data.experimentalData.Images(nPractice+1:end);

    figure(10);
    for iter2 = 1:nTrials

        % Determine location of fingerpad marker in real space
        rotated_images = imrotate(images{iter2},270);

        centroid = findGreenDot(rotated_images);
        imshow(rotated_images);
        hold on;
        plot(centroid(1), centroid(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);  % red circle
        title(num2str(true_locations(iter1,iter2)));
        hold off;

        % pause(2);

        [~, centroid_y] = transformPointsForward(tform, centroid(1), centroid(2));

        reported_locations(iter1,iter2,:) = centroid_y;
    end
end

% Confusion Matrix
figure;
response_vector = reshape(responses,1,[]);
stimuli_vector = reshape(stimuli,1,[]);
C = confusionmat(stimuli_vector, response_vector);
confusionchart(C);

% Historgram with Errors
error = reported_locations(:,:,1)-true_locations(:,:,1);
error_vector = reshape(error,1,[]);

edges = -1.5:.1:1.5;

histogram(error_vector, edges);  % adjust number of bins as needed
xlabel('Error (cm)');
ylabel('Count');
title('Histogram of Error');

disp(strcat("Experiment 3 - Average Error: ", num2str(mean(abs(error_vector)))));