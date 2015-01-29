% Creates GUI panel and controls for OT Bioelettronica Processing
% This module create all panels and its axes that will be used to plot the
% signals
function handles = graphs_otbio(handles)
% Initialization function to create GUI of axes

handles = graph_creation(handles);


function handles = graph_creation(handles)

panel_pos = get(handles.panel_tools, 'Position');

% creates the axes for signal plot
% axes pos          is the set of axes position, proportional to total length of figure (1400x787 pixels)
% axes_w, axes_h    axes width and heigth, respectively - depends on the
% number of axes in a row

axes_pos = [0.009, 0.009, 0.991, 0.984];

nr = handles.map_shape(1);
nc = handles.map_shape(2);

axes_h = axes_pos(4)/nr;
axes_w = axes_pos(3)/nc;

loose_inset = [0 0 0 0];

% signal reading
handles.n_channels = handles.map_shape(1)*handles.map_shape(2);
signal = zeros(5, handles.n_channels);
signal = signal(:,handles.map_template);
signal(:,:) = [];

% initializing variables
handles.haxes = zeros(handles.n_channels, 1);
handles.hplots = zeros(handles.n_channels, 1);

% creates the panel for tms and voluntary contraction processing
% position depends on the tool's panel size
panelgraph_mar = [panel_pos(1), 2*panel_pos(2),...
    2*panel_pos(1), 3*panel_pos(2)];
panelgraph_pos = [panelgraph_mar(1), panelgraph_mar(2)+panel_pos(4),...
    1-panelgraph_mar(3) 1-(panelgraph_mar(4)+panel_pos(4))];
handles.panel_graph = uipanel(hObject, 'BackgroundColor', 'w', ...
    'Title', 'OT Bioelettronica Graphs',...
    'Units', 'normalized');
set(handles.panel_graph, 'Position', panelgraph_pos)

for i=1:handles.n_channels
    ri = ceil(i/handles.map_shape(1))-1;
    ci = mod(i-1,handles.map_shape(1))+1;
    outer_pos = [axes_pos(1)+(ri)*axes_w,...
        axes_pos(2)+(handles.map_shape(1) - ci)*axes_h, axes_w, axes_h];
    handles.haxes(i) = axes('Parent', handles.panel_graph, 'OuterPosition',outer_pos,...
        'Box', 'on', 'Units', 'normalized', 'LooseInset', loose_inset);
    set(handles.haxes(i), 'FontSize', 7, 'ButtonDownFcn', @axes_ButtonDownFcn);   
end

guidata(hObject, handles);

function axes_ButtonDownFcn(hObject, eventdata)
% Callback for Button Down in each axes
handles = guidata(hObject);

handles = dialog_detect(handles);

% Update handles structure
guidata(hObject, handles);
