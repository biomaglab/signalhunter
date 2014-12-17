% --- Creates GUI panel and controls for TMS and Voluntary Contraction Processing
function panel_files(hObject)

% create the panel and controls, and return the handles
panel_creation(hObject);



function panel_creation(hObject)

handles = guidata(hObject);

% creates the panel for files functions
panel_files_pos = [0.736, 0.009, 0.089, 0.195];
panel_files = uipanel(hObject, 'Position', panel_files_pos,...
    'Title', 'Files', 'BackgroundColor', 'w', 'Units', 'normalized');

% push button load
pb_load_pos = [0.15, 0.05, 0.7, 0.3];
pushbutton_load = uicontrol(panel_files,...
    'String', 'Load', 'Units', 'normalized', ...
    'Callback', @pushbutton_load_Callback);
set(pushbutton_load, 'Position', pb_load_pos);

% push button export
pb_export_pos = [0.15, 0.4, 0.7, 0.3];
pushbutton_export = uicontrol(panel_files,...
    'String', 'Export', 'Units', 'normalized', ...
    'Callback', @pushbutton_export_Callback);
set(pushbutton_export, 'Position', pb_export_pos);

% push button export
pb_save_pos = [0.15, 0.70, 0.7, 0.3];
pushbutton_save = uicontrol(panel_files,...
    'String', 'Save', 'Units', 'normalized', ...
    'Callback', @pushbutton_save_Callback);
set(pushbutton_save, 'Position', pb_save_pos);

align([pushbutton_load, pushbutton_export, pushbutton_save], 'None', 'Distribute');
 
% Update handles structure
guidata(hObject, handles);


function pushbutton_load_Callback(hObject, eventdata)
% Callback - Button Load data in MAT file
handles = guidata(hObject);

'button load callback'
for i = 1:5
    value = i/5;
    update_progress_bar(handles.progress_bar, value)
    pause(1)
end

% Update handles structure
guidata(hObject, handles);

function pushbutton_export_Callback(hObject, eventdata)
% Callback - Button Export in XLS file
handles = guidata(hObject);

'pushbutton export callback'

% Update handles structure
guidata(hObject, handles);

function pushbutton_save_Callback(hObject, eventdata)
% Callback - Button Save in MAT File
handles = guidata(hObject);

'pushbutton save callback'

% Update handles structure
guidata(hObject, handles);