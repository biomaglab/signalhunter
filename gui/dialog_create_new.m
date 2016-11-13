
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


function [varargout] = dialog_create_new
%DIALOG_CREATE_NEW Summary of this function goes here
%   Detailed explanation goes here

hObject = dialog_creation;
% [varargout{1}, varargout{2}, varargout{3}] = output_dialog(hObject);
[varargout{1}, varargout{2}] = output_dialog(hObject);


% function [data_id, map_template, map_shape] = output_dialog(hObject)
function [map_template, map_shape] = output_dialog(hObject)
% Output function for dialog_detect

uiwait(hObject);
handles = guidata(hObject);

data = get(handles.table,'Data');

for i = 1:size(data,1)*size(data,2)
    if isempty(data{i}) == 1
        data{i} = nan;
    end
end

data_mat = cell2mat(data);
pos_channel = isnan(data_mat)==0;
channel_number = data_mat(pos_channel);
channel_sort = sort(channel_number);

pos = zeros(length(channel_sort),1);
for j = 1:length(channel_sort)
    pos(j,1) = find(data_mat==channel_sort(j));
end

v = get (handles.popup1, 'Value');
s = get (handles.popup1, 'String');
% data_id = s{v};
map_template = pos;
map_shape = size(data_mat);

delete(hObject);


% Get default command line output from handles structure
% varargout{1} = data_id;
% varargout{2} = map_template;
% varargout{3} = map_shape;


function hObject = dialog_creation

% Figure creation
% hObject is the handle to the figure
fig_pos = [520, 287, 640, 514];
hObject = figure('Name', 'Signal Hunter', 'Color', 'w', 'Resize', 'off',...
    'Units', 'pixels', 'Position', fig_pos, 'ToolBar', 'none',...
    'MenuBar', 'none', 'NumberTitle','off', 'DockControls', 'off');

% center the figure window on the screen
movegui(hObject, 'center');
ax_pos = [0, 419, 645, 102];
signal_logo = load('signal_hunter.mat');
hax = axes('Parent', hObject, 'Units', 'pixels');
set(hax, 'Position', ax_pos);

image(signal_logo.ima)
axis tight;
axis fill;
axis off;
axis image;

text1_pos = [0.012, 0.78, 0.157, 0.035];
text2_pos = [0.205, 0.78, 0.063, 0.035];
text3_pos = [0.295, 0.78, 0.087, 0.035];

htext1 = uicontrol(hObject, 'Style', 'text', 'Units', 'normalized', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'String', 'Select file type:', ...
    'HorizontalAlignment', 'center');
set(htext1, 'Position', text1_pos);

htext2 = uicontrol(hObject, 'Style', 'text', 'Units', 'normalized', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'String', 'Rows:', ...
    'HorizontalAlignment', 'center');
set(htext2, 'Position', text2_pos);

htext3 = uicontrol(hObject, 'Style', 'text', 'Units', 'normalized', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'String', 'Columns:', ...
    'HorizontalAlignment', 'center');
set(htext3, 'Position', text3_pos);

popup1_pos = [0.015, 0.74, 0.155, 0.03];
popup2_pos = [0.21, 0.74, 0.06, 0.03];
popup3_pos = [0.312, 0.74, 0.06, 0.03];

popup1 = uicontrol(hObject, 'Style', 'popupmenu', 'Units', 'normalized', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'String',...
    {'ASCII', 'Bin', 'BioPac', 'MEP Analysis', 'OTBio', 'TMS + VC'},...
    'HorizontalAlignment', 'center', 'Callback', @popup1_Callback);
set(popup1, 'Position', popup1_pos);

nitems = num2cell((1:20)');

popup2 = uicontrol(hObject, 'Style', 'popupmenu', 'Units', 'normalized', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'String', nitems,...
    'HorizontalAlignment', 'center', 'Callback', @popup2_Callback);
set(popup2, 'Position', popup2_pos);

popup3 = uicontrol(hObject, 'Style', 'popupmenu', 'Units', 'normalized', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'String', nitems,...
    'HorizontalAlignment', 'center', 'Callback', @popup3_Callback);
set(popup3, 'Position', popup3_pos);

pb1_pos = [0.402, 0.72, 0.106, 0.05];
pb2_pos = [0.523, 0.72, 0.075, 0.05];
pb3_pos = [0.612, 0.72, 0.130, 0.05];
pb4_pos = [0.748, 0.72, 0.130, 0.05];
pb5_pos = [0.880, 0.72, 0.106, 0.05];

% push button for superimposed force selection
pb(1) = uicontrol(hObject, 'String', 'Transpose', ...
    'FontSize', 8, 'Units', 'normalized');
set(pb(1), 'Position', pb1_pos, ...
    'Callback', @pb_transpose_Callback);

% push button for superimposed force selection
pb(2) = uicontrol(hObject, 'String', 'Clear', ...
    'FontSize', 8, 'Units', 'normalized');
set(pb(2), 'Position', pb2_pos, ...
    'Callback', @pb_clear_Callback);

% push button for superimposed force selection
pb(3) = uicontrol(hObject, 'String', 'Save Template', ...
    'FontSize', 8, 'Units', 'normalized');
set(pb(3), 'Position', pb3_pos, ...
    'Callback', @pb_save_Callback);

% push button for superimposed force selection
pb(4) = uicontrol(hObject, 'String', 'Open Template', ...
    'FontSize', 8, 'Units', 'normalized');
set(pb(4), 'Position', pb4_pos, ...
    'Callback', @pb_open_Callback);

% push button for superimposed force selection
pb(5) = uicontrol(hObject, 'String', 'OK', ...
    'FontSize', 8, 'Units', 'normalized');
set(pb(5), 'Position', pb5_pos, ...
    'Callback', @pb_ok_Callback);

align([pb(1), pb(2), pb(3), pb(4), pb(5)],...
    'distribute', 'bottom');

table_pos = [0.015, 0.015, 0.97, 0.68];
table = uitable(hObject, 'FontSize', 8, 'Units', 'normalized',...
    'ColumnName', 'numbered', 'RowName', 'numbered', 'RowStriping', 'on');
set(table, 'Position', table_pos);

row_size = get(popup2, 'Value');
col_size = get(popup3, 'Value');


d = cell(row_size,col_size);
for j = 1:row_size*col_size
    d{j}=j;
end
set(table, 'Data', d,'ColumnEditable',true,'ColumnFormat',{'numeric'});
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(table,'ColumnWidth',col_width)

handles.dialog_new = hObject;
handles.popup1 = popup1;
handles.popup2 = popup2;
handles.popup3 = popup3;
handles.table = table;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton_clear.
function pb_clear_Callback(hObject, ~)

handles = guidata(hObject);

row_size = get(handles.popup2, 'Value');
col_size = get(handles.popup3, 'Value');
d = cell(row_size,col_size);

set(handles.table, 'Data', d);
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.table,'ColumnWidth',col_width)

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton_ok.
function pb_ok_Callback(hObject, ~)

% Callback - button to resume window

% Run here the callback for general graphs and processing
% figure_processing(data_id, map_template, map_shape);

% close(handles.dialog_new)
handles = guidata(hObject);
uiresume(handles.dialog_new);



% --- Executes on button press in pushbutton_OpenTemplate.
function pb_open_Callback(hObject, ~)

handles = guidata(hObject);

[fn, pn] = uigetfile({'*.mat','MATLAB File (*.mat)'},...
    'Select the template file');

aux = load([pn fn]);
f = fieldnames(aux);
d = getfield(aux,f{1});

set(handles.table, 'Data', d);
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.table,'ColumnWidth',col_width)
set(handles.popup2, 'Value', size(d,1));
set(handles.popup3, 'Value', size(d,2));

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton_SaveTemplate.
function pb_save_Callback(hObject, ~)

handles = guidata(hObject);

data = get(handles.table,'Data');

[fn, pn] = uiputfile({'*.mat','MATLAB File (*.mat)'},...
    'Save template');

save([pn fn],'data')


% --- Executes on button press in pushbutton1.
function pb_transpose_Callback(hObject, ~)

handles = guidata(hObject);

global active
row_size = get (handles.popup2, 'Value');
col_size = get (handles.popup3, 'Value');
d = cell(row_size,col_size);

cont = 1;

if active == 0
    for i = 1:row_size
        for j = 1:col_size
            d{i,j} = cont;
            cont = cont+1;
        end
    end
    active = 1;
else
    for j = 1:col_size
        for i = 1:row_size
            d{i,j} = cont;
            cont = cont+1;
        end
    end
    active = 0;
end

set(handles.table, 'Data', d);
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.table,'ColumnWidth',col_width)

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in popupmenu2.
function popup1_Callback(hObject, ~)
handles = guidata(hObject);

valuefiletype = get(handles.popup1, 'Value');

cellfiletype = get(handles.popup1, 'String');

filetype = lower(cellfiletype{valuefiletype});

switch filetype
    case 'tms + vc'
        set(handles.popup2, 'Enable', 'off');
        set(handles.popup3, 'Enable', 'off');
        
        set(handles.popup2, 'value', 1);
        set(handles.popup3, 'value', 1);
        
        popup2_Callback(hObject)
    case 'mep analysis'
        set(handles.popup2, 'Enable', 'off');
        set(handles.popup3, 'Enable', 'off');
        
        set(handles.popup2, 'value', 1);
        set(handles.popup3, 'value', 1);
        
        popup2_Callback(hObject)
    case 'otbio'
        set(handles.popup2, 'Enable', 'on');
        set(handles.popup3, 'Enable', 'on');
        
        popup2_Callback(hObject)
    case 'biopac'
        set(handles.popup2, 'Enable', 'on');
        set(handles.popup3, 'Enable', 'on');
        
        popup2_Callback(hObject)
    case 'bin'
        set(handles.popup2, 'Enable', 'off');
        set(handles.popup3, 'Enable', 'off');
        
        set(handles.popup2, 'value', 1);
        set(handles.popup3, 'value', 1);
        
        popup2_Callback(hObject)
    case 'ascii'
        set(handles.popup2, 'Enable', 'on');
        set(handles.popup3, 'Enable', 'on');
        
        popup2_Callback(hObject)
end


% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in popupmenu2.
function popup2_Callback(hObject, ~)

handles = guidata(hObject);

row_size = get(handles.popup2, 'Value');
col_size = get(handles.popup3, 'Value');

d = cell(row_size,col_size);
for j = 1:row_size*col_size
    d{j}=j;
end
set(handles.table, 'Data', d,'ColumnEditable',true,'ColumnFormat',{'numeric'});
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.table,'ColumnWidth',col_width)

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in popupmenu3.
function popup3_Callback(hObject, ~)

handles = guidata(hObject);

row_size = get (handles.popup2, 'Value');
col_size = get (handles.popup3, 'Value');

d = cell(row_size,col_size);
for j = 1:row_size*col_size
    d{j}=j;
end

set(handles.table, 'Data', d);
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.table,'ColumnWidth',col_width)

% Update handles structure
guidata(hObject, handles);
