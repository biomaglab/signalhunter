
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


function progbar_update(obj, value)
% PROGBAR_UPDATE: Update the progress bar built in figure_processing
%
% obj: handle of progress bar axes
% value: percentage of total progress in range 0 to 1.

axes(obj);
axis off;
cla;
axis([0 1 0 1]);

hold on
h1 = fill([0 1 1 0], [0 0 1 1], 'w');
set(h1,'EdgeColor','k');
fill([0 value value 0],[0 0 1 1], 'g');
hold off
