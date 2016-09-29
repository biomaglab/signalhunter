function [hplot] = plot_multi(ax, processed, id_axes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

i = id_axes(1);
j = id_axes(2);
k = id_axes(3);

split_pots = processed.split_pots{k,j}(:,1,i);
split_xs = processed.split_xs{k,j}(:,1);

latency_I = processed.latency_I{k,j}(:,1,i);
pmin = processed.pmin{k,j}(:,1,i);
pmax = processed.pmax{k,j}(:,1,i);

hplot = zeros(3,4,10);
axes(ax);


% xlabel('Time (s)')
% ylabel('EMG (mV)')
% set(ax, 'YLimMode', 'manual', 'YLim', [-1 1]);

% for i=1:size(data,2)
hold on
% hplot(id_axes(1),id_axes(2)) = plot(xs{i}(:,1), data{i}(:, id_axes(1)*id_axes(2)));
hplot(i, j, k) = plot(split_xs, split_pots);
% plot(latency_I, processed.split_pots{k,j}(latency_I,1,i), 'r');

hold off
% end

