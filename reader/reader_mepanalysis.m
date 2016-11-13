
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


function output_reader = reader_mepanalysis

% loading signal and configuration data
[filename, pathname] = uigetfile({'*.mat','MAT-files (*.mat)'},...
    'Select the signal file');
data_aux = load([pathname filename]);
var_name = fieldnames(data_aux);
eval(['data = data_aux.' var_name{1} ';']);

% Potential window start after trigger onset (miliseconds)
t0 = 10;
% Potential window duration after t0 (miliseconds)
t1 = 60;


% load header information
output_reader.xunits = data.xunits;
output_reader.start = data.start;
output_reader.interval = data.interval;
output_reader.fs = double(data.points);
output_reader.chans = data.chans;
output_reader.n_meps = data.frames;
output_reader.chaninfo = data.chaninfo;
output_reader.frameinfo = data.frameinfo;

signal = squeeze(data.values);
% duration of mep signal set to 200 ms
duration = 0.2*output_reader.fs;
output_reader.signal = signal(1:duration,:);
output_reader.xs = (0:output_reader.interval:(double((duration-1))/double(output_reader.fs)))';

% figure titles with states
fig_titles = cell(output_reader.n_meps,1);
states = cell(output_reader.n_meps,1);
frame_start = cell(output_reader.n_meps,1);
mep_amp = zeros(output_reader.n_meps,1);
mep_pmin = zeros(output_reader.n_meps,2);
mep_pmax = zeros(output_reader.n_meps,2);

for i = 1:output_reader.n_meps
    fig_titles{i,1} = data.frameinfo(i).label;
    states{i,1} = data.frameinfo(i).state;
    frame_start{i,1} = data.frameinfo(i).start;
    [mep_amp(i), mep_pmin(i,:), mep_pmax(i,:)] = p2p_amplitude(output_reader.signal(:,i),...
        output_reader.fs, [t0 t1]);
end

mep_pmin(:,1) = mep_pmin(:,1)/output_reader.fs;
mep_pmax(:,1) = mep_pmax(:,1)/output_reader.fs;

output_reader.fig_titles = fig_titles;
output_reader.states = states;
output_reader.frame_start = frame_start;

output_reader.mep_amp = mep_amp;
output_reader.mep_pmin = mep_pmin;
output_reader.mep_pmax = mep_pmax;
output_reader.mep_lat = zeros(output_reader.n_meps,1);
output_reader.mep_end = zeros(output_reader.n_meps,1);
output_reader.mep_dur = zeros(output_reader.n_meps,1);
output_reader.mep_amp_bkp = mep_amp;
output_reader.mep_pmin_bkp = mep_pmin;
output_reader.mep_pmax_bkp = mep_pmax;
output_reader.mep_lat_bkp = zeros(output_reader.n_meps,1);
output_reader.mep_end_bkp = zeros(output_reader.n_meps,1);
output_reader.mep_dur_bkp = zeros(output_reader.n_meps,1);

