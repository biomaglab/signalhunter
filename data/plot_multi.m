function [hsig, hpeaks, hlat] = plot_multi(ax, processed, id_axes)
%PLOT_MULTI: Summary of this function goes here
%   Detailed explanation goes here

id_cond = id_axes(1);
ci = id_axes(2);
ri = id_axes(3);

split_pots = processed.split_pots{id_cond,ci}(:,:,ri);
average_pots = processed.average_pots{id_cond,ci}(:,:,ri);

% xs starting from trigger
n_pots = size(split_pots, 2);
xs_norm = processed.xs_norm{id_cond,ci};

latency_av = processed.latency_av{id_cond,ci}(1,:,ri);
pmin_av = processed.pmin_av{id_cond,ci}(:,:,ri);
pmax_av = processed.pmax_av{id_cond,ci}(:,:,ri);

globalmin = processed.globalmin(id_cond,ci);
globalmax = processed.globalmax(id_cond,ci);

axes(ax);
hold on

% signal
hsig = plot(xs_norm, split_pots, xs_norm(:,1), average_pots);
for n = 1:n_pots
    hsig(n).Color = [153 153 153]/255;
end
hsig(end).Color = 'k';

axis([xs_norm(1,1) xs_norm(end,1) 1.2*globalmin 1.2*globalmax]);

lim = axis;

% potential peaks
hpeaks = plot(xs_norm(pmin_av(1),1), pmin_av(2), xs_norm(pmax_av(1),1), pmax_av(2)) ;
hpeaks(1).Marker = '+';
hpeaks(1).Color = 'r';
hpeaks(1).MarkerSize = 9;
hpeaks(2).Marker = '+';
hpeaks(2).Color = 'r';
hpeaks(2).MarkerSize = 9;

% potential latency
hlat = plot([xs_norm(latency_av,1) xs_norm(latency_av,1)], [lim(3)  lim(4)], 'g');
% hlat2 = plot([latency_av latency_av], [lim(3)  lim(4)], '--k');

hold off



% hplot = zeros(3,4,10);
% xlabel('Time (s)')
% ylabel('EMG (mV)')
% set(ax, 'YLimMode', 'manual', 'YLim', [-1 1]);
% for i=1:size(data,2)
% hplot(id_axes(1),id_axes(2)) = plot(xs{i}(:,1), data{i}(:, id_axes(1)*id_axes(2)));
% hplot(i, j, k) = plot(split_xs, split_pots);
% plot(latency_I, processed.split_pots{k,j}(latency_I,1,i), 'r');
% processed.split_pots{k,j}(latency_I,id,i)
% end

