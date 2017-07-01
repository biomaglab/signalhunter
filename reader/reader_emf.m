
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


function reader = reader_emf
%READER_EMF read, import and organize data in Structure format used in
%SignalHunter EMF Analysis
% 
% INPUT:
% 
% raw data: .mat file containing raw signal (uigetfile), followed by
% manual enter of aquisition parameters (Equipment, *Stimulation mode,
% *Stimulation Frequency, Sampling Frequency).
%
% raw data: .bin file containing raw signal (uigetfile) and .txt with
% aquisition parameters.
%
% processed data: .mat file containing structure data in EMF Analysis
% frmat**.
% 
% OUTPUT:
%
% handles.reader structure containing processed data in EMF Analysis
% frmat**.
%
% * Parameters that will be extract together with processed data at .csv
% file later. Equipment: Equipment model; Stimulation mode: pTMS, ppTMS or
% rTMS; Stimulation Frequency in Hz (1 Hz to pTMS/ppTMS); Sampling
% Frequency from Data Aquisition in Hz;
%
% ** EMF Analysis structure is mainly composed by: panel variables and
% reader variables. reader variables includes: equipment model, stimulation
% mode, stimulation frequency, sampling frequency, filename and pathname,
% raw data, raw time vector, info_text (for variables visualization in
% panel_emf.m), axes information, push_buttons information, tstart
% (absolute time when pulse starts), tonset (abs. time in maximum value),
% tend (abs. time when pulse ends), signal (windoned in each detected
% pulse), xs (windoned abs. time in each detected pulse), number of pulses,
% figure titles (which includes equipment and stimulation mode
% informations), calculated onset, total duration and pulse zero-to-peak
% amplitude;


% loading signal and configuration data. Input data can be *.mat files
% (processed or raw signal) or *.bin (with *.txt parameters file in the
% same folder)
 [filename, pathname, frmat] = uigetfile({'*.mat;','Matlab files (*.mat)';...
     '*.bin;','Binary files'},'Select signal file');
 
% Waitbar to show frames progess
% Used this instead of built-in figure progess bar to avoid need of handles
hbar = waitbar(0.5, 'Reading signals...', 'Name','Progress');

% check if selected file is *.bin (frmat == 2) or *.mat (frmat == 1)

if (frmat==2)
    
    % If is *.bin, initiates import_emf.m function for structure building
    % with raw signal and acquisition parameters
    
	filename = strrep(filename,'.bin','');

	file_parameters = strcat(pathname,filename,'.txt');
	file_data = strcat(filename,'.bin');
	parameters = dlmread(file_parameters);

	prompt = {'Equipament';'Stimulation mode'; 'Stimulation frequency (1 for pTMS/ppTMS)'};
	dlg_title = 'Equipament information';
	info = inputdlg(prompt,dlg_title,1);

	reader.equipment = info{1};
	reader.mode = info{2};
	reader.freq = info{3};

	clear info prompt dlg_title

	% Acquisition parameters by manual input
	prompt = {'Enter Gain';'Enter offset'; 'Enter Sample Frequency (Hz)'};
	dlg_title = 'Acquisition parameters';
	parameters = inputdlg(prompt,dlg_title,1);

	signal_path = pathname;
	signal_gain =  parameters(1);
	signal_offset = parameters(2);
	%configuration.signal_time_elapsed = parameters(3);
	reader.fs = parameters(5);
	reader.filename = filename;
	reader.pathname = pathname;


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
	
else
    
    % Load *.mat file and check if is already processed
    load_var = importdata([pathname,filename]);

    % If is already processed, it contains the field 'equipment'
    if (isfield(load_var,'equipment')==0)
        
        % if is not processed, the data corresponds only to raw signal.
        % Other acquisition parameters will be filled manually
        reader.raw = load_var;
        clear loaded_var
        
        prompt = {'Equipament';'Stimulation mode'; 'Stimulation frequency (1 for pTMS/ppTMS)'; 'Sampling Frequency (Hz)'};
        dlg_title = 'Equipament and Acquisition information';
        infor = inputdlg(prompt,dlg_title,1);

        reader.equipment = infor{1};
        reader.mode = infor{2};
        reader.freq = str2double(infor{3});
        reader.fs = str2double(infor{4});
        clear infor prompt dlg_title
        
        reader.filename = filename;
        reader.pathname = pathname;
        
        reader.time = 0:1/reader.fs:length(reader.raw)/reader.fs;
        reader.time(1) = [];
        
        reader.raw_bkp = reader.raw;
        reader.time_bkp = reader.time;
    
    else 
        % if the *.mat file is already processed, just finish reader_emf.m
        reader = load_var;
        clear loaded_var
    end
end


