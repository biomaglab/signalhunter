function figure_processing(varargin)
if ~isempty(varargin)
    handles.data_id = varargin{1};
    handles.map_template = varargin{2};
    handles.map_shape = varargin{3};
else
    handles.map_shape = [5,13];
    handles.map_template = (1:handles.map_shape(1)*handles.map_shape(2));
end

map_figure_creation(handles);


% --- Executes just before map_figure is made visible.
function hObject = map_figure_creation(handles)

set(0,'units','pixels');
scnsize = get(0,'screensize');
figw = ceil(scnsize(3)*0.9);
figh = floor(scnsize(4)*0.8);

% Figure creation
% hObject is the handle to the figure
hObject = figure('Name', 'Parameters Detection', 'Color', 'w', ...
    'MenuBar', 'none', 'ToolBar', 'figure', ...
    'DockControls', 'off', 'NumberTitle','off');
handles.fig = hObject;
set(hObject, 'Units', 'Pixels', 'Position', [0 0 figw figh]);

% center the figure window on the screen
movegui(hObject, 'center');

% creates the menu bar 1 with 1 submenu
handles.menufile = uimenu('Label', 'File', 'Parent', hObject);
handles.subopen = uimenu(handles.menufile, 'Label', 'Open',...
    'Callback', @callback_open);

% creates the menu bar 2 with 1 submenu
handles.menutools = uimenu('Label', 'Processing Tools', 'Parent', hObject);
handles.subtools(1) = uimenu(handles.menutools, 'Label', 'TMS + VC',...
    'Callback', @callback_tms_vc);
handles.subtools(2) = uimenu(handles.menutools, 'Label', 'OT Bioelettronica',...
    'Callback', @callback_otbio);

set(handles.menutools, 'Visible', 'off');

% creates the progress bar as an axes with variable filling
pos_progbar = [0.831, 0.011, 0.16, 0.04];
handles.progress_bar = axes('Parent', hObject, 'Units', 'Normalized');
set(handles.progress_bar, 'Position', pos_progbar);
hfill = fill([0 1 1 0],[0 0 1 1], 'b');
axis([0 1 0 1]);
set(hfill,'EdgeColor','k');
axis off;

% decide wich panel tools to create depending on the type of application
switch lower(handles.data_id)
    
    case 'tms + vc'
        handles = panel_tms_vc(handles);
        set(handles.subtools(1), 'Checked', 'on');
        
    case 'otbio'
        handles = panel_otbio(handles);
        set(handles.subtools(2), 'Checked', 'on');
        
    case 'myosystem'
        disp('myosystem selected');
        
    case 'biopac'
        disp('biopac selected');
        
    case 'bin'
        disp('bin selected');
        
    case 'ascii'
        disp('ascii selected');        
end

% create panel to export, save and load files
panel_files(handles);

% Update handles structure
guidata(hObject, handles);


% --- Callbacks for GUI objects.

function callback_open(hObject, eventdata)
% Callback - Sub Menu 1
handles = guidata(hObject);

% decide wich set of axes to create depending on type of application
switch lower(handles.data_id)
    
    % TMS and Voluntary Contraction Processing - Sarah Dias application
    case 'tms + vc'
        handles.reader = reader_tms_vc;
        handles.processed = processing_tms_vc(handles.reader);
        handles = graphs_tms_vc(handles);
    
    % TMS and OT Bioelettronica Processing - Victor Souza application
    case 'otbio'
        handles = graphs_otbio(handles);
        
    case 'myosystem'
        disp('myosystem selected');
        
    case 'biopac'
        disp('biopac selected');
        
    case 'bin'
        disp('bin selected');
        
    case 'ascii'
        disp('ascii selected');        
end

% Update handles structure
guidata(hObject, handles);

function callback_tms_vc(hObject, eventdata)
% Callback - Sub Menu 2

handles = guidata(hObject);

if isfield(handles, 'panel_tools')
    delete(handles.panel_tools);
    handles = rmfield(handles, 'panel_tools');
end
if isfield(handles, 'panel_graph')
    delete(handles.panel_graph);
    handles = rmfield(handles, 'panel_graph');
    handles = rmfield(handles, 'haxes');
end

if strcmp(get(handles.subtools(1), 'Checked'),'on')
    set(handles.subtools(1), 'Checked', 'off');
else
    handles = panel_tms_vc(handles);
    set(handles.subtools(:), 'Checked', 'off');
    set(handles.subtools(1), 'Checked', 'on');
end

% Update handles structure
guidata(hObject, handles);

function callback_otbio(hObject, eventdata)
% Callback - Sub Menu 2

handles = guidata(hObject);

if isfield(handles, 'panel_tools')
    delete(handles.panel_tools);
    handles = rmfield(handles, 'panel_tools');
end
if isfield(handles, 'panel_graph')
    delete(handles.panel_graph);
    handles = rmfield(handles, 'panel_graph');
    handles = rmfield(handles, 'haxes');
end

if strcmp(get(handles.subtools(2), 'Checked'),'on')
    set(handles.subtools(2), 'Checked', 'off');
else
    handles = panel_otbio(handles);
    set(handles.subtools(:), 'Checked', 'off');
    set(handles.subtools(2), 'Checked', 'on');
end

% Update handles structure
guidata(hObject, handles);

