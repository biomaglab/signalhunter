% --- Creates GUI panel and controls for TMS and Voluntary Contraction Processing
function panel_logo_biomag(handles)

% create the panel and controls, and return the handles
panel_creation(handles);



function panel_creation(handles)

% position of biomag logo considering the progress bar
% panelprogbar_pos = get(handles.progress_bar, 'Position');
% panel_pos = [panelprogbar_pos(1), panelprogbar_pos(2) + panelprogbar_pos(4) + 0.01,...
%     panelprogbar_pos(3), 0.095];

panel_pos = [0.8310, 0.061, 0.16, 0.095];
panel_biomaglogo = uipanel(handles.fig, 'Position', panel_pos,...
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
