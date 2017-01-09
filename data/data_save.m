
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


function [handles, filt_id] = data_save(handles)
%SAVE_DATA Summary of this function goes here
%   Detailed explanation goes here

switch handles.data_id
        
    case 'tms + vc'
        filt_id = save_tms_vc(handles.reader, handles.processed);
        
    case 'mep analysis'
        filt_id = save_mepanalysis(handles.reader);
        
    case 'multi channels'
        filt_id = save_multi(handles.reader, handles.processed);
        
end

end


function filt_id = save_mepanalysis(reader)

filename_aux = 'subject_data';

[filename, pathname, filt_id] = uiputfile({'*.mat','MATLAB File (*.mat)'},...
    'Save processed data', filename_aux);

if filt_id
    save([pathname filename], 'reader');
end

end


function filt_id = save_tms_vc(reader, processed)
%SAVE_TMS_VC Summary of this function goes here
%   Detailed explanation goes here

sub_name = reader.sub_name;
leg = reader.leg;
process_id = reader.process_id;

if process_id == 1
    series_nb = reader.series_nb;
    filename = [sub_name '_' leg '_Serie' num2str(series_nb) '.mat'];
elseif process_id == 2
    filename = [sub_name '_' leg '_MVCpre.mat'];
elseif process_id == 3
    filename = [sub_name '_' leg '_MVC2min.mat'];
end

[output_file, ouput_path, filt_id] = uiputfile({'*.mat','MATLAB File (*.mat)'},...
    'Save processed data', filename);

if filt_id
    save([ouput_path output_file], 'processed', 'reader');
end

end

function filt_id = save_multi(reader, processed)

subject = reader.subject;
filename_aux = [subject{1,1} 'data'];

[filename, pathname, filt_id] = uiputfile({'*.mat','MATLAB File (*.mat)'},...
    'Save processed data', filename_aux);

if filt_id
    save([pathname filename], 'reader', 'processed');
end

end

