function [hplot] = plot_multi(ax, reader, id_axes, i)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

signal = reader.signal;
data = signal.data;
xs = signal.xs;

hplot = zeros(3,4);
axes(ax);

% xlabel('Time (s)')
% ylabel('EMG (mV)')
% set(ax, 'YLimMode', 'manual', 'YLim', [-1 1]);

% for i=1:size(data,2)
% hold on
% hplot(id_axes(1),id_axes(2)) = plot(xs{i}(:,1), data{i}(:, id_axes(1)*id_axes(2)));
hplot(id_axes(1),id_axes(2)) = plot(xs{i}(:,1), data{i}(:, 2));
% hold off
% end

