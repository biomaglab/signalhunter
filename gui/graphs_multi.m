% Creates GUI panel and controls for OT Bioelettronica Processing
% This module create all panels and its axes that will be used to plot the
% signals
function handles = graphs_multi(handles)
% Initialization function to create GUI of axes

handles = graph_creation(handles);


function handles = graph_creation(handles)

panel_pos = get(handles.panel_tools, 'Position');

% initializing variables
% id_cond: condition identifier;
% conditions: vector of all conditions being processed;
% panel_graph: vector of panel handles parent of all axes
% haxes: vector of handles of all axes
% cond_names: name of all conditions

if ~isfield(handles, 'id_cond')
   handles.id_cond = 1; 
end

% data = handles.reader.signal.data;

% temporary just to test
% nr = handles.map_shape(1);
% nc = handles.map_shape(2);

nr = 3;
nc = 4;

% axes_h = axes_pos(4)/nr;
% axes_w = axes_pos(3)/nc;

% all_models represents the axes distribution in the panel
% format: [n rows, mcols in row 1, pcols in row 2, qcols in row n]

% handles.id_mod = [1, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5];
% handles.id_mod = 1;
processed = handles.processed;
handles.conditions = (1:handles.reader.n_frames);
model = [nr nc];
n_axes = nr*nc;

handles.cond_names = handles.reader.fig_titles;

handles.panel_graph = zeros(1, handles.conditions(end));
handles.haxes = zeros(nr, nc, handles.conditions(end));

% creates the panel for multiple graphs processing
% position depends on the tool's panel size

tic
for k = 1:handles.conditions(end)
    panelgraph_mar = [panel_pos(1), 2*panel_pos(2),...
        2*panel_pos(1), 3*panel_pos(2)];
    panelgraph_pos = [panelgraph_mar(1), panelgraph_mar(2)+panel_pos(4),...
        1-panelgraph_mar(3) 1-(panelgraph_mar(4)+panel_pos(4))];
    handles.panel_graph(k) = uipanel(handles.fig, 'BackgroundColor', 'w', ...
        'Title', handles.cond_names{k},...
        'Units', 'normalized', 'Visible', 'off');
    set(handles.panel_graph(k), 'Position', panelgraph_pos)
       
    handles.haxes = graph_model(handles.panel_graph, handles.haxes,...
        model, k);
%     plot_multi(handles.haxes, handles.processed,...
%         handles.id_mod(i), process_id, i);
%     for j = 1:n_axes
%         id_axes = [j, k];
%         [~] = plot_multi(handles.haxes(j, k), handles.reader, id_axes, k);
%     end
    for i = 1:nr
        for j = 1:nc
            id_axes = [i, j, k];
            [~] = plot_multi(handles.haxes(i, j, k), processed, id_axes);
        end
    end
%     plot_multi(handles.haxes, handles.reader, i);
    
    % progress bar update
    value = k/handles.conditions(end);
    progbar_update(handles.progress_bar, value);
    
    msg = ['Plots of ', int2str(k), ' done.'];
    handles = panel_textlog(handles, msg);
    
end
toc

set(handles.panel_graph(handles.id_cond), 'Visible', 'on');

guidata(handles.fig, handles);


function axes_ButtonDownFcn(hObject, ~)
% Callback for Button Down in each axes
handles = guidata(hObject);

handles.id_axes = find(gca == handles.haxes(:,:));
handles = dialog_detect_multi(handles);

hwbar = waitbar(0.5, 'Updating graphics...');

handles.haxes = refresh_axes(handles);

msg = ['Data and plots for ', '" ', handles.cond_names{handles.id_cond}, ' " updated.'];
handles = panel_textlog(handles, msg);

waitbar(1.0, hwbar)
close(hwbar)

% Update handles structure
guidata(hObject, handles);


function ax = graph_model(panel_graph, ax, model, id_cond)

% creates axes for signal plot
% all_models and model: configuration number of rows (nr) and columns (nc)
% axes pos: set of axes position in normalized units
% axes_w, axes_h: axes width and heigth, respectively - depends on the

nr = model(1); % y
nc = model(2); % x

% axes_pos = [0.009, 0.212, 0.991, 0.984];
axes_pos = [0.009, 0.012, 0.991, 0.984];

axes_w = (axes_pos(3)-2*axes_pos(1))/nc;
axes_h = axes_pos(4)/nr;

% zero loose inset eliminates empty spaces between axes
loose_inset = [0 0 0 0];

for i=1:nr
    for j=1:nc
        outer_pos = [axes_pos(1)+(j-1)*axes_w,...
            axes_pos(2)+(nr - i)*axes_h, axes_w, axes_h];
        ax(i, j, id_cond) = axes('Parent', panel_graph(id_cond),...
            'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
        set(ax(i, j, id_cond), 'ButtonDownFcn', @axes_ButtonDownFcn,...
            'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
        set(get(ax(i, j, id_cond),'XLabel'),'String','Time (ms)')
        set(get(ax(i, j, id_cond),'YLabel'),'String','EMG (uV)')
    end
end

% for i=1:nr*nc
%     ri = ceil(i/nr)-1;
%     ci = mod(i-1,nr)+1;
%     outer_pos = [axes_pos(1)+(ri)*axes_w,...
%         axes_pos(2)+(nr - ci)*axes_h, axes_w, axes_h];
%     ax(i, id_cond) = axes('Parent', panel_graph(id_cond),...
%         'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
%     set(ax(i, id_cond), 'ButtonDownFcn', @axes_ButtonDownFcn,...
%         'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
%     set(get(ax(i, id_cond),'XLabel'),'String','Time (s)')
%     set(get(ax(i, id_cond),'YLabel'),'String','EMG (uV)')
% end


function ax = refresh_axes(handles)
% Function to update all plots after manual changes in dialog detect

process_id = handles.reader.process_id;
ax = handles.haxes;

for i = 1:size(ax,1)
    for j = 1:size(ax,2)
        if ishandle(ax(i, j))
            cla(ax(i, j));
        end
    end
end

for i = 1:handles.conditions(end)
    [~] = plot_multi(handles.haxes(j, i), handles.reader, id_axes);   
end

% After refreshing axes, set the ButtonDownFcn callback function
set(ax, 'ButtonDownFcn', @axes_ButtonDownFcn);
