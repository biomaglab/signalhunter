
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


function tf = output_emf(handles)
%EMF Analysis Output Function to standardize the output for EMF Analysis
%processing

tic
previous_data = [];

equipament = handles.reader.equipaments;
mode = handles.reader.mode;
freq = handles.reader.freq';
id = handles.reader.id';



pzero = handles.reader.pzero';
pmax = handles.reader.pmax';

tstart = handles.reader.tstart';
tonset = handles.reader.tonset';
onset = handles.reader.onset';

tduration = handles.reader.tduration';
duration = handles.reader.duration';


[filename, pathname, filterindex] = uiputfile({'*.xls;*.xlsx','MS Excel Files (*.xls,*.xlsx)'},...
    'Export data', 'processed_data.xlsx');

export_data = [equipament mode num2cell(freq) num2cell(id) ...
    num2cell(pzero) num2cell(pmax) num2cell(tstart) ...
    num2cell(tonset) num2cell(onset) num2cell(tduration) num2cell(duration)];

headers = [{'Equipament'} {'mode'} {'frequency'} {'id'}...
{'zero amplitude (mV)'} {'peak amplitude (mV)'} {'t0 (s)'} {'tonset (s)'}...
{'onset time (us)'} {'tduration (s)'} {'duration (us)'} ];

switch filterindex
    case 1
        try
            [~, ~, previous_data] = xlsread([pathname filename]);
        end
        if isempty(previous_data)
            xlswrite([pathname filename], [headers; export_data])
        else
            xlswrite([pathname filename], [previous_data; export_data])
        end
        
    case 2
        fid = fopen([pathname filename]);
        try
            previous_data = fgets(fid);
        end
        the_format = '\n%d %s %d %d %d';
        if isempty(previous_data)
            fid = fopen([pathname filename], 'w');
            fprintf(fid, '%s %s %s %s %s', headers{1,:});
            fprintf(fid, the_format, export_data{1,:});
            fclose(fid);
        else
            fid = fopen([pathname filename], 'a');
            fprintf(fid, the_format, export_data{1,:});
            fclose(fid);
        end
end
tf = toc;

