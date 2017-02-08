
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


function [hpzero, hpmax, honset, hduration] = plot_emf(ax, signal, fs, pzero, pmax, pmax_t, onset, onset_bkp, duration, duration_bkp)

axes(ax);

xs = 0:1/fs:length(signal)/fs;
xs(1) = [];

hold on
plot(xs{1,1}, signal{1,1},'.');
yl = get(ax, 'YLim');
if  pmax(1) ~=0
    hpzero = plot(xs{1,1}(1), pzero(1), '.', 'Color','r');
    hpmax = plot(pmax_t, pmax(1), '.', 'MarkerSize', 15, 'LineWidth', 2);
else
    hpzero = plot(xs{1,1}(1), pzero(1), '.', 'Color',[0.7, 0.7, 0.7]);
    hpmax = plot(pmax_t, pmax(1), '.', 'Color',[0.7, 0.7, 0.7]);
end

if duration(1) ~=0
    honset = plot([onset onset], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2);
    hduration = plot([duration duration], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2);
else
    honset = plot([onset_bkp(1) onset_bkp(1)], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2,'Color',[0.7,0.7,0.7]);
    hduration = plot([duration_bkp duration_bkp], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2,'Color',[0.7,0.7,0.7]);
    
end

hold off
