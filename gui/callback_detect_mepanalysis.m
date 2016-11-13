
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


function handles = callback_detect_mepanalysis(handles, id_pb)
%BUTTONS_CALLBACK_MEPANALYSIS Summary of this function goes here
%   Detailed explanation goes here

handles = pb_detect_callback(handles, id_pb);

function handles = pb_detect_callback(handles, id_pb)

axesdetect = handles.axesdetect;
id = handles.id_cond;
info_text = handles.info_text;
yl = get(axesdetect, 'YLim');
xl = get(axesdetect, 'XLim');

switch id_pb
    case 1
        
        hstr = handles.hstr(id_pb, :);
        
        % ---- Delete previous plots
        if isfield(handles,'hpmin')
            if ishandle(handles.hpmin)
                delete(handles.hpmin)
                delete(handles.hpmax)
            end
        end
        % ----
        
        % ---- MEP minimum
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the negative peak and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.3f'));
        handles.hpmin = plot(axesdetect, [xl(1) xl(2)], [y(1) y(1)], 'g',...
            'MarkerSize', 15, 'LineWidth', 2);
        
        % ---- MEP maximum
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the positive peak and click ENTER');
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(2),'%.3f'));
        handles.hpmax = plot(axesdetect, [xl(1) xl(2)], [y(2) y(2)], 'g',...
            'MarkerSize', 15, 'LineWidth', 2);
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update MEPs amplitudes, minimum and maximum peaks
        handles.reader.mep_amp(id) = y(2) - y(1);
        handles.reader.mep_pmin(id, :) = [x(1), y(1)];
        handles.reader.mep_pmax(id, :) = [x(2), y(2)];
        
    case 2
        
        hstr = handles.hstr(id_pb, :);
        
        % ---- Delete previous plots
        if isfield(handles,'hlat')
            if ishandle(handles.hlat)
                delete(handles.hlat)
                delete(handles.hend)
            end
        end
        % ----
        
        % ---- MEP start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the MEP start and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.3f'));
        handles.hlatsta = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)], 'm',...
            'MarkerSize', 15, 'LineWidth', 2);
        
        % ---- MEP end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the MEP end and click ENTER');
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.3f'));
        handles.hlatend = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)], 'm',...
            'MarkerSize', 15, 'LineWidth', 2);
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update MEPs duration, start and end instants
        handles.reader.mep_dur(id) = x(2) - x(1);
        handles.reader.mep_lat(id) = x(1);
        handles.reader.mep_end(id) = x(2);
        
    case 3
        
        % ---- Delete previous plots
        if isfield(handles,'hpmin')
            if ishandle(handles.hpmin)
                delete(handles.hpmin)
                delete(handles.hpmax)
            end
        end
        
        % ---- Delete previous plots
        if isfield(handles,'hlatsta')
            if ishandle(handles.hlat)
                delete(handles.hlat)
                delete(handles.hend)
            end
        end
        
        % Update MEPs amplitudes, minimum and maximum peaks
        handles.reader.mep_amp(id) = 0;
        handles.reader.mep_pmin(id, :) = [0, 0];
        handles.reader.mep_pmax(id, :) = [0, 0];
        
        % Update MEPs duration, start and end instants
        handles.reader.mep_dur(id) = 0;
        handles.reader.mep_lat(id) = 0;
        handles.reader.mep_end(id) = 0;
        
        % Update strings
        hstr = handles.hstr(1, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.3f'));
        set(hstr(1,2), 'String', num2str(0.00,'%.3f'));
        
        hstr = handles.hstr(2, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.3f'));
        set(hstr(1,2), 'String', num2str(0.00,'%.3f'));
        
    case 4
        
        % ---- Delete previous plots
        if isfield(handles,'hpmin')
            if ishandle(handles.hpmin)
                delete(handles.hpmin)
                delete(handles.hpmax)
            end
        end
        
        % ---- Delete previous plots
        if isfield(handles,'hlat')
            if ishandle(handles.hlat)
                delete(handles.hlat)
                delete(handles.hend)
            end
        end
        
        % Update MEPs amplitudes, minimum and maximum peaks
        handles.reader.mep_amp(id) = handles.reader.mep_amp_bkp(id);
        handles.reader.mep_pmin(id, :) = handles.reader.mep_pmin_bkp(id, :);
        handles.reader.mep_pmax(id, :) = handles.reader.mep_pmax_bkp(id, :);
        
        % Update MEPs duration, start and end instants
        handles.reader.mep_dur(id) = 0;
        handles.reader.mep_lat(id) = 0;
        handles.reader.mep_end(id) = 0;
        
        % Update strings
        hstr = handles.hstr(1, :);
        set(hstr(1,1), 'String', num2str(handles.reader.mep_pmin(id,2),'%.3f'));
        set(hstr(1,2), 'String', num2str(handles.reader.mep_pmax(id,2),'%.3f'));
        
        hstr = handles.hstr(2, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.3f'));
        set(hstr(1,2), 'String', num2str(0.00,'%.3f'));
        
        % Update amplitude plots
        hold on
        handles.hpmin = plot(axesdetect, handles.reader.mep_pmin(id,1),...
            handles.reader.mep_pmin(id,2), 'xr', 'MarkerSize', 15, 'LineWidth', 2);
        handles.hpmax = plot(axesdetect, handles.reader.mep_pmax(id,1),...
            handles.reader.mep_pmax(id,2), 'xr', 'MarkerSize', 15, 'LineWidth', 2);
        hold off
end
        