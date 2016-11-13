
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


function handles = graphs_multi(handles)
% GRAPHS_MULTI Initialization function to create GUI of axes
% Creates GUI panel and controls for Multi Channels processing
% This module create all panels and its axes that will be used to plot the
% signals

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


% temporary just to test
% nr = handles.map_shape(1);
% nc = handles.map_shape(2);
process_id = handles.reader.process_id;
if process_id == 1
    nr = 3;
    nc = 4;
elseif process_id == 2
    nr = 3;
    nc = 3;
elseif process_id == 3
    nr = 3;
    nc = 3;
end

% all_models represents the axes distribution in the panel
% format: [n rows, mcols in row 1, pcols in row 2, qcols in row n]

handles.conditions = (1:handles.reader.n_frames);
model = [nr nc];

handles.cond_names = handles.reader.fig_titles;

handles.panel_graph = zeros(1, handles.conditions(end));
handles.haxes = zeros(handles.conditions(end), nc, nr);

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

    for ri = 1:nr
        for ci = 1:nc
            id_axes = [k, ci, ri];
            [~, ~, ~] = plot_multi(handles.haxes(k, ci, ri), handles.processed, id_axes);
        end
    end
    
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

[ci, ri] = find(gca == squeeze(handles.haxes(handles.id_cond,:,:)));
handles.id_axes = [handles.id_cond, ci, ri];
handles = dialog_detect_multi(handles);

progbar_update(handles.progress_bar, 0.5);

handles.haxes(handles.id_cond, ci, ri) = refresh_axes(handles);

msg = ['Data and plots for ', '" ', handles.reader.fig_titles{handles.id_cond}, ' " updated.'];
handles = panel_textlog(handles, msg);

progbar_update(handles.progress_bar, 1.0);

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
axes_pos = [0.014, 0.012, 0.991, 0.954];

axes_w = axes_pos(3)/nc-0.005;
axes_h = axes_pos(4)/nr;

% zero loose inset eliminates empty spaces between axes
loose_inset = [0 0 0 0];

for ri=1:nr
    for rj=1:nc
        outer_pos = [axes_pos(1)+(rj-1)*axes_w+0.004,...
            axes_pos(2)+(nr - ri)*axes_h, axes_w, axes_h];
        ax(id_cond, rj, ri) = axes('Parent', panel_graph(id_cond),...
            'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
        set(ax(id_cond, rj, ri), 'ButtonDownFcn', @axes_ButtonDownFcn,...
            'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
        set(get(ax(id_cond, rj, ri),'XLabel'),'String','Time (ms)')
        set(get(ax(id_cond, rj, ri),'YLabel'),'String','EMG (uV)')
        
        % Add labels to first graph at each column and row
        if ri == 1
            outertxt = [outer_pos(1) + (axes_w - 0.055)/2,...
                outer_pos(2) + axes_h, 0.07, 0.03];
            uicontrol('Parent', panel_graph(id_cond),...
                'Style','text',...
                'String', sprintf('Instant %d', rj),...
                'Units', 'normalized',...
                'FontSize', 10,...
                'FontWeight', 'bold',...
                'BackgroundColor', [1 1 1],...
                'Position',outertxt);
        end
        
        if rj == 1
            outertxt = [outer_pos(1)-0.015,...
                outer_pos(2) + (axes_h)/2, 0.015, 0.03];
            uicontrol('Parent', panel_graph(id_cond),...
                'Style','text',...
                'String', ['M' sprintf('%d', ri)],...
                'Units', 'normalized',...
                'FontSize', 10,...
                'FontWeight', 'bold',...
                'BackgroundColor', [1 1 1],...
                'Position',outertxt);
        end
        
    end

end


function ax = refresh_axes(handles)
% Function to update all plots after manual changes in dialog detect

id_axes = handles.id_axes;
ax = handles.haxes(id_axes(1), id_axes(2), id_axes(3));

if ishandle(ax)
    cla(ax);
end

[~, ~, ~] = plot_multi(ax, handles.processed, id_axes);

% After refreshing axes, set the ButtonDownFcn callback function
set(ax, 'ButtonDownFcn', @axes_ButtonDownFcn);
