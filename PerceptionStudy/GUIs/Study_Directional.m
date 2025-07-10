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

%% Randomization
participantNumber = "00";

delays = [0.5, 1];

nStimuli = 4;
nRepetitions = 5;
nDelays = length(delays);

stimNum = 1:nStimuli;

nTraining = nStimuli*nDelays;

nTrials = (nStimuli*nRepetitions*nDelays) + nTraining;

orderedStimuli = repmat(1:nStimuli,1,nRepetitions*nDelays)';
trainingStimuli = repmat(1:nStimuli,1,nDelays)';

orderedDelays = zeros(nTrials-nTraining,1);
trainingDelays = zeros(nTraining,1);
s = 1;
t = 1;
for i = 1:nDelays
    orderedDelays(s:s+nRepetitions*nStimuli-1) = repmat(delays(i),nRepetitions*nStimuli,1);
    trainingDelays(t:t+nStimuli-1) = repmat(delays(i),nStimuli,1);
    s = s+nRepetitions*nStimuli;
    t = t+nStimuli;
end

trainingShuffle = randperm(nTraining);
trialShuffle = randperm(nTrials-nTraining);

randomizedStimuli = [trainingStimuli(trainingShuffle); orderedStimuli(trialShuffle)];
randomizedDelays = [trainingDelays(trainingShuffle); orderedDelays(trialShuffle)];

%% 
stimLabels = {'Left','Right','Up','Down'};
stimReps = [1 1 1 1];

% Display Initialization
figSize = [20,200,1800,750];
fig_h = figure('Name','NI Data Acquisition','Position',figSize,...
    'Color',[0.95,0.95,0.95]);


%% STORE EXPERIMENTAL DATA
experimentalData.nTrials = nTrials;
experimentalData.nRepetitions = nRepetitions;
experimentalData.nStimuli = nStimuli;
experimentalData.nDelays = nDelays;
experimentalData.Delays = randomizedDelays;
experimentalData.Trial = 1;
experimentalData.Stimuli = randomizedStimuli;
experimentalData.Labels = stimLabels;
experimentalData.Speeds = 10./delays;
experimentalData.Response = zeros(nTrials,1); % to hold answers
experimentalData.PlayCounter = zeros(nTrials,1); % to hold play counts

fig_h.UserData = experimentalData;

%% UI CONTROLS
tString = sprintf('1 / %i',nTrials);
trialNum = uicontrol('Style', 'text',...
    'Position', [100 figSize(4)-70 200 30],...
    'BackgroundColor',[1,1,1],...
    'String',tString,'FontSize',20);

uicontrol('Style', 'text',...
    'Position', [100 figSize(4)-30 200 30],...
    'BackgroundColor',[1,1,1],...
    'String','Trial Num','FontSize',20);


left = uicontrol('Style', 'pushbutton',...
    'Position', [500 figSize(4)-500 125 125],...
    'Callback', {@submitAnswer, 1, trialNum, nTrials, participantNumber},...
    'BackgroundColor',[1,0,0],...
    'String','Left','Tag','aButton','Enable','off', 'FontSize',16);


right = uicontrol('Style', 'pushbutton',...
    'Position', [750 figSize(4)-500 125 125],...
    'Callback', {@submitAnswer, 2, trialNum, nTrials, participantNumber},...
    'BackgroundColor',[1,0,0],...
    'String','Right','Tag','aButton','Enable','off', 'FontSize',16);


up = uicontrol('Style', 'pushbutton',...
    'Position', [1000 figSize(4)-500 125 125],...
    'Callback', {@submitAnswer, 3, trialNum, nTrials, participantNumber},...
    'BackgroundColor',[1,0,0],...
    'String','Up','Tag','aButton','Enable','off', 'FontSize',16);


down = uicontrol('Style', 'pushbutton',...
    'Position', [1250 figSize(4)-500 125 125],...
    'Callback', {@submitAnswer, 4, trialNum, nTrials, participantNumber},...
    'BackgroundColor',[1,0,0],...
    'String','Down','Tag','aButton','Enable','off', 'FontSize',16);


playButton = uicontrol('Style', 'pushbutton',...
    'Position', [250 figSize(4)-250 150 150],...
    'Callback', {@playStimulus, ax},...
    'BackgroundColor',[1,0,0],...
    'String','Play Stimulus', 'Tag','pb', 'FontSize',14);

%% MAIN LOOP
while ishandle(fig_h)
    pause(0.01)
end


%% CALLBACK FUNCTIONS
function playStimulus(hObject,event,ax)
    aButton = findobj('Tag','aButton');

    set(hObject,'Enable','off');
    set(aButton,'Enable','off');
        
    set(aButton,'BackgroundColor',[1 0 0]);
    set(hObject,'BackgroundColor',[1 0 0]); 

    uData = hObject.Parent.UserData;
    uData.PlayCounter(uData.Trial) = uData.PlayCounter(uData.Trial)+1; %increment play counter
    set(hObject.Parent,'UserData',uData);

    % Play Video / Display Image Here
    stimNum = uData.Stimuli(uData.Trial);
    stimName = uData.Labels{stimNum};
    motionPattern(stimName,uData.Delays(uData.Trial),ax);
    cla(ax);

    % Render UI
    set(hObject,'Enable','on');
    set(aButton,'Enable','on');
    
    set(hObject,'BackgroundColor',[0 1 0]); 
    set(aButton,'BackgroundColor',[0 1 0]);    
end

function submitAnswer(hObject, event, answer, trialNum, maxT, pNumber)
    aButton = findobj('Tag','aButton');
    pb = findobj('Tag','pb');

    set(pb,'Enable','off');
    set(aButton,'Enable','off');
    
    set(aButton,'BackgroundColor',[1 0 0]);
    set(pb,'BackgroundColor',[1 0 0]); 
    
    uData = hObject.Parent.UserData;
    uData.Response(uData.Trial) = answer;
    uData.Trial = uData.Trial+1;
    set(hObject.Parent,'UserData',uData);    
    
    if uData.Trial > maxT 
        file_location = sprintf('PerceptualData/Directional/Subj_%s.mat',pNumber);
        save(file_location,'uData');
        close(hObject.Parent);
        return;
    else
        trialNum.String = sprintf('%i / %i',uData.Trial, maxT);
    end

    pause(0.5);
    set(pb,'Enable','on');
    
end
