function progbar_update(obj, value)
% function to update the progress bar filling
% obj: must be the handle of progress bar axes
% value: must be the percentage of total progress

axes(obj);
axis off;
cla;
axis([0 1 0 1]);

hold on
h1 = fill([0 1 1 0], [0 0 1 1], 'w');
set(h1,'EdgeColor','k');
fill([0 value value 0],[0 0 1 1], 'b');
hold off
