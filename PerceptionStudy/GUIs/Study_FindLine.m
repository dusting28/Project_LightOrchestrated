%% Dustin Goetz
clc;

figs = findall(0, 'Type', 'figure');  % Get all figure handles
for k = 1:length(figs)
    if figs(k).Number ~= 1
        close(figs(k));
    end
end

clearvars -except vid src ax
cla(ax)

warning('off', 'all');

%% Randomization
participantNumber = "02";

Locations = [0,10,20,30,40,50,60,70,80,90];
nLocations = length(Locations);
nRepetitions = 1;

stimNum = 1:nLocations;
nTrials = (nLocations*nRepetitions)+1;

orderedStimuli = zeros(nTrials-1,1);
s = 1;
for i = 1:nLocations
    orderedStimuli(s:s+nRepetitions-1) = repmat(stimNum(i),nRepetitions,1);
    s = s+nRepetitions;
end
trialNum = randperm((nLocations*nRepetitions),(nLocations*nRepetitions));
randomizedStimuli = [nLocations+1, orderedStimuli(trialNum)'];

trainingLocation = 100;
Locations = [Locations, trainingLocation];

%% Data Storage
experimentalData.nTrials = nTrials;
experimentalData.nRepetitions = nRepetitions;
experimentalData.nStimuli = nLocations;
experimentalData.nTraining = 1;
experimentalData.Stimuli = randomizedStimuli;
experimentalData.Locations = Locations;
experimentalData.Images = cell(nTrials,1); % to holds images
experimentalData.completionTime = zeros(1,length(nTrials));

%% Run Trials

for iter1 = 1:nTrials
    cla(ax);  % Clear previous
    drawLine(Locations(randomizedStimuli(iter1)),ax);
    drawnow;

    tic;

    input(strcat("Hit Enter to Finish Trial ",num2str(iter1),": "));

    experimentalData.completionTime(iter1) = toc;
    
    % Take Picture
    start(vid);
    img = getdata(vid, 1);
    img = rot90(img, 2);
    experimentalData.Images{iter1} = img;

    cla(ax);

    % Display Picture
    imgFig = figure(2);
    imshow(img, []);
    title(strcat("Trial ",num2str(iter1)," / ", num2str(nTrials)));

    waitfor(imgFig);
end

%% Save Data
file_location = sprintf('PerceptualData/Line/Subj_%s.mat',participantNumber);
save(file_location,'experimentalData');
disp("Data Saved")
