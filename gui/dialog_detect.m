
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


function varargout = dialog_detect(handles)
% DIALOG_DETECT Creates GUI panel and controls when axes Button Down Fcn is assessed
% This GUI allows the user to change and manipulated the peak, time and
% threshold selections in the signal plotted in one axes

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

% pushbutton names
pb_names = {{'Contraction Duration',...
    'Voluntary Amplitudes',...
    'Superimposed Force',...
    'Neurostim Amplitudes'},...
    {'Contraction Duration',...
    'Neurostim Amplitudes',...
    'Superimposed Force',...
    'Neurostim Amplitudes'},...
    {'M-wave Duration',...
    'M-wave Amplitudes',...
    'Superimposed Force',...
    'Neurostim Amplitudes'},...
    {'M-wave Duration',...
    'M-wave Amplitudes',...
    'Superimposed Force',...
    'Neurostim Amplitudes'},...
    {'MEP Duration',...
    'MEP Amplitudes',...
    'EMG Recovery',...
    'TMS Pulse'}};

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
    'Callback', @pb_detect_1_Callback);

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
    'Callback', @pb_detect_2_Callback);

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
    'Callback', @pb_detect_3_Callback);

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
    'Callback', @pb_detect_4_Callback);

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
elseif id == 2
    
elseif id == 3
        
elseif id == 4
        
else
    set(pb_detect(3), 'Visible', 'on');
    set(hstr(3,1), 'Visible', 'on');
    set(pb_detect(4), 'Visible', 'on');
    set(hstr(4,1), 'Visible', 'on');
end

handles.axesdetect = axesdetect;
handles.hstr = hstr;
handles.pb_names = pb_names;

handles = plot_graph(handles);

guidata(hObject, handles);

function handles = plot_graph(handles)

handles = plot_detect(handles, handles.id_mod(handles.id_cond));


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

function pb_detect_1_Callback(hObject, ~)
% Callback - button for superimposed force selection
handles = guidata(hObject);

handles = callback_detect_tms_vc(handles, 1);

% Update handles structure
guidata(hObject, handles);

function pushbutton_close_Callback(~, ~)
% Callback - button to resume window
uiresume;

function pb_detect_2_Callback(hObject, ~)
% Callback - button for voluntary contraction force selection
handles = guidata(hObject);

handles = callback_detect_tms_vc(handles, 2);

% Update handles structure
guidata(hObject, handles);

function pb_detect_3_Callback(hObject, ~)
% Callback - button for contraction time selection
handles = guidata(hObject);

handles = callback_detect_tms_vc(handles, 3);

% Update handles structure
guidata(hObject, handles);

function pb_detect_4_Callback(hObject, ~)
% Callback - button for neurostimulation contraction force
handles = guidata(hObject);

handles = callback_detect_tms_vc(handles, 4);

% Update handles structure
guidata(hObject, handles);

% --- Set of functions to collect cursor coordinates in a graph

% Function GETPTS used to detect (x,y) coordinates. The best one is to use
% DATACURSORMODE, but it changes the focus of window to MATLAB main
% window after pressing ENTER to select the point. The funcion GINPUT is
% also a better approach, but the cross is not limited to the AXES, which
% makes the interface ugly.
% hold on
%
% GETPTS script to get (x,y) coordinates.
% % Show information text to guide user to press enter button.
% set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
%     'String', 'Select the minimum contraction force and click ENTER');
% [x(1), y(1)] = getpts(handles.axesdetect);
% str = ['(',num2str(x(1),'%0.3g'),', ',num2str(y(1),'%0.3g'),')'];
% text(x(1),y(1),str,'VerticalAlignment','bottom');
% % plot(handles.axesdetect, x(1), y(1), 'xr', 'MarkerFaceColor', 'r', ...
% %     'LineWidth', 2, 'MarkerSize', 11);
% plot([x(1)*0.95 x(1)*1.05], [y(1) y(1)],'r');
% set(handles.text_contrac_min, 'String', num2str(y(1)));
% 
% % Show information text to guide user to press enter button.
% set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
%     'String', 'Select the maximum contraction force and click ENTER');
% [x(2), y(2)] = getpts(handles.axesdetect);
% str = ['(',num2str(x(2),'%0.3g'),', ',num2str(y(2),'%0.3g'),')'];
% text(x(2),y(2),str,'VerticalAlignment','bottom');
% % plot(handles.axesdetect, x(2), y(2), 'xg', 'MarkerFaceColor', 'g', ...
% %     'LineWidth', 2, 'MarkerSize', 11);
% plot([x(2)*0.95 x(2)*1.05], [y(2) y(2)],'r');
% set(handles.text_contrac_max, 'String', num2str(y(2)));
% 
% hold off
% 
% % Remove information text to guide user to press enter button.
% set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
% 
% handles.peaks = [x(1), y(1); x(2), y(2)];

% --------

% GINPUT script to get (x,y) coordinates.
% hold on
% pos = ginput(1);
% plot(handles.axesdetect, pos(1), pos(2), 'or');
% set(handles.text_amp_min, 'String', num2str(pos(2)));
% 
% pos = ginput(1);
% plot(handles.axesdetect, pos(1), pos(2), 'ob');
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
%         plot(handles.axesdetect, pos(1), pos(2), '+r','LineWidth', 3);
%     else
%         set(handles.text_amp_max, 'String', num2str(pos(2)));
%         plot(handles.axesdetect, pos(1), pos(2), '+g','LineWidth', 3);
%     end
%     dcm_obj.removeDataCursor(dcm_obj.CurrentDataCursor);
%     set(dcm_obj, 'Enable', 'off');
% end
% hold off


% Extra function to add text to graph with points coordinates
% % function txt = update_data_text(hObject, eventdata)
% % % Callback - function to update DataTip for DATACURSORMODE
% % handles = guidata(hObject);
% % 
% % pos = get(eventdata,'Position');
% % txt = {['Time: ',num2str(pos(1))],...
% % 	   ['Amplitude: ',num2str(pos(2))],...
% %        'Press Enter to Select Point.'};
