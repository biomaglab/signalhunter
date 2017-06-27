
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

% first row of buttons
pb_prev_pos = [pos_x(1,1), pos_y(1), w(1)+0.07, h];
pb_next_pos = [pos_x(1,2)+0.07, pos_y(1), w(1)+0.07, h];
edit_idcond_pos = [pos_x(1,3)+0.15, pos_y(1)+0.02, w(1)-0.05, h-0.05];

% second row of buttons
pb_open_pos = [pos_x(2,1), pos_y(2), w(2)+0.07, h];
pb_save_pos = [pos_x(2,2)+0.07, pos_y(2), w(2)+0.07, h];
% pb_del_pos = [pos_x(2,3), pos_y(



% push button to Open Files (*.bin, raw *.mat and processed *.mat)
pushbutton_open = uicontrol(handles.panel_tools, 'String', 'Open',...
    'Units', 'normalized', 'FontWeight', 'bold', 'FontUnits', 'normalized',...
    'Callback', @pushbutton_open_Callback);
set(pushbutton_open, 'Position', pb_open_pos, 'FontSize', 0.3);

% push button to Save and Export files (*.csv and *.mat)
pushbutton_save = uicontrol(handles.panel_tools, 'String', 'Save',...
    'Units', 'normalized', 'FontWeight', 'bold', 'FontUnits', 'normalized',...
    'Callback', @pushbutton_save_Callback);
set(pushbutton_save, 'Position', pb_save_pos, 'FontSize', 0.3);

% push button to previous plot
pushbutton_prev = uicontrol(handles.panel_tools, 'String', '<',...
    'Units', 'normalized', 'FontWeight', 'bold',...
    'FontUnits', 'normalized', 'Callback', @pushbutton_prev_Callback);
set(pushbutton_prev, 'Position', pb_prev_pos, 'FontSize', 0.4);

% push button to next plot
pushbutton_next = uicontrol(handles.panel_tools, 'String', '>',...
    'Units', 'normalized', 'FontWeight', 'bold',...
    'FontUnits', 'normalized', 'Callback', @pushbutton_next_Callback);
set(pushbutton_next, 'Position', pb_next_pos, 'FontSize', 0.4);

% edit for plot selection
handles.edit_idcond = uicontrol(handles.panel_tools, 'Style', 'edit',...
    'String', '1', 'BackgroundColor', 'w', 'Units', 'normalized',...
    'FontWeight', 'bold', 'FontUnits', 'normalized',...
    'Callback', @edit_idcond_Callback);
set(handles.edit_idcond, 'Position', edit_idcond_pos, 'FontSize', 0.4);

align([pushbutton_prev, pushbutton_next, handles.edit_idcond], 'Distribute', 'Center');

% panel for Variables exhibition (Onset time, Total duration and Amplitude)
info_panel_pos = [0.16, 0.008, 0.10, 0.16];
handles.info_panel = uipanel(hObject, 'BackgroundColor', 'w', ...
    'Title', 'Info panel',...
    'Units', 'normalized');
set(handles.info_panel, 'Position', info_panel_pos,'Visible','On');


% Update handles structure
guidata(hObject, handles);

function pushbutton_next_Callback(hObject, ~)
% Callback - Button Previous Condition
handles = guidata(hObject);

set(handles.panel_graph(handles.id_cond), 'Visible', 'off');
set(handles.info_text(handles.id_cond),'Visible','off');


% By changing id_cond, plots are updated in panel_emf
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
set(handles.info_text(handles.id_cond),'FontSize',0.12,'Visible','on');

% Update handles structure
guidata(hObject, handles);

function pushbutton_prev_Callback(hObject, eventdata)
% Callback - Button Previous Condition
handles = guidata(hObject);

set(handles.panel_graph(handles.id_cond), 'Visible', 'off');
set(handles.info_text(handles.id_cond),'Visible','off');


% By changing id_cond, plots are updated in panel_emf
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
set(handles.info_text(handles.id_cond),'FontSize',0.12,'Visible','on');

% Update handles structure
guidata(hObject, handles);

function pushbutton_open_Callback(hObject, eventdata)
% Callback - Button Open
handles = guidata(hObject);

% message to progress log
msg = 'Reading signal data...';
handles = panel_textlog(handles, msg);

%
handles.reader = reader_emf;

msg = char(strcat('Equipment: ''', cellstr(handles.reader.equipment), ...
    '''; Mode: ''', cellstr(handles.reader.mode), ...
    '''; Number of pulses: ',  num2str(handles.reader.n_pulses),'. '));
handles = panel_textlog(handles, msg);

handles = graphs_emf(handles);

% Update handles structure
guidata(hObject, handles);

function pushbutton_save_Callback(hObject, eventdata)
% Callback - Button Save

handles = guidata(hObject);

% create labels for .csv file.
rowlabels = {'Filename';'Equipment';'Mode';'Stimulation_Frequency';'Pulse_num';'Start_s';...
    'Onset_us';'Duration_us';'Amplitude_mV'};

% Choose filename to .csv file
[filename, pathname] = uiputfile('.csv','Create new file or append to existing one', ...
    [handles.reader.pathname,handles.reader.filename]);

% If file selected already exists, aux variable will help to append new
% values to the same .csv
if exist([pathname,filename])==2
    
    export = table2cell(readtable([pathname,filename]));
    aux = size(export,1) + 1;
    
else
    aux = 1;
    
end

% for loop will begin at the aux value. If is a new .csv file, aux = 1.
% Else, aux is equal to the last file in previous .csv, appending new
% values to the older ones.
for i = aux:(handles.reader.n_pulses + aux - 1)
    
    % Export variables must follow rowlabels order, defined before
    export{i,1} = cellstr(handles.reader.filename);
    export{i,2} = cellstr(handles.reader.equipment);
    export{i,3} = cellstr(handles.reader.mode);
    export{i,4} = (handles.reader.freq);
    export{i,5} = i - aux + 1;
    export{i,6} = (handles.reader.tstart(i - aux + 1) - handles.reader.tstart(1))/handles.reader.fs;
    export{i,7} = handles.reader.onset(i - aux + 1);
    export{i,8} = handles.reader.duration(i - aux + 1);
    export{i,9} = handles.reader.amplitude(i - aux + 1);
    
end

% Table_export converts appended (or new) cell array to table format.
% Then is exported using writetable function
table_export = cell2table(export,'VariableNames',rowlabels);
writetable(table_export,[pathname,filename])

% message to progress log
msg = strcat('Variables exported to ',pathname, filename);
handles = panel_textlog(handles, msg);


% data variable store only handles.reader variable, which can be read
% by EMF_Analysis after
[filename, pathname] = uiputfile('.mat','Create a new file for reader data',...
    [handles.reader.pathname,handles.reader.filename]);

data = handles.reader;
save([pathname,filename],'data');

% message to progress log
msg = strcat('Handles.reader variables save to ',handles.reader.pathname,handles.reader.filename,'.mat');
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

