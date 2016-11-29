
% -------------------------------------------------------------------------
% Signal Hunter - electrophysiological signal analysis  
% Copyright (C) 2013, 2013-2016  University of Sao Paulo
% 
% Homepage:  http://df.ffclrp.usp.br/biomaglab
% Contact:   biomaglab@gmail.com
% License:   GNU - GPL 3 (LICENSE.txt)
% 
% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or any later
% version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
% 
% The full GNU General Public License can be accessed at file LICENSE.txt
% or at <http://www.gnu.org/licenses/>.
% 
% -------------------------------------------------------------------------


function signalhunter
% SIGNALHUNTER Startup function of Signal Hunter sofware

disp('SIGNAL HUNTER');
disp('This software is a package for electrophysiological signal analysis.');
disp('It is a collection of functions developed in Biomag Lab at the');
disp('University of Sao Paulo, and is available to the scientific community');
disp('as copyright freeware under the terms of the GNU General Public Licence.');
fprintf('\n');

sighunter_path = pwd;
sh_ls_path = genpath(sighunter_path);
path(sh_ls_path, path);

pth_aux = userpath;

% TODO: MATLAB has built-in functions to choose delimiter according to OS,
% for future improvement use this functions instead of this if's.
if isunix
    del = find(pth_aux == '/');
elseif ismac
    del = find(pth_aux == '/');
else
    del = find(pth_aux == '\');
end

pth = pth_aux(1:del(end-1));

if isunix
    config_dir = [pth '.signalhunter/'];
elseif ismac
    config_dir = [pth '.signalhunter/'];
else
    config_dir = [pth '.signalhunter\'];
end

[~,~,~] = mkdir(config_dir);

% create the figure, uicontrols and return the handles
signalhunter_logo;
figure_processing(config_dir);


function signalhunter_logo

fig_pos = [520, 383, 550, 417];
hfiglogo = figure('Name', '', 'Color', 'w', 'Resize', 'off', 'DockControls', 'off',...
    'Units', 'pixels', 'Position', fig_pos, 'ToolBar', 'none', 'WindowStyle', 'moda', ...
    'MenuBar', 'none', 'NumberTitle','off', 'DockControls', 'off', 'Visible', 'off');

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

pause(0.05)

set(hfiglogo, 'Visible', 'on')

pause(1)
close(hfiglogo)
