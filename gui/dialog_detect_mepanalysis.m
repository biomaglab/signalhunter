
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


function varargout = dialog_detect_mepanalysis(handles)
% DIALOG_DETECT_MEPANALYSIS Creates GUI panel and controls when axes Button Down Fcn is assessed
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

id = handles.id_cond;
mep_pmin = handles.reader.mep_pmin(id,2);
mep_pmax = handles.reader.mep_pmax(id,2);
mep_lat = handles.reader.mep_lat(id);
mep_end = handles.reader.mep_end(id);
% pushbutton names
pb_names = {'Amplitude', 'Latency',...
    'No MEP', 'Initial Values'};
fig_titles = handles.reader.fig_titles;

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
set(get(axesdetect,'Title'),'String',fig_titles{id})

% ----- Position of Controls

pb_detect_1_pos = [0.17, 0.85, 4/6, 0.10];
str_1_min_pos = [0.17, 0.77, 1.75/6, 0.06];
str_1_max_pos = [0.54, 0.77, 1.75/6, 0.06];
pb_detect_2_pos = [0.17, 0.65, 4/6, 0.10];
str_2_min_pos = [0.17, 0.57, 1.75/6, 0.06];
str_2_max_pos = [0.54, 0.57, 1.75/6, 0.06];
pb_detect_3_pos = [0.17, 0.45, 4/6, 0.10];
pb_detect_4_pos = [0.17, 0.30, 4/6, 0.10];
pb_close_pos = [0.17, 0.05, 4/6, 0.10];

% ----- Amplitude selection

% push button for amplitude selection
pb_detect(1) = uicontrol(panel_graph, 'String', pb_names{1}, ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_detect(1), 'Position', pb_detect_1_pos, ...
    'Callback', @pb_detect_1_Callback);

% static text for minimum amplitude selection
hstr(1,1) = uicontrol(panel_graph, 'String', num2str(mep_pmin,'%.3f'), 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized', 'HorizontalAlignment', 'center');
set(hstr(1,1), 'Position', str_1_min_pos);

% static text for maximum amplitude selection
hstr(1,2) = uicontrol(panel_graph, 'String', num2str(mep_pmax,'%.3f'), 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized');
set(hstr(1,2), 'Position', str_1_max_pos);

% ----- Latency selection

% push button for latency selection
pb_detect(2) = uicontrol(panel_graph, 'String', pb_names{2}, ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_detect(2), 'Position', pb_detect_2_pos, ...
    'Callback', @pb_detect_2_Callback);

% static text for minimum latency selection
hstr(2,1) = uicontrol(panel_graph, 'String', num2str(mep_lat,'%.3f'), 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized', 'HorizontalAlignment', 'center');
set(hstr(2,1), 'Position', str_2_min_pos);

% static text for maximum latency selection
hstr(2,2) = uicontrol(panel_graph, 'String', num2str(mep_end,'%.3f'), 'Style', 'text', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', ...
    'bold', 'Units', 'normalized');
set(hstr(2,2), 'Position', str_2_max_pos);

% ----- No MEP selection

% push button for absence of mep selection
pb_detect(3) = uicontrol(panel_graph, 'String', pb_names{3}, ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');    
set(pb_detect(3), 'Position', pb_detect_3_pos, ...
    'Callback', @pb_detect_3_Callback);

% ----- Return initial values

% push button to return for initial values
pb_detect(4) = uicontrol(panel_graph, 'String', pb_names{4}, ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');    
set(pb_detect(4), 'Position', pb_detect_4_pos, ...
    'Callback', @pb_detect_4_Callback);

% push button to close dialog_detect figure
pb_close = uicontrol(panel_graph, 'String', 'Finished', 'BackgroundColor', 'g', ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');
set(pb_close, 'Position', pb_close_pos, ...
    'Callback', @pushbutton_close_Callback);

% align uicontrols inside the graph_panel
align([axesdetect, panel_graph], 'None', 'Top');
align([pb_detect(1), hstr(1,1), pb_detect(2),...
    hstr(2,1), pb_detect(3), pb_close],...
    'Left', 'None');
align([pb_detect(1), hstr(1,2), pb_detect(2),...
    hstr(2,2), pb_detect(3), pb_close],...
    'Right', 'None');


handles.axesdetect = axesdetect;
handles.hstr = hstr;
handles.pb_names = pb_names;

signal = handles.reader.signal;
xs = handles.reader.xs;
pmin = handles.reader.mep_pmin;
pmax = handles.reader.mep_pmax;

[handles.hpmin, handles.hpmax, handles.hlat, handles.hend] = plot_mepanalysis(axesdetect,...
    signal(:,id), xs, pmin(id,:), pmax(id,:), [mep_lat, mep_end]);

% handles = plot_graph(handles);

guidata(hObject, handles);

% function handles = plot_graph(handles)
% 
% handles = plot_detect(handles, handles.id_mod(handles.id_cond));


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
% Callback - button for amplitude selection
handles = guidata(hObject);

handles = callback_detect_mepanalysis(handles, 1);

% Update handles structure
guidata(hObject, handles);

function pb_detect_2_Callback(hObject, ~)
% Callback - button for latency selection
handles = guidata(hObject);

handles = callback_detect_mepanalysis(handles, 2);

% Update handles structure
guidata(hObject, handles);

function pb_detect_3_Callback(hObject, ~)
% Callback - button for mep absence
handles = guidata(hObject);

handles = callback_detect_mepanalysis(handles, 3);

% Update handles structure
guidata(hObject, handles);

function pb_detect_4_Callback(hObject, ~)
% Callback - button for mep absence
handles = guidata(hObject);

handles = callback_detect_mepanalysis(handles, 4);

% Update handles structure
guidata(hObject, handles);

function pushbutton_close_Callback(~, ~)
% Callback - button to resume window
uiresume;


