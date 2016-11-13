
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


function lat = find_latency(data, threshold)
%LATENCY Calculate potentials latency
% Use differential signal and then calculate the standard deviation of all
% diff values, then get the location where diff value is 2 times the mean
% standard deviation of all values
%
% INPUT:
% 
% data: m x n array (m is signal length and n is number of potentials)
% twin: [a b] (a is window start and b is window end for latency
% calculation - milisenconds)
% threshold: minimum level of signal difference to consider for potential
% finding
% 
% OUTPUT:
%
% lat: 1 x n array (column vector of latency instants
%

% remove singletons dimensions
data = squeeze(data);
n_signals = size(data,2);

% threshold of 0.7 is good
threshood_std = threshold;

% window size for moving average filter
windowSize = 10;

% magic number
% method consider latency displaced after potential start
% this constant rewind latency (units in points of signal)
mn = 5;

lat = zeros(1,n_signals);

% moving average filter for signal smoothing and noise reduction
window = ones(1,windowSize);
fpotential = filter(window, windowSize, data', [], 2)';

% differential signal is greater during potential and smaller for noise
diff_fpotential = diff([fpotential(1,:); fpotential], [], 1);
stddiff = std(diff_fpotential, 0, 1);

for i = 1:n_signals
    lat(1,i) = find(abs(diff_fpotential(:,i)) > threshood_std*stddiff(:,i), 1)-mn;
    if lat(1,i) <= 0
        lat(1,i) = 1;
    end    
end

end

