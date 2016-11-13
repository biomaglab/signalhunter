
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


function handles = graphs_otbio(handles)
% GRAPHS_OTBIO Initialization function to create GUI of axes
% Creates GUI panel and controls for OT Bioelettronica Processing
% This module create all panels and its axes that will be used to plot the
% signals

handles = graph_creation(handles);


function handles = graph_creation(handles)

% % % panel_pos = get(handles.panel_tools, 'Position');
% % % 
% % % % creates the axes for signal plot
% % % % axes pos          is the set of axes position, proportional to total length of figure (1400x787 pixels)
% % % % axes_w, axes_h    axes width and heigth, respectively - depends on the
% % % % number of axes in a row
% % % 
% % % axes_pos = [0.009, 0.009, 0.991, 0.984];
% % % 
% % % nr = handles.map_shape(1);
% % % nc = handles.map_shape(2);
% % % 
% % % axes_h = axes_pos(4)/nr;
% % % axes_w = axes_pos(3)/nc;
% % % 
% % % loose_inset = [0 0 0 0];
% % % 
% % % % signal reading
% % % handles.n_channels = handles.map_shape(1)*handles.map_shape(2);
% % % signal = zeros(5, handles.n_channels);
% % % signal = signal(:,handles.map_template);
% % % signal(:,:) = [];
% % % 
% % % % initializing variables
% % % handles.haxes = zeros(handles.n_channels, 1);
% % % handles.hplots = zeros(handles.n_channels, 1);
% % % 
% % % % creates the panel for tms and voluntary contraction processing
% % % % position depends on the tool's panel size
% % % panelgraph_mar = [panel_pos(1), 2*panel_pos(2),...
% % %     2*panel_pos(1), 3*panel_pos(2)];
% % % panelgraph_pos = [panelgraph_mar(1), panelgraph_mar(2)+panel_pos(4),...
% % %     1-panelgraph_mar(3) 1-(panelgraph_mar(4)+panel_pos(4))];
% % % handles.panel_graph = uipanel(hObject, 'BackgroundColor', 'w', ...
% % %     'Title', 'OT Bioelettronica Graphs',...
% % %     'Units', 'normalized');
% % % set(handles.panel_graph, 'Position', panelgraph_pos)
% % % 
% % % for i=1:handles.n_channels
% % %     ri = ceil(i/handles.map_shape(1))-1;
% % %     ci = mod(i-1,handles.map_shape(1))+1;
% % %     outer_pos = [axes_pos(1)+(ri)*axes_w,...
% % %         axes_pos(2)+(handles.map_shape(1) - ci)*axes_h, axes_w, axes_h];
% % %     handles.haxes(i) = axes('Parent', handles.panel_graph, 'OuterPosition',outer_pos,...
% % %         'Box', 'on', 'Units', 'normalized', 'LooseInset', loose_inset);
% % %     set(handles.haxes(i), 'FontSize', 7, 'ButtonDownFcn', @axes_ButtonDownFcn);   
% % % end
% % % 
% % % guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

panel_pos = get(handles.panel_tools, 'Position');

% initializing variables
% id_cond is the condition identifier; conditions is a vector of all
% conditions being processed; panel_graph is the vector of panel handles
% that are parent of all axes, haxes is a vector of handles of all axes and
% cond_names is the name of all conditions

if ~isfield(handles, 'id_cond')
   handles.id_cond = 1; 
end

% process_id = handles.reader.process_id;
process_id = 1;
data = handles.reader.signal.data;

nr = handles.map_shape(1);
nc = handles.map_shape(2);

% axes_h = axes_pos(4)/nr;
% axes_w = axes_pos(3)/nc;

% all_models represents the axes distribution in the panel
% format: [n rows, mcols in row 1, pcols in row 2, qcols in row n]

% handles.id_mod = [1, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5];
handles.id_mod = 1;
handles.processed = [];
handles.conditions = (1:size(data,3));
handles.cond_names = {{'cond1'}, {'cond2'}};
% all_models = {[3 1 4 7], [2 1 3], [3 1 2 4], [3 1 3 3], [3 1 3 6]};
model = [nr nc];

% handles.cond_names = handles.reader.fig_titles;

handles.panel_graph = zeros(1, length(handles.conditions));
handles.haxes = zeros(nr*nc, length(handles.conditions));

% creates the panel for multiple graphs processing
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
       
    handles.haxes = graph_model(handles.panel_graph, handles.haxes,...
        model, process_id, i);
%     plot_multi(handles.haxes, handles.processed,...
%         handles.id_mod(i), process_id, i);
    plot_multi(handles.haxes, handles.reader, i);
    
    % progress bar update
    value = i/length(handles.conditions);
    progbar_update(handles.progress_bar, value);
    
    msg = ['Plots of ', '" ', int2str(i), ' " done.'];
    handles = panel_textlog(handles, msg);
    
end
toc

set(handles.panel_graph(handles.id_cond), 'Visible', 'on');

guidata(handles.fig, handles);


function axes_ButtonDownFcn(hObject, eventdata)
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


function ax = graph_model(panel_graph, ax, model, process_id, id_cond)

% creates the axes for signal plot
% all_models and model: the configuration number of rows (nr) and
% columns (nc)
% axes pos: is the set of axes position in normalized units
% axes_w, axes_h    axes width and heigth, respectively - depends on the

nr = model(1);
nc = model(2);

axes_pos = [0.009, 0.212, 0.991, 0.984];

axes_h = axes_pos(4)/nr;
axes_w = axes_pos(3)/nc;
% if length(nc) > 1
%     axes_w2 = axes_pos(3)/nc(2);
%     axes_w3 = axes_pos(3)/nc(end);
% end

% loose inset set to zero eliminates empty spaces between axes
loose_inset = [0 0 0 0];

% MVC Pre

% % for two rows, configuration 2 x 3
% labels = {'M-wave for EMG VL','M-wave for EMG VM',...
%     'M-wave for EMG RF'};
% for i = 1:nc(1)
%     outer_pos = [(i-1)*axes_w, axes_pos(1)  + 1/nr, axes_w, axes_h];
%     ax(i, id_cond) = axes('Parent', panel_graph(id_cond),...
%         'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
%     set(ax(i, id_cond), 'ButtonDownFcn', @axes_ButtonDownFcn,...
%         'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
%     set(get(ax(i, id_cond),'Title'),'String',labels{i})
%     set(get(ax(i, id_cond),'XLabel'),'String','Time (s)')
%     set(get(ax(i, id_cond),'YLabel'),'String','EMG (V)')
% end

for i=1:nr*nc
    ri = ceil(i/nr)-1;
    ci = mod(i-1,nr)+1;
    outer_pos = [axes_pos(1)+(ri)*axes_w,...
        axes_pos(2)+(nr - ci)*axes_h, axes_w, axes_h];
    ax(i, id_cond) = axes('Parent', panel_graph(id_cond),...
        'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
    set(ax(i, id_cond), 'ButtonDownFcn', @axes_ButtonDownFcn,...
        'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
    set(get(ax(i, id_cond),'XLabel'),'String','Time (s)')
    set(get(ax(i, id_cond),'YLabel'),'String','EMG (V)')
end



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

for i = 1:length(handles.conditions)
    
    plot_signals(ax, handles.processed, handles.id_mod(i), process_id, i);
    
end

% After refreshing axes, set the ButtonDownFcn callback function
set(ax, 'ButtonDownFcn', @axes_ButtonDownFcn);
