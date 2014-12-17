% --- Creates GUI panel and controls for TMS and Voluntary Contraction Processing
function handles = panel_tms_vc(handles)

% create the panel and controls, and return the handles
handles = panel_creation(handles);

function handles = panel_creation(handles)

hObject = handles.fig;

% creates the panel for tms and voluntary contraction processing
paneltms_pos = [0.005, 0.008, 0.225, 0.195];
handles.panel_tools = uipanel(hObject, 'BackgroundColor', 'w', ...
    'Title', 'TMS and Voluntary Contraction Processing',...
    'Units', 'normalized');
set(handles.panel_tools, 'Position', paneltms_pos);

% edit for conditions value
cond_names = 'Conditions: 1 - 0, 2 - 45, 3 - 90';
edit_cond_pos = [0.1, 0.68, 0.8, 0.3];
handles.edit_cond = uicontrol(handles.panel_tools, 'String', cond_names,'Units', 'normalized');
set(handles.edit_cond, 'Style', 'edit', 'Position', edit_cond_pos, 'BackgroundColor', 'w');

% edit for threshold value
edit_idcond_pos = [0.1, 0.35, 0.2, 0.3];
handles.edit_idcond = uicontrol(handles.panel_tools, 'String', '1','Units', 'normalized',...
    'Callback', @edit_idcond_Callback);
set(handles.edit_idcond, 'Style', 'edit', 'Position', edit_idcond_pos, 'BackgroundColor', 'w');

align([handles.edit_cond, handles.edit_idcond], 'Center', 'None');

% push button previous
pb_prev_pos = [0.3, 0.02, 0.2, 0.3];
pushbutton_prev = uicontrol(handles.panel_tools, 'String', '<','Units', 'normalized',...
    'Callback', @pushbutton_prev_Callback);
set(pushbutton_prev, 'Position', pb_prev_pos);

% push button next
pb_next_pos = [0.5, 0.02, 0.2, 0.3];
pushbutton_next = uicontrol(handles.panel_tools, 'String', '>','Units', 'normalized',...
    'Callback', @pushbutton_next_Callback);
set(pushbutton_next, 'Position', pb_next_pos);

% Update handles structure
guidata(hObject, handles);

function pushbutton_next_Callback(hObject, eventdata)
% Callback - Button Previous Condition
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

function pushbutton_prev_Callback(hObject, eventdata)
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

function edit_idcond_Callback(hObject, eventdata)
% Callback - Edit idangle
handles = guidata(hObject);

'pushbutton edit_idcond callback'

% Update handles structure
guidata(hObject, handles);
