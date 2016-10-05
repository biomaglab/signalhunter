function figure_processing
% Main figure of signalhunter to open and process all data
% Figure is divided into panels and menus. Each panel may be filled
% according to the application of interest. Modular programming must be
% done to avoid redundancy.

% Example of old varargin use for figure_processing
% if ~isempty(varargin)
%     handles.data_id = varargin{1};
%     handles.map_template = varargin{2};
%     handles.map_shape = varargin{3};
% else
%     handles.map_shape = [5,13];
%     handles.map_template = (1:handles.map_shape(1)*handles.map_shape(2));
% end

map_figure_creation;


% --- Executes just before map_figure is made visible.
function map_figure_creation

set(0,'units','pixels');
scnsize = get(0,'screensize');
figw = ceil(scnsize(3)*0.9);
figh = floor(scnsize(4)*0.8);

% Figure creation
% hObject is the handle to the figure
hObject = figure('Name', 'Parameters Detection', 'Color', [255 255 255]/255, ...
    'MenuBar', 'none', 'ToolBar', 'figure', ...
    'DockControls', 'off', 'NumberTitle','off');
handles.fig = hObject;
set(hObject, 'Units', 'Pixels', 'Position', [0 0 figw figh]);

% center the figure window on the screen
movegui(hObject, 'center');

%--------------------------------------------------------------------------
% creates the menu bar 1 with 1 submenu
handles.menufile = uimenu('Label', 'File', 'Parent', hObject);
handles.subopen = uimenu(handles.menufile, 'Label', 'Open');

handles.ascii = uimenu(handles.subopen, 'Label', 'ASCII',...
    'Callback', @callback_open);
handles.bin = uimenu(handles.subopen, 'Label', 'Bin',...
    'Callback', @callback_open);
handles.biopac = uimenu(handles.subopen, 'Label', 'Biopac',...
    'Callback', @callback_open);
handles.mep = uimenu(handles.subopen, 'Label', 'MEP analysis',...
    'Callback', @callback_open);
handles.myosystem = uimenu(handles.subopen, 'Label', 'Myosystem',...
    'Callback', @callback_open);
handles.otbio = uimenu(handles.subopen, 'Label', 'Multi channels',...
    'Callback', @callback_open);
handles.tms_vc = uimenu(handles.subopen, 'Label', 'TMS + VC',...
    'Callback', @callback_open);
handles.tms_vc = uimenu(handles.subopen, 'Label', 'EMF Analysis',...
    'Callback', @callback_open);


handles.subsavelog = uimenu(handles.menufile, 'Label', 'Save log',...
    'Callback', @callback_savelog);
handles.subnew = uimenu(handles.menufile, 'Label', 'Create New',...
    'Callback', @callback_createnew);

handles.hsubdata = uimenu(handles.menufile, 'Label', 'Data');

uimenu(handles.hsubdata, 'Label', 'Export data table',...
    'Callback', @(obj, eventdata)callback_data(obj, 'export'));
uimenu(handles.hsubdata, 'Label', 'Load MAT file',...
    'Callback', @(obj, eventdata)callback_data(obj, 'load'));
uimenu(handles.hsubdata, 'Label', 'Save MAT file',...
    'Callback', @(obj, eventdata)callback_data(obj, 'save'));

set(handles.hsubdata, 'Enable', 'off');

%--------------------------------------------------------------------------
% creates the menu bar 2 with 1 submenu
handles.menutools = uimenu('Label', 'Processing Tools', 'Parent', hObject);
handles.subtools(1) = uimenu(handles.menutools, 'Label', 'TMS + VC',...
    'Callback', @callback_tms_vc);
handles.subtools(2) = uimenu(handles.menutools, 'Label', 'MEP analysis',...
    'Callback', @callback_mepanalysis);
handles.subtools(3) = uimenu(handles.menutools, 'Label',...
    'Multi channels', 'Callback', @callback_multi);

set(handles.menutools, 'Visible', 'on');

% creates the progress bar as an axes with variable filling and start full
pos_progbar = [0.831, 0.011, 0.16, 0.04];
handles.progress_bar = axes('Parent', hObject, 'Units', 'Normalized');
set(handles.progress_bar, 'Position', pos_progbar);
progbar_update(handles.progress_bar, 1);

% create logos panel
panel_logo_biomag(handles);

% start processing log
handles = panel_textlog(handles, []);

% Update handles structure
guidata(hObject, handles);


% --- Callbacks for GUI objects.
function callback_open(hObject, eventdata)
% Callback - Sub Menu 1
handles = guidata(hObject);
open_id = 0;

handles.data_id = lower(get(hObject,'Label'));
set(handles.hsubdata, 'Enable', 'on');

guidata(handles.fig, handles);

% message to progress log
msg = 'Reading signal data...';
handles = panel_textlog(handles, msg);

% decide wich set of axes to create depending on type of application
switch handles.data_id
    
    % TMS and Voluntary Contraction Processing - Sarah Dias application
    case 'tms + vc'
        if strcmp(get(handles.subtools(1), 'Checked'),'off')
            handles = callback_tms_vc(handles.fig);
        end
        handles = panel_tms_vc(handles);
        handles.reader = reader_tms_vc;
        
        msg = ['Data opened: "', handles.reader.sub_name,...
            '"; leg: "',  handles.reader.leg,...
            '"; series number: "', num2str(handles.reader.series_nb),...
            '"; TMS order: "', num2str(handles.reader.order_TMS),...
            '"; file name: "', handles.reader.filename, '".'];
        handles = panel_textlog(handles, msg);
        msg = 'Processing TMS + VC data...';
        handles = panel_textlog(handles, msg);
        
        handles.processed = process_tms_vc(handles.reader);
        
        msg = 'Data processed.';
        handles = panel_textlog(handles, msg);
        
        handles = graphs_tms_vc(handles);
        open_id = 1;
    
    % MEP analysis Signal Processing - Abrahao Baptista application
    case 'mep analysis'
        callback_mepanalysis(handles.fig);
        handles = panel_otbio(handles);
        handles.reader = reader_mepanalysis;
        
        msg = ['Data opened.', 'Number of MEPs: ',  handles.reader.n_meps];
        handles = panel_textlog(handles, msg);
        
        handles = graphs_mepanalysis(handles);
        open_id = 1;
        
    % Multiple channels - Victor Souza application
    case 'multi channels'
        handles = callback_multi(handles.fig);
        
%         [map_template, map_shape] = dialog_create_new;
%         handles.map_template = map_template;
%         handles.map_shape = map_shape;
        
        [handles.reader, open_id] = reader_multi;
                
        if open_id
            msg = 'Succesfully read data.';
            handles = panel_textlog(handles, msg);
            set(handles.hsubdata, 'Enable', 'on');
            
            handles.processed = process_multi(handles.reader);
            handles = panel_multi(handles);
            handles = graphs_multi(handles);
            
        else
           msg = 'Open canceled.';
           handles = panel_textlog(handles, msg);
            
        end
        
        
    case 'myosystem'
        disp('myosystem selected');
        msg = 'may the force be with you!';
        handles = panel_textlog(handles, msg);
        
    case 'biopac'
        disp('biopac selected');
        
    case 'bin'
        disp('bin selected');
        
    case 'ascii'
        disp('ascii selected');
        
    case 'emf analysis'
        msg = 'EMF data are oppening';
        handles = panel_textlog(handles, msg);
        handles = panel_emf(handles);
%         set(handles.subtools(4), 'Checked', 'on');
        msg = '>>> OK';
        handles = panel_textlog(handles, msg);
    
end

if open_id
    handles = panel_files(handles);
end

% Update handles structure
guidata(handles.fig, handles);

function handles = callback_createnew(hObject, ~)
% Callback - Sub Menu 2
handles = guidata(hObject);
% set(handles.fig,'Visible','off')
% close(handles.fig)
% signalhunter
% [data_id, map_template, map_shape] = dialog_create_new;
[map_template, map_shape] = dialog_create_new;
handles.map_template = map_template;
handles.map_shape = map_shape;
guidata(hObject, handles);

function callback_savelog(hObject, ~)
% Callback - Sub Menu 2
handles = guidata(hObject);

% progress bar update
value = 1/2;
progbar_update(handles.progress_bar, value)

filename = 'processing_log.txt';

% loading output template
[output_file, ouput_path, filt_id] = uiputfile({'*.txt','Text File (*.txt)'},...
    'Save processing log', filename);

log = get(handles.edit_log,'String');

if filt_id
    fileID = fopen([ouput_path output_file],'w');
    for i = 1:length(log)
        fprintf(fileID,'%s \r\n', log{i});
    end
    fclose(fileID);
end

% progress bar update
value = 1;
progbar_update(handles.progress_bar, value)

%--------------------------------------------------------------------------
% menu.toolbar instatiation
%--------------------------------------------------------------------------


function handles = callback_tms_vc(hObject, ~)
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
    set(handles.subtools(:), 'Checked', 'off');
    set(handles.subtools(1), 'Checked', 'on');
end

% Update handles structure
guidata(hObject, handles);


function callback_mepanalysis(hObject, ~)
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
    set(handles.subtools(:), 'Checked', 'off');
    set(handles.subtools(2), 'Checked', 'on');
end

% Update handles structure
guidata(hObject, handles);

function handles = callback_multi(hObject, ~)
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

if strcmp(get(handles.subtools(3), 'Checked'),'on')
    set(handles.subtools(3), 'Checked', 'off');
else
    set(handles.subtools(:), 'Checked', 'off');
    set(handles.subtools(3), 'Checked', 'on');
end

% Update handles structure
guidata(hObject, handles);

function callback_data(hObject, menu_id)
%CALLBACK_DATA Summary of this function goes here
%   Detailed explanation goes here

handles = guidata(hObject);
menu_id_up = [upper(menu_id(1)) menu_id(2:end)];

% message to progress log
msg = [menu_id_up ' data in progress...'];
handles = panel_textlog(handles, msg);

value = 1/2;
progbar_update(handles.progress_bar, value)

% call function to save, load or export
input = '(handles)';
[handles, filt_id] = eval(['data_' menu_id input]);

value = 1;
progbar_update(handles.progress_bar, value)

% message to progress log
if filt_id
    msg = [menu_id_up ' data finished.'];
    handles = panel_textlog(handles, msg);
else
    msg = [menu_id_up ' canceled.'];
    handles = panel_textlog(handles, msg);
end

guidata(hObject, handles)