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
participantNumber = "07";

nStimuli = 7;
nRepetitions = 5;

stimNum = 1:nStimuli;
repNum = 1:nRepetitions;

stimNumTraining = 1:nStimuli;

nTrials = (nStimuli*nRepetitions) + length(stimNumTraining);

orderedStimuli = zeros(nTrials,1);
orderedRepetitions = zeros(nTrials,1);


s = 1;
for i = 1:nStimuli
    orderedStimuli(s:s+nRepetitions-1) = repmat(stimNum(i),nRepetitions,1);
    s = s+nRepetitions;
end
% 
trainingTrials = randperm(length(stimNumTraining),length(stimNumTraining));
% trainingTrials = 1:length(stimNumTraining);

trialNum = randperm((nStimuli*nRepetitions),(nStimuli*nRepetitions));
randomizedStimuli = [trainingTrials'; orderedStimuli(trialNum)];

dataTable = table;
dataTable.Stimuli = randomizedStimuli;

%% 
stimReps = [1 1 1 1 1 1 1 1 1];

% Display Initialization
figSize = [20,200,1800,750];
fig_h = figure('Name','NI Data Acquisition','Position',figSize,...
    'Color',[0.95,0.95,0.95]);


%% STORE EXPERIMENTAL DATA
experimentalData.nTrials = nTrials;
experimentalData.nRepetitions = nRepetitions;
experimentalData.nStimuli = nStimuli;
experimentalData.Trial = 1;
experimentalData.Stimuli = randomizedStimuli;
experimentalData.Response = zeros(nTrials,1); % to hold answers
experimentalData.PlayCounter = zeros(nTrials,1); % to hold play counts
experimentalData.movedYet = 0;

fig_h.UserData = experimentalData;

%% UI CONTROLS
tString = sprintf('1 / %i',nTrials);
trialNum = uicontrol('Style', 'text',...
    'Position', [100 figSize(4)-70 200 30],...
    'BackgroundColor',[1,1,1],...
    'String',tString,'FontSize',20);

noVibr = uicontrol('Style', 'text',...
    'Position', [250 figSize(4)-585 200 50],...
    'BackgroundColor',[0.7,0.7,0.7],...
    'String','No Sensation','FontSize',20);

strngIm = uicontrol('Style', 'text',...
    'Position', [1450 figSize(4)-585 300 50],...
    'BackgroundColor',[0.7,0.7,0.7],...
    'String','Strongest Imaginable','FontSize',20);

uicontrol('Style', 'text',...
    'Position', [100 figSize(4)-30 200 30],...
    'BackgroundColor',[1,1,1],...
    'String','Trial Num','FontSize',20);

slider = uicontrol('Style','slider','Position', [450 figSize(4)-600 1000 100],...
    'Callback', {@sliderCallback},...
    'Min',0,'Max',10,'Value',randi([1 9],1),'BackgroundColor',[.3,.3,.3],...
    'Tag','aSlider');

submitButton = uicontrol('Style', 'pushbutton',...
    'Position', [820 figSize(4)-300 200 200],...
    'Callback', {@submitAnswer, trialNum, nTrials,participantNumber},...
    'BackgroundColor',[1,0,0],...
    'String','Submit Answer','Tag','aButton','Enable','off', 'FontSize',18);

playButton = uicontrol('Style', 'pushbutton',...
    'Position', [250 figSize(4)-300 150 150],...
    'Callback', {@playStimulus, stimReps, ax},...
    'BackgroundColor',[1,0,0],...
    'String','Play Stimulus', 'Tag','pb', 'FontSize',14);


%% MAIN LOOP
    
set(fig_h,'WindowKeyPressFcn',@keyPressCallback);
set(fig_h, 'WindowScrollWheelFcn', @wheel);  % <-- Add this line here
while ishandle(fig_h)
    pause(0.01)
end


%% CALLBACK FUNCTIONS
function playStimulus(hObject,event, stimReps,ax)
    aSlider = findobj('Tag','aSlider');
    aButton = findobj('Tag','aButton');
    pButton = findobj('Tag','pb');

    set(hObject,'Enable','off');
    set(aButton,'Enable','off');
    set(pButton,'Enable','off');
       
    set(hObject,'BackgroundColor',[1 0 0]); 
    set(aButton,'BackgroundColor',[1 0 0]); 
    
    uData = hObject.Parent.UserData;
    stimNum = uData.Stimuli(uData.Trial);
    repNum = stimReps(stimNum);
    
    uData.PlayCounter(uData.Trial) = uData.PlayCounter(uData.Trial)+1; %increment play counter
    set(hObject.Parent,'UserData',uData);
    
    %% Play Stimulus
    min_intensity = .715;
    max_intensity = .76;
    
    intensity = min_intensity + (max_intensity-min_intensity)*(stimNum-1)/(uData.nStimuli-1);
    analogPixel(1,6,intensity,ax);
    drawnow;
    pause(0.017);
    cla(ax);
    pause(.75);

    set(hObject,'Enable','on');
    
    set(pButton,'Enable','on');
    
    set(hObject,'BackgroundColor',[0 1 0]);  

    if uData.movedYet
        set(aButton,'Enable','on');
        set(aButton,'BackgroundColor',[0 1 0]);
    else
        set(aButton,'Enable','off');
        set(aButton,'BackgroundColor',[1 0 0]);
    end

    set(hObject.Parent,'UserData',uData);
end

function submitAnswer(hObject, event, trialNum, maxT,pNumber)
    aButton = findobj('Tag','aButton');
    aSlider = findobj('Tag','aSlider');
    pb = findobj('Tag','pb');

    set(pb,'Enable','off');
    set(aButton,'Enable','off');
    
    set(aButton,'BackgroundColor',[1 0 0]);
    set(pb,'BackgroundColor',[1 0 0]); 
    
    uData = hObject.Parent.UserData;
    uData.Response(uData.Trial) = aSlider.Value;
    uData.Trial = uData.Trial+1;
    set(hObject.Parent,'UserData',uData);    
    
    if uData.Trial > maxT 
        file_location = sprintf('PerceptualData/Magnitude/Subj_%s.mat',pNumber);
        save(file_location,'uData');
        close(hObject.Parent);
        return;
    else
        trialNum.String = sprintf('%i / %i',uData.Trial, maxT);
    end

    pause(.75);
    set(pb,'Enable','on');
    aSlider.Value = randi([1 9],1);
    uData.movedYet = 0;

    set(hObject.Parent,'UserData',uData);
    
end

function sliderCallback(hObject, event)
    set(gcf, 'WindowScrollWheelFcn', @wheel);
end

function wheel(hObject, callbackdata)
    aSlider = findobj('Tag','aSlider');
    aButton = findobj('Tag','aButton');
    pb = findobj('Tag','pb');

    uData = hObject.Parent.UserData;

    % Update slider value
    if callbackdata.VerticalScrollCount < 0
        if aSlider.Value + 0.1 >= aSlider.Max
            aSlider.Value = aSlider.Max;
            uData.movedYet = 0;
        else
            aSlider.Value = aSlider.Value + 0.1;
            uData.movedYet = 1;
        end
    elseif callbackdata.VerticalScrollCount > 0
        if aSlider.Value - 0.1 <= aSlider.Min
            aSlider.Value = aSlider.Min;
            uData.movedYet = 0;
        else
            aSlider.Value = aSlider.Value - 0.1;
            uData.movedYet = 1;
        end
    end

    % Decide whether to enable button
    if uData.movedYet
        set(aButton,'Enable','on');
        set(aButton,'BackgroundColor',[0 1 0]);
    else
        set(aButton,'Enable','off');
        set(aButton,'BackgroundColor',[1 0 0]);
    end

    set(hObject.Parent,'UserData',uData);
end



