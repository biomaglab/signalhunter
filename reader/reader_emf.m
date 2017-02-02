
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

% % loading signal and configuration data
%  [filename, pathname, format] = uigetfile({'*.mat;','Matlab files (*.mat)';...
%      '*.bin;','Binary files'},'Select signal file');
% Waitbar to show frames progess
% Used this instead of built-in figure progess bar to avoid need of handles
hbar = waitbar(0.5, 'Reading signals...', 'Name','Progress');

% if (format==2)
    filename = 'rTMS_100hz_100';
    pathname = 'D:\Dados TMS\MagPro\rTMS\';
    reader = import_emf(filename, pathname);
% else
%     data = load([pathname,filename]);
    
    % Check if *.mat file is already processed
%     if (isfield(data,'equipment')==0)
%         
%         reader.raw = data;
%         clear data
%         
%         prompt = {'Equipament';'Stimulation mode'; 'Stimulation frequency (1 for pTMS/ppTMS)'; 'Sampling Frequency (Hz)'};
%         dlg_title = 'Equipament and Acquisition information';
%         info = inputdlg(prompt,dlg_title,1);
% 
%         reader.equipment = info{1};
%         reader.mode = info{2};
%         reader.freq = info{3};
%         reader.fs = info{4};
%         clear info prompt dlg_title
%         
%         reader.filename = file;
%         
%         reader.time = 0:1/reader.fs:length(reader.data)/reader.fs;
%         reader.time(1) = [];
%         
%         reader = process_emf(reader);
%     
%     else 
%         reader = data;
%     end
% end

% load reader information
reader.equipment = data.equipment;
reader.mode = data.mode;
reader.freq = data.frequency;

reader.tstart = data.tstart;
reader.tstart_bkp = output_reader.tstart;

reader.tonset = data.tonset;
reader.tonset_bkp = output_reader.tonset;

reader.tend = data.tend;
reader.tend_bkp = reader.tend;

% pulse duration and onset values will be calculated further

reader.pzero = data.pzero;
reader.pzero_bkp = reader.pzero;

reader.pmax = data.pmax;
reader.pmax_bkp = reader.pmax;


reader.signal = data.signal;
reader.xs = data.xs; %time vector
reader.fs = data.fs; %samplig frequency
reader.id = data.id; %pulse id
reader.n_pulses = length(data.id); %number of pulses


% figure titles with states
fig_titles = cell(reader.n_pulses,1);

% creates figure titles with equipment, mode and pulse id
for i = 1:reader.n_pulses 
    fig_titles{i,1} = horzcat(data.equipment{i},' - ', data.mode{i,1}, ' - ',...
        num2str(data.id(i)),'.');
end

reader.fig_titles = fig_titles;

