
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


function reader = import_emf(file, path)
%IMPORT_EMF Summary of this function goes here
%   Detailed explanation goes here

file = strrep(file,'.bin','');

file_parameters = strcat(path,file,'.txt');
file_data = strcat(file,'.bin');
parameters = dlmread(file_parameters);

% prompt = {'Equipament';'Stimulation mode'; 'Stimulation frequency (1 for pTMS/ppTMS)'};
% dlg_title = 'Equipament information';
% info = inputdlg(prompt,dlg_title,1);

%  reader.equipment = info{1};
%  reader.mode = info{2};
%  reader.freq = info{3};
 
  reader.equipment = 'Magpro';
 reader.mode = 'rTMS';
 reader.freq = '100';

clear info prompt dlg_title

% Acquisition parameters by manual input
%prompt = {'Enter Gain';'Enter offset'; 'Enter Sample Frequency (Hz)'};
%dlg_title = 'Acquisition parameters';
%parameters = inputdlg(prompt,dlg_title,1);

signal_path = path;
signal_gain =  parameters(1);
signal_offset = parameters(2);
%configuration.signal_time_elapsed = parameters(3);
reader.fs = parameters(5);
reader.filename = file;


% clear info_signal;
clear parameters;
FileID = fopen(strcat(signal_path,file_data));

% Loading file
reader.raw = fread(FileID,'int8','b');
fclose(FileID);


reader.raw = reader.raw*signal_gain + signal_offset;
reader.time = 0:(1/reader.fs):length(reader.raw)/(reader.fs);
reader.time(1) = [];

reader.raw_bkp = reader.raw;
reader.time_bkp = reader.time;
reader = process_emf(reader);

uisave('handles'); 

