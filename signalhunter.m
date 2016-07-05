function signalhunter

sighunter_path = pwd;
sh_ls_path = genpath(sighunter_path);
path(path, sh_ls_path);

% create the figure, uicontrols and return the handles
signalhunter_logo;
figure_processing;


function signalhunter_logo

fig_pos = [520, 383, 550, 417];
hfiglogo = figure('Name', '', 'Color', 'w', 'Resize', 'off', 'DockControls', 'off',...
    'Units', 'pixels', 'Position', fig_pos, 'ToolBar', 'none', 'WindowStyle', 'moda', ...
    'MenuBar', 'none', 'NumberTitle','off', 'DockControls', 'off');

movegui(hfiglogo, 'center')

signal_logo = load('signal_hunter_opening.mat');

hax = axes('Parent', hfiglogo, 'Units', 'Normalized');
axis([0 1 0 1]);
image(signal_logo.ima)
axis tight;
axis fill;
axis off;
axis image;
set(hax, 'Position', [0 0 1 1]);

pause(1)
close(hfiglogo)
