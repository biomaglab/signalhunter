% Creates GUI panel and controls for TMS and Voluntary Contraction Processing
% This module create all panels and its axes that will be used to plot the
% signals
function handles = graphs_tms_vc(handles)
% Initialization function to create GUI of axes

handles = graph_creation(handles);

function handles = graph_creation(handles)

panel_pos = get(handles.panel_tools, 'Position');

% initializing variables
% id_cond is the condition identifier; conditions is a vector of all
% conditions being processed; panel_graph is the vector of panel handles
% that are parent of all axes, haxes is a vector of handles of all axes and
% cond_names is the name of all conditions
handles.id_cond = 1;
handles.conditions = (1:11);
handles.panel_graph = zeros(1, handles.conditions(end));
handles.haxes = zeros(12, handles.conditions(end));
% handles.hplots = zeros(sum(n_cols), 1);

handles.cond_names = {...
    'Whole set of contractions + voluntary contractions characteristics',...
    'Whole set of contractions + neurostim while at rest',...
    'Neurostim at rest EMG VL',...
    'Neurostim at rest EMG VM',...
    'Neurostim at rest EMG RF',...
    'Neurostim at exercise EMG VL',...
    'Neurostim at exercise EMG VM',...
    'Neurostim at exercise EMG RF',...
    'TMS and MED EMG VL',...
    'TMS and MED EMG VM',...
    'TMS and MED EMG RF'};

% creates the panel for tms and voluntary contraction processing
% position depends on the tool's panel size
reader = tms_vc_reader;
processed = tms_vc_processing(reader);

for i = 1:11
    panelgraph_mar = [panel_pos(1), 2*panel_pos(2),...
        2*panel_pos(1), 3*panel_pos(2)];
    panelgraph_pos = [panelgraph_mar(1), panelgraph_mar(2)+panel_pos(4),...
        1-panelgraph_mar(3) 1-(panelgraph_mar(4)+panel_pos(4))];
    handles.panel_graph(i) = uipanel(handles.fig, 'BackgroundColor', 'w', ...
        'Title', handles.cond_names{i},...
        'Units', 'normalized', 'Visible', 'off');
    set(handles.panel_graph(i), 'Position', panelgraph_pos)
    % some conditions share the same axes configuration so they can be
    % constructed with the same commands
      
    switch i
        case 1
            handles.id_mod = 1;
            handles = graph_model(handles,i);
            plot_signals(handles, processed, i);
        case 2
            handles.id_mod = 2;
            handles = graph_model(handles, i);
            plot_signals(handles, processed, i);
        case {3, 4, 5}
            handles.id_mod = 3;
            handles = graph_model(handles, i);
            plot_signals(handles, processed, i);
        case {6, 7, 8}
            handles.id_mod = 4;
            handles = graph_model(handles, i);
            plot_signals(handles, processed, i);
        case {9, 10, 11}
            handles.id_mod = 5;
            handles = graph_model(handles, i);
            plot_signals(handles, processed, i);
    end   
    
end

set(handles.panel_graph(1), 'Visible', 'on');


function axes_ButtonDownFcn(hObject, eventdata)
% Callback for Button Down in each axes
handles = guidata(hObject);

handles = dialog_detect(handles);

% Update handles structure
guidata(hObject, handles);

function handles = graph_model(handles,id)

% creates the axes for signal plot
% all_models and model: the configuration number of rows (nr) and
% columns (nc)
% axes pos: is the set of axes position in normalized units
% axes_w, axes_h    axes width and heigth, respectively - depends on the

all_models = {[3 1 4 7], [2 1 3], [3 1 2 4], [3 1 3 3], [3 1 3 6]};
model = all_models{handles.id_mod};

nr = model(1);
nc = model(2:nr+1);

axes_pos = [0.009, 0.212, 0.991, 0.984];

axes_h = axes_pos(4)/nr;
axes_w2 = axes_pos(3)/nc(2);
axes_w3 = axes_pos(3)/nc(end);

% loose inset set to zero eliminates empyt spaces between axes
loose_inset = [0 0 0 0];

if nr == 2
    % for two rows configuration
    outer_pos = [0, axes_pos(1) + 1/nr, 1-axes_pos(1), axes_h];
    handles.haxes(1, id) = axes('Parent', handles.panel_graph(id),...
        'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
    set(handles.haxes(1, id), 'ButtonDownFcn', @axes_ButtonDownFcn, ...
        'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
    set(get(handles.haxes(1, id),'Title'),'String','Detection of Force Production')
    set(get(handles.haxes(1, id),'XLabel'),'String','Time (s)')
    set(get(handles.haxes(1, id),'YLabel'),'String','Force (N)')
    
    for i = 1:nc(2)
    outer_pos = [(i-1)*axes_w2, axes_pos(1), axes_w2, axes_h];
    handles.haxes(nc(1)+i, id) = axes('Parent', handles.panel_graph(id),...
        'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
    set(handles.haxes(nc(1)+i, id), 'ButtonDownFcn', @axes_ButtonDownFcn,...
        'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
    set(get(handles.haxes(nc(1)+i, id),'XLabel'),'String','Time (s)')
    set(get(handles.haxes(nc(1)+i, id),'YLabel'),'String','Force (N)')
    end
else
    % for three rows configuration
    % first row from the top - one axes
    outer_pos = [0, axes_pos(1) + 2/nr, 1-axes_pos(1), axes_h];
    handles.haxes(1, id) = axes('Parent', handles.panel_graph(id),...
        'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
    set(handles.haxes(1, id), 'ButtonDownFcn', @axes_ButtonDownFcn, ...
        'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
    set(get(handles.haxes(1, id),'Title'),'String','Detection of Force Production')
    set(get(handles.haxes(1, id),'XLabel'),'String','Time (s)')
    set(get(handles.haxes(1, id),'YLabel'),'String','Force (N)')
    
    % second row from the top
    for i = 1:nc(2)
    outer_pos = [(i-1)*axes_w2, axes_pos(1) + 1/nr, axes_w2, axes_h];
    handles.haxes(nc(1)+i, id) = axes('Parent', handles.panel_graph(id),...
        'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
    set(handles.haxes(nc(1)+i, id), 'ButtonDownFcn', @axes_ButtonDownFcn,...
        'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
    set(get(handles.haxes(nc(1)+i, id),'XLabel'),'String','Time (s)')
    set(get(handles.haxes(nc(1)+i, id),'YLabel'),'String','Force (N)')
    end
    
    % third row from the top
    for i = 1:nc(nr)
        outer_pos = [(i-1)*axes_w3, axes_pos(1), axes_w3, axes_h];
        handles.haxes(sum(nc(1:2))+i, id) = axes('Parent', handles.panel_graph(id),...
            'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
        set(handles.haxes(sum(nc(1:2))+i, id), 'ButtonDownFcn', @axes_ButtonDownFcn, ...
            'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
        set(get(handles.haxes(sum(nc(1:2))+i, id),'XLabel'),'String','Time (s)')
        set(get(handles.haxes(sum(nc(1:2))+i, id),'YLabel'),'String','Force (N)')
    end
    
end

