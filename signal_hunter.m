function varargout = signal_hunter(varargin)
% SIGNAL_HUNTER MATLAB code for signal_hunter.fig
%      SIGNAL_HUNTER, by itself, creates a new SIGNAL_HUNTER or raises the existing
%      singleton*.
%
%      H = SIGNAL_HUNTER returns the handle to a new SIGNAL_HUNTER or the handle to
%      the existing singleton*.
%
%      SIGNAL_HUNTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNAL_HUNTER.M with the given input arguments.
%
%      SIGNAL_HUNTER('Property','Value',...) creates a new SIGNAL_HUNTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before signal_hunter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to signal_hunter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help signal_hunter

% Last Modified by GUIDE v2.5 17-Oct-2013 20:31:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @signal_hunter_OpeningFcn, ...
                   'gui_OutputFcn',  @signal_hunter_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before signal_hunter is made visible.
function signal_hunter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to signal_hunter (see VARARGIN)
global active

% this command is creating a white board in the up limits that is undesired 
% movegui(hObject, 'center')

% backup the matlab path before signal_hunter, save it to a file at config
% folder and then set the new path of matlab containing all signal_hunter
% folders

% % file_config = './config/ml_pth_bkp.mat'; 
% % 
% % if exist(file_config, 'file')
% %     bkp_pth = load(file_config);
% %     ml_pth = bkp_pth.ml_pth_bkp;
% %     path(ml_pth);
% % end
% % save(file_config, 'ml_pth_bkp');


sighunter_path = pwd;
sh_ls_path = genpath(sighunter_path);
path(path, sh_ls_path);

signal_hunter_logo;

signal_logo = load('signal_hunter.mat');
axes(handles.axes_logo)
image(signal_logo.ima)

set(handles.axes_logo,'XTick', []);
set(handles.axes_logo,'YTick', []);
set(handles.axes_logo,'ZTick', []);
set(handles.axes_logo,'Box', 'off');
set(handles.axes_logo,'XAxisLocation', 'top');


active = 0;

row_size = get (handles.popupmenu2, 'Value');
col_size = get (handles.popupmenu3, 'Value');


d = cell(row_size,col_size);
for j = 1:row_size*col_size
    d{j}=j;
end
set(handles.uitable1, 'Data', d,'ColumnEditable',true,'ColumnFormat',{'numeric'});
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.uitable1,'ColumnWidth',col_width)





% Choose default command line output for signal_hunter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes signal_hunter wait for user response (see UIRESUME)
% uiwait(handles.figure_SignalMain);


% --- Outputs from this function are returned to the command line.
function varargout = signal_hunter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

row_size = get (handles.popupmenu2, 'Value');
col_size = get (handles.popupmenu3, 'Value');


d = cell(row_size,col_size);
for j = 1:row_size*col_size
    d{j}=j;
end
set(handles.uitable1, 'Data', d,'ColumnEditable',true,'ColumnFormat',{'numeric'});
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.uitable1,'ColumnWidth',col_width)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



row_size = get (handles.popupmenu2, 'Value');
col_size = get (handles.popupmenu3, 'Value');

d = cell(row_size,col_size);
for j = 1:row_size*col_size
    d{j}=j;
end

set(handles.uitable1, 'Data', d);
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.uitable1,'ColumnWidth',col_width)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global active
row_size = get (handles.popupmenu2, 'Value');
col_size = get (handles.popupmenu3, 'Value');
d = cell(row_size,col_size);

cont = 1;

if active == 0
    for i = 1:row_size
        for j = 1:col_size
            d{i,j} = cont;
            cont = cont+1;
        end
    end
    active = 1;
else
    for j = 1:col_size
        for i = 1:row_size
            d{i,j} = cont;
            cont = cont+1;
        end
    end
    active = 0;
end

set(handles.uitable1, 'Data', d);
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.uitable1,'ColumnWidth',col_width)


% --- Executes on button press in pushbutton_clear.
function pushbutton_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
row_size = get (handles.popupmenu2, 'Value');
col_size = get (handles.popupmenu3, 'Value');
d = cell(row_size,col_size);

set(handles.uitable1, 'Data', d);
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.uitable1,'ColumnWidth',col_width)


% --- Executes on button press in pushbutton_ok.
function pushbutton_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.figure_SignalMain,'Visible','off')

data = get(handles.uitable1,'Data');

for i = 1:size(data,1)*size(data,2)
   
    if isempty(data{i}) == 1
        data{i} = nan;
    end
    
end

data_mat = cell2mat(data);
    

pos_channel = isnan(data_mat)==0;

channel_number = data_mat(pos_channel);

channel_sort = sort(channel_number);


for j = 1:length(channel_sort)
    pos(j,1) = find(data_mat==channel_sort(j));
end


v = get (handles.popupmenu1, 'Value');
s = get (handles.popupmenu1, 'String');
data_id = s{v};

map_template = pos;

map_shape = size(data_mat);

figure_processing(data_id, map_template, map_shape);

close(handles.figure_SignalMain)




% --- Executes on button press in pushbutton_SaveTemplate.
function pushbutton_SaveTemplate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SaveTemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.uitable1,'Data');


[fn pn] = uiputfile('*.mat');

save([pn fn],'data')

% --- Executes on button press in pushbutton_OpenTemplate.
function pushbutton_OpenTemplate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OpenTemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fn pn] = uigetfile('*.mat');

aux = load([pn fn]);

f = fieldnames(aux);
d = getfield(aux,f{1});

set(handles.uitable1, 'Data', d);
col_width = cell(1,20);

for i = 1:20
    col_width{i}=30;
end

set(handles.uitable1,'ColumnWidth',col_width)
