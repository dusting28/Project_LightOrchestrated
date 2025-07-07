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

Locations = [2,8; 3,3; 5,2; 7,6; 8,2; 2,9; 4,2; 6,5; 7,9; 8,3;];
Symbols = ["+","+","+","+","+","x","x","x","x","x"];
trainingLocation = [7,8; 4,8;];
trainingSymbols = ["+","x"];

nLocations = length(Symbols);
nTraining = length(trainingSymbols);
nRepetitions = 1;

stimNum = 1:nLocations;
nTrials = (nLocations*nRepetitions)+nTraining;

orderedStimuli = zeros(nTrials-nTraining,1);
s = 1;
for i = 1:nLocations
    orderedStimuli(s:s+nRepetitions-1) = repmat(stimNum(i),nRepetitions,1);
    s = s+nRepetitions;
end
orderedTraining = 1:nTraining;


trialNum = randperm((nLocations*nRepetitions));
trainingNum = randperm(nTraining);
randomizedStimuli = [orderedTraining(trainingNum)+nLocations, orderedStimuli(trialNum)'];

Locations = [Locations; trainingLocation];
Symbols = [Symbols, trainingSymbols];

%% Data Storage
experimentalData.nTrials = nTrials;
experimentalData.nRepetitions = nRepetitions;
experimentalData.nStimuli = nLocations;
experimentalData.nTraining = nTraining;
experimentalData.Stimuli = randomizedStimuli;
experimentalData.Locations = Locations;
experimentalData.Symbols = Symbols;
experimentalData.Responses = cell(nTrials,1);
experimentalData.Images = cell(nTrials,1); % to holds images
experimentalData.completionTime = zeros(1,length(nTrials));

%% Run Trials

for iter1 = 1:nTrials
    cla(ax);  % Clear previous

    if strcmp(Symbols(randomizedStimuli(iter1)),"+")
        singlePixel(Locations(randomizedStimuli(iter1),1),Locations(randomizedStimuli(iter1),2),ax);
        singlePixel(Locations(randomizedStimuli(iter1),1)-1,Locations(randomizedStimuli(iter1),2),ax);
        singlePixel(Locations(randomizedStimuli(iter1),1),Locations(randomizedStimuli(iter1),2)-1,ax);
        singlePixel(Locations(randomizedStimuli(iter1),1)+1,Locations(randomizedStimuli(iter1),2),ax);
        singlePixel(Locations(randomizedStimuli(iter1),1),Locations(randomizedStimuli(iter1),2)+1,ax);
    elseif strcmp(Symbols(randomizedStimuli(iter1)),"x")
        singlePixel(Locations(randomizedStimuli(iter1),1),Locations(randomizedStimuli(iter1),2),ax);
        singlePixel(Locations(randomizedStimuli(iter1),1)-1,Locations(randomizedStimuli(iter1),2)-1,ax);
        singlePixel(Locations(randomizedStimuli(iter1),1)+1,Locations(randomizedStimuli(iter1),2)-1,ax);
        singlePixel(Locations(randomizedStimuli(iter1),1)-1,Locations(randomizedStimuli(iter1),2)+1,ax);
        singlePixel(Locations(randomizedStimuli(iter1),1)+1,Locations(randomizedStimuli(iter1),2)+1,ax);
    end

    drawnow;

    tic;

     userResponse = input(strcat("Enter + or x for user response: ",num2str(iter1),": "),'s');
     experimentalData.Responses{iter1} = userResponse;

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
file_location = sprintf('PerceptualData/Dot/Subj_%s.mat',participantNumber);
save(file_location,'experimentalData');
disp("Data Saved")
