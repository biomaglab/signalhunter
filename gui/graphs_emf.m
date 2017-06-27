
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


function handles = graphs_emf(handles)
% GRAPHS_EMF Initialization function to create GUI of axes
% Creates GUI panel and controls for FEM Analysis Processing
% This module create all panels and its axes that will be used to plot the
% signals

handles = graph_creation(handles);

% message to progress log
msg = 'Graphs for signal plot created.';
handles = panel_textlog(handles, msg);

function handles = graph_creation(handles)

panel_pos = get(handles.panel_tools, 'Position');

% initializing variables
% id_cond is the condition identifier; panel_graph is the vector of panel handles
% that are parents of all axes, haxes is a vector of handles of all axes and

if ~isfield(handles, 'id_cond')
   handles.id_cond = 1; 
end

handles.conditions = (1:handles.reader.n_pulses);
handles.panel_graph = zeros(1, handles.reader.n_pulses);
handles.haxes = zeros(1, handles.reader.n_pulses);

fig_titles = handles.reader.fig_titles;

% creates the panel for EMF Analysis

for i = 1:handles.reader.n_pulses
    panelgraph_mar = [panel_pos(1), 2*panel_pos(2),...
        2*panel_pos(1), 3*panel_pos(2)];
    panelgraph_pos = [panelgraph_mar(1), panelgraph_mar(2)+panel_pos(4),...
        1-panelgraph_mar(3) 1-(panelgraph_mar(4)+panel_pos(4))];
    handles.panel_graph(1,i) = uipanel(handles.fig,...
        'BackgroundColor', 'w', 'Title', fig_titles{i},...
        'Units', 'normalized', 'Visible', 'off');
    set(handles.panel_graph(1,i), 'Position', panelgraph_pos)
      
    handles.haxes(1,i) = graph_model(handles.panel_graph, fig_titles, i);
    
    
    plot_emf(handles.haxes(1, i), handles.reader.signal{:,i},...
        handles.reader.xs{:,i}, handles.reader.tstart(i), handles.reader.tonset(i),...
        handles.reader.tend(i), handles.reader.time, handles.reader.raw);
    
    % progress bar update
    value = i/handles.reader.n_pulses;
    progbar_update(handles.progress_bar, value);
    
    msg = [num2str(i) ' Plots of Pulse', '" ', fig_titles{i}, ' " done.'];
    handles = panel_textlog(handles, msg);
    
end
toc

set(handles.panel_graph(handles.id_cond), 'Visible', 'on');

guidata(handles.fig, handles);


function axes_ButtonDownFcn(hObject, eventdata)
% Callback for Button Down in each axes
handles = guidata(hObject);

id = handles.id_cond;

handles.id_axes = find(gca == handles.haxes(1,:));
handles = dialog_detect_emf(handles);
handles.haxes(1, id) = refresh_axes(handles.haxes(1, id), handles.reader.signal(:, id),...
    handles.reader.xs(1,id), handles.reader.pzero(1,id), handles.reader.pmax(1,id),...
    handles.reader.pmax_t(1,id), handles.reader.tonset(1,id), ...
    handles.reader.tonset_bkp(1,id),...
    handles.reader.tduration(1,id), handles.reader.tduration_bkp(1,id));

msg = [num2str(id) ' Data and plots for ', '" ', handles.reader.fig_titles{handles.id_cond}, ' " updated.'];
handles = panel_textlog(handles, msg);

% Update handles structure
guidata(hObject, handles);

function ax = graph_model(panel_graph, fig_titles, id_cond)

% creates the axes for signal plot

% loose inset set to zero eliminates empyt spaces between axes
loose_inset = [0 0 0 0];

outer_pos = [0, 0, 1.0, 1.0];
ax = axes('Parent', panel_graph(id_cond),...
    'OuterPosition',outer_pos, 'Box', 'on', 'Units', 'normalized');
set(ax, 'LooseInset', loose_inset, ...
    'FontSize', 7, 'NextPlot', 'add');
set(ax, 'ButtonDownFcn', @axes_ButtonDownFcn, ...
    'LooseInset', loose_inset, 'FontSize', 7, 'NextPlot', 'add');
set(get(ax,'Title'),'String',fig_titles{id_cond})
set(get(ax,'XLabel'),'String','Time (s)')
set(get(ax,'YLabel'),'String','Amplitude (mV)')
 
function ax = refresh_axes(ax, signal, xs, pzero, pmax, pmax_t, onset, onset_bkp, duration, duration_bkp)
% Function to update all plots after manual changes in dialog detect

if ishandle(ax)
    cla(ax);
end

plot_emf(ax, signal, xs, pzero, pmax, pmax_t, onset, onset_bkp, duration, duration_bkp);

set(ax, 'ButtonDownFcn', @axes_ButtonDownFcn);
