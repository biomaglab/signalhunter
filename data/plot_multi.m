function [ax] = plot_multi(ax, processed, id_axes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

i = id_axes(1);
j = id_axes(2);
k = id_axes(3);

% a = 1;
% b = 7;
% r = round((b-a).*rand(1000,1) + a);
% id = r(1);

split_pots = processed.split_pots{k,j}(:,:,i);
average_pots = processed.average_pots{k,j}(:,:,i);

% TODO: standardize xs in time starting from trigger
n_signals = size(split_pots,2);
split_xs = repmat(processed.split_xs{k,j}(:,1), [1 n_signals]);

latency_I_av = processed.latency_I_av{k,j}(:,:,i);
pmin_av = processed.pmin_av{k,j}(:,:,i);
pmax_av = processed.pmax_av{k,j}(:,:,i);

axes(ax);
hold on

% signal
hsig = plot(split_xs, split_pots, split_xs(:,1), average_pots);
for n = 1:n_signals
    hsig(n).Color = [153 153 153]/255;
end
hsig(end).Color = 'k';
hsig(end).Visible = 'on';

lim = axis;

% potential minimum
hmin = plot(split_xs(pmin_av(1),1), pmin_av(2), '+r', 'markersize', 10) ;
% potential maximum
hmax = plot(split_xs(pmax_av(1),1), pmax_av(2), '+r', 'markersize', 10);
% latency line
hlat = plot([split_xs(latency_I_av,1) split_xs(latency_I_av,1)], [lim(3)  lim(4)], 'g');

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

