
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


% --- Creates GUI panel and controls when axes Button Down Fcn is assessed
% This GUI allows the user to change and manipulated the peak, time and
% threshold selections in the signal plotted in one axes
function varargout = process_emf(handles)
%PROCESS_EMF reads pre-structures reader files (from reader_emf.m) and
%automatically identify Pulse Start, Onset and Total duration times,
%offering tools for signal window, invert and peak detection by Amplitude
%threshold of Convolution filters.
%
% INPUT:
%
% pre-structured reader_emf files containing: raw signal data, raw time
% vector and aquisition Parameters;
%
% OUTPUT:
%
% Complete reader_emf structure, which add to pre-structured reader tstart
% (absolute time when pulse starts), tonset (abs. time in maximum value),
% tend (abs. time when pulse ends), signal (windoned in each detected
% pulse), xs (windoned abs. time in each detected pulse), number of pulses,
% figure titles (which includes equipment and stimulation mode
% informations), calculated onset, total duration and pulse zero-to-peak
% amplitude;

% create the figure, uicontrols and return the handles
hObject = figure_creation(handles);


varargout{1} = output_dialog_detect(hObject);


function varargout = output_dialog_detect(hObject)
% Output function for dialog_detect

uiwait(hObject);
handles = guidata(hObject);
delete(hObject);

% Get default command line output from handles structure
varargout{1} = handles;


function hObject = figure_creation(handles)

% The size of screen is detected and the size of the figure is created
% relative to it
set(0,'units','pixels');
scnsize = get(0,'screensize');
figw1 = ceil(scnsize(3)*(0.8));
figh1 = floor(scnsize(4)*(0.8));
fig_pos = [0 0 figw1 figh1];

% Figure creation
% hObject is the handle to the figure
hObject = figure('Name', 'Pulse Processing', 'Color', 'w', ...
    'Units', 'pixels', 'Position', fig_pos, 'ToolBar', 'figure', ...
    'MenuBar', 'none', 'NumberTitle','off', 'DockControls', 'off', ...
    'KeyPressFcn', @key_press_callback);

% center the figure window on the screen
movegui(hObject, 'center');


% pushbutton names
pb_names = {'Window', 'Invert', 'Peak Detection', ...
    'Peak Detection (conv)', 'Initial Values'};


% creates the panel for buttons in dialog_detect
panelgraph_pos = [1.5/50 0.15 1/4 5/6];
panel_graph = uipanel(hObject, 'Title', 'Selection Tools', ...
    'BackgroundColor', 'w', 'Units', 'normalized');
set(panel_graph, 'Position', panelgraph_pos);

% information text to guide user pressing ENTER after choosing axes
% coordinates
info_text_pos = [1.5/50 0.05 1/4 1/10];
handles.info_text = uicontrol(hObject, 'Style', 'text', 'Units', 'normalized', ...
    'BackgroundColor', 'w', 'FontSize', 10, 'FontWeight', 'bold');
set(handles.info_text, 'Position', info_text_pos);

% loose_inset set to zero eliminates spaces between axes
loose_inset = [0 0 0 0];

% axes for signal plotting
outer_pos = [0.30, 1/15, 2/3, 7/8];
axesdetect = axes('Parent', hObject, 'OuterPosition',outer_pos,...
    'Box', 'on', 'Units', 'normalized', 'LooseInset', loose_inset);
set(get(axesdetect,'Title'),'String','Processing')

% ----- Position of Controls

pb_detect_1_pos = [0.17, 0.85, 4/6, 0.08];
pb_detect_2_pos = [0.17, 0.75, 4/6, 0.08];
pb_detect_3_pos = [0.17, 0.65, 4/6, 0.08];
pb_detect_4_pos = [0.17, 0.55, 4/6, 0.08];
pb_detect_5_pos = [0.17, 0.45, 4/6, 0.08];
pb_close_pos = [0.17, 0.25, 4/6, 0.10];


% ----- Window select

% push button for window selection
pb_detect(1) = uicontrol(panel_graph, 'String', pb_names{1}, ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_detect(1), 'Position', pb_detect_1_pos, ...
    'Callback', @pb_detect_1_Callback);

% ----- Signal Invert

% push button for Invert tool
pb_detect(2) = uicontrol(panel_graph, 'String', pb_names{2}, ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_detect(2), 'Position', pb_detect_2_pos, ...
    'Callback', @pb_detect_2_Callback);


% ----- Automatic Peak Detection (by Amplitude Threshold)

pb_detect(3) = uicontrol(panel_graph, 'String', pb_names{3}, ...
    'FontSize', 10, 'FontWeight', 'bold', 'Units', 'normalized');
set(pb_detect(3), 'Position', pb_detect_3_pos, ...
    'Callback', @pb_detect_3_Callback);


% ----- Automatic Peak Detection (by convolution)

% push button for Automatic Peak Detection (by convolution)
pb_detect(4) = uicontrol(panel_graph, 'String', pb_names{4}, ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');
set(pb_detect(4), 'Position', pb_detect_4_pos, ...
    'Callback', @pb_detect_4_Callback);


% ----- Return initial values

% push button to return for initial values
pb_detect(5) = uicontrol(panel_graph, 'String', pb_names{5}, ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');
set(pb_detect(5), 'Position', pb_detect_5_pos, ...
    'Callback', @pb_detect_5_Callback);

% push button to close processing_emf figure
pb_close = uicontrol(panel_graph, 'String', 'Finished', 'BackgroundColor', 'g', ...
    'FontSize', 10, 'FontWeight', 'bold','Units', 'normalized');
set(pb_close, 'Position', pb_close_pos, ...
    'Callback', @pushbutton_close_Callback);


handles.axesdetect = axesdetect;
handles.pb_names = pb_names;

plot(handles.time, handles.raw, '.')
title('Raw data')
ylabel('Amplitude (mV)')
xlabel('Time (s)')

guidata(hObject, handles);


function pb_detect_1_Callback(hObject, ~)

% Callback - button for signal window selection
handles = guidata(hObject);

hold on
set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', 'Select inicial window point and press ENTER');
[x,~] = ginput;

[~, index]  = min(abs(handles.time - x(end)));

set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', 'Select final window point and press ENTER');
[x2,~] = ginput;

[~, index2]  = min(abs(handles.time - x2(end)));
hold off

% Remove information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', 'w', 'String', '');

% Update Pulse window
handles.time = handles.time(index:index2);
handles.raw = handles.raw(index:index2);

% If tstart, tend, tonset and windowed signal exist before new window,
% exclude to new processing
if(isfield(handles,'tonset') == 1)
    fields = {'tstart', 'tend', 'tonset','signal'};
    handles = rmfield(handles,fields);
    set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
        'String', 'Onset, duration and windowed signal were deleted. Please process again.');
end

plot(handles.time,handles.raw,'.')
title('Raw data')
ylabel('Amplitude (mV)')
xlabel('Time (s)')

% Update handles structure
guidata(hObject, handles);

function pb_detect_2_Callback(hObject, ~)

% Callback - button for data invert
handles = guidata(hObject);

% If tstart, tend, tonset and windowed signal exist before data invert,
% exclude to new processing
if(isfield(handles,'tonset') == 1)
    fields = {'tstart', 'tend', 'tonset','signal'};
    handles = rmfield(handles,fields);
    set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
        'String', 'Onset, duration and windowed signal were deleted. Please process again.');
end

handles.raw = handles.raw*(-1);

plot(handles.time,handles.raw,'.')
title('Raw data')
ylabel('Amplitude (mV)')
xlabel('Time (s)')

% Update handles structure
guidata(hObject, handles);

function pb_detect_3_Callback(hObject, ~)

% Callback - button for peak, onset and duration detection by threshold
handles = guidata(hObject);


% If tstart, tend, tonset and windowed signal exist before new processing,
% exclude
if(isfield(handles,'tonset') == 1)
    fields = {'tstart', 'tend', 'tonset','signal'};
    handles = rmfield(handles,fields);
end

set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', 'Select amplitude threshold and press Enter.');
[~, y] = ginput;

try
    [handles.tonset, handles.tstart, handles.tend] = peak_detect(handles.raw,y);
catch expression
    
end

% window signal around each pulse detected
for j = 1:length(handles.tonset(1,:));
    handles.signal{:,j} = handles.raw(handles.tstart(1,j):handles.tend(1,j));
    handles.xs{:,j} = handles.tstart(1,j):handles.tend(1,j);
end

% Update plot with peak, onset and duration events
plot(handles.time,handles.raw,'.')
hold on
plot(handles.time(handles.tstart),handles.raw(handles.tstart),'.','color','r')
plot(handles.time(handles.tonset),handles.raw(handles.tonset),'.','color','r')
plot(handles.time(handles.tend),handles.raw(handles.tend),'.','color','r')
title('Raw data')
ylabel('Amplitude (mV)')
xlabel('Time (s)')
hold off

number = num2str(length(handles.signal(1,:)));
set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', strcat(number,' pulses where detected.'));


% Update handles structure
guidata(hObject, handles);

function pb_detect_4_Callback(hObject, ~)

% Callback - button for peak, onset and duration detection by Convolution
handles = guidata(hObject);

% If tstart, tend, tonset and windowed signal exist before new processing,
% exclude
if(isfield(handles,'tonset') == 1)
    fields = {'tstart', 'tend', 'tonset','signal'};
    handles = rmfield(handles,fields);
end

% Select properly window signal to convolution signal. Is recomended that
% the convolution pulse be from the same Equipment model, with a Intensity
% higher then 50%.
[filename, pathname] = uigetfile('.mat','Select pulse shape for convolution');
caux = importdata(horzcat(pathname, filename));
convol = conv(handles.raw,caux);

% Select a convolution amplitude threshold
set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', 'Select convolution threshold and press ENTER');

plot(convol,'color','r')
title('Convolution filter threshold')
ylabel('Convolution')
xlabel('Time (s)')
[~,y] = ginput;

set(handles.info_text, 'BackgroundColor', 'w', 'String', '');

% The nexts steps where inspired by peak_detect.m routine, but with
% modifications for convolution detection.

pulse_position  = find(convol > y(end));
pulse_position = pulse_position  - length(caux);

j = 1;
i = 1;
for k = 1:(length(pulse_position)-1)
    
    aux(i) = pulse_position(k+1) - pulse_position(k);
    
    % find pulse groups with distances higher than 4000 points
    % (experimental values, test for other data)
    
    if aux(i) < 4000
        pulse(i,j) = handles.raw(pulse_position(k));
        pulse_indice(i,j) = k;
        % keep adding a new point to actual pulse group
        i = i + 1;
    else
        % create a new pulse group j
        j = j + 1;
        i = 1;
        pulse(i,j) = handles.raw(pulse_position(k));
        pulse_indice(i,j) = k;
        i = i + 1;
        
    end
end

clear aux j i

for j = 1:length(pulse(1,:))
    [~, max_aux] = max(diff(pulse(:,j)));
    pulse2(:,j) = handles.raw((pulse_position(pulse_indice(max_aux,j))-400):...
        (pulse_position(pulse_indice(max_aux,j))+600));
    threshold = max(pulse2(:,j)) - (max(pulse2(:,j)) - min(pulse2(:,j)))/4;
    
    % find relative (pulse2) indices for peak, start and pulse_end
    try
        [peak(j), tstart(j), pulse_end(j)] = peak_detect(pulse2(:,j),threshold);
    catch expression
        if(strcmp('Index exceeds matrix dimensions.',...
                expression.message)==1)
            set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
                'String', 'No pulses where find. Check if signal is not inverted or try another convolution filter.');
        end
    end
    
    % Transform to absolute indices values
    handles.tstart(j) = pulse_position(pulse_indice(max_aux,j))-400+tstart(j);
    handles.tonset(j) = pulse_position(pulse_indice(max_aux,j))-400+peak(j);
    handles.tend(j) = pulse_position(pulse_indice(max_aux,j))-400+pulse_end(j);
    
    handles.signal{1,j} = pulse2(tstart(j):pulse_end(j),j);
    handles.xs{1,j} = handles.tstart(j):handles.tend(j);
end

% Update plot with start,onset and duration events
plot(handles.time,handles.raw,'.')
hold on
plot(handles.time(handles.tstart),handles.raw(handles.tstart),'.','color','r')
plot(handles.time(handles.tonset),handles.raw(handles.tonset),'.','color','r')
plot(handles.time(handles.tend),handles.raw(handles.tend),'.','color','r')
title('Raw data')
ylabel('Amplitude (mV)')
xlabel('Time (s)')
hold off

number = num2str(length(pulse(1,:)));
set(handles.info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', strcat(number,' pulses where detected.'));

% Update handles structure
guidata(hObject, handles);

function pb_detect_5_Callback(hObject, ~)
% Callback - Initial Values
handles = guidata(hObject);

fields = {'tstart', 'tend', 'tonset'};
if(isfield(handles,fields)==1)
    handles = rmfield(handles,fields);
else
end

handles.raw = handles.raw_bkp;
handles.time = handles.time_bkp;

% Update plot with Initial Values
plot(handles.time,handles.raw,'.')
title('Raw data')
ylabel('Amplitude (mV)')
xlabel('Time (s)')

% Update handles structure
guidata(hObject, handles);


function pushbutton_close_Callback(hObject, ~)
% Finish processing and back to Figure Processing window
handles = guidata(hObject);

fields = {'raw_bkp','time_bkp'};
handles = rmfield(handles,fields);

handles.n_pulses = length(handles.tonset(1,:));

% Create figure titles for panel_emf figures visualization
for i = 1:handles.n_pulses
    handles.fig_titles{i,1} = horzcat(handles.equipment,...
        ' - ', handles.mode, ' - ', num2str(i),'.');
    
    handles.onset(i) = double(handles.time(handles.tonset(i)) - ...
        handles.time(handles.tstart(i)))*10^6;
    handles.duration(i) = double(handles.time(handles.tend(i))...
        - handles.time(handles.tstart(i)))*10^6;
    handles.amplitude(i) = double(abs(handles.raw(handles.tonset(i))...
        - handles.raw(handles.tstart(i))));
end

% Update guidata and resume processing_emf.m window
guidata(hObject, handles);
uiresume;


