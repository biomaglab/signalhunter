
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


% --- Creates GUI panel and controls for OT Bioelettronica Processing
function handles = panel_otbio(handles)

% create the panel and controls and return the handles
handles = panel_creation(handles);



function handles = panel_creation(handles)

hObject = handles.fig;

% creates the panel for ot bioelettronica processing
panelotbio_pos = [0.005, 0.008, 0.725, 0.195];
handles.panel_tools = uipanel(hObject, 'BackgroundColor', 'w', ...
    'Title', 'OT Bioelettronica Processing',...
    'Units', 'normalized');
set(handles.panel_tools, 'Position', panelotbio_pos);

% push button trigger
pb_trig_pos = [0.01, 0.68, 0.10, 0.3];
pushbutton_trig = uicontrol(handles.panel_tools,...
    'String', 'Trigger', 'Units', 'normalized',...
    'Callback', @pushbutton_trig_Callback);
set(pushbutton_trig, 'Position', pb_trig_pos);

% text and edit for high pass frequency
text_hf_pos = [0.01, 0.35, 0.045, 0.3];
text_hf = uicontrol(handles.panel_tools, 'String', 'HF (Hz)', 'Units', 'normalized');
set(text_hf, 'Style', 'text', 'Position', text_hf_pos, 'BackgroundColor', 'w');

edit_hf_pos = [0.065, 0.35, 0.045, 0.3];
edit_hf = uicontrol(handles.panel_tools, 'String', '25','Units', 'normalized');
set(edit_hf, 'Style', 'edit', 'Position', edit_hf_pos, 'BackgroundColor', 'w');

% text and edit for low pass frequency
text_lf_pos = [0.01, 0.02, 0.045, 0.3];
text_lf = uicontrol(handles.panel_tools, 'String', 'LF (Hz)','Units', 'normalized');
set(text_lf, 'Style', 'text', 'Position', text_lf_pos, 'BackgroundColor', 'w');

edit_lf_pos = [0.065, 0.02, 0.045, 0.3];
edit_lf = uicontrol(handles.panel_tools, 'String', '400', 'Units', 'normalized');
set(edit_lf, 'Style', 'edit', 'Position', edit_lf_pos, 'BackgroundColor', 'w');

align([pushbutton_trig, text_hf, text_lf], 'Left', 'None');
align([pushbutton_trig, edit_hf, edit_lf], 'Right', 'None');
 
% push button meps
pb_meps_pos = [0.13, 0.68, 0.10, 0.3];
pushbutton_meps = uicontrol(handles.panel_tools,...
    'String', 'MEPs', 'Units', 'normalized',...
    'Callback', @pushbutton_meps_Callback);
set(pushbutton_meps, 'Position', pb_meps_pos);

% text and edit for init signal window
text_ti_pos = [0.13, 0.35, 0.045, 0.3];
text_ti = uicontrol(handles.panel_tools, 'String', 't start (ms)', 'Units', 'normalized');
set(text_ti, 'Style', 'text', 'Position', text_ti_pos, 'BackgroundColor', 'w');

edit_ti_pos = [0.18, 0.35, 0.045, 0.3];
handles.edit_ti = uicontrol(handles.panel_tools, 'String', '15', 'Units', 'normalized');
set(handles.edit_ti, 'Style', 'edit', 'Position', edit_ti_pos, 'BackgroundColor', 'w');

% text and edit for end signal window
text_tf_pos = [0.13, 0.02, 0.045, 0.3];
text_tf = uicontrol(handles.panel_tools, 'String', 't end (ms)', 'Units', 'normalized');
set(text_tf, 'Style', 'text', 'Position', text_tf_pos, 'BackgroundColor', 'w');

edit_tf_pos = [0.18, 0.02, 0.045, 0.3];
handles.edit_tf = uicontrol(handles.panel_tools, 'String', '60','Units', 'normalized');
set(handles.edit_tf, 'Style', 'edit', 'Position', edit_tf_pos, 'BackgroundColor', 'w');

align([pushbutton_meps, text_ti, text_tf], 'Left', 'None');
align([pushbutton_meps, handles.edit_ti, handles.edit_tf], 'Right', 'None');

% push button clusters
pb_cluster_pos = [0.25, 0.68, 0.10, 0.3];
pushbutton_cluster = uicontrol(handles.panel_tools, 'String', 'Clusters', 'Units', 'normalized',...
    'Callback', @pushbutton_cluster_Callback);
set(pushbutton_cluster, 'Position', pb_cluster_pos);

% push button maps
pb_maps_pos = [0.25, 0.35, 0.10, 0.3];
pushbutton_maps = uicontrol(handles.panel_tools, 'String', 'Maps','Units', 'normalized',...
    'Callback', @pushbutton_maps_Callback);
set(pushbutton_maps, 'Position', pb_maps_pos);

% push button simulated mep
pb_sim_pos = [0.25, 0.02, 0.10, 0.3];
pushbutton_sim = uicontrol(handles.panel_tools, 'String', 'Sim MEPs','Units', 'normalized',...
    'Callback', @pushbutton_sim_meps_Callback);
set(pushbutton_sim, 'Position', pb_sim_pos);

align([pushbutton_meps, text_ti, text_tf], 'None', 'Center');
 
% push button threshold
pb_thresh_pos = [0.37, 0.68, 0.1, 0.3];
pushbutton_thresh = uicontrol(handles.panel_tools, 'String', 'Threshold','Units', 'normalized',...
    'Callback', @pushbutton_thresh_Callback);
set(pushbutton_thresh, 'Position', pb_thresh_pos);

% edit for threshold value
edit_threshv_pos = [0.37, 0.35, 0.045, 0.3];
handles.edit_threshv = uicontrol(handles.panel_tools, 'String', '10','Units', 'normalized');
set(handles.edit_threshv, 'Style', 'edit', 'Position', edit_threshv_pos, 'BackgroundColor', 'w');

% push button clean
pb_clean_pos = [0.37, 0.02, 0.10, 0.3];
pushbutton_clean = uicontrol(handles.panel_tools, 'String', 'Clean','Units', 'normalized',...
    'Callback', @pushbutton_clean_Callback);
set(pushbutton_clean, 'Position', pb_clean_pos);

align([pushbutton_thresh, handles.edit_threshv, pushbutton_clean], 'Center', 'None');

% edit for threshold value
angles_names = 'Conditions: 1 - 0, 2 - 45, 3 - 90';
edit_angles_pos = [0.49, 0.68, 0.3, 0.3];
handles.edit_angles = uicontrol(handles.panel_tools, 'String', angles_names,'Units', 'normalized');
set(handles.edit_angles, 'Style', 'edit', 'Position', edit_angles_pos, 'BackgroundColor', 'w');

% edit for conditions
edit_idangle_pos = [0.49, 0.35, 0.045, 0.3];
handles.edit_idangle = uicontrol(handles.panel_tools, 'String', '0','Units', 'normalized',...
    'Callback', @edit_idangle_Callback);
set(handles.edit_idangle, 'Style', 'edit', 'Position', edit_idangle_pos, 'BackgroundColor', 'w');

align([handles.edit_angles, handles.edit_idangle], 'Center', 'None');

% push button previous
pb_prev_pos = [0.58, 0.02, 0.05, 0.3];
pushbutton_prev = uicontrol(handles.panel_tools, 'String', '<','Units', 'normalized',...
    'Callback', @pushbutton_prev_Callback);
set(pushbutton_prev, 'Position', pb_prev_pos);

% push button next
pb_next_pos = [0.645, 0.02, 0.05, 0.3];
pushbutton_next = uicontrol(handles.panel_tools, 'String', '>','Units', 'normalized',...
    'Callback', @pushbutton_next_Callback);
set(pushbutton_next, 'Position', pb_next_pos);

% Update handles structure
guidata(hObject, handles);


function pushbutton_trig_Callback(hObject, eventdata)
% Callback - Button Trigger
handles = guidata(hObject);

'button trigger callback'
for i = 1:5
    value = i/5;
    progbar_update(handles.progress_bar, value)
    pause(1)
end

% Update handles structure
guidata(hObject, handles);

function pushbutton_meps_Callback(hObject, eventdata)
% Callback - Button MEPs
handles = guidata(hObject);

'pushbutton meps callback'

% Update handles structure
guidata(hObject, handles);

function pushbutton_cluster_Callback(hObject, eventdata)
% Callback - Button Cluster Maps
handles = guidata(hObject);

'pushbutton clusters callback'

% Update handles structure
guidata(hObject, handles);

function pushbutton_maps_Callback(hObject, eventdata)
% Callback - Button Amplitude and Line Maps
handles = guidata(hObject);

'pushbutton maps callback'

% Update handles structure
guidata(hObject, handles);

function pushbutton_next_Callback(hObject, eventdata)
% Callback - Button Previous Condition
handles = guidata(hObject);

'pushbutton next callback'

% Update handles structure
guidata(hObject, handles);

function pushbutton_prev_Callback(hObject, eventdata)
% Callback - Button Previous Condition
handles = guidata(hObject);

'pushbutton previous callback'

% Update handles structure
guidata(hObject, handles);

function pushbutton_sim_meps_Callback(hObject, eventdata)
% Callback - Button Simulated MEPs
handles = guidata(hObject);

'pushbutton sim meps callback'

% Update handles structure
guidata(hObject, handles);

function pushbutton_thresh_Callback(hObject, eventdata)
% Callback - Button Threshold
handles = guidata(hObject);

'pushbutton threshold callback'

% Update handles structure
guidata(hObject, handles);

function pushbutton_clean_Callback(hObject, eventdata)
% Callback - Button Clean
handles = guidata(hObject);

'pushbutton clean callback'

% Update handles structure
guidata(hObject, handles);

function edit_idangle_Callback(hObject, eventdata)
% Callback - Edit idangle
handles = guidata(hObject);

'pushbutton edit_idangle callback'

% Update handles structure
guidata(hObject, handles);
