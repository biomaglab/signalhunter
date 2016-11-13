
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

function [amp, pmin, pmax] = p2p_amplitude(data, fs, twin)
%P2P_AMPLITUDE Find signal peak to peak amplitude, instant and intensity of
%greatest intensity peak and valley
% 
% INPUT:
% 
% data: m x n array (m is signal length and n is number of potentials)
% fs: sampling frequency in Hz
% twin: [a b] (a is window start and b is window end for peak finding -
% milisenconds)
% 
% OUTPUT:
%
% amp: 1 x n row vector of peak to peak amplitudes
% pmin: 2 x n array (1st row is valley instants and 2nd row is valley
% intensity
% pmax: 2 x n array (1st row is peak instants and 2nd row is peak
% intensity
%

% remove singletons dimensions
data = squeeze(data);
n_signals = size(data,2);

% convert time window in miliseconds to array position
if ~exist('twin', 'var')
    t0 = 1;
    tend = size(data,1);
elseif isempty(twin)
    t0 = 1;
    tend = size(data,1);
else
    t0 = ceil(twin(1)*fs/1000);
    tend = ceil(twin(2)*fs/1000);
end

% potential window for peak finding
potwindow = zeros(size(data,1),size(data,2));
potwindow(t0:tend,:) = data(t0:tend,:);

peak = zeros(1, n_signals);
valley = zeros(1, n_signals);
tmax = zeros(1, n_signals);
tmin = zeros(1, n_signals);

for i = 1:n_signals
    
    [pks, plocs] = findpeaks(potwindow(:,i));        
    [vls, vlocs] = findpeaks(-potwindow(:,i));
    
    if ~isempty(plocs) && ~isempty(vlocs)
        % instant of potential peak
        tp_aux = plocs(pks == max(pks));
        tmax(1,i) = tp_aux(1);
        peak(1,i) = potwindow(tmax(1,i),i);
        
        % instant of potential valley
        tv_aux = vlocs(vls == max(vls));
        tmin(1,i) = tv_aux(1);
        valley(1,i) = potwindow(tmin(1,i),i);
    else
        tmax(1,i) = 0;
        peak(1,i) = 0;
        
        tmin(1,i) = 0;
        valley(1,i) = 0;
    end
    
end

pmin = [tmin; valley];
pmax = [tmax; peak];

amp = abs(peak - valley);


