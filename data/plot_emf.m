
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
%PLOT_EMF function plot pulses signal together with tstart, tonset and tend
%parameters.
%
% INPUTS:
%
% ax: axes information from that pulse;
% signal: windoned signal;
% xs: windoned time vector;
% tstart, tonset and tend: INDICES for those variables;
% time and raw: raw data from signal and time vector;
%
% OUTPUTS:
%
% plot in panel_emf

axes(ax);
plot(xs, raw(xs),'.');

hold on

% Plot values before and after windowed pulse
plot(((tstart - 20):(tstart - 1)),raw((tstart - 20):(tstart - 1)),'.','color',[0.6 0.6 0.6])
plot(((tend + 1):(tend +20)),raw((tend + 1):(tend +20)),'.','color',[0.6 0.6 0.6])

plot((tstart), raw(tstart), '.', 'Color','r','MarkerSize', 15, 'LineWidth', 2);
plot((tonset), raw(tonset), '.', 'Color','r', 'MarkerSize', 15, 'LineWidth', 2);

plot((tend), raw(tend), '.', 'Color','r', 'MarkerSize', 15, 'LineWidth', 2);


hold off
end
