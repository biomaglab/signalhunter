
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


% --- Creates GUI panel and controls when axes Button Down Fcn is assessed
% This GUI allows the user to change and manipulated the peak, time and
% threshold selections in the signal plotted in one axes
function varargout = processing_emf(handles)

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
hObject = figure('Name', 'Pulse Processing', 'Color', 'w', ...
    'Units', 'pixels', 'Position', fig_pos, 'ToolBar', 'figure', ...
    'MenuBar', 'none', 'NumberTitle','off', 'DockControls', 'off', ...
    'KeyPressFcn', @key_press_callback);

% center the figure window on the screen
movegui(hObject, 'center');


% pushbutton names
pb_names = {'Window', 'Invert', 'Peak Detection', ...
    'Peak Detection (conv)', 'Initial Values'};


%fig_titles = handles.reader.fig_titles;

% creates the panel for buttons in dialog_detect
panelgraph_pos = [1.5/50 0.15 1/4 5/6];
panel_graph = uipanel(hObject, 'Title', 'Selection Tools', ...
    'BackgroundColor', 'w', 'Units', 'normalized');
set(panel_graph, 'Position', panelgraph_pos);

% information text to guide user pressing ENTER after choosing axes
% coordinates
info_text_pos = [1.5/50 0.05 1/4 1/10];
handles.info_text = uicontrol(hObject, 'Style', 'text', 'Units', 'normalized', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', 'bold');
set(handles.info_text, 'Position', info_text_pos);

% loose_inset set to zero eliminates spaces between axes
loose_inset = [0 0 0 0];

% axes for signal plotting
outer_pos = [0.30, 1/15, 2/3, 7/8];
axesdetect = axes('Parent', hObject, 'OuterPosition',outer_pos,...
    'Box', 'on', 'Units', 'normalized', 'LooseInset', loose_inset);
set(get(axesdetect,'Title'),'String','Processing')

% ----- Position of Controls

pb_detect_1_pos = [0.17, 0.85, 4/6, 0.08];
pb_detect_2_pos = [0.17, 0.75, 4/6, 0.08];
pb_detect_3_pos = [0.17, 0.65, 4/6, 0.08];
pb_detect_4_pos = [0.17, 0.55, 4/6, 0.08];
pb_detect_5_pos = [0.17, 0.45, 4/6, 0.08];
pb_close_pos = [0.17, 0.25, 4/6, 0.10];

% ----- Window select

% push button for window selection
pb_detect(1) = uicontrol(panel_graph, 'String', pb_names{1}, ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_detect(1), 'Position', pb_detect_1_pos, ...
    'Callback', @pb_detect_1_Callback);

% ----- Signal Invert

% push button for Invert tool
pb_detect(2) = uicontrol(panel_graph, 'String', pb_names{2}, ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_detect(2), 'Position', pb_detect_2_pos, ...
    'Callback', @pb_detect_2_Callback);



% ----- Automatic Peak Detection

pb_detect(3) = uicontrol(panel_graph, 'String', pb_names{3}, ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_detect(3), 'Position', pb_detect_3_pos, ...
    'Callback', @pb_detect_3_Callback);



% ----- Automatic Peak Detection (by convolution)

% push button for Automatic Peak Detection (by convolution)
pb_detect(4) = uicontrol(panel_graph, 'String', pb_names{4}, ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');    
set(pb_detect(4), 'Position', pb_detect_4_pos, ...
    'Callback', @pb_detect_4_Callback);



% ----- Return initial values

% push button to return for initial values
pb_detect(5) = uicontrol(panel_graph, 'String', pb_names{5}, ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');    
set(pb_detect(5), 'Position', pb_detect_5_pos, ...
    'Callback', @pb_detect_5_Callback);

% push button to close dialog_detect figure
pb_close = uicontrol(panel_graph, 'String', 'Finished', 'BackgroundColor', 'g', ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');
set(pb_close, 'Position', pb_close_pos, ...
    'Callback', @pushbutton_close_Callback);


handles.axesdetect = axesdetect;
handles.pb_names = pb_names;

%time values are from bkp, keeping absolute values on graph (not plotting
%from zero);
plot(handles.time, handles.raw, '.')

hold on
 if isfield(handles,'max_pos')
     if ishandle(handles.max_pos)
     plot(max_pos, handles.raw(max_pos),'.','color','r')
     end
 else
 end
 hold off
 

 
guidata(hObject, handles);


function pb_detect_1_Callback(hObject, ~)
% Callback - button for amplitude selection
handles = guidata(hObject);

handles = callback_processing_emf(handles, 1);

% Update handles structure
guidata(hObject, handles);

function pb_detect_2_Callback(hObject, ~)
% Callback - button for latency selection
handles = guidata(hObject);

handles = callback_processing_emf(handles, 2);

% Update handles structure
guidata(hObject, handles);

function pb_detect_3_Callback(hObject, ~)
% Callback - button for mep absence
handles = guidata(hObject);

handles = callback_processing_emf(handles, 3);

% Update handles structure
guidata(hObject, handles);

function pb_detect_4_Callback(hObject, ~)
% Callback - button for mep absence
handles = guidata(hObject);

handles = callback_processing_emf(handles, 4);

% Update handles structure
guidata(hObject, handles);

function pb_detect_5_Callback(hObject, ~)
% Callback - button for mep absence
handles = guidata(hObject);

handles = callback_processing_emf(handles, 5);

% Update handles structure
guidata(hObject, handles);

function pushbutton_close_Callback(hObject, ~)
% 
% if isfield(handles,'tonset_pos')==1
%     time = 0:1/(handles.signal_xs):(length(handles.signal)/handles.signal_xs);     
%     time(1) = [];
%     time = time';
%     handles.tonset = time(handles.tonset_pos);
%     handles.tduration = time(handles.tduration_pos);
%     handles.pmax_t = time(handles.pmax_pos);
%  else
% end
% 
% handles.tonset_bkp = handles.tonset;
% handles.tonset_pos_bkp = handles.tonset_pos;
% 
% handles.tduration_bkp = handles.tduration;
% handles.tduration_pos_bkp = handles.tduration_pos;
% 
% handles.pmax_bkp = handles.pmax;
% handles.pmax_pos_bkp = handles.pmax_pos;
% handles.pmax_t_bkp = handles.pmax_t;
% 
% handles.pzero = handles.signal(handles.tonset_pos);     
% handles.pzero_bkp = handles.signal(handles.tonset_pos);



% Callback - button to resume window
% guidata(hObject, handles);
uiresume;


