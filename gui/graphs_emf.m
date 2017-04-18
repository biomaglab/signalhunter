
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
% Creates GUI panel and controls for EMF Analysis Processing
% This module create all panels and its axes that will be used to plot the
% signals
% This module offers the possibility to manually change tstart, tonset and
% tend values, calculating new values for Zero-To-Peak Amplitude, Onset
% time and Total Pulse Duration.

handles = graph_creation(handles);

% message to progress log
msg = 'Graphs for signal plot created.';
handles = panel_textlog(handles, msg);

function handles = graph_creation(handles)

tic
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
handles.info_txt = zeros(1, handles.reader.n_pulses);

fig_titles = handles.reader.fig_titles;

% creates the panel for EMF Analysis in all detected pulses

for i = 1:handles.reader.n_pulses
    panelgraph_mar = [panel_pos(1), 2*panel_pos(2),...
        2*panel_pos(1), 3*panel_pos(2)];
    panelgraph_pos = [panelgraph_mar(1), panelgraph_mar(2)+panel_pos(4),...
        1-panelgraph_mar(3) 1-(panelgraph_mar(4)+panel_pos(4))];
    handles.panel_graph(1,i) = uipanel(handles.fig,...
        'BackgroundColor', 'w', 'Title', fig_titles{i},...
        'Units', 'normalized', 'Visible', 'off');
    set(handles.panel_graph(1,i), 'Position', panelgraph_pos)
    
    % Creates axes, plots and info_text for all pulses
    handles.haxes(1,i) = graph_model(handles.panel_graph, fig_titles, i);
    
    plot_emf(handles.haxes(1, i), handles.reader.signal{:,i},...
        handles.reader.xs{:,i}, handles.reader.tstart(i), handles.reader.tonset(i),...
        handles.reader.tend(i), handles.reader.time, handles.reader.raw);
    
    % progress bar update
    value = i/handles.reader.n_pulses;
    progbar_update(handles.progress_bar, value);
    
    msg = [num2str(i) ' Plots of Pulse', '" ', fig_titles{i}, ' " done.'];
    handles = panel_textlog(handles, msg);
    
    msg2 = sprintf(['Onset: ' num2str(handles.reader.onset(i),'%.2f') ...
        ' (us).\nAmplitude: ' num2str(handles.reader.amplitude(i),'%.2f') ...
        ' (mV).\nDuration: ' num2str(handles.reader.duration(i),'%.2f') 'us']);
    
    handles.info_text(i) = uicontrol(handles.info_panel, 'Style','text','String', msg2,...
        'BackgroundColor', 'w', 'Units', 'normalized',...
        'FontWeight', 'bold', 'FontUnits', 'normalized',...
        'HorizontalAlignment','left','Visible','Off',...
        'Position',[0 0 0.9 0.9]);
    
end
toc

set(handles.panel_graph(handles.id_cond), 'Visible', 'on');
set(handles.info_text(handles.id_cond),'FontSize',0.12,'Visible', 'on');


guidata(handles.fig, handles);


function axes_ButtonDownFcn(hObject, eventdata)
% Callback for Button Down in each axes
% Button Down Function on graphs_emf.m provides an 'post-processing' tool
% for chancing tstart, tonset and tend values with a click. The most
% closest variable (tstart, tonset or tend) will be changed for the point
% selected on plot.

handles = guidata(hObject);

id = handles.id_cond;

handles.id_axes = find(gca == handles.haxes(1,id));
[x,y] = ginput(1);

% Detect nearest event on ginput data (tstart, tonset or tend)
x = round(x);

aux(1) = abs(x - handles.reader.tstart(id));
aux(2) = abs(x - handles.reader.tonset(id));
aux(3) = abs(x - handles.reader.tend(id));
[~, min_aux] = min(aux);

switch min_aux
    
    case 1
        handles.reader.tstart(id) = x;
        
    case 2
        handles.reader.tonset(id) = x;
        
    case 3
        handles.reader.tend(id) = x;
end


% Update Onset, Amplitude and Duration values

handles.reader.onset(id) = double(handles.reader.time(handles.reader.tonset(id))...
    - handles.reader.time(handles.reader.tstart(id)))*10^6;
handles.reader.duration(id) = double(handles.reader.time(handles.reader.tend(id))...
    - handles.reader.time(handles.reader.tstart(id)))*10^6;
handles.reader.amplitude(id) = double(abs(handles.reader.raw(handles.reader.tonset(id))...
    - handles.reader.raw(handles.reader.tstart(id))));

set(handles.panel_graph(1,id), 'Visible', 'off')
set(handles.haxes(1,id),'Visible','off')
cla(handles.haxes(1,id))

% Refresh plot with new selected values
handles.haxes(1, id) = refresh_axes(handles.haxes, handles);


set(handles.info_text(id),'Visible', 'off');

msg2 = sprintf(['Onset: ' num2str(handles.reader.onset(id),'%.2f') ...
    ' (us).\nAmplitude: ' num2str(handles.reader.amplitude(id),'%.2f') ...
    ' (mV).\nDuration: ' num2str(handles.reader.duration(id),'%.2f') 'us']);

handles.info_text(id) = uicontrol(handles.info_panel, 'Style','text','String', msg2,...
    'BackgroundColor', 'w', 'Units', 'normalized',...
    'FontWeight', 'bold', 'FontUnits', 'normalized',...
    'HorizontalAlignment','left','Visible','Off',...
    'Position',[0 0 0.9 0.9]);

set(handles.panel_graph(handles.id_cond), 'Visible', 'on');
set(handles.haxes(1,id),'Visible','on')
set(handles.info_text(handles.id_cond),'FontSize',0.12,'Visible', 'on');


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
set(get(ax,'XLabel'),'String','Time (us)')
set(get(ax,'YLabel'),'String','Amplitude (mV)')



function ax = refresh_axes(ax, handles)
% Function to update all plots after manual changes in dialog detect
id = handles.id_cond;

cla(ax)


ax = graph_model(handles.panel_graph, handles.reader.fig_titles, id);

plot_emf(ax, handles.reader.signal{:,id},...
    handles.reader.xs{:,id}, handles.reader.tstart(id), handles.reader.tonset(id),...
    handles.reader.tend(id), handles.reader.time, handles.reader.raw);

set(ax, 'ButtonDownFcn', @axes_ButtonDownFcn, ...
    'FontSize', 7, 'NextPlot', 'add');
