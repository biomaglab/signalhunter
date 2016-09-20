function [hplot] = plot_multi(ax, reader, id_axes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

signal = reader.signal;
data = signal.data;
Time = signal.Time;

hplot = zeros(15,2);
axes(ax);

xlabel('Time (s)')
ylabel('EMG (mV)')
set(ax, 'YLimMode', 'manual', 'YLim', [-1 1]);

% for i=1:size(data,2)
hold on
hplot(id_axes(1),id_axes(2)) = plot(Time,data(:,id_axes(1),id_axes(2)));
hold off
% end

