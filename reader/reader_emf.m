
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


function output_reader = reader_emf

% loading signal and configuration data
[filename, pathname] = uigetfile({'*.mat','MAT-files (*.mat)'},...
    'Select the signal file');
    
data = load([pathname filename]);
%data = data_aux.teste;
var_name = fieldnames(data);
%eval(['data = data_aux.' var_name{1} ';']);

% load header information
output_reader.equipaments = data.equipament;
output_reader.mode = data.mode;
output_reader.freq = data.frequency;

output_reader.tstart = data.tstart;
output_reader.tstart_bkp = output_reader.tstart;

output_reader.tonset = data.tonset;
output_reader.tonset_bkp = output_reader.tonset;

output_reader.onset = (data.tonset - data.tstart)*10^6;

output_reader.tduration = data.tduration;
output_reader.tduration_bkp = output_reader.tduration;

output_reader.duration = (data.tduration - data.tstart)*10^6;

output_reader.pzero = data.pzero;
output_reader.pzero_bkp = output_reader.pzero;

output_reader.pmax = data.pmax;
output_reader.pmax_bkp = output_reader.pmax;

output_reader.signal = data.signal;
output_reader.xs = data.xs;
output_reader.fs = data.fs;
output_reader.id = data.id;








output_reader.n_pulses = length(data.id);


% figure titles with states
fig_titles = cell(output_reader.n_pulses,1);


for i = 1:output_reader.n_pulses
    fig_titles{i,1} = horzcat(data.equipament{i},' - ', data.mode{i,1}, ' - ', num2str(data.id(i)),'.');
    %states{i,1} = data.frameinfo(i).state;
    %tstart = data.tstart(i);
    %[mep_amp(i), mep_pmin(i,:), mep_pmax(i,:)] = peak2peak_amplitude(output_reader.xs,...
        %output_reader.signal(:,i), output_reader.fs);
end

output_reader.fig_titles = fig_titles;
%output_reader.states = states;
%output_reader.frame_start = frame_start;

%output_reader.mep_amp = mep_amp;
%output_reader.mep_pmin = mep_pmin;
%output_reader.mep_pmax = mep_pmax;
%output_reader.mep_lat = zeros(output_reader.n_meps,1);
%output_reader.mep_end = zeros(output_reader.n_meps,1);
%output_reader.mep_dur = zeros(output_reader.n_meps,1);



