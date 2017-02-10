
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


% --- Creates GUI panel and controls for EMF Analysis
function handles = panel_emf(handles)

% create the panel and controls, and return the handles
handles = panel_creation(handles);

function handles = panel_creation(handles)

hObject = handles.fig;

% creates the panel for EMF Analysis

paneltools_pos = [0.005, 0.008, 0.15, 0.16];
handles.panel_tools = uipanel(hObject, 'BackgroundColor', 'w', ...
    'Title', 'EMF Analysis',...
    'Units', 'normalized');
set(handles.panel_tools, 'Position', paneltools_pos);


n_cols = [3;3]; n_rows = 2;
mar_x = 0.02; mar_y = 0.02;
% w = 1./n_cols-(n_cols+1)*mar_x; h = (1/n_rows-(n_rows+1)*mar_y);
w = (1./n_cols-((n_cols+1)*mar_x)); h = (1/n_rows-(n_rows+1)*mar_y);
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
pb_import_pos = [pos_x(2,1), pos_y(2), w(2)+0.07, h];
pb_clean_pos = [pos_x(2,2)+0.07, pos_y(2), w(2)+0.07, h];
pb_reset_pos = [pos_x(2,3)+0.15, pos_y(2), w(2)-0.05, h];
% first row of buttons
pb_prev_pos = [pos_x(1,1), pos_y(1), w(1)+0.07, h];
pb_next_pos = [pos_x(1,2)+0.07, pos_y(1), w(1)+0.07, h];
edit_idcond_pos = [pos_x(1,3)+0.15, pos_y(1)+0.02, w(1)-0.05, h-0.05];

% % push button to clean plots
% pushbutton_clean = uicontrol(handles.panel_tools, 'String', 'Clean',...
%     'Units', 'normalized', 'FontWeight', 'bold', ...
%     'Callback', @pushbutton_clean_Callback);
% set(pushbutton_clean, 'Position', pb_clean_pos);

%push button to import data
pushbutton_import = uicontrol(handles.panel_tools, 'String', 'New',...
    'Units', 'normalized', 'FontWeight', 'bold', 'FontUnits', 'normalized',...
    'Callback', @pushbutton_import_Callback);
set(pushbutton_import, 'Position', pb_import_pos, 'FontSize', 0.3);


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

% align([pushbutton_prev, pushbutton_next, handles.edit_idcond], 'Distribute', 'Center');


info_panel_pos = [0.16, 0.008, 0.10, 0.16];
handles.info_panel = uipanel(hObject, 'BackgroundColor', 'w', ...
    'Title', 'Info panel',...
    'Units', 'normalized');
set(handles.info_panel, 'Position', info_panel_pos,'Visible','On');


% Update handles structure
guidata(hObject, handles);

function pushbutton_next_Callback(hObject, eventdata)
% Callback - Button Previous Condition
handles = guidata(hObject);

set(handles.panel_graph(handles.id_cond), 'Visible', 'off');
set(handles.info_text(handles.id_cond),'Visible','off');


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
set(handles.info_text(handles.id_cond),'Visible','on');

% Update handles structure
guidata(hObject, handles);

function pushbutton_prev_Callback(hObject, eventdata)
% Callback - Button Previous Condition
handles = guidata(hObject);

set(handles.panel_graph(handles.id_cond), 'Visible', 'off');
set(handles.info_text(handles.id_cond),'Visible','off');


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
set(handles.info_text(handles.id_cond),'Visible','on');

% Update handles structure
guidata(hObject, handles);

function pushbutton_open_Callback(hObject, eventdata)
% Callback - Button Open
handles = guidata(hObject);

% message to progress log
msg = 'Reading signal data...';
handles = panel_textlog(handles, msg);

handles.reader = reader_emf;

msg = char(strcat('Equipment: ''', cellstr(handles.reader.equipment), ...
         '''; Mode: ''', cellstr(handles.reader.mode), ...
         '''; Number of pulses: ',  num2str(handles.reader.n_pulses),'. '));
handles = panel_textlog(handles, msg);

handles = graphs_emf(handles);

% Update handles structure
guidata(hObject, handles);

function pushbutton_reset_Callback(hObject, eventdata)
% Callback - Button Clean - Not working fot this panel
vars = guidata(hObject);

handles.data_id = vars.data_id;
handles.map_template = vars.map_template;
handles.map_shape = vars.map_shape;
handles.fig = vars.fig;
handles.menufile = vars.menufile;
handles.subopen = vars.subopen;
handles.menutools = vars.menutools;
handles.subtools = vars.subtools;
handles.panel_files = vars.panel_files;
handles.progress_bar = vars.progress_bar;
handles.panel_tools = vars.panel_tools;
handles.edit_idcond = vars.edit_idcond;
handles.panel_txtlog = vars.edit_idcond;
handles.edit_log = vars.edit_log;

set(handles.edit_idcond, 'String', '1');

delete(vars.panel_graph);

% message to progress log
msg = 'Signal Hunter for EMF Analysis restarted.';
handles = panel_textlog(handles, msg);

% Update handles structure
guidata(hObject, handles);

function edit_idcond_Callback(hObject, eventdata)
% Callback - Edit Condition Callback
handles = guidata(hObject);

% progress bar update
value = 1/2;
progbar_update(handles.progress_bar, value)

set(handles.panel_graph(handles.id_cond), 'Visible', 'off');
set(handles.info_panel(handles.id_cond),'Visible','off');
id = str2double(get(handles.edit_idcond, 'String'));

if id > 0 && id <= length(handles.id_mod)
   handles.id_cond = id; 
else
   handles.id_cond = 1;
end

set(handles.edit_idcond, 'String', num2str(handles.id_cond));
set(handles.panel_graph(handles.id_cond), 'Visible', 'on');
set(handles.info_panel(handles.id_cond),'Visible','on');

% progress bar update
value = 1;
progbar_update(handles.progress_bar, value)

% Update handles structure
guidata(hObject, handles);

function pushbutton_import_Callback(hObject, eventdata)
%Callback - Import data for EMF Analysis

handles = guidata(hObject);

% message to progress log
msg = 'Importing signal data...';
handles = panel_textlog(handles, msg);

handles.reader = import_emf;

msg = ['Data opened.', 'Number of frames: ',  num2str(handles.reader.n_pulses),];
handles = panel_textlog(handles, msg);
handles = graphs_emf(handles);

% Update handles structure



guidata(hObject, handles);



