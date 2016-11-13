
% -------------------------------------------------------------------------
% Signal Hunter - electrophysiological signal analysis  
% Copyright (C) 2013, 2013-2016  University of Sao Paulo
% 
% Homepage:  http://df.ffclrp.usp.br/biomaglab
% Contact:   biomaglab@gmail.com
% License:   GNU - GPL 3 (LICENSE.txt)
% 
% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or any later
% version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
% 
% The full GNU General Public License can be accessed at file LICENSE.txt
% or at <http://www.gnu.org/licenses/>.
% 
% -------------------------------------------------------------------------
% 
% Author: Victor Hugo Souza
% Date: 13.11.2016


function [ handles ] = import_emf()
%IMPORT_EMF Summary of this function goes here
%   Detailed explanation goes here

[file, path] = uigetfile('.bin','Select binary file');

file = strrep(file,'.bin','');

file_parameters = strcat(path,file,'.txt');
file_data = strcat(file,'.bin');
parameters = dlmread(file_parameters);

prompt = {'Equipament';'Stimulation mode'; 'Stimulation frequency (1 for pTMS/ppTMS)'};
dlg_title = 'Equipament information';
info = inputdlg(prompt,dlg_title,1);

 reader.equipament = info{1};
 reader.mode = info{2};
 reader.freq = info{3};

clear info prompt dlg_title

%prompt = {'Enter Gain';'Enter offset'; 'Enter Sample Frequency (Hz)'};
%dlg_title = 'Acquisition parameters';
%parameters = inputdlg(prompt,dlg_title,1);

reader.signal_path = path;
reader.signal_gain =  parameters(1);
reader.signal_offset = parameters(2);
%configuration.signal_time_elapsed = parameters(3);
reader.signal_sample = parameters(3);
reader.signal_filename = file;


% clear info_signal;
clear parameters;
FileID = fopen(strcat(reader.signal_path,file_data));

% Loading file
raw = fread(FileID,'int8','b');
fclose(FileID);


reader.raw = raw*(reader.signal_gain) + reader.signal_offset;
reader.time = 0:(reader.signal_sample/length(reader.raw)):(reader.signal_sample);
reader.time(1) = [];

reader.raw_backup = reader.raw;
reader.time_backup = reader.time;

handles.reader = reader;
clear reader
handles = processing_emf(handles.reader);

handles.tonset_bkp = handles.tonset;
handles.tduration_bkp = handles.tduration;


handles.pmax_bkp = handles.pmax;
handles.pmax_t = handles.pmax_t;
 
handles.pzero_bkp = handles.pzero;





for i = 1:handles.n_pulses
    handles.fig_titles{i,1} = horzcat(handles.equipament,...
        ' - ', handles.mode, ' - ', num2str(handles.id(i)),'.');
   
    handles.onset(i) = (handles.pmax_t(i) - handles.tonset(i))*10^6;                                
    handles.duration(i) = (handles.tduration(i)- ...
                               handles.tonset(i))*10^6;
end

uisave('handles'); 

