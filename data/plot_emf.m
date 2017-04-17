
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


function  plot_emf(ax, signal, xs, tstart, tonset, tend, time, raw)

axes(ax);
% [~,start_aux,~] = intersect(xs,tstart);
% [~,onset_aux,~] = intersect(xs,tonset);
% [~,end_aux,~] = intersect(xs,tend);

% yl = get(ax, 'YLim');

plot(xs, raw(xs),'.');
% ylim([yl(1) yl(2)])

hold on

% Plot values before and after windowed pulse
plot(((tstart - 20):(tstart - 1)),raw((tstart - 20):(tstart - 1)),'.','color',[0.6 0.6 0.6])
plot(((tend + 1):(tend +20)),raw((tend + 1):(tend +20)),'.','color',[0.6 0.6 0.6])


% yl = get(ax, 'YLim');

    plot((tstart), raw(tstart), '.', 'Color','r','MarkerSize', 15, 'LineWidth', 2);
    plot((tonset), raw(tonset), '.', 'Color','r', 'MarkerSize', 15, 'LineWidth', 2);

    plot((tend), raw(tend), '.', 'Color','r', 'MarkerSize', 15, 'LineWidth', 2);


hold off
end
