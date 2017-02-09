
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
[~,start_aux,~] = intersect(xs,tstart);
[~,onset_aux,~] = intersect(xs,tonset);
[~,end_aux,~] = intersect(xs,tend);

plot(xs, signal,'.');

hold on

plot(((tstart - 20):(tstart - 1)),raw((tstart - 20):(tstart - 1)),'.','color',[0.6 0.6 0.6])
plot(((tend + 1):(tend +20)),raw((tend + 1):(tend +20)),'.','color',[0.6 0.6 0.6])


yl = get(ax, 'YLim');
% if  pmax ~=0
    plot(tstart, signal(start_aux), '.', 'Color','r');
    plot(tonset, signal(onset_aux), '.', 'MarkerSize', 15, 'LineWidth', 2);
% else
%     plot(xs{1,1}(1), signal(xs(1,1)), '.', 'Color',[0.7, 0.7, 0.7]);
%     plot(pmax_t, pmax(1), '.', 'Color',[0.7, 0.7, 0.7]);
% end

% if duration(1) ~=0
    plot(tend, signal(end_aux), '.', 'MarkerSize', 15, 'LineWidth', 2);

%     plot([onset onset], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2);
%     plot([duration duration], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2);
% else
%     honset = plot([onset_bkp(1) onset_bkp(1)], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2,'Color',[0.7,0.7,0.7]);
%     hduration = plot([duration_bkp duration_bkp], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2,'Color',[0.7,0.7,0.7]);
    
% end

hold off
end
