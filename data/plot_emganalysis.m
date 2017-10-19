
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


function hp = plot_emganalysis(ax, signal, xs)

axes(ax);
hold on
hp = plot(xs, signal);
% yl = get(ax, 'YLim');
% if pmin(1) ~= 0 && pmax(1) ~=0
%     hpmin = plot(pmin(1), pmin(2), 'xr', 'MarkerSize', 15, 'LineWidth', 2);
%     hpmax = plot(pmax(1), pmax(2), 'xr', 'MarkerSize', 15, 'LineWidth', 2);
% else
%     hpmin = nan;
%     hpmax = nan;
% end
% 
% if lat(1) ~= 0
%     hlat = plot([lat(1) lat(1)], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2);
%     hend = plot([lat(2) lat(2)], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2);
% else
%     hlat = nan;
%     hend = nan;
% end

hold off
