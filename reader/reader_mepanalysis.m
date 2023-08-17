
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


function reader = reader_mepanalysis

% DEV MODE - REMOVE AFTER FINISHED
[filename, pathname, filt_id] = uigetfile({'*.csv','MagVenture - Comma-separated values (*.csv)';...
    '*.csv', 'Comma-separated values (*.csv)'; ...
    '*.mat','MAT-files (*.mat)'},...
    'Select the signal file', 'MEPData.csv');

% loading signal and configuration data
% [filename, pathname, filt_id] = uigetfile({'*.csv','Comma-separated values (*.csv)';...
%     '*.mat','MAT-files (*.mat)'}, 'Select the signal file');

% [filename, pathname, filt_id] = uigetfile({'*.csv','MagVenture - Comma-separated values (*.csv)';...
%     '*.csv', 'Comma-separated values (*.csv)'; ...
%     '*.mat','MAT-files (*.mat)'},...
%     'Select the signal file', '05_FCP_HE_60rMT.csv');

switch filt_id
    case 0
        reader = false;
    case 1
        data = importdata([pathname filename], ';', 22);
        reader = csv_reader(data.data, pathname, filename, true);
    case 2
        data = importdata([pathname filename]);
        reader = csv_reader(data, pathname, filename, false);
    case 3
        data_aux = load([pathname filename]);
        var_name = fieldnames(data_aux);
        eval(['data = data_aux.' var_name{1} ';']);
        reader = mat_reader(data);

end

end


function reader = csv_reader(data_aux, pathname, filename, epoched)


% TODO: Find a way to know the sampling frequency when no time
% vector is exported in file

% disp(['Size of data: ' num2str(size(data_aux, 2))])

% Workaround for Jordania data
% TODO: Have to ask user how the columns on the data file is organized
if isstruct(data_aux)
    xs = data_aux.data(:,1);
    data = data_aux.data(:,2:end-1);
    trigger = data_aux.data(:,end);
else
    if epoched
        % MagVenture CSV data is in microseconds and microvolts, converting
        % to seconds and milivolts
        xs = data_aux(:,1)/1e6;
        data = data_aux(:,2:end);
        trigger = false;
    else
        % Comma-sepparated values needs to be organized as such:
        % 1st column: the time vector
        % 2nd - nth column: the EMG channels
        % Last column: is the TMS trigger channel
        % CSV data from Jordania is in seconds and microvolts, converting
        % to seconds and milivolts
        xs = data_aux(:,1);
        data = data_aux(:,2:end-1);
        trigger = data_aux(:,end);
    end
end

% if isstruct(data_aux)
%     if size(data_aux.data, 2) == 5
%         xs = data_aux.data(:,1);
%         data = data_aux.data(:,2:end-1);
%         trigger = data_aux.data(:,end);
%     else
%         xs = (0:size(data_aux.data(:,1)))'/2000;
%         data = data_aux.data(:,1:end-1);
%         trigger = data_aux.data(:,end);
%     end
% else
%     if size(data_aux, 2) == 5
%         xs = data_aux(:,1);
%         data = data_aux(:,2:end-1);
%         trigger = data_aux(:,end);
%     else
%         xs = (0:size(data_aux(:,1)))'/2000;
%         data = data_aux(:,1:end-1);
%         trigger = data_aux(:,end);
%     end
% end

fs = 1/(xs(3,1)-xs(2,1));

n_frames = size(data, 2);
fig_titles = cell(n_frames, 1);

if epoched
    title_label = 'MEP';
else
    title_label = 'CH';
end

for id = 1:n_frames
    fig_titles{id,1} = strcat(title_label, num2str(id));
end

signal.xs = xs;
signal.data = data;
signal.trigger = trigger;

reader.filename = filename;
reader.signal = signal;
reader.path = pathname;
reader.fig_titles = fig_titles;
reader.fs = fs;
reader.n_frames = n_frames;
reader.process_id = 1;

end


function reader = mat_reader(data)

% Potential window start after trigger onset (miliseconds)
t0 = 10;
% Potential window duration after t0 (miliseconds)
t1 = 60;


% load header information
reader.xunits = data.xunits;
reader.start = data.start;
reader.interval = data.interval;
reader.fs = double(data.points);
reader.chans = data.chans;
reader.n_frames = data.frames;
reader.chaninfo = data.chaninfo;
reader.frameinfo = data.frameinfo;

signal = squeeze(data.values);
% duration of mep signal set to 200 ms
duration = 0.2*reader.fs;
reader.signal = signal(1:duration,:);
reader.xs = (0:reader.interval:(double((duration-1))/double(reader.fs)))';

% figure titles with states
fig_titles = cell(reader.n_frames,1);
states = cell(reader.n_frames,1);
frame_start = cell(reader.n_frames,1);
mep_amp = zeros(reader.n_frames,1);
mep_pmin = zeros(reader.n_frames,2);
mep_pmax = zeros(reader.n_frames,2);

for i = 1:reader.n_frames
    fig_titles{i,1} = data.frameinfo(i).label;
    states{i,1} = data.frameinfo(i).state;
    frame_start{i,1} = data.frameinfo(i).start;
    [mep_amp(i), mep_pmin(i,:), mep_pmax(i,:)] = p2p_amplitude(reader.signal(:,i),...
        reader.fs, [t0 t1]);
end

mep_pmin(:,1) = mep_pmin(:,1)/reader.fs;
mep_pmax(:,1) = mep_pmax(:,1)/reader.fs;

reader.fig_titles = fig_titles;
reader.states = states;
reader.frame_start = frame_start;

reader.mep_amp = mep_amp;
reader.mep_pmin = mep_pmin;
reader.mep_pmax = mep_pmax;
reader.mep_lat = zeros(reader.n_frames,1);
reader.mep_end = zeros(reader.n_frames,1);
reader.mep_dur = zeros(reader.n_frames,1);
reader.mep_amp_bkp = mep_amp;
reader.mep_pmin_bkp = mep_pmin;
reader.mep_pmax_bkp = mep_pmax;
reader.mep_lat_bkp = zeros(reader.n_frames,1);
reader.mep_end_bkp = zeros(reader.n_frames,1);
reader.mep_dur_bkp = zeros(reader.n_frames,1);

reader.process_id = 2;

end
