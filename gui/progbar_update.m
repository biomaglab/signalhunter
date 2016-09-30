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
