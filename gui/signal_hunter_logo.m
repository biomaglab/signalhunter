function varargout = signal_hunter_logo(varargin)
% SIGNAL_HUNTER_LOGO M-file for signal_hunter_logo.fig
%      SIGNAL_HUNTER_LOGO, by itself, creates a new SIGNAL_HUNTER_LOGO or raises the existing
%      singleton*.
%
%      H = SIGNAL_HUNTER_LOGO returns the handle to a new SIGNAL_HUNTER_LOGO or the handle to
%      the existing singleton*.
%
%      SIGNAL_HUNTER_LOGO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNAL_HUNTER_LOGO.M with the given input arguments.
%
%      SIGNAL_HUNTER_LOGO('Property','Value',...) creates a new SIGNAL_HUNTER_LOGO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before signal_hunter_logo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to signal_hunter_logo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% Created by André Salles Cunha Peres 02/09/2011 

% Edit the above text to modify the response to help signal_hunter_logo

% Last Modified by GUIDE v2.5 17-Oct-2013 21:06:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @signal_hunter_logo_OpeningFcn, ...
                   'gui_OutputFcn',  @signal_hunter_logo_OutputFcn, ...
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


% --- Executes just before signal_hunter_logo is made visible.
function signal_hunter_logo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to signal_hunter_logo (see VARARGIN)

signal_logo = load('signal_hunter_opening.mat');
axes(handles.axes1)
image(signal_logo.ima)
set(handles.axes1,'XTick', []);
set(handles.axes1,'YTick', []);
set(handles.axes1,'ZTick', []);


pause(0.5)
close(handles.figure_logo)



% Choose default command line output for signal_hunter_logo
%handles.output = hObject;

% Update handles structure
%guidata(hObject, handles);

% UIWAIT makes signal_hunter_logo wait for user response (see UIRESUME)
% uiwait(handles.figure_logo);


% --- Outputs from this function are returned to the command line.
function varargout = signal_hunter_logo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% uiwait(hObject);
% handles = guidata(hObject);
% 
% delete(hObject);

% Get default command line output from handles structure
%varargout{1} = handles.output;
