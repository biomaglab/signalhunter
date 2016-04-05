% Creates GUI panel and controls for TMS and Voluntary Contraction Processing
% This module create all panels and its axes that will be used to plot the
% signals
function handles = graphs_tms_vc(handles)
% Initialization function to create GUI of axes

handles = graph_creation(handles);

% message to progress log
msg = 'Graphs for signal plot created.';
handles = panel_textlog(handles, msg);

function handles = graph_creation(handles)

panel_pos = get(handles.panel_tools, 'Position');

% initializing variables
% id_cond is the condition identifier; conditions is a vector of all
% conditions being processed; panel_graph is the vector of panel handles
% that are parent of all axes, haxes is a vector of handles of all axes and
% cond_names is the name of all conditions

if ~isfield(handles, 'id_cond')
   handles.id_cond = 1; 
end

process_id = handles.reader.process_id;

% all_models represente the axes distribution in the panel
% format: [n rows, mcols in row 1, pcols in row 2, qcols in row n]

if process_id == 1
    handles.id_mod = [1, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5];
    handles.conditions = (1:11);
    all_models = {[3 1 4 7], [2 1 3], [3 1 2 4], [3 1 3 3], [3 1 3 6]};
elseif process_id == 2
    handles.id_mod = [6, 7];
    handles.conditions = (1:2);
    all_models = {[2 1 1], [2 3 3]};
elseif process_id == 3
    handles.id_mod = [8, 9];
    handles.conditions = (1:2);
    all_models = {[1 1], [3 1 1 1]};
end

handles.cond_names = handles.reader.fig_titles;

handles.panel_graph = zeros(1, handles.conditions(end));
handles.haxes = zeros(length(handles.conditions)+1, handles.conditions(end));
% handles.hplots = zeros(sum(n_cols), 1);

% handles.cond_names = {...
%     'Whole set of contractions + voluntary contractions characteristics',...
%     'Whole set of contractions + neurostim while at rest',...
%     'Neurostim at rest EMG VL',...
%     'Neurostim at rest EMG VM',...
%     'Neurostim at rest EMG RF',...
%     'Neurostim at exercise EMG VL',...
%     'Neurostim at exercise EMG VM',...
%     'Neurostim at exercise EMG RF',...
%     'TMS and MEP EMG VL',...
%     'TMS and MEP EMG VM',...
%     'TMS and MEP EMG RF'};

% creates the panel for tms and voluntary contraction processing
% position depends on the tool's panel size

tic
for i = 1:length(handles.conditions)
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
    
    model = all_models{handles.id_mod(i)};
    
    handles.haxes = graph_model(handles.panel_graph, handles.haxes,...
        model, i);
    plot_signals(handles.haxes, handles.processed,...
        handles.id_mod(i), process_id, i);
    
    % progress bar update
    value = i/length(handles.conditions);
    progbar_update(handles.progress_bar, value);
    
    msg = ['Plots of ', '" ', handles.cond_names{i}, ' " done.'];
    handles = panel_textlog(handles, msg);
    
end
toc

set(handles.panel_graph(handles.id_cond), 'Visible', 'on');

guidata(handles.fig, handles);


function axes_ButtonDownFcn(hObject, eventdata)
% Callback for Button Down in each axes
handles = guidata(hObject);

% ['coisa ' num2str(find(gca == handles.haxes(:)))]
handles.id_axes = find(gca == handles.haxes(:,:));
handles = dialog_detect(handles);
handles.haxes = refresh_axes(handles.haxes, handles.processed,...
    handles.id_mod, handles.id_cond);

msg = ['Data and plots for ', '" ', handles.cond_names{handles.id_cond}, ' " updated.'];
handles = panel_textlog(handles, msg);

% Update handles structure
guidata(hObject, handles);

function ax = graph_model(panel_graph, ax, model, id_cond)

% creates the axes for signal plot
% all_models and model: the configuration number of rows (nr) and
% columns (nc)
% axes pos: is the set of axes position in normalized units
% axes_w, axes_h    axes width and heigth, respectively - depends on the


nr = model(1);
nc = model(2:nr+1);

axes_pos = [0.009, 0.212, 0.991, 0.984];

axes_h = axes_pos(4)/nr;
axes_w2 = axes_pos(3)/nc(2);
axes_w3 = axes_pos(3)/nc(end);

% loose inset set to zero eliminates empyt spaces between axes
loose_inset = [0 0 0 0];

if nr == 1
    % for two rows configuration
    outer_pos = [0, 0, 1, 1];
    ax(1, id_cond) = axes('Parent', panel_graph(id_cond),...
        'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
%     set(ax(1, id_cond), 'LooseInset', loose_inset, ...
%         'FontSize', 7, 'NextPlot', 'add');
    set(ax(1, id_cond), 'ButtonDownFcn', @axes_ButtonDownFcn, ...
        'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
    set(get(ax(1, id_cond),'Title'),'String','Detection of Force Production')
    set(get(ax(1, id_cond),'XLabel'),'String','Time (s)')
    set(get(ax(1, id_cond),'YLabel'),'String','Force (N)')

elseif nr == 2
    % for two rows configuration
    outer_pos = [0, axes_pos(1) + 1/nr, 1-axes_pos(1), axes_h];
    ax(1, id_cond) = axes('Parent', panel_graph(id_cond),...
        'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
    set(ax(1, id_cond), 'LooseInset', loose_inset, ...
        'FontSize', 7, 'NextPlot', 'add');
%     set(ax(1, id), 'ButtonDownFcn', @axes_ButtonDownFcn, ...
%         'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
    set(get(ax(1, id_cond),'Title'),'String','Detection of Force Production')
    set(get(ax(1, id_cond),'XLabel'),'String','Time (s)')
    set(get(ax(1, id_cond),'YLabel'),'String','Force (N)')
    
    for i = 1:nc(2)
    outer_pos = [(i-1)*axes_w2, axes_pos(1), axes_w2, axes_h];
    ax(nc(1)+i, id_cond) = axes('Parent', panel_graph(id_cond),...
        'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
    set(ax(nc(1)+i, id_cond), 'ButtonDownFcn', @axes_ButtonDownFcn,...
        'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
    set(get(ax(nc(1)+i, id_cond),'XLabel'),'String','Time (s)')
    set(get(ax(nc(1)+i, id_cond),'YLabel'),'String','Force (N)')
    end
else
    % for three rows configuration
    % first row from the top - one axes
    outer_pos = [0, axes_pos(1) + 2/nr, 1-axes_pos(1), axes_h];
    ax(1, id_cond) = axes('Parent', panel_graph(id_cond),...
        'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
    set(ax(1, id_cond), 'LooseInset', loose_inset, ...
        'FontSize', 7, 'NextPlot', 'add');
%     set(ax(1, id), 'ButtonDownFcn', @axes_ButtonDownFcn, ...
%         'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
    set(get(ax(1, id_cond),'Title'),'String','Detection of Force Production')
    set(get(ax(1, id_cond),'XLabel'),'String','Time (s)')
    set(get(ax(1, id_cond),'YLabel'),'String','Force (N)')
    
    % second row from the top
    for i = 1:nc(2)
    outer_pos = [(i-1)*axes_w2, axes_pos(1) + 1/nr, axes_w2, axes_h];
    ax(nc(1)+i, id_cond) = axes('Parent', panel_graph(id_cond),...
        'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
    set(ax(nc(1)+i, id_cond), 'ButtonDownFcn', @axes_ButtonDownFcn,...
        'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
    set(get(ax(nc(1)+i, id_cond),'XLabel'),'String','Time (s)')
    set(get(ax(nc(1)+i, id_cond),'YLabel'),'String','Force (N)')
    end
    
    % third row from the top
    for i = 1:nc(nr)
        outer_pos = [(i-1)*axes_w3, axes_pos(1), axes_w3, axes_h];
        ax(sum(nc(1:2))+i, id_cond) = axes('Parent', panel_graph(id_cond),...
            'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
        set(ax(sum(nc(1:2))+i, id_cond), 'LooseInset', loose_inset, ...
            'FontSize', 7, 'NextPlot', 'add');
%         set(ax(sum(nc(1:2))+i, id), 'ButtonDownFcn', @axes_ButtonDownFcn, ...
%             'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
        set(get(ax(sum(nc(1:2))+i, id_cond),'XLabel'),'String','Time (s)')
        set(get(ax(sum(nc(1:2))+i, id_cond),'YLabel'),'String','Force (N)')
    end
    
end

function ax = refresh_axes(ax, processed, id_mod, id_cond)
% Function to update all plots after manual changes in dialog detect

for i = 1:size(ax,1)
    if ishandle(ax(i, id_cond))
        cla(ax(i, id_cond));
    end
end

plot_signals(ax, processed, id_mod(id_cond), id_cond);
for j = 2:5
    set(ax(j, id_cond), 'ButtonDownFcn', @axes_ButtonDownFcn);
end
