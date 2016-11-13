
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


function handles = callback_detect_emf(handles, id_pb)
%BUTTONS_CALLBACK_EMF Summary of this function goes here
%   Detailed explanation goes here

handles = pb_detect_callback(handles, id_pb);

function handles = pb_detect_callback(handles, id_pb)

axesdetect = handles.axesdetect;
id = handles.id_cond;
info_text = handles.info_text;
yl = get(axesdetect, 'YLim');
xl = get(axesdetect, 'XLim');

%tstart = handles.reader.tstart(id);

switch id_pb
    case 1
        
        hstr = handles.hstr(id_pb, :);
        
        % ---- Delete previous plots
        if isfield(handles,'hpzero')
            if ishandle(handles.hpzero)
                delete(handles.hpzero)
                delete(handles.hpmax)
            end
        end
        % ----
        
        % ---- Pulse zero
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the zero point and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.3f'));
        handles.hpzero = plot(axesdetect, [xl(1) xl(2)], [y(1) y(1)], 'g',...
            'MarkerSize', 15, 'LineWidth', 2);
        
        % ---- Pulse maximum
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
        
        % Update Pulse amplitudes, minimum and maximum peaks
       % handles.reader.mep_amp(id) = y(2) - y(1);
        handles.reader.pzero(id) = y(1);
        handles.reader.pmax(id) = y(2);
        
    case 2
        
        hstr = handles.hstr(id_pb, :);
        
        % ---- Delete previous plots
        if isfield(handles,'htonset')
            if ishandle(handles.htonset)
                delete(handles.htonset)
            end
        end
        % ----
        
        % ---- Onset start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the Pulse Start and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        tonset = x(1);
        
        pulse_onset = handles.reader.pmax_t(handles.id_cond) - tonset;
        
        set(hstr(1,1), 'String', num2str(pulse_onset*10^6,'%.3f'));
        handles.htstart = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)], 'm',...
            'MarkerSize', 15, 'LineWidth', 2);
        set(hstr(1,2), 'String', 'us');
%         handles.htonset = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)], 'm',...
%             'MarkerSize', 15, 'LineWidth', 2);
%         
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update MEPs duration, start and end instants
        %handles.reader.mep_dur(id) = x(2) - x(1);
        handles.reader.onset(id) = pulse_onset;
        handles.reader.tonset(id) = tonset;
        
        
        
    case 3
        
        hstr = handles.hstr(id_pb, :);
        
        % ---- Delete previous plots
        if isfield(handles,'htduration')
            if ishandle(handles.htduration)
                delete(handles.htduration)
            end
        end
      
        
        % ---- Duration end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the Duration end and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        tduration = x(1);
        
        handles.duration = x(1) - handles.reader.tonset(id);
        
        set(hstr(1,1), 'String', num2str(handles.duration,'%.3f'));
        set(hstr(1,2), 'String', 'us');
        hold on
        
        handles.htduration = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)], 'm',...
            'MarkerSize', 15, 'LineWidth', 2,'Color','r');
        
        hold off
        
        
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update Pulse duration, start and end instants
        
        handles.reader.tduration(id) = tduration;
        %handles.reader.duration(id) = handles.reader.duration(id);
       
        
    case 4
        
        
        % ---- Delete previous plots
        if isfield(handles,'hpzero')
            if ishandle(handles.hpzero)
                delete(handles.hpzero)
                delete(handles.hpmax)
            end
        end
        
         % ---- Delete previous plots
        if isfield(handles,'htduration')
            if ishandle(handles.htduration)
                delete(handles.htduration)
               % delete(handles.htonset)
            end
        end
        
        % Update Pulse amplitudes, zero and maximum peaks
        %handles.reader.mep_amp(id) = 0;
        handles.reader.pzero(id) = 0;
        handles.reader.pmax(id) = 0;
        
        % Update Pulse Start, Onset and Duration
        handles.reader.tstart(id) = 0;
        handles.reader.tonset(id) = 0;
        handles.reader.tduration(id) = 0;
        
        % Update strings
        hstr = handles.hstr(1, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.3f'));
        set(hstr(1,2), 'String', num2str(0.00,'%.3f'));
        
        hstr = handles.hstr(2, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.3f'));
        set(hstr(1,2), 'String', 'us');
        
        hstr = handles.hstr(3, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.3f'));
        set(hstr(1,2), 'String', 'us');
        
    case 5
        
        % ---- Delete previous plots
        if isfield(handles,'hpzero')
            if ishandle(handles.hpzero)
                delete(handles.hpzero)
                delete(handles.hpmax)
            end
        end
        
        % ---- Delete previous plots
        if isfield(handles,'htonset')
            if ishandle(handles.htonset)
                delete(handles.htonset)
                delete(handles.htduration)
            end
        end
        
        % Update pulse zero and maximum amplitudes
        %handles.reader.mep_amp(id) = handles.reader.mep_amp_bkp(id);
        handles.reader.pzero(id) = handles.reader.pzero_bkp(id);
        handles.reader.pmax(id) = handles.reader.pmax_bkp(id);
        
        % Update Pulse Start, Onset and Duration
        handles.reader.tonset(id) = handles.reader.tonset_bkp(id);
        handles.reader.tduration(id) = handles.reader.tduration_bkp(id);
        
        handles.reader.onset(id) = (handles.reader.tonset(id) - ...
                                    handles.reader.tstart(id))*10^6;
                                
        handles.reader.duration(id) = (handles.reader.tduration(id) - ...
                                    handles.reader.tstart(id))*10^6;
        
        % Update strings
        hstr = handles.hstr(1, :);
        set(hstr(1,1), 'String', num2str(handles.reader.pzero(id),'%.3f'));
        set(hstr(1,2), 'String', num2str(handles.reader.pmax(id),'%.3f'));
        
        hstr = handles.hstr(2, :);
        set(hstr(1,1), 'String', num2str(handles.reader.onset(id),'%.3f'));
        set(hstr(1,2), 'String', 'us');
        
        hstr = handles.hstr(3, :);
        set(hstr(1,1), 'String', num2str(handles.reader.duration(id),'%.3f'));
        set(hstr(1,2), 'String', 'us');
       
        
        % Update amplitude plots
        hold on
        handles.hpzero = plot(axesdetect, ...
             handles.reader.tstart(id),handles.reader.pzero(id), 'xr', 'MarkerSize', 15, 'LineWidth', 2);
        handles.hpmax = plot(axesdetect, handles.reader.tonset(id), handles.reader.pmax(id),...
            'xr', 'MarkerSize', 15, 'LineWidth', 2);
        
        hold off
end