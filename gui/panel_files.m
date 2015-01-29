% --- Creates GUI panel and controls for TMS and Voluntary Contraction Processing
function panel_files(handles)

% create the panel and controls, and return the handles
panel_creation(handles);



function panel_creation(handles)

paneltools_pos = get(handles.panel_tools, 'Position');

panel_files_pos = [paneltools_pos(1) + paneltools_pos(3) + 0.01,...
    paneltools_pos(2), 0.089, paneltools_pos(4)];
panel_files = uipanel(handles.fig, 'Position', panel_files_pos,...
    'Title', 'Files', 'BackgroundColor', 'w', 'Units', 'normalized');

n_rows = 3; mar_x = 0.15; mar_y = 0.05;
w = 1-2*mar_x;
h = 1/n_rows-mar_y;
pos_x = mar_x;
pos_y = nan(n_rows,1);

for i = 1:n_rows
   pos_y(i) = i*mar_y + (i-1)*h;
end

pb_load_pos = [pos_x, pos_y(3), w, h];
pb_export_pos = [pos_x, pos_y(2), w, h];
pb_save_pos = [pos_x, pos_y(1), w, h];

% push button load
pushbutton_load = uicontrol(panel_files, 'FontWeight', 'bold',...
    'String', 'Load', 'Units', 'normalized', ...
    'Callback', @pushbutton_load_Callback);
set(pushbutton_load, 'Position', pb_load_pos);

% push button export
pushbutton_export = uicontrol(panel_files, 'FontWeight', 'bold',...
    'String', 'Export', 'Units', 'normalized', ...
    'Callback', @pushbutton_export_Callback);
set(pushbutton_export, 'Position', pb_export_pos);

% push button export
pushbutton_save = uicontrol(panel_files, 'FontWeight', 'bold',...
    'String', 'Save', 'Units', 'normalized', ...
    'Callback', @pushbutton_save_Callback);
set(pushbutton_save, 'Position', pb_save_pos);

align([pushbutton_load, pushbutton_export, pushbutton_save], 'None', 'Distribute');



function pushbutton_load_Callback(hObject, eventdata)
% Callback - Button Load data in MAT file
handles = guidata(hObject);

[handles.reader, handles.processed] = load_tms_vc(handles.reader);

delete(handles.panel_graph);
handles = graphs_tms_vc(handles);

% Update handles structure
guidata(hObject, handles);

function pushbutton_export_Callback(hObject, eventdata)
% Callback - Button Export in XLS file
handles = guidata(hObject);

value = 1/2;
progbar_update(handles.progress_bar, value)

output_tms_vc(handles.reader, handles.processed);

value = 1;
progbar_update(handles.progress_bar, value)

% Update handles structure
guidata(hObject, handles);

function pushbutton_save_Callback(hObject, eventdata)
% Callback - Button Save in MAT File
handles = guidata(hObject);

value = 1/2;
progbar_update(handles.progress_bar, value)

save_tms_vc(handles.reader, handles.processed);

value = 1;
progbar_update(handles.progress_bar, value)

% Update handles structure
guidata(hObject, handles);
