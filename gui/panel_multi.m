
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


% --- Creates GUI panel and controls for Multi Channels EMG processing of
% TMS motor evoked potentials.
function handles = panel_multi(handles)

% create the panel and controls, and return the handles
handles = panel_creation(handles);

function handles = panel_creation(handles)

hObject = handles.fig;

% creates the panel for tms and voluntary contraction processing
% paneltools_pos = [0.005, 0.008, 0.15, 0.195];
paneltools_pos = [0.005, 0.008, 0.15, 0.16];
handles.panel_tools = uipanel(hObject, 'BackgroundColor', 'w', ...
    'Title', 'Multiple Electrodes Processing',...
    'Units', 'normalized');
set(handles.panel_tools, 'Position', paneltools_pos);

n_cols = [2;3]; n_rows = 2;
mar_x = 0.02; mar_y = 0.02;
w = (1./n_cols-((n_cols+1)*mar_x));
h = (1/n_rows-(n_rows+1)*mar_y);
pos_x = nan(n_rows, max(n_cols));
pos_y = nan(n_rows,1);

for i = 1:n_rows
   for j = 1:n_cols(i)
       pos_x(i,j) = j*mar_x + (j-1)*w(i);
   end
   pos_y(i) = i*mar_y + (i-1)*h;
end

w = flipud(w);
pos_x = flipud(pos_x);

% second row of buttons
pb_clean_pos = [pos_x(2,1), pos_y(2), w(2), h];
pb_reset_pos = [pos_x(2,2), pos_y(2), w(2), h];

% first row of buttons
pb_prev_pos = [pos_x(1,1), pos_y(1), w(1)+0.07, h];
pb_next_pos = [pos_x(1,2)+0.07, pos_y(1), w(1)+0.07, h];
edit_idcond_pos = [pos_x(1,3)+0.15, pos_y(1)+0.02, w(1)-0.05, h-0.05];

% push button to clean plots
pushbutton_open = uicontrol(handles.panel_tools, 'String', 'Open',...
    'Units', 'normalized', 'FontWeight', 'bold', 'FontUnits', 'normalized',...
    'Callback', @pushbutton_open_Callback);
set(pushbutton_open, 'Position', pb_clean_pos, 'FontSize', 0.3);

% push button to clean plots
pushbutton_reset = uicontrol(handles.panel_tools, 'String', 'Reset',...
    'Units', 'normalized', 'FontWeight', 'bold', 'FontUnits', 'normalized',...
    'Callback', @pushbutton_reset_Callback);
set(pushbutton_reset, 'Position', pb_reset_pos, 'FontSize', 0.3);

% push button previous
pushbutton_prev = uicontrol(handles.panel_tools, 'String', '<',...
    'Units', 'normalized', 'FontWeight', 'bold',...
    'FontUnits', 'normalized', 'Callback', @pushbutton_prev_Callback);
set(pushbutton_prev, 'Position', pb_prev_pos, 'FontSize', 0.4);

% push button next
pushbutton_next = uicontrol(handles.panel_tools, 'String', '>',...
    'Units', 'normalized', 'FontWeight', 'bold',...
    'FontUnits', 'normalized', 'Callback', @pushbutton_next_Callback);
set(pushbutton_next, 'Position', pb_next_pos, 'FontSize', 0.4);

% edit for threshold value
handles.edit_idcond = uicontrol(handles.panel_tools, 'Style', 'edit',...
    'String', '1', 'BackgroundColor', 'w', 'Units', 'normalized',...
    'FontWeight', 'bold', 'FontUnits', 'normalized',...
    'Callback', @edit_idcond_Callback);
set(handles.edit_idcond, 'Position', edit_idcond_pos, 'FontSize', 0.4);

% Update handles structure
guidata(hObject, handles);


function pushbutton_next_Callback(hObject, ~)
% Callback - Button Next Condition
handles = guidata(hObject);

set(handles.panel_graph(handles.id_cond), 'Visible', 'off');

% change text condition
if handles.id_cond >= numel(handles.conditions)
   handles.id_cond = 1; 
   set(handles.edit_idcond, 'String',...
       num2str(handles.conditions(handles.id_cond)))
else
    handles.id_cond = handles.id_cond + 1;        
    set(handles.edit_idcond, 'String',...
       num2str(handles.conditions(handles.id_cond)))
end

set(handles.panel_graph(handles.id_cond), 'Visible', 'on');

% Update handles structure
guidata(hObject, handles);


function pushbutton_prev_Callback(hObject, ~)
% Callback - Button Previous Condition
handles = guidata(hObject);

set(handles.panel_graph(handles.id_cond), 'Visible', 'off');

% change text condition
if handles.id_cond == 1
   handles.id_cond = numel(handles.conditions); 
   set(handles.edit_idcond, 'String',...
       num2str(handles.conditions(handles.id_cond)))
else
    handles.id_cond = handles.id_cond - 1;        
    set(handles.edit_idcond, 'String',...
       num2str(handles.conditions(handles.id_cond)))
end

set(handles.panel_graph(handles.id_cond), 'Visible', 'on');

% Update handles structure
guidata(hObject, handles);


function pushbutton_open_Callback(hObject, ~)
% Callback - Button Open
handles = guidata(hObject);

if isfield(handles, 'panel_graph')
    delete(handles.panel_graph);
    handles = rmfield(handles, 'panel_graph');
    handles = rmfield(handles, 'haxes');
end

% [map_template, map_shape] = dialog_create_new;
% handles.map_template = map_template;
% handles.map_shape = map_shape;

[handles.reader, open_id] = reader_multi(handles.config_dir);

handles.id_cond = 1;

if open_id
    msg = 'Succesfully read data.';
    handles = panel_textlog(handles, msg);
    
    handles.processed = process_multi(handles.reader);
    handles = graphs_multi(handles);
    set(handles.hsubdata, 'Enable', 'on');
    
else
    msg = 'Open canceled.';
    handles = panel_textlog(handles, msg);
    
end

% Update handles structure
guidata(hObject, handles);


function pushbutton_reset_Callback(hObject, ~)
% Callback - Button Reset
vars = guidata(hObject);

handles.fig = vars.fig;
handles.hmenufile = vars.hmenufile;
handles.hsubopen = vars.hsubopen;
handles.hsubdata = vars.hsubdata;
handles.hmenutools = vars.hmenutools;
handles.hsubtools = vars.hsubtools;
handles.panel_files = vars.panel_files;
handles.progress_bar = vars.progress_bar;
handles.panel_tools = vars.panel_tools;
handles.edit_idcond = vars.edit_idcond;
handles.panel_txtlog = vars.panel_txtlog;
handles.edit_log = vars.edit_log;
handles.config_dir = vars.config_dir;

set(handles.edit_idcond, 'String', '1');
set(handles.hsubdata, 'Enable', 'off');

if isfield(vars, 'panel_graph')
    if ishandle(vars.panel_graph)
        delete(vars.panel_graph);
    end
end

% message to progress log
msg = 'Signal Hunter for multi processing restarted.';
handles = panel_textlog(handles, msg);

% Update handles structure
guidata(hObject, handles);


function edit_idcond_Callback(hObject, ~)
% Callback - Edit Condition Callback
handles = guidata(hObject);

% progress bar update
value = 1/2;
progbar_update(handles.progress_bar, value)

set(handles.panel_graph(handles.id_cond), 'Visible', 'off');
id = str2double(get(handles.edit_idcond, 'String'));

if id > 0 && id <= handles.conditions(end)
   handles.id_cond = id; 
else
   handles.id_cond = 1;
end

set(handles.edit_idcond, 'String', num2str(handles.id_cond));
set(handles.panel_graph(handles.id_cond), 'Visible', 'on');

% progress bar update
value = 1;
progbar_update(handles.progress_bar, value)

% Update handles structure
guidata(hObject, handles);
