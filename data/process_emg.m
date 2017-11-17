
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


function processed = process_emg(reader)
%PROCESS_EMG Process and calculate EMG start, end, mean and median
% frequency and RMS amplitude.
% 
% INPUT:
% 
% reader: structure with read variables
% 
% OUTPUT:
%
% processed: structure with data processed
% 

signal = reader.signal;
n_channels = reader.n_channels;
fs = reader.fs;

% EMG window start (seconds)
t0 = 8;
% EMG window end (seconds)
t1 = 18;

emg_start_I = (t0*fs)*ones(n_channels, 1);
emg_end_I = (t1*fs)*ones(n_channels, 1);
emg_start = t0*ones(n_channels, 1);
emg_end = t1*ones(n_channels, 1);

fmed = zeros(n_channels, 1);
fmean = zeros(n_channels, 1);
rms = zeros(n_channels, 1);

amp_avg = zeros(n_channels, 1);
amp_min = zeros(n_channels, 1);
amp_max = zeros(n_channels, 1);
pmin_I = zeros(n_channels, 1);
pmax_I = zeros(n_channels, 1);

for n = 1:n_channels
    [fmed(n), rms(n), fmean(n)]= fmed_rms(signal(emg_start_I(n):emg_end_I(n)-1,n), fs, emg_end_I(n)-emg_start_I(n));
    [~, pmin, pmax] = p2p_amplitude(signal(:,n), fs, 1000*[t0 t1]);
    amp_avg(n) = mean(signal(emg_start_I(n):emg_end_I(n)-1,n));

    amp_min(n) = pmin(2);
    amp_max(n) = pmax(2);
    pmin_I(n) = pmin(1);
    pmax_I(n) = pmax(1);
end

processed.fmed = fmed;
processed.fmean = fmean;
processed.rms = rms;

processed.emg_start_I = emg_start_I;
processed.emg_end_I = emg_end_I;
processed.emg_start = emg_start;
processed.emg_end = emg_end;

processed.pmin_I = pmin_I;
processed.pmax_I = pmax_I;
processed.amp_min = amp_min;
processed.amp_max = amp_max;
processed.amp_avg = amp_avg;

processed.fmed_bkp = fmed;
processed.fmean_bkp = fmean;
processed.rms_bkp = rms;

processed.emg_start_I_bkp = emg_start_I;
processed.emg_end_I_bkp = emg_end_I;
processed.emg_start_bkp = emg_start;
processed.emg_end_bkp = emg_end;

processed.pmin_I_bkp = pmin_I;
processed.pmax_I_bkp = pmax_I;
processed.amp_min_bkp = amp_min;
processed.amp_max_bkp = amp_max;
processed.amp_avg_bkp = amp_avg;

end
