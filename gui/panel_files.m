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
    'Callback', @(obj, eventdata)callback_data(obj, eventdata, 'load'));
set(pushbutton_load, 'Position', pb_load_pos, 'FontSize', fontsize);

% push button export
pushbutton_export = uicontrol(handles.panel_files, 'FontWeight', 'bold',...
    'String', 'Export', 'Units', 'normalized', 'FontUnits', 'normalized',...
    'Callback', @(obj, eventdata)callback_data(obj, eventdata, 'export'));
set(pushbutton_export, 'Position', pb_export_pos, 'FontSize', fontsize);

% push button export
pushbutton_save = uicontrol(handles.panel_files, 'FontWeight', 'bold',...
    'String', 'Save', 'Units', 'normalized', 'FontUnits', 'normalized',...
    'Callback', @(obj, eventdata)callback_data(obj, eventdata, 'save'));
%     'Callback', @pushbutton_save_Callback);
    
set(pushbutton_save, 'Position', pb_save_pos, 'FontSize', fontsize);

switch lower(handles.data_id)
    case 'tms + vc'
        align([pushbutton_load, pushbutton_export, pushbutton_save], 'None', 'Distribute');
    case 'mep analysis'
        set(pushbutton_load, 'Visible', 'off')
        set(pushbutton_save, 'Visible', 'off')
        align([pushbutton_load, pushbutton_export, pushbutton_save], 'None', 'Distribute');
end

