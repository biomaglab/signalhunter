% --- Creates GUI panel and controls when axes Button Down Fcn is assessed
% This GUI allows the user to change and manipulated the peak, time and
% threshold selections in the signal plotted in one axes
function varargout = dialog_detect(handles)

% create the figure, uicontrols and return the handles
hObject = figure_creation(handles);
varargout{1} = output_dialog_detect(hObject);


function varargout = output_dialog_detect(hObject)
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
figw1 = ceil(scnsize(3)*(1/2));
figh1 = floor(scnsize(4)*(1/2));
fig_pos = [0 0 figw1 figh1];

% Figure creation
% hObject is the handle to the figure
hObject = figure('Name', 'Parameters Detection', 'Color', 'w', ...
    'Units', 'pixels', 'Position', fig_pos,...
    'MenuBar', 'none', 'NumberTitle','off', 'DockControls', 'off', ...
    'KeyPressFcn', @key_press_callback);

% center the figure window on the screen
movegui(hObject, 'center');

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
handles.haxes = axes('Parent', hObject, 'OuterPosition',outer_pos,...
    'Box', 'on', 'Units', 'normalized', 'LooseInset', loose_inset);

t = [1:100];
y = sin(t);
hplot = plot(handles.haxes, t, y, 'LineWidth', 2);
xlabel('Time (s)','FontSize', 11);
ylabel('Force (N)','FontSize', 11);

% ----- Amplitude Selection

% push button for amplitude selection
pb_amp_pos = [1/6, 0.85, 4/6, 0.12];
handles.pb_amp = uicontrol(panel_graph, 'String', 'Amplitude', ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(handles.pb_amp, 'Position', pb_amp_pos);
set(handles.pb_amp, 'Callback', @pushbutton_amplitude_Callback);

% static text for minimum amplitude selection
amp_min_pos = [1/6, 0.70, 1.75/6, 0.07];
handles.text_amp_min = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized', 'HorizontalAlignment', 'center');
set(handles.text_amp_min, 'Position', amp_min_pos);

% static text for maximum amplitude selection
amp_max_pos = [3.25/6, 0.70, 1.75/6, 0.07];
handles.text_amp_max = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized');
set(handles.text_amp_max, 'Position', amp_max_pos);

% ----- Time Selection

% push button for instants of time selection
pb_time_pos = [1/6, 0.53, 4/6, 0.12];
pb_time = uicontrol(panel_graph, 'String', 'Time Instant', ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_time, 'Position', pb_time_pos);
set(pb_time, 'Callback', @pushbutton_time_Callback);

% static text for minimum amplitude selection
time_min_pos = [1/6, 0.40, 1.75/6, 0.07];
handles.text_time_min = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized', 'HorizontalAlignment', 'center');
set(handles.text_time_min, 'Position', time_min_pos);

% static text for maximum amplitude selection
time_max_pos = [3.25/6, 0.40, 1.75/6, 0.07];
handles.text_time_max = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized');
set(handles.text_time_max, 'Position', time_max_pos);

% ----- Threshold Selection

% push button for upper Y threshold selection
pb_thresh_pos = [1/6, 0.30, 4/6, 0.12];
pb_thresh = uicontrol(panel_graph, 'String', sprintf('Threshold'), ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');    
set(pb_thresh, 'Position', pb_thresh_pos);
set(pb_thresh, 'Callback', @pushbutton_thresh_Callback);

% static text for minimum amplitude selection
thresh_min_pos = [1/6, 0.07, 1.75/6, 0.07];
handles.text_thresh_min = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized', 'HorizontalAlignment', 'center');
set(handles.text_thresh_min, 'Position', thresh_min_pos);

% static text for maximum amplitude selection
thresh_max_pos = [3.25/6, 0.07, 1.75/6, 0.07];
handles.text_thresh_max = uicontrol(panel_graph, 'String', '0.00', 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized');
set(handles.text_thresh_max, 'Position', thresh_max_pos);

% push button to close dialog_detect figure
pb_close_pos = [1/6, 0.05, 4/6, 0.12];
pb_close = uicontrol(panel_graph, 'String', 'Finished', 'BackgroundColor', 'g', ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');
set(pb_close, 'Position', pb_close_pos);
set(pb_close, 'Callback', @pushbutton_close_Callback);

% align uicontrols inside the graph_panel
align([handles.haxes, panel_graph], 'None', 'Top');
align([handles.pb_amp, handles.text_amp_min, pb_time, handles.text_time_min,pb_thresh, handles.text_thresh_min, pb_close], 'Left', 'Distribute');
align([handles.pb_amp, handles.text_amp_max, pb_time, handles.text_time_max,pb_thresh, handles.text_thresh_max, pb_close], 'Right', 'Distribute');

guidata(hObject, handles);

function key_press_callback(hObject, eventdata)
% KeyPressFcn for dialog_detect figure
disp('the key was pressed')

% c_info = getCursorInfo(handles.dcm_obj);
% pos = c_info.Position;
% set(handles.text_amp_min, 'String', num2str(pos(2)));
% hold on
% plot(handles.haxes, pos(1), pos(2), 'or','LineWidth', 3);
% hold off
% handles.dcm_obj.removeDataCursor(dcm_obj.CurrentDataCursor);
% set(handles.dcm_obj, 'Enable', 'off');
eventdata.Key

function pushbutton_amplitude_Callback(hObject, eventdata)
% Callback - button for amplitude selection
handles = guidata(hObject);

% Function GETPTS used to detect (x,y) coordinates. The best one is to use
% DATACURSORMODE, but it changes the focus of window to MATLAB main
% window after pressing ENTER to select the point. The funcion GINPUT is
% also a better approach, but the cross is not limited to the AXES, which
% makes the interface ugly.
hold on

% Show information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', 'Select the minimum amplitude and click ENTER');
[x(1), y(1)] = getpts(handles.haxes);
str = ['(',num2str(x(1),'%0.3g'),', ',num2str(y(1),'%0.3g'),')'];
text(x(1),y(1),str,'VerticalAlignment','bottom');
plot(handles.haxes, x(1), y(1), 'xr', 'MarkerFaceColor', 'r', ...
    'LineWidth', 2, 'MarkerSize', 11);
set(handles.text_amp_min, 'String', num2str(y(1)));

% Show information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', 'Select the maximum amplitude and click ENTER');
[x(2), y(2)] = getpts(handles.haxes);
str = ['(',num2str(x(2),'%0.3g'),', ',num2str(y(2),'%0.3g'),')'];
text(x(2),y(2),str,'VerticalAlignment','bottom');
plot(handles.haxes, x(2), y(2), 'xg', 'MarkerFaceColor', 'g', ...
    'LineWidth', 2, 'MarkerSize', 11);
set(handles.text_amp_max, 'String', num2str(y(2)));

hold off

% Remove information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', 'w', 'String', '');

handles.peaks = [x(1), y(1); x(2), y(2)];

% --------

% GINPUT script to get (x,y) coordinates.
% hold on
% pos = ginput(1);
% plot(handles.haxes, pos(1), pos(2), 'or');
% set(handles.text_amp_min, 'String', num2str(pos(2)));
% 
% pos = ginput(1);
% plot(handles.haxes, pos(1), pos(2), 'ob');
% set(handles.text_amp_max, 'String', num2str(pos(2)));
% hold off

% --------

% DATACURSORMODE script to get (x,y) coordinates.
% hold on
% for i = 1:2
%     dcm_obj = datacursormode(gcf);
%     set(dcm_obj,'DisplayStyle','datatip',...
%         'SnapToDataVertex','off','Enable','on', ...
%         'UpdateFcn', @update_data_text)  
%     
%     pause
%    
%     c_info = getCursorInfo(dcm_obj);
%     pos = c_info.Position;
%     
%     if i == 1
%         set(handles.text_amp_min, 'String', num2str(pos(2)));
%         plot(handles.haxes, pos(1), pos(2), '+r','LineWidth', 3);
%     else
%         set(handles.text_amp_max, 'String', num2str(pos(2)));
%         plot(handles.haxes, pos(1), pos(2), '+g','LineWidth', 3);
%     end
%     dcm_obj.removeDataCursor(dcm_obj.CurrentDataCursor);
%     set(dcm_obj, 'Enable', 'off');
% end
% hold off

% Update handles structure
guidata(hObject, handles);

function pushbutton_close_Callback(hObject, eventdata)
% Callback - button to resume window
uiresume;

function pushbutton_thresh_Callback(hObject, eventdata)
% Callback - button for Y threshold selection
handles = guidata(hObject);

xl = get(handles.haxes, 'XLim');
yl = get(handles.haxes, 'YLim');
xlv = [xl(1):xl(2)];

% Function GETPTS used to detect (x,y) coordinates. The best one is to use
% DATACURSORMODE, but it changes the focus of window to MATLAB main
% window after pressing ENTER to select the point. The funcion GINPUT is
% also a better approach, but the cross is not limited to the AXES, which
% makes the interface ugly.
hold on

% Show information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', 'Select the lower threshold and click ENTER');
[x(1), y(1)] = getpts(handles.haxes);
str = ['(',num2str(y(1),'%0.3g'),')'];
text(x(1),y(1),str,'VerticalAlignment','bottom');
plot(handles.haxes, xlv, y(1)*ones(size(xlv)), '-r', 'LineWidth', 2);
set(handles.text_thresh_min, 'String', num2str(y(1)));

% Show information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', 'Select the upper threshold and click ENTER');
[x(2), y(2)] = getpts(handles.haxes);
str = ['(',num2str(y(2),'%0.3g'),')'];
text(x(2),y(2),str,'VerticalAlignment','bottom');
plot(handles.haxes, xlv, y(2)*ones(size(xlv)), '-g', 'LineWidth', 2);
set(handles.text_thresh_max, 'String', num2str(y(2)));
hold off

% Remove information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', 'w', 'String', '');

handles.thresh = [x(1), y(1); x(2), y(2)];

% Update handles structure
guidata(hObject, handles);

function pushbutton_time_Callback(hObject, eventdata)
% Callback - button for instants of time selection
handles = guidata(hObject);

% Function GETPTS used to detect (x,y) coordinates. The best one is to use
% DATACURSORMODE, but it changes the focus of window to MATLAB main
% window after pressing ENTER to select the point. The funcion GINPUT is
% also a better approach, but the cross is not limited to the AXES, which
% makes the interface ugly.
hold on

% Show information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', 'Select the initial time and click ENTER');
[x(1), y(1)] = getpts(handles.haxes);
str = ['(',num2str(x(1),'%0.3g'),' ms',')'];
text(x(1),y(1),str,'VerticalAlignment','bottom');
plot(handles.haxes, x(1), y(1), 'or', 'LineWidth', 2, 'MarkerSize', 8);
set(handles.text_time_min, 'String', num2str(x(1)));

% Show information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', 'Select the final time and click ENTER');
[x(2), y(2)] = getpts(handles.haxes);
str = ['(',num2str(x(2),'%0.3g'),' ms',')'];
text(x(2),y(2),str,'VerticalAlignment','bottom');
plot(handles.haxes, x(2), y(2), 'og', 'LineWidth', 2, 'MarkerSize', 8);
set(handles.text_time_max, 'String', num2str(x(2)));
hold off

% Remove information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', 'w', 'String', '');

handles.times = [x(1), y(1); x(2), y(2)];

% Update handles structure
guidata(hObject, handles);

% % function txt = update_data_text(hObject, eventdata)
% % % Callback - function to update DataTip for DATACURSORMODE
% % handles = guidata(hObject);
% % 
% % pos = get(eventdata,'Position');
% % txt = {['Time: ',num2str(pos(1))],...
% % 	   ['Amplitude: ',num2str(pos(2))],...
% %        'Press Enter to Select Point.'};
