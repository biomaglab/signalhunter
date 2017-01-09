
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


% --- Creates GUI panel and controls for TMS and Voluntary Contraction Processing
function handles = panel_files(handles)

% create the panel and controls, and return the handles
handles = panel_creation(handles);


function handles = panel_creation(handles)

paneltools_pos = get(handles.panel_tools, 'Position');

panel_files_pos = [paneltools_pos(1) + paneltools_pos(3) + 0.01,...
    paneltools_pos(2), 0.089, paneltools_pos(4)];
handles.panel_files = uipanel(handles.fig, 'Position', panel_files_pos,...
    'Title', 'Files', 'BackgroundColor', 'w', 'Units', 'normalized');

n_rows = 3; mar_x = 0.15; mar_y = 0.05;
w = 1-2*mar_x;
h = 1/n_rows-mar_y;
pos_x = mar_x;
pos_y = nan(n_rows,1);

for i = 1:n_rows
   pos_y(i) = i*mar_y + (i-1)*h;
end

pb_export_pos = [pos_x, pos_y(3), w, h];
pb_load_pos = [pos_x, pos_y(2), w, h];
pb_save_pos = [pos_x, pos_y(1), w, h];

fontsize = 0.5;

% push button load
pushbutton_load = uicontrol(handles.panel_files, 'FontWeight', 'bold',...
    'String', 'Load', 'Units', 'normalized', 'FontUnits', 'normalized', ...
    'Callback', @(obj, eventdata)callback_data(obj, 'load'));
set(pushbutton_load, 'Position', pb_load_pos, 'FontSize', fontsize);

% push button export
pushbutton_export = uicontrol(handles.panel_files, 'FontWeight', 'bold',...
    'String', 'Export', 'Units', 'normalized', 'FontUnits', 'normalized',...
    'Callback', @(obj, eventdata)callback_data(obj, 'export'));
set(pushbutton_export, 'Position', pb_export_pos, 'FontSize', fontsize);

% push button save
pushbutton_save = uicontrol(handles.panel_files, 'FontWeight', 'bold',...
    'String', 'Save', 'Units', 'normalized', 'FontUnits', 'normalized',...
    'Callback', @(obj, eventdata)callback_data(obj, 'save'));
    
set(pushbutton_save, 'Position', pb_save_pos, 'FontSize', fontsize);


function callback_data(hObject, menu_id)
%CALLBACK_DATA Summary of this function goes here
%   Detailed explanation goes here

handles = guidata(hObject);
menu_id_up = [upper(menu_id(1)) menu_id(2:end)];

% message to progress log
msg = [menu_id_up ' data in progress...'];
handles = panel_textlog(handles, msg);

value = 1/2;
progbar_update(handles.progress_bar, value)

% call function to save, load or export
input = '(handles)';
[handles, filt_id] = eval(['data_' menu_id input]);

value = 1;
progbar_update(handles.progress_bar, value)

% message to progress log
if filt_id
    msg = [menu_id_up ' data finished.'];
    handles = panel_textlog(handles, msg);
else
    msg = [menu_id_up ' canceled.'];
    handles = panel_textlog(handles, msg);
end

guidata(hObject, handles)
