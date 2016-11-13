
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


function handles = graphs_mepanalysis(handles)
% GRAPHS_MEPANALYSIS Initialization function to create GUI of axes
% Creates GUI panel and controls for MEP Analysis Processing
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

n_meps = handles.reader.n_meps;
signal = handles.reader.signal;
xs = handles.reader.xs;
pmin = handles.reader.mep_pmin;
pmax = handles.reader.mep_pmax;
mep_lat = handles.reader.mep_lat;
mep_end = handles.reader.mep_end;

handles.conditions = (1:n_meps);
handles.panel_graph = zeros(1, n_meps);
handles.haxes = zeros(1, n_meps);

fig_titles = handles.reader.fig_titles;

% creates the panel for mep analysis processing

tic
for i = 1:n_meps
    panelgraph_mar = [panel_pos(1), 2*panel_pos(2),...
        2*panel_pos(1), 3*panel_pos(2)];
    panelgraph_pos = [panelgraph_mar(1), panelgraph_mar(2)+panel_pos(4),...
        1-panelgraph_mar(3) 1-(panelgraph_mar(4)+panel_pos(4))];
    handles.panel_graph(1,i) = uipanel(handles.fig,...
        'BackgroundColor', 'w', 'Title', fig_titles{i},...
        'Units', 'normalized', 'Visible', 'off');
    set(handles.panel_graph(1,i), 'Position', panelgraph_pos)
      
    handles.haxes(1,i) = graph_model(handles.panel_graph, fig_titles, i);
    [~, ~] = plot_mepanalysis(handles.haxes(1, i), signal(:,i),...
        xs, pmin(i,:), pmax(i,:), [mep_lat(i), mep_end(i)]);
    
    % progress bar update
    value = i/n_meps;
    progbar_update(handles.progress_bar, value);
    
    msg = [num2str(i) ' Plots of ', '" ', fig_titles{i}, ' " done.'];
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
handles = dialog_detect_mepanalysis(handles);
handles.haxes(1, id) = refresh_axes(handles.haxes(1, id), handles.reader.signal(:, id),...
    handles.reader.xs, handles.reader.mep_pmin(id,:), handles.reader.mep_pmax(id,:),...
    [handles.reader.mep_lat(id), handles.reader.mep_end(id)]);

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
 
function ax = refresh_axes(ax, signal, xs, pmin, pmax, lat)
% Function to update all plots after manual changes in dialog detect

if ishandle(ax)
    cla(ax);
end

plot_mepanalysis(ax, signal, xs, pmin, pmax, lat);

set(ax, 'ButtonDownFcn', @axes_ButtonDownFcn);
