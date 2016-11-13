
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
% 
% Author: Victor Hugo Souza
% Date: 13.11.2016


function handles = panel_textlog(handles, msg)
% PANEL_TEXTLOG Create the text log to show user the time progress of used
% functions.

if isempty(msg)
    % create the panel and controls, and return the handles
    handles = panel_creation(handles);
else
    write_text_log(handles.edit_log, msg)
end


function handles = panel_creation(handles)

% position of panel text log considering the panel files and progress bar
% panelfiles_pos = get(handles.panel_files, 'Position');
% panelprogbar_pos = get(handles.progress_bar, 'Position');
% panel_files_pos = [panelfiles_pos(1) + panelfiles_pos(3) + 0.01, panelfiles_pos(2),...
%     panelprogbar_pos(1) - (panelfiles_pos(1) + panelfiles_pos(3) + 2*0.01), panelfiles_pos(4)];

panel_txtlog_pos = [0.264, 0.008, 0.557, 0.16];
handles.panel_txtlog = uipanel(handles.fig, 'Position', panel_txtlog_pos,...
    'Title', 'Processing Log', 'BackgroundColor', 'w', 'Units', 'normalized');

edit_pos = [0.005, 0.04, 0.99, 0.95];

t = clock;

t(5) = 2;

day = num2str(t(3));
if t(3) < 10
    day = ['0', num2str(t(3))];
end

month = num2str(t(2));
if t(2) < 10
    month = ['0', num2str(t(2))];
end

hour = num2str(t(4));
if t(4) < 10
    hour = ['0', num2str(t(4))];
end

min = num2str(t(5));
if t(5) < 10
    min = ['0', num2str(t(5))];
end

opening_log = ['% -- Processing started at ', day,...
    '/', month, '/', num2str(t(1)), ' ',...
    hour, ':', min];


% Text field to real-time log
handles.edit_log = uicontrol(handles.panel_txtlog, 'Style', 'edit',...
    'Units', 'normalized', 'String', opening_log, 'Enable', 'inactive',...
    'Max', 3, 'Min', 1, 'BackgroundColor', 'w', 'FontSize', 11,...
    'HorizontalAlignment', 'left');
set(handles.edit_log, 'Position', edit_pos);


function write_text_log(heditlog, msg)

msg = ['>> ', msg];
oldmsgs = cellstr(get(heditlog,'String'));
set(heditlog,'String',[cellstr(msg);oldmsgs]);

