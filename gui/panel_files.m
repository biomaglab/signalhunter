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

pb_load_pos = [pos_x, pos_y(3), w, h];
pb_export_pos = [pos_x, pos_y(2), w, h];
pb_save_pos = [pos_x, pos_y(1), w, h];

fontsize = 0.5;

% push button load
pushbutton_load = uicontrol(handles.panel_files, 'FontWeight', 'bold',...
    'String', 'Load', 'Units', 'normalized', 'FontUnits', 'normalized', ...
    'Callback', @pushbutton_load_Callback);
set(pushbutton_load, 'Position', pb_load_pos, 'FontSize', fontsize);

% push button export
pushbutton_export = uicontrol(handles.panel_files, 'FontWeight', 'bold',...
    'String', 'Export', 'Units', 'normalized', 'FontUnits', 'normalized',...
    'Callback', @pushbutton_export_Callback);
set(pushbutton_export, 'Position', pb_export_pos, 'FontSize', fontsize);

% push button export
pushbutton_save = uicontrol(handles.panel_files, 'FontWeight', 'bold',...
    'String', 'Save', 'Units', 'normalized', 'FontUnits', 'normalized',...
    'Callback', @pushbutton_save_Callback);
set(pushbutton_save, 'Position', pb_save_pos, 'FontSize', fontsize);

switch lower(handles.data_id)
    case 'tms + vc'
        align([pushbutton_load, pushbutton_export, pushbutton_save], 'None', 'Distribute');
    case 'mep analysis'
        set(pushbutton_load, 'Visible', 'off')
        set(pushbutton_save, 'Visible', 'off')
        align([pushbutton_load, pushbutton_export, pushbutton_save], 'None', 'Distribute');
end


function pushbutton_load_Callback(hObject, eventdata)
% Callback - Button Load data in MAT file
handles = guidata(hObject);

switch lower(handles.data_id)
    case 'tms + vc'
        try
            [handles.reader, handles.processed] = load_tms_vc(handles.reader);
            delete(handles.panel_graph);
            handles = graphs_tms_vc(handles);
            % message to progress log
            msg = 'Processed data loaded.';
            handles = panel_textlog(handles, msg);          
        catch
            % message to progress log
            msg = 'Loading canceled.';
            handles = panel_textlog(handles, msg);            
        end
        
    case 'mep analysis'
        % message to progress log
        msg = 'Not available yet.';
        handles = panel_textlog(handles, msg);
        
end


% Update handles structure
guidata(hObject, handles);

function pushbutton_export_Callback(hObject, eventdata)
% Callback - Button Export in XLS file
handles = guidata(hObject);

% message to progress log
msg = 'Exporting data to EXCEL file...';
handles = panel_textlog(handles, msg);

value = 1/2;
progbar_update(handles.progress_bar, value)

switch lower(handles.data_id)
    case 'tms + vc'
        % message to progress log
        filt_id = output_tms_vc(handles.reader, handles.processed);
        if filt_id
            msg = 'Processed data exported to EXCEL File.';
            handles = panel_textlog(handles, msg);
        else
            msg = 'Exporting canceled.';
            handles = panel_textlog(handles, msg);
        end
        
    case 'mep analysis'
        % message to progress log
        tf = output_mepanalysis(handles.reader);
        msg = ['Processed data exported in ' num2str(tf, '%.2f') ' seconds.'];
        handles = panel_textlog(handles, msg);
end

value = 1;
progbar_update(handles.progress_bar, value)

% Update handles structure
guidata(hObject, handles);

function pushbutton_save_Callback(hObject, eventdata)
% Callback - Button Save in MAT File
handles = guidata(hObject);

% message to progress log
msg = 'Saving data to MATLAB File...';
handles = panel_textlog(handles, msg);

value = 1/2;
progbar_update(handles.progress_bar, value)

filt_id = save_tms_vc(handles.reader, handles.processed);

value = 1;
progbar_update(handles.progress_bar, value)

% message to progress log
if filt_id
    msg = 'Processed data saved to MATLAB File.';
    handles = panel_textlog(handles, msg);
else
    msg = 'Saving canceled.';
    handles = panel_textlog(handles, msg);
end

% Update handles structure
guidata(hObject, handles);
