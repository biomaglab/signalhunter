
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


function [hamp, hlat, hend] = plot_emganalysis(ax, signal, xs, amp, lat)

axes(ax);
hold on
hp = plot(xs, signal);

yl = get(ax, 'YLim');
if amp(1) ~=0
%     hpmin = plot(pmin(1), pmin(2), 'xr', 'MarkerSize', 15, 'LineWidth', 2);
    hamp = plot([xs(amp(1)-round(0.03*amp(1))) xs(amp(1)+round(0.03*amp(1)))],...
        [amp(2) amp(2)], 'MarkerSize', 15,...
        'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560]);
else
%     hpmin = nan;
    hamp = nan;
end

if lat(1) ~= 0
    hlat = plot([lat(1) lat(1)], [yl(1) yl(2)], '--',...
        'MarkerSize', 15, 'LineWidth', 2, 'Color', [0.4660 0.6740 0.1880]);
    hend = plot([lat(2) lat(2)], [yl(1) yl(2)], '--',...
        'MarkerSize', 15, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840]);
else
    hlat = nan;
    hend = nan;
end

hold off
