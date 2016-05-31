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
handles.mep = uimenu(handles.subopen, 'Label', 'MEP Analysis',...
    'Callback', @callback_open);
handles.myosystem = uimenu(handles.subopen, 'Label', 'Myosystem',...
    'Callback', @callback_open);
handles.otbio = uimenu(handles.subopen, 'Label', 'OTBio',...
    'Callback', @callback_open);
handles.tms_vc = uimenu(handles.subopen, 'Label', 'TMS + VC',...
    'Callback', @callback_open);


handles.subsavelog = uimenu(handles.menufile, 'Label', 'Save log',...
    'Callback', @callback_savelog);
handles.subnew = uimenu(handles.menufile, 'Label', 'Create New',...
    'Callback', @callback_createnew);

%--------------------------------------------------------------------------
% creates the menu bar 2 with 1 submenu
handles.menutools = uimenu('Label', 'Processing Tools', 'Parent', hObject);
handles.subtools(1) = uimenu(handles.menutools, 'Label', 'TMS + VC',...
    'Callback', @callback_tms_vc);
handles.subtools(2) = uimenu(handles.menutools, 'Label', 'MEP Analysis',...
    'Callback', @callback_mepanalysis);
handles.subtools(3) = uimenu(handles.menutools, 'Label',...
    'OT Bioelettronica', 'Callback', @callback_otbio);

set(handles.menutools, 'Visible', 'on');

% creates the progress bar as an axes with variable filling
pos_progbar = [0.831, 0.011, 0.16, 0.04];
handles.progress_bar = axes('Parent', hObject, 'Units', 'Normalized');
set(handles.progress_bar, 'Position', pos_progbar);
hfill = fill([0 1 1 0],[0 0 1 1], 'b');
axis([0 1 0 1]);
set(hfill,'EdgeColor','k');
axis off;

% create logos panel
panel_logo_biomag(handles);

if isfield(handles,'data_id')
    % decide wich panel tools to create depending on the type of application
    switch lower(handles.data_id)
        
        case 'tms + vc'
            % create text log panel
            handles = panel_textlog(handles, []);
            handles = panel_tms_vc(handles);
            set(handles.subtools(1), 'Checked', 'on');
            
        case 'mep analysis'
            % create text log panel
            handles = panel_textlog(handles, []);
            handles = panel_mepanalysis(handles);
            set(handles.subtools(2), 'Checked', 'on');
            
        case 'otbio'
            handles = panel_otbio(handles);
            set(handles.subtools(3), 'Checked', 'on');
            
        case 'myosystem'
            disp('myosystem selected');
            
        case 'biopac'
            disp('biopac selected');
            
        case 'bin'
            disp('bin selected');
            
        case 'ascii'
            disp('ascii selected');
    end
    
    handles = panel_files(handles);
else
    handles = panel_textlog(handles, []);
end


% Update handles structure
guidata(hObject, handles);



% --- Callbacks for GUI objects.

function callback_open(hObject, eventdata)
% Callback - Sub Menu 1
handles = guidata(hObject);

handles.data_id = get(hObject,'Label');

% message to progress log
msg = 'Reading signal data...';
handles = panel_textlog(handles, msg);

% decide wich set of axes to create depending on type of application
switch lower(handles.data_id)
    
    % TMS and Voluntary Contraction Processing - Sarah Dias application
    case 'tms + vc'
        if strcmp(get(handles.subtools(1), 'Checked'),'off')
            handles = callback_tms_vc(handles.fig);
        end
        handles.reader = reader_tms_vc;
        
        msg = ['Data opened: "', handles.reader.sub_name,...
            '"; leg: "',  handles.reader.leg,...
            '"; series number: "', num2str(handles.reader.series_nb),...
            '"; TMS order: "', num2str(handles.reader.order_TMS),...
            '"; file name: "', handles.reader.filename, '".'];
        handles = panel_textlog(handles, msg);
        msg = 'Processing TMS + VC data...';
        handles = panel_textlog(handles, msg);
        
        handles.processed = processing_tms_vc(handles.reader);
        
        msg = 'Data processed.';
        handles = panel_textlog(handles, msg);
        
        handles = graphs_tms_vc(handles);
    
    % MEP analysis Signal Processing - Abrahao Baptista application
    case 'mep analysis'
        callback_mepanalysis(handles.fig);
        handles.reader = reader_mepanalysis;
        
        msg = ['Data opened.', 'Number of frames: ',  handles.reader.n_meps,];
        handles = panel_textlog(handles, msg);
        
        handles = graphs_mepanalysis(handles);
        
    % TMS and OT Bioelettronica Processing - Victor Souza application
    case 'otbio'
        callback_otbio(handles.fig);
        handles = graphs_otbio(handles);
        
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
    
end

% Update handles structure
guidata(hObject, handles);

function callback_createnew(hObject, eventdata)
% Callback - Sub Menu 2
handles = guidata(hObject);
% set(handles.fig,'Visible','off')
close(handles.fig)
signalhunter

function callback_savelog(hObject, eventdata)
% Callback - Sub Menu 2
handles = guidata(hObject);

% progress bar update
value = 1/2;
progbar_update(handles.progress_bar, value)

sub_name = handles.reader.sub_name;
leg = handles.reader.leg;
series_nb = handles.reader.series_nb;
process_id = handles.reader.process_id;

if process_id == 1
    filename = [sub_name '_' leg '_Serie' num2str(series_nb) '.txt'];
elseif process_id == 2
    filename = [sub_name '_' leg '_MVCpre.txt'];
elseif process_id == 3
    filename = [sub_name '_' leg '_MVC2min.txt'];
else
    filename = 'processing_log.txt';
end

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

function handles = callback_tms_vc(hObject, eventdata)
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

function callback_mepanalysis(hObject, eventdata)
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
    set(handles.subtools(3), 'Checked', 'off');
else
    handles = panel_otbio(handles);
    set(handles.subtools(:), 'Checked', 'off');
    set(handles.subtools(3), 'Checked', 'on');
end

% Update handles structure
guidata(hObject, handles);

