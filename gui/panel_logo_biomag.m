% --- Creates GUI panel and controls for TMS and Voluntary Contraction Processing
function panel_logo_biomag(fig_main)

% create the panel and controls, and return the handles
panel_creation(fig_main);



function panel_creation(fig_main)

% position of biomag logo considering the progress bar
% panelprogbar_pos = get(handles.progress_bar, 'Position');
% panel_pos = [panelprogbar_pos(1), panelprogbar_pos(2) + panelprogbar_pos(4) + 0.01,...
%     panelprogbar_pos(3), 0.095];

panel_pos = [0.8310, 0.061, 0.16, 0.095];
panel_biomaglogo = uipanel(fig_main, 'Position', panel_pos,...
    'BackgroundColor', 'w', 'Units', 'normalized', 'BorderWidth', 1);

biomaglogo = load('logo_biomag_usp.mat');

hax = axes('Parent', panel_biomaglogo, 'Units', 'Normalized');
hfill = fill([0 1 1 0],[0 0 1 1], 'm');
axis([0 1 0 1]);
set(hfill,'EdgeColor','k');
image(biomaglogo.ima)
axis off;
axis image;
set(hax, 'Position', [0 0 1 1]);
