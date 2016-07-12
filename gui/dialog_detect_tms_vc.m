% --- Creates GUI panel and controls when axes Button Down Fcn is assessed
% This GUI allows the user to change and manipulated the peak, time and
% threshold selections in the signal plotted in one axes
function varargout = dialog_detect_tms_vc(handles)

% create the figure, uicontrols and return the handles
hObject = figure_creation(handles);
varargout{1} = output_dialog(hObject);


function varargout = output_dialog(hObject)
% Output function for dialog_detect

uiwait(hObject);
handles = guidata(hObject);
delete(hObject);

% Get default command line output from handles structure
varargout{1} = handles;


function hObject = figure_creation(handles)

% The size of screen is detected and the size of the figure is created
% relative to it
set(0,'units','pixels');
scnsize = get(0,'screensize');
figw1 = ceil(scnsize(3)*(0.7));
figh1 = floor(scnsize(4)*(0.7));
fig_pos = [0 0 figw1 figh1];

% Figure creation
% hObject is the handle to the figure
hObject = figure('Name', 'Parameters Detection', 'Color', 'w', ...
    'Units', 'pixels', 'Position', fig_pos, 'ToolBar', 'figure', ...
    'MenuBar', 'none', 'NumberTitle','off', 'DockControls', 'off', ...
    'KeyPressFcn', @key_press_callback);

% center the figure window on the screen
movegui(hObject, 'center');

id = handles.id_mod(handles.id_cond);

if id == 1 || id == 4
    if handles.id_axes == 1
        id = 11;
    elseif handles.id_axes == 61 || handles.id_axes == 73 || handles.id_axes == 85
        id = 14;
    end
elseif id == 2 && handles.id_axes == 13
    id = 12;
elseif id == 3
    % This is disabled beacuse it's not necessary now
    if handles.id_axes == 25 || handles.id_axes == 37 || handles.id_axes == 49
        id = 13;
    end
elseif id == 6 && handles.id_axes == 1
    id = 10;
end


% pushbutton names
pb_names = {{'Contraction Duration',... #id 1
    'Voluntary Amplitudes',...
    'Superimposed TMS',...
    'Superimp. Neurostim'},...
    {'Neurostim Duration',... #id 2
    'Neurostim Amplitudes',...
    'None',...
    'None'},...
    {'M-wave Duration',... #id 3
    'M-wave Amplitudes',...
    'None',...
    'None'},...
    {'M-wave Duration',... #id 4
    'M-wave Amplitudes',...
    'None',...
    'None'},...
    {'MEP Duration',... #id 5
    'MEP Amplitudes',...
    'EMG Recovery',...
    'TMS Pulse'},...
    {'Neurostim Duration',... #id 6
    'Neurostim Amplitudes',...
    'None',...
    'None'},...
    {'M-wave Duration',... #id 7
    'M-wave Amplitudes',...
    'None',...
    'None'},...
    {'Maximum Force',...#id 8
    'Force Duration',...
    'None',...
    'None'},...
    {'Force Duration',...#id 9
    'None',...
    'None',...
    'None'},...
    {'Contraction Duration 1',... #id 10
    'Maximum Contraction 1',...
    'Contraction Duration 2',...
    'Maximum Contraction 2'},...
     {'Contraction 1',... #id 11
    'Contraction 2',...
    'Contraction 3',...
    'Contraction 4'},...
    {'Contraction 1',... #id 12
    'Contraction 2',...
    'Contraction 3',...
    'None'},...
    {'Contraction 1',... #id 13
    'Contraction 2',...
    'None',...
    'None'},...
    {'Contraction 1',... #id 14
    'Contraction 2',...
    'Contraction 3',...
    'Contraction 4'}};

% creates the panel for buttons in dialog_detect
panelgraph_pos = [1.5/50 0.275 1/4 4/6];
panel_graph = uipanel(hObject, 'Title', 'Selection Tools', ...
    'BackgroundColor', 'w', 'Units', 'normalized');
set(panel_graph, 'Position', panelgraph_pos);

% information text to guide user pressing ENTER after choosing axes
% coordinates
info_text_pos = [1.5/50 2/15 1/4 1/10];
handles.info_text = uicontrol(hObject, 'Style', 'text', 'Units', 'normalized', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', 'bold');
set(handles.info_text, 'Position', info_text_pos);

% loose_inset set to zero eliminates spaces between axes
loose_inset = [0 0 0 0];

% axes for signal plotting
outer_pos = [0.30, 1/15, 2/3, 7/8];
axesdetect = axes('Parent', hObject, 'OuterPosition',outer_pos,...
    'Box', 'on', 'Units', 'normalized', 'LooseInset', loose_inset);

% ----- Position of Controls

pb_detect_1_pos = [0.17, 0.85, 4/6, 0.10];
str_1_min_pos = [0.17, 0.77, 1.75/6, 0.06];
str_1_max_pos = [0.54, 0.77, 1.75/6, 0.06];
pb_detect_2_pos = [0.17, 0.65, 4/6, 0.10];
str_2_min_pos = [0.17, 0.57, 1.75/6, 0.06];
str_2_max_pos = [0.54, 0.57, 1.75/6, 0.06];
pb_detect_3_pos = [0.17, 0.45, 4/6, 0.10];
str_3_min_pos = [0.17, 0.37, 1.75/6, 0.06];
str_3_max_pos = [0.54, 0.37, 1.75/6, 0.06];
pb_detect_4_pos = [0.17, 0.25, 4/6, 0.10];
str_4_min_pos = [0.17, 0.17, 1.75/6, 0.06];
str_4_max_pos = [0.54, 0.17, 1.75/6, 0.06];
pb_close_pos = [0.17, 0.05, 4/6, 0.10];

% ----- Superimposed force selection

% push button for superimposed force selection
pb_detect(1) = uicontrol(panel_graph, 'String', pb_names{id}(1), ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_detect(1), 'Position', pb_detect_1_pos, ...
    'Callback', @(obj, eventdata)pb_detect_Callback(obj, eventdata, id, 1));

% static text for minimum superimposed force selection
hstr(1,1) = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized', 'HorizontalAlignment', 'center');
set(hstr(1,1), 'Position', str_1_min_pos);

% static text for maximum superimposed force selection
hstr(1,2) = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized');
set(hstr(1,2), 'Position', str_1_max_pos);

% ----- Voluntary conctraction force selection

% push button for contraction selection
pb_detect(2) = uicontrol(panel_graph, 'String', pb_names{id}(2), ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_detect(2), 'Position', pb_detect_2_pos, ...
    'Callback', @(obj, eventdata)pb_detect_Callback(obj, eventdata, id, 2));

% static text for minimum contraction selection
hstr(2,1) = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized', 'HorizontalAlignment', 'center');
set(hstr(2,1), 'Position', str_2_min_pos);

% static text for maximum contraction selection
hstr(2,2) = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized');
set(hstr(2,2), 'Position', str_2_max_pos);

% ----- Voluntary contraction time selection

% push button for voluntary contraction time selection
pb_detect(3) = uicontrol(panel_graph, 'String', pb_names{id}(3), ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');    
set(pb_detect(3), 'Position', pb_detect_3_pos, 'Visible', 'off', ...
    'Callback', @(obj, eventdata)pb_detect_Callback(obj, eventdata, id, 3));

% static text for start of voluntary contraction
hstr(3,1) = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized', 'HorizontalAlignment', 'center');
set(hstr(3,1), 'Visible', 'off', 'Position', str_3_min_pos);

% static text for end of voluntary contraction
hstr(3,2) = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized');
set(hstr(3,2), 'Visible', 'off', 'Position', str_3_max_pos);

% ----- Neurostim conctraction force selection

% push button for neurostim contraction force selection
pb_detect(4) = uicontrol(panel_graph, 'String', pb_names{id}(4), ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');    
set(pb_detect(4), 'Position', pb_detect_4_pos, 'Visible', 'off', ...
    'Callback', @(obj, eventdata)pb_detect_Callback(obj, eventdata, id, 4));

% static text for neurostim minimum force selection
hstr(4,1) = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized', 'HorizontalAlignment', 'center');
set(hstr(4,1), 'Visible', 'off', 'Position', str_4_min_pos);

% static text for neurostim maximum force selection
hstr(4,2) = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized');
set(hstr(4,2), 'Visible', 'off', 'Position', str_4_max_pos);

% push button to close dialog_detect figure
pb_close = uicontrol(panel_graph, 'String', 'Finished', 'BackgroundColor', 'g', ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');
set(pb_close, 'Position', pb_close_pos, ...
    'Callback', @pushbutton_close_Callback);

% align uicontrols inside the graph_panel
align([axesdetect, panel_graph], 'None', 'Top');
align([pb_detect(1), hstr(1,1), pb_detect(2),...
    hstr(2,1), pb_detect(3), hstr(3,1),...
    pb_detect(4), hstr(4,1), pb_close], 'Left', 'Distribute');
align([pb_detect(1), hstr(1,2), pb_detect(2),...
    hstr(2,2), pb_detect(3), hstr(3,2),...
    pb_detect(4), hstr(4,2), pb_close], 'Right', 'Distribute');

if id == 1
    set(pb_detect(3), 'Visible', 'on');
    set(hstr(3,1), 'Visible', 'on');
    set(hstr(3,2), 'Visible', 'on');
    set(pb_detect(4), 'Visible', 'on');
    set(hstr(4,1), 'Visible', 'on');
    set(hstr(4,2), 'Visible', 'on');
    
elseif id == 5
    set(pb_detect(3), 'Visible', 'on');
    set(hstr(3,1), 'Visible', 'on');
    set(pb_detect(4), 'Visible', 'on');
    set(hstr(4,1), 'Visible', 'on');
    
elseif id == 9
    set(pb_detect(2), 'Visible', 'off');
    set(hstr(2,1), 'Visible', 'off');
    
elseif id == 10
    set(hstr(2,2), 'Visible', 'off');
    set(pb_detect(3), 'Visible', 'on');
    set(hstr(3,1), 'Visible', 'on');
    set(hstr(3,2), 'Visible', 'on');
    set(pb_detect(4), 'Visible', 'on');
    set(hstr(4,1), 'Visible', 'on');
    
elseif id == 11
    set(pb_detect(3), 'Visible', 'on');
    set(hstr(3,1), 'Visible', 'on');
    set(hstr(3,2), 'Visible', 'on');
    set(pb_detect(4), 'Visible', 'on');
    set(hstr(4,1), 'Visible', 'on');
    set(hstr(4,2), 'Visible', 'on');
      
elseif id == 12
    set(pb_detect(3), 'Visible', 'on');
    set(hstr(3,1), 'Visible', 'on');
    set(hstr(3,2), 'Visible', 'on');
    
elseif id == 14
    set(hstr(1,2), 'Visible', 'off');
    set(hstr(2,2), 'Visible', 'off');
    set(pb_detect(3), 'Visible', 'on');
    set(hstr(3,1), 'Visible', 'on');
    set(pb_detect(4), 'Visible', 'on');
    set(hstr(4,1), 'Visible', 'on');

end

handles.axesdetect = axesdetect;
handles.hstr = hstr;
handles.pb_names = pb_names;

handles = plot_graph(handles, id);

guidata(hObject, handles);

function handles = plot_graph(handles, id)

handles = plot_detect(handles, id);


function key_press_callback(~, eventdata)
% KeyPressFcn for dialog_detect figure
disp('the key was pressed')

% c_info = getCursorInfo(handles.dcm_obj);
% pos = c_info.Position;
% set(handles.text_amp_min, 'String', num2str(pos(2)));
% hold on
% plot(handles.axesdetect, pos(1), pos(2), 'or','LineWidth', 3);
% hold off
% handles.dcm_obj.removeDataCursor(dcm_obj.CurrentDataCursor);
% set(handles.dcm_obj, 'Enable', 'off');
eventdata.Key

function pb_detect_Callback(hObject, ~, id, id_pb)
% Callback - button for superimposed force selection
handles = guidata(hObject);

handles = callback_detect_tms_vc(handles, id, id_pb);

% Update handles structure
guidata(hObject, handles);

function pushbutton_close_Callback(~, ~)
% Callback - button to resume window
uiresume;

