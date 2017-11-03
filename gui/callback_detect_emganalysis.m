
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


function handles = callback_detect_emganalysis(handles, id_pb)
%BUTTONS_CALLBACK_EMGANALYSIS Summary of this function goes here
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
        if isfield(handles,'hpmax')
            if ishandle(handles.hpmax)
%                 delete(handles.hpmin)
                delete(handles.hpmax)
            end
        end
        % ----
        
        % ---- EMG minimum
        hold on
        
        % Show information text to guide user to press enter button.
%         set(info_text, 'BackgroundColor', [1 1 0.5], ...
%             'String', 'Select the negative peak and click ENTER');
%         [x(1), y(1)] = getpts(axesdetect);
%         set(hstr(1,1), 'String', num2str(y(1),'%.3f'));
%         handles.hpmin = plot(axesdetect, [xl(1) xl(2)], [y(1) y(1)], 'g',...
%             'MarkerSize', 15, 'LineWidth', 2);
        
        % ---- EMG maximum
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the desired amplitude and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(1),'%.3f'));
        handles.hpmax = plot(axesdetect, [xl(1) xl(2)], [y(1) y(1)], 'g',...
            'MarkerSize', 15, 'LineWidth', 2);
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update EMGs amplitudes, minimum and maximum peaks
%         handles.reader.emg_amp(id) = y(2) - y(1);
%         handles.reader.emg_pmin(id, :) = [x(1), y(1)];
        handles.processed.pmax_I(id) = round(handles.reader.fs*x(1));
        handles.processed.amp_max(id) = y(1);
        
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
        
        % ---- EMG start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the EMG start and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.3f'));
        handles.hlat = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)], 'm',...
            'MarkerSize', 15, 'LineWidth', 2);
        
        % ---- EMG end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the EMG end and click ENTER');
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.3f'));
        handles.hend = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)], 'm',...
            'MarkerSize', 15, 'LineWidth', 2);
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update EMGs duration, start and end instants
%         handles.reader.emg_dur(id) = x(2) - x(1);
        fs = handles.reader.fs;
        signal = handles.reader.signal(:, id);
        
        emg_start_I = round(fs*x(1));
        emg_end_I = round(fs*x(2));
        
        [fmed, rms, fmean]= fmed_rms(signal(emg_start_I:emg_end_I-1), fs, emg_end_I-emg_start_I);

        handles.processed.emg_start_I(id) = emg_start_I;
        handles.processed.emg_end_I(id) = emg_end_I;
        handles.processed.emg_start(id) = x(1);
        handles.processed.emg_end(id) = x(2);
        
        handles.processed.fmed(id) = fmed;
        handles.processed.fmean(id) = fmean;
        handles.processed.rms(id) = rms;
        
    case 3
        
        % ---- Delete previous plots
        if isfield(handles,'hpmax')
            if ishandle(handles.hpmax)
%                 delete(handles.hpmin)
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
        
        % Update EMGs amplitudes, minimum and maximum peaks
%         handles.processed.emg_amp(id) = 0;
        handles.processed.pmax_I(id) = 1;
        handles.processed.amp_max(id) = 0;
        
        % Update EMGs duration, start and end instants
%         handles.processed.emg_dur(id) = 0;
        handles.processed.emg_start_I(id) = 1;
        handles.processed.emg_end_I(id) = 2;
        handles.processed.emg_start(id) = 0;
        handles.processed.emg_end(id) = 0;
        
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
            if ishandle(handles.hpmax)
                delete(handles.hpmax)
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
        
        % Update EMGs amplitudes, minimum and maximum peaks
        handles.processed.pmax_I(id) = handles.processed.pmax_I_bkp(id);
        handles.processed.amp_max(id) = handles.processed.amp_max_bkp(id);
        
        % Update EMGs duration, start and end instants
        handles.processed.emg_start_I(id) = handles.processed.emg_start_I_bkp(id);
        handles.processed.emg_end_I(id) = handles.processed.emg_end_I_bkp(id);
        handles.processed.emg_start(id) = handles.processed.emg_start_bkp(id);
        handles.processed.emg_end(id) = handles.processed.emg_end_bkp(id);
        
        % Update strings
        hstr = handles.hstr(1, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.3f'));
        set(hstr(1,2), 'String', num2str(handles.processed.amp_max(id),'%.3f'));
        
        hstr = handles.hstr(2, :);
        set(hstr(1,1), 'String', num2str(handles.processed.emg_start(id),'%.3f'));
        set(hstr(1,2), 'String', num2str(handles.processed.emg_end(id),'%.3f'));
        
        % Update amplitude plots
        xs = handles.reader.xs;
        amp = [handles.processed.pmax_I(id) handles.processed.amp_max(id)];
        lat = [handles.processed.emg_start(id) handles.processed.emg_end(id)];
        yl = get(axesdetect, 'YLim');
        
        hold on
        handles.hpmax = plot(axesdetect, [xs(amp(1)-round(0.03*amp(1))) xs(amp(1)+round(0.03*amp(1)))],...
            [amp(2) amp(2)], 'MarkerSize', 15,...
            'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560]);
        handles.hlat = plot(axesdetect, [lat(1) lat(1)], [yl(1) yl(2)], '--',...
            'MarkerSize', 15, 'LineWidth', 2, 'Color', [0.4660 0.6740 0.1880]);
        handles.hend = plot(axesdetect, [lat(2) lat(2)], [yl(1) yl(2)], '--',...
        'MarkerSize', 15, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840]);
        hold off
end
        