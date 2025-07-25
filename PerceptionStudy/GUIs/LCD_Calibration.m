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

%%

min_intensity = .715;
% max_intensity = .76;

intensity = min_intensity;

fillColor = [intensity intensity intensity];

rectangle('Parent', ax, 'Position', [0, 0, 2000, 1000], 'FaceColor', fillColor, 'EdgeColor', 'none');
drawnow;