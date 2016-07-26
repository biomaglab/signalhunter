
function [hpzero, hpmax, honset, hduration] = plot_emf(ax, signal, xs, pzero, pmax, pmax_t, onset, onset_bkp, duration, duration_bkp)

axes(ax);
hold on
plot(xs{1,1}, signal{1,1},'.');
yl = get(ax, 'YLim');
if  pmax(1) ~=0
    hpzero = plot(xs{1,1}(1), pzero(1), '.', 'Color','r');
    hpmax = plot(pmax_t, pmax(1), '.', 'MarkerSize', 15, 'LineWidth', 2);
else
    hpzero = plot(xs{1,1}(1), pzero(1), '.', 'Color',[0.7, 0.7, 0.7]);
    hpmax = plot(pmax_t, pmax(1), '.', 'Color',[0.7, 0.7, 0.7]);
end

if duration(1) ~=0
    honset = plot([onset onset], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2);
    hduration = plot([duration duration], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2);
else
    honset = plot([onset_bkp(1) onset_bkp(1)], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2,'Color',[0.7,0.7,0.7]);
    hduration = plot([duration_bkp duration_bkp], [yl(1) yl(2)], '--y', 'MarkerSize', 15, 'LineWidth', 2,'Color',[0.7,0.7,0.7]);
    
end

hold off
