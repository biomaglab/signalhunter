
function [hpmin, hpmax, hlat, hend] = plot_mepanalysis(ax, signal, xs, pmin, pmax, lat)

axes(ax);
hold on
plot(xs, signal);
yl = get(ax, 'YLim');
if pmin(1) ~= 0 && pmax(1) ~=0
    hpmin = plot(pmin(1), pmin(2), 'xr', 'MarkerSize', 15, 'LineWidth', 2);
    hpmax = plot(pmax(1), pmax(2), 'xr', 'MarkerSize', 15, 'LineWidth', 2);
else
    hpmin = nan;
    hpmax = nan;
end

if lat(1) ~= 0
    hlat = plot([lat(1) lat(1)], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2);
    hend = plot([lat(2) lat(2)], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2);
else
    hlat = nan;
    hend = nan;
end

hold off
