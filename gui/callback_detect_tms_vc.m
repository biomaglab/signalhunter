
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


function handles = callback_detect_tms_vc(handles, id, id_pb)
%CALLBACK_DETECT_TMS_VC Summary of this function goes here
%   Detailed explanation goes here
input = '(handles, id_pb, id)';
handles = eval(['pb_mod' int2str(id) input]);

function handles = pb_mod1(handles, id_pb, id)

axesdetect = handles.axesdetect;
id_mod = handles.id_mod(handles.id_cond);
pb_name = handles.pb_names{id_mod}(id_pb);
id_axes = handles.id_axes - (11*(handles.id_cond-1)+handles.id_cond);
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);
isi = handles.processed.signal.isi;
dt = 0.5; % length of selection line display

switch id_pb
    case 1
        
        % ---- Delete previous plots
        if isfield(handles,'hcontrac_start')
            if ishandle(handles.hcontrac_start)
                delete(handles.hcontrac_start)
                delete(handles.hcontrac_end)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- Contraction start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hcontrac_start = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');
        
        % ---- Contraction end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hcontrac_end = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update contraction start and end
        handles.processed.vol_contrac_start(id_axes) = round(x(1)*1/(isi*10^-3));
        handles.processed.vol_contrac_end(id_axes) = round(x(2)*1/(isi*10^-3));
        
    case 2
        data = handles.processed.signal.data;
        % ---- Delete previous plots
        if isfield(handles,'hmax_B')
            if ishandle(handles.hmax_B)
                delete(handles.hmax_B)
                delete(handles.hmax_C)
            end
        end
        % ----
        
        % ---- Minimum voluntary contraction
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.2f'));
        handles.hmax_B = plot(axesdetect, [x(1)-dt x(1)+dt], [y(1) y(1)],'r');
        
        % ---- Maximum voluntary contraction
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
        handles.hmax_C = plot(axesdetect, [x(2)-dt x(2)+dt], [y(2) y(2)],'g');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum voluntary contraction force
        handles.processed.max_B_I(id_axes) = round(x(1)*1/(isi*10^-3));
        handles.processed.max_C_I(id_axes) = round(x(2)*1/(isi*10^-3));
        handles.processed.max_B(id_axes) = y(1);
        handles.processed.max_C(id_axes) = y(2);
        % ---
        
        % Update RMS value
        work_zone(:,1) = handles.processed.max_C_I-(1/(isi*10^-3))/4;
        work_zone(:,2) = handles.processed.max_C_I+(1/(isi*10^-3))/4;
        if id_axes > 1
            for i=1:1:4
                handles.processed.RMS(i,id_axes) = mean(data(round(work_zone(i,1)):round(work_zone(i,2)),id_axes+4));
            end
        end
        % ---
        
    case 3
        
        % ---- Delete previous plots
        if isfield(handles,'hsup_force_min')
            if ishandle(handles.hsup_force_min)
                delete(handles.hsup_force_min)
                delete(handles.hsup_force_max)
            end
        end
        % ----
        
        % ---- Minimum superimposed force
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.2f'));
        handles.hsup_force_min = plot(axesdetect, [x(1)-dt x(1)+dt], [y(1) y(1)],'k');
        
        % ---- Maximum superimposed force
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
        handles.hsup_force_max = plot(axesdetect, [x(2)-dt x(2)+dt], [y(2) y(2)],'k');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum superimposed force
        handles.processed.superimposed_B_I(id_axes) = round(x(1)*1/(isi*10^-3));
        handles.processed.superimposed_F_I(id_axes) = round(x(2)*1/(isi*10^-3));
        handles.processed.superimposed_B(id_axes) = y(1);
        handles.processed.superimposed_F(id_axes) = y(2);
        
    case 4
        if id_axes == 1
            errordlg('This force plateau does not have neurostimulation.');
        else
            
            % ---- Delete previous plots
            if isfield(handles,'hneurostim_min')
                if ishandle(handles.hneurostim_min)
                    delete(handles.hneurostim_min)
                    delete(handles.hneurostim_max)
                end
            end
            % ----
            
            % ---- Minimum neurostimulation force
            hold on
            
            % Show information text to guide user to press enter button.
            set(info_text, 'BackgroundColor', [1 1 0.5], ...
                'String', ['Select the minimum ' pb_name ' and click ENTER']);
            [x(1), y(1)] = getpts(axesdetect);
            set(hstr(1,1), 'String', num2str(y(1),'%.2f'));
            handles.hneurostim_min = plot(axesdetect, [x(1)-dt x(1)+dt], [y(1) y(1)],'--g');
            
            % ---- Maximum neurostimulation force
            set(info_text, 'BackgroundColor', [1 1 0.5], ...
                'String', ['Select the maximum ' pb_name ' and click ENTER']);
            [x(2), y(2)] = getpts(axesdetect);
            set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
            handles.hneurostim_max = plot(axesdetect, [x(2)-dt x(2)+dt], [y(2) y(2)],'--g');
            
            hold off
            % ----
            
            % Remove information text to guide user to press enter button.
            set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
            
            % Update minimum and maximum neurostimulation force
            handles.processed.contrac_neurostim_min_I(id_axes) = round(x(1)*1/(isi*10^-3));
            handles.processed.contrac_neurostim_max_I(id_axes) = round(x(2)*1/(isi*10^-3));
            handles.processed.contrac_neurostim_min(id_axes) = y(1);
            handles.processed.contrac_neurostim_max(id_axes) = y(2);
        end
        
end

function handles = pb_mod2(handles, id_pb, id)

axesdetect = handles.axesdetect;
processed = handles.processed;
id_mod = handles.id_mod(handles.id_cond);
pb_name = handles.pb_names{id_mod}(id_pb);
id_axes = handles.id_axes - 13;
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);
isi = processed.signal.isi;
data = processed.signal.data;
dt = 0.1; % length of selection line display

stim_contrac_start_p = processed.stim_contrac_start_p;
stim_contrac_end = processed.stim_contrac_end;
neurostim_max = processed.neurostim_max;
neurostim_max_I = processed.neurostim_max_I;
HRT_abs = processed.HRT_abs;


switch id_pb
    case 1
        % push button for neurostim contraction time selection
        % ---- Delete previous plots
        if isfield(handles,'hstim_contrac_start')
            if ishandle(handles.hstim_contrac_start)
                delete(handles.hstim_contrac_start);
                delete(handles.hstim_contrac_end);
                delete(handles.htime_peak);
                delete(handles.hneurostim_max);
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        hold on
        
        % ---- Contraction start
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hstim_contrac_start = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');
        
        % ---- Contraction end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hstim_contrac_end = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update contraction start and end
        stim_contrac_start_p(id_axes) = round(x(1)*1/(isi*10^-3));
        stim_contrac_end(id_axes) = round(x(2)*1/(isi*10^-3));
        handles.processed.stim_contrac_start_p(id_axes) = stim_contrac_start_p(id_axes);
        handles.processed.stim_contrac_end(id_axes) = stim_contrac_end(id_axes);
        
        % Update plots that are connected to the start and end of
        % neurostim contraction
        % plot of maximum neurostim contraction intensity
        handles.hneurostim_max = plot(axesdetect, [x(1) x(2)],...
            [neurostim_max(id_axes) neurostim_max(id_axes)],'k');
        % plot of timeline from neurostim start to maximum neurostim activity
        handles.htime_peak = plot(axesdetect, [x(1) neurostim_max_I(id_axes)* isi*10^-3],...
            [mean(data(stim_contrac_start_p(id_axes):stim_contrac_end(id_axes),1)) mean(data(stim_contrac_start_p(id_axes):stim_contrac_end(id_axes),1))],'k');
        
        hold off
        
    case 2
        % push button for neurostim contraction selection
        % ---- Delete previous plots
        if isfield(handles,'hneurostim_max')
            if ishandle(handles.hneurostim_max)
                delete(handles.hneurostim_max)
                delete(handles.hneurostim_B)
                delete(handles.hneurostim_max_I)
                delete(handles.htime_peak);
                delete(handles.hHRT_abs);
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        hold on
        % ---- Minimum voluntary contraction
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.2f'));
        handles.hneurostim_B = plot(axesdetect, [x(1)-dt x(1)+dt],...
            [y(1) y(1)],'r');
        
        % ---- Maximum voluntary contraction
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
        handles.hneurostim_max = plot(axesdetect, [stim_contrac_start_p(id_axes)* isi*10^-3 stim_contrac_end(id_axes)* isi*10^-3],...
            [y(2) y(2)],'g');
        handles.hneurostim_max_I = plot(axesdetect, [x(2) x(2)],...
            [yl(1) y(2)],'k--');
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum, maximum and HRT neurostim contraction force
        neurostim_max_I(id_axes) = round(x(2)*1/(isi*10^-3));
        HRT_y = (y(2)-y(1))/2 + y(1);
        HRT(id_axes) = find(data(neurostim_max_I(id_axes):stim_contrac_end(id_axes) + 1/(isi*10^-3),1) < HRT_y, 1);
        HRT_abs(id_axes) = HRT(id_axes) + neurostim_max_I(id_axes);
        
        handles.processed.neurostim_B(id_axes) = y(1);
        handles.processed.neurostim_max(id_axes) = y(2);
        handles.processed.neurostim_max_I(id_axes) = neurostim_max_I(id_axes);
        handles.processed.HRT_abs(id_axes) = HRT_abs(id_axes);
        
        % Update plots that are connected to the maximum and minimum
        % neurostim contraction
        % plot of timeline from maxium peak to half neurostim activity
        handles.hHRT_abs = plot(axesdetect, [x(2) HRT_abs(id_axes)* isi*10^-3],...
            [HRT_y HRT_y],'k');
        % plot of timeline from neurostim start to maximum neurostim activity
        mean_contrac = mean(data(stim_contrac_start_p(id_axes):stim_contrac_end(id_axes),1));
        if mean_contrac > y(2)
           mean_contrac = HRT_y; 
        end
        handles.htime_peak = plot(axesdetect, [stim_contrac_start_p(id_axes)* isi*10^-3 x(2)],...
            [mean_contrac mean_contrac],'k');
        
        hold off
end

function handles = pb_mod3(handles, id_pb, id)

axesdetect = handles.axesdetect;
processed = handles.processed;
id_mod = handles.id_mod(handles.id_cond);
pb_name = handles.pb_names{id_mod}(id_pb);
id_axes = handles.id_axes - (11*(handles.id_cond-1)+(handles.id_cond-1));
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);
isi = processed.signal.isi;
k = handles.id_cond - 1;


switch id_pb
    case 1
        
        % ---- Delete previous plots
        if isfield(handles,'hM_wave_start_I')
            if ishandle(handles.hM_wave_start_I)
                delete(handles.hM_wave_start_I)
                delete(handles.hM_wave_end_I)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- Contraction start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hM_wave_start_I = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');
        
        % ---- Contraction end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hM_wave_end_I = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update contraction start and end
        handles.processed.M_wave_start_I(id_axes,k) = round(x(1)*1/(isi*10^-3));
        handles.processed.M_wave_end_I(id_axes,k) = round(x(2)*1/(isi*10^-3));
        
    case 2
        
        % ---- Delete previous plots
        if isfield(handles,'hmax_M_wave_I')
            if ishandle(handles.hmax_M_wave_I)
                delete(handles.hmax_M_wave_I)
                delete(handles.hmin_M_wave_I)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- Minimum voluntary contraction
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.2f'));
        handles.hmin_M_wave_I = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'--m');
        
        % ---- Maximum voluntary contraction
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
        handles.hmax_M_wave_I = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'--k');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum M-wave contraction force
        handles.processed.min_M_wave_I(id_axes,k) = round(x(1)*1/(isi*10^-3));
        handles.processed.max_M_wave_I(id_axes,k) = round(x(2)*1/(isi*10^-3));
        
end

function handles = pb_mod4(handles, id_pb, id)

axesdetect = handles.axesdetect;
processed = handles.processed;
id_mod = handles.id_mod(handles.id_cond);
pb_name = handles.pb_names{id_mod}(id_pb);
id_axes = handles.id_axes - (11*(handles.id_cond-1)+(handles.id_cond-1));
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);
isi = processed.signal.isi;
k = handles.id_cond - 4;

switch id_pb
    case 1
        
        % ---- Delete previous plots
        if isfield(handles,'hM_wave_ex_start_I')
            if ishandle(handles.hM_wave_ex_start_I)
                delete(handles.hM_wave_ex_start_I)
                delete(handles.hM_wave_ex_end_I)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- Contraction start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hM_wave_ex_start_I = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');
        
        % ---- Contraction end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hM_wave_ex_end_I = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update contraction start and end
        handles.processed.M_wave_ex_start_I(id_axes,k) = round(x(1)*1/(isi*10^-3));
        handles.processed.M_wave_ex_end_I(id_axes,k) = round(x(2)*1/(isi*10^-3));
        
    case 2
        
        % ---- Delete previous plots
        if isfield(handles,'hM_wave_ex_max_I')
            if ishandle(handles.hM_wave_ex_max_I)
                delete(handles.hM_wave_ex_max_I)
                delete(handles.hM_wave_ex_min_I)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- Minimum voluntary contraction
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.2f'));
        handles.hM_wave_ex_min_I = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'--m');
        
        % ---- Maximum voluntary contraction
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
        handles.hM_wave_ex_max_I = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'--k');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum M-wave exercise contraction force
        handles.processed.M_wave_ex_min_I(id_axes,k) = round(x(1)*1/(isi*10^-3));
        handles.processed.M_wave_ex_max_I(id_axes,k) = round(x(2)*1/(isi*10^-3));
        
end

function handles = pb_mod5(handles, id_pb, id)

axesdetect = handles.axesdetect;
processed = handles.processed;
id_mod = handles.id_mod(handles.id_cond);
pb_name = handles.pb_names{id_mod}(id_pb);
id_axes = handles.id_axes - (11*(handles.id_cond-1)+(handles.id_cond));
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);
isi = processed.signal.isi;
k = handles.id_cond - 7;

switch id_pb
    case 1
        
        % ---- Delete previous plots
        if isfield(handles,'hM_wave_MEP_start_I')
            if ishandle(handles.hM_wave_MEP_start_I)
                delete(handles.hM_wave_MEP_start_I)
                delete(handles.hM_wave_MEP_end_I)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- Contraction start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hM_wave_MEP_start_I = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');
        
        % ---- Contraction end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hM_wave_MEP_end_I = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update contraction start and end
        handles.processed.M_wave_MEP_start_I(id_axes,k) = round(x(1)*1/(isi*10^-3));
        handles.processed.M_wave_MEP_end_I(id_axes,k) = round(x(2)*1/(isi*10^-3));
        
    case 2
        
        % ---- Delete previous plots
        if isfield(handles,'hM_wave_MEP_max_I')
            if ishandle(handles.hM_wave_MEP_max_I)
                delete(handles.hM_wave_MEP_max_I)
                delete(handles.hM_wave_MEP_min_I)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- Minimum voluntary contraction
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hM_wave_MEP_min_I = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'--m');
        
        % ---- Maximum voluntary contraction
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hM_wave_MEP_max_I = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'--k');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum M-wave exercise contraction force
        handles.processed.M_wave_MEP_min_I(id_axes,k) = round(x(1)*1/(isi*10^-3));
        handles.processed.M_wave_MEP_max_I(id_axes,k) = round(x(2)*1/(isi*10^-3));
        
    case 3
        
        % ---- Delete previous plot
        if isfield(handles,'hEMG_recov_point')
            if ishandle(handles.hEMG_recov_point)
                delete(handles.hEMG_recov_point)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- EMG recovery point after TMS
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the EMG recovery point and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hEMG_recov_point = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'y');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum M-wave exercise contraction force
        handles.processed.EMG_recov_point(id_axes,k) = round(x(1)*1/(isi*10^-3));
        
    case 4
        
        % ---- Delete previous plot
        if isfield(handles,'hTMS_stim')
            if ishandle(handles.hTMS_stim)
                delete(handles.hTMS_stim)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- EMG recovery point after TMS
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the TMS stimulus point and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hTMS_stim = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'c');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum M-wave exercise contraction force
        handles.processed.TMS_stim(id_axes) = round(x(1)*1/(isi*10^-3));
        
end

function handles = pb_mod6(handles, id_pb, id)

axesdetect = handles.axesdetect;
processed = handles.processed;
pb_name = handles.pb_names{id}(id_pb);
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);

contrac_start = processed.contrac_start;
contrac_end = processed.contrac_end;
baseline = processed.baseline;
signal = processed.signal;
data = signal.data;
isi = signal.isi;
Time = signal.time;

switch id_pb
    case 1
        % push button for neurostim contraction time selection
        % ---- Delete previous plots
        if isfield(handles,'hcontrac_start')
            if ishandle(handles.hcontrac_start)
                delete(handles.hcontrac_start);
                delete(handles.hcontrac_end);
                delete(handles.hHRT);
                delete(handles.hstart_dashed);
                delete(handles.hHRT_dashed);
                delete(handles.hTwitch);
                delete(handles.hTwitch_dashed);
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        hold on
        
        % ---- Contraction start
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hcontrac_start = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');
        
        % ---- Contraction end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hcontrac_end = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update contraction start and end
        contrac_start(1) = round(x(1)*1/(isi*10^-3));
        contrac_end(1) = round(x(2)*1/(isi*10^-3));
                
        [Twitch_y, Twitch_x] = max(data(contrac_start(1):contrac_end(1)));
        Twitch_x = Twitch_x + contrac_start(1);
        HRT = find(data(Twitch_x:contrac_end(1)) < (Twitch_y-baseline)/2+baseline ,1);
        HRT = HRT + Twitch_x;
        
        % Update plots that are connected to the start and end of
        % neurostim contraction
        handles.hTwitch = plot(axesdetect, [Time(Twitch_x-200) Time(Twitch_x+200)],[Twitch_y Twitch_y],'r');
        handles.hTwitch_dashed = plot(axesdetect, [Time(Twitch_x) Time(Twitch_x)],[yl(1) yl(2)],'--k');
        handles.hHRT = plot(axesdetect, [Time(HRT) Time(HRT)],[yl(1) yl(2)],'m');
        handles.hstart_dashed = plot(axesdetect, [Time(contrac_start(1)) Time(Twitch_x)],[(yl(2)-yl(1))/2+yl(1)+5 (yl(2)-yl(1))/2+yl(1)+5],'--k');
        handles.hHRT_dashed = plot(axesdetect, [Time(Twitch_x) Time(HRT)],[(yl(2)-yl(1))/2+yl(1) (yl(2)-yl(1))/2+yl(1)],'--k');
        
        % Update global values
        handles.processed.contrac_start(1) = contrac_start(1);
        handles.processed.contrac_end(1) = contrac_end(1);
        handles.processed.HRT = HRT;
        handles.processed.Twitch_x = Twitch_x;
        handles.processed.Twitch_y = Twitch_y;
        
        hold off
        
    case 2
        % push button for neurostim contraction selection
        % ---- Delete previous plots
        if isfield(handles,'hTwitch')
            if ishandle(handles.hTwitch)
                delete(handles.hTwitch)
                delete(handles.hTwitch_dashed)
                delete(handles.hbaseline)
                delete(handles.hstart_dashed);
                delete(handles.hHRT_dashed);
                delete(handles.hHRT);
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        hold on
        % ---- Minimum voluntary contraction
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.2f'));
        handles.hbaseline = plot(axesdetect, [x(1)-0.05 x(1)+0.05],...
            [y(1) y(1)],'r');
        
        % ---- Maximum voluntary contraction
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
        handles.hTwitch = plot(axesdetect, [x(2)-0.05 x(2)+0.05],...
            [y(2) y(2)],'g');
        handles.hTwitch_dashed = plot(axesdetect, [x(2) x(2)],...
            [yl(1) y(2)],'k--');
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum, maximum and HRT neurostim contraction force
        baseline = y(1);
        Twitch_x = round(x(2)*1/(isi*10^-3));
        Twitch_y = y(2);
        HRT = find(data(Twitch_x:contrac_end(1)) < (Twitch_y-baseline)/2+baseline ,1);
        HRT = HRT + Twitch_x;
        
        % Update plots that are connected to the start and end of
        % neurostim contraction
        handles.hTwitch_dashed = plot(axesdetect, [Time(Twitch_x) Time(Twitch_x)],[yl(1) yl(2)],'--k');
        handles.hHRT = plot(axesdetect, [Time(HRT) Time(HRT)],[yl(1) yl(2)],'m');
        handles.hstart_dashed = plot(axesdetect, [Time(contrac_start(1)) Time(Twitch_x)],[(yl(2)-yl(1))/2+yl(1)+5 (yl(2)-yl(1))/2+yl(1)+5],'--k');
        handles.hHRT_dashed = plot(axesdetect, [Time(Twitch_x) Time(HRT)],[(yl(2)-yl(1))/2+yl(1) (yl(2)-yl(1))/2+yl(1)],'--k');
        
        % Update global values
        handles.processed.HRT = HRT;
        handles.processed.Twitch_x = Twitch_x;
        handles.processed.Twitch_y = Twitch_y;
        handles.processed.baseline = baseline;
        
        hold off
end

function handles = pb_mod7(handles, id_pb, id)

axesdetect = handles.axesdetect;
pb_name = handles.pb_names{id}(id_pb);
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);
k = handles.id_axes - 6;

processed = handles.processed;
M_wave_min = processed.M_wave_min;
M_wave_max = processed.M_wave_max;
M_wave_ex_start_I = processed.M_wave_ex_start_I;
M_wave_ex_end_I = processed.M_wave_ex_end_I;
M_wave_ex_min_I = processed.M_wave_ex_min_I;
M_wave_ex_max_I = processed.M_wave_ex_max_I;
M_wave_area = processed.M_wave_area;
M_wave_area_2 = processed.M_wave_area_2;
isi = processed.signal.isi;
fs = 1/(isi*10^-3);
data = processed.signal.data;

switch id_pb
    case 1
        
        % ---- Delete previous plots
        if isfield(handles,'hM_wave_ex_start_I')
            if ishandle(handles.hM_wave_ex_start_I)
                delete(handles.hM_wave_ex_start_I)
                delete(handles.hM_wave_ex_end_I)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- Contraction start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hM_wave_ex_start_I = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');
        
        % ---- Contraction end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hM_wave_ex_end_I = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update contraction start and end
        M_wave_ex_start_I(k+1) = round(x(1)*1/(isi*10^-3));
        M_wave_ex_end_I(k+1) = round(x(2)*1/(isi*10^-3));
           
        M_wave_amp = M_wave_max-M_wave_min;
        M_wave_duration = abs(M_wave_ex_min_I-M_wave_ex_max_I);
        
        M_wave_area_2(k) = trapz_perso(abs(data(M_wave_ex_start_I(k+1):M_wave_ex_end_I(k+1),k+1)), fs);
        
        handles.processed.M_wave_ex_start_I = M_wave_ex_start_I;
        handles.processed.M_wave_ex_end_I = M_wave_ex_end_I;
        handles.processed.M_wave_area_2 = M_wave_area_2;
        handles.processed.M_wave_amp = M_wave_amp;
        handles.processed.M_wave_duration = M_wave_duration;
        
    case 2
        
        % ---- Delete previous plots
        if isfield(handles,'hM_wave_ex_max_I')
            if ishandle(handles.hM_wave_ex_max_I)
                delete(handles.hM_wave_ex_max_I)
                delete(handles.hM_wave_ex_min_I)
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- Minimum voluntary contraction
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.2f'));
        handles.hM_wave_ex_min_I = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'--m');
        
        % ---- Maximum voluntary contraction
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
        handles.hM_wave_ex_max_I = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'--k');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum M-wave exercise contraction force
        M_wave_ex_min_I(k+1) = round(x(1)*1/(isi*10^-3));
        M_wave_ex_max_I(k+1) = round(x(2)*1/(isi*10^-3));
        M_wave_min(k+1) = y(1);
        M_wave_max(k+1) = y(2);
        
        M_wave_amp = M_wave_max-M_wave_min;
        M_wave_duration = abs(M_wave_ex_min_I-M_wave_ex_max_I);
                
        M_wave_area(k) = trapz_perso(abs(data(M_wave_ex_max_I(k+1):M_wave_ex_min_I(k+1),k+1)), fs);
        
        handles.processed.M_wave_ex_min_I = M_wave_ex_min_I;
        handles.processed.M_wave_ex_max_I = M_wave_ex_max_I;
        handles.processed.M_wave_min = M_wave_min;
        handles.processed.M_wave_max = M_wave_max;
        handles.processed.M_wave_area = M_wave_area;
        handles.processed.M_wave_amp = M_wave_amp;
        handles.processed.M_wave_duration = M_wave_duration;
        
end

function handles = pb_mod10(handles, id_pb, id)

axesdetect = handles.axesdetect;
pb_name = handles.pb_names{id}(id_pb);
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);
dt = 0.5; % length of selection line display

processed = handles.processed;
contrac_max_I = processed.contrac_max_I;
contrac_max = processed.contrac_max;
contrac_start = processed.contrac_start;
contrac_end = processed.contrac_end;

isi = processed.signal.isi;
Time = processed.signal.time;
data = processed.signal.data;

switch id_pb
    case {1, 3}
        if id_pb == 1
            j = 2;
        else
            j = 3;
        end
        
        % ---- Delete previous plots
        if isfield(handles,'hcontrac_start_I')
            if ishandle(handles.hcontrac_start_I(j))
                delete(handles.hcontrac_start_I(j))
                delete(handles.hcontrac_end_I(j))
                delete(handles.hcontrac_max(j))
            end
        end
        % ----
        
        yl = get(axesdetect, 'YLim');
        
        % ---- Contraction start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the minimum ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hcontrac_start_I(j) = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');
        
        % ---- Contraction end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hcontrac_end_I(j) = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');
        
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update contraction start and end
        contrac_start(j) = round(x(1)*1/(isi*10^-3));
        contrac_end(j) = round(x(2)*1/(isi*10^-3));
        
        % find max
        [maxt, max_It] = max(data(contrac_start(j):contrac_end(j),1));
        contrac_max(j) = maxt;
        contrac_max_I(j) = max_It + contrac_start(j);
        
        handles.hcontrac_max(j) = plot(axesdetect,...
            [Time(contrac_max_I(j)-10000) Time(contrac_max_I(j)+10000)],[contrac_max(j) contrac_max(j)],'m');
        
        hold off
        
        handles.processed.contrac_start = contrac_start;
        handles.processed.contrac_end = contrac_end;
        handles.processed.contrac_max = contrac_max;
        handles.processed.contrac_max_I = contrac_max_I;
        
        
    case {2, 4}

        if id_pb == 2
            j = 2;
        else
            j = 3;
        end
        
        % ---- Delete previous plots
        if isfield(handles,'hcontrac_max')
            if ishandle(handles.hcontrac_max(j))
                delete(handles.hcontrac_max(j))
            end
        end
        % ----
        
        % ---- Minimum voluntary contraction
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the ' pb_name ' and click ENTER']);
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.2f'));
        handles.hcontrac_max(j) = plot(axesdetect, [x(1)-dt x(1)+dt], [y(1) y(1)],'g');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum voluntary contraction force
        handles.processed.contrac_max_I(j) = round(x(1)*1/(isi*10^-3));
        handles.processed.contrac_max(j) = y(1);
        % ---
        

end


function handles = pb_mod11(handles, id_pb, id)
% Mode 1, first graph
% Allow user to change start and end of each contraction

axesdetect = handles.axesdetect;
pb_name = handles.pb_names{id}(id_pb);
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);

isi = handles.processed.signal.isi;

% ---- Delete previous plots
if isfield(handles,'hvol_contrac_start')
    if ishandle(handles.hvol_contrac_start(id_pb))
        delete(handles.hvol_contrac_start(id_pb))
        delete(handles.hvol_contrac_end(id_pb))
    end
end
% ----

yl = get(axesdetect, 'YLim');

% ---- Contraction neurostim instant
hold on

% Show information text to guide user to press enter button.
set(info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', ['Select ' pb_name ' start and click ENTER']);
[x(1), ~] = getpts(axesdetect);
set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
handles.hvol_contrac_start(id_pb) = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');

% ---- Contraction end
set(info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', ['Select ' pb_name ' end and click ENTER']);
[x(2), ~] = getpts(axesdetect);
set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
handles.hvol_contrac_end(id_pb) = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');

% ----

% Remove information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', 'w', 'String', '');

% Update contraction start and end
handles.processed.vol_contrac_start(id_pb) = round(x(1)*1/(isi*10^-3));
handles.processed.vol_contrac_end(id_pb) = round(x(2)*1/(isi*10^-3));

function handles = pb_mod12(handles, id_pb, id)
% Mode 2, second graphic 1
% Allow user to change start and end of each contraction

axesdetect = handles.axesdetect;
pb_name = handles.pb_names{id}(id_pb);
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);

isi = handles.processed.signal.isi;

% ---- Delete previous plots
if isfield(handles,'hvol_contrac_start')
    if ishandle(handles.hstim_contrac_start_p(id_pb))
        delete(handles.hstim_contrac_start_p(id_pb))
        delete(handles.hstim_contrac_end(id_pb))
    end
end
% ----

yl = get(axesdetect, 'YLim');

% ---- Contraction neurostim instant
hold on

% Show information text to guide user to press enter button.
set(info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', ['Select ' pb_name ' start and click ENTER']);
[x(1), ~] = getpts(axesdetect);
set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
handles.hvol_contrac_start(id_pb) = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');

% ---- Contraction end
set(info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', ['Select ' pb_name ' end and click ENTER']);
[x(2), ~] = getpts(axesdetect);
set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
handles.hvol_contrac_end(id_pb) = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');

% ----

% Remove information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', 'w', 'String', '');

% Update contraction start and end
handles.processed.stim_contrac_start_p(id_pb) = round(x(1)*1/(isi*10^-3));
handles.processed.stim_contrac_end(id_pb) = round(x(2)*1/(isi*10^-3));


function handles = pb_mod13(handles, id_pb, id)
% Mode 2, second graphic 1
% Allow user to change start and end of each contraction
% This is disabled beacuse it's not necessary now

axesdetect = handles.axesdetect;
pb_name = handles.pb_names{id}(id_pb);
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);

k = handles.id_cond - 1;

isi = handles.processed.signal.isi;

% ---- Delete previous plots
if isfield(handles,'hM_wave_start_I')
    if ishandle(handles.hM_wave_start_I(id_pb))
        delete(handles.hM_wave_start_I(id_pb))
        delete(handles.hM_wave_end_I(id_pb))
    end
end
% ----

yl = get(axesdetect, 'YLim');

% ---- Contraction neurostim instant
hold on

% Show information text to guide user to press enter button.
set(info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', ['Select ' pb_name ' start and click ENTER']);
[x(1), ~] = getpts(axesdetect);
set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
handles.hM_wave_start_I(id_pb) = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');

% ---- Contraction end
set(info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', ['Select ' pb_name ' end and click ENTER']);
[x(2), ~] = getpts(axesdetect);
set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
handles.hM_wave_end_I(id_pb) = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');

% ----

% Remove information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', 'w', 'String', '');

% Update contraction start and end
handles.processed.M_wave_start_I(id_pb+1,k) = round(x(1)*1/(isi*10^-3));
handles.processed.M_wave_end_I(id_pb+1,k) = round(x(2)*1/(isi*10^-3));


function handles = pb_mod14(handles, id_pb, id)
% Mode 4 and screens 6, 7, 8
% Allow user to change instant of neurostimulation
axesdetect = handles.axesdetect;
pb_name = handles.pb_names{id}(id_pb);
info_text = handles.info_text;
hstr = handles.hstr(id_pb, :);

i = handles.id_cond - 4;

processed = handles.processed;
contrac_neurostim = processed.contrac_neurostim;
M_wave_ex_max_I = processed.M_wave_ex_max_I;
M_wave_ex_min_I = processed.M_wave_ex_min_I;
M_wave_ex_start_I = processed.M_wave_ex_start_I;
M_wave_ex_end_I = processed.M_wave_ex_end_I;
signal = processed.signal;
data = signal.data;
isi = processed.signal.isi;


% ---- Delete previous plots
if isfield(handles,'hcontrac_neurostim')
    if ishandle(handles.hcontrac_neurostim(id_pb))
        delete(handles.hcontrac_neurostim(id_pb))
    end
end
% ----

yl = get(axesdetect, 'YLim');

% ---- Contraction neurostim instant
hold on

% Show information text to guide user to press enter button.
set(info_text, 'BackgroundColor', [1 1 0.5], ...
    'String', ['Select ' pb_name ' start and click ENTER']);
[x(1), ~] = getpts(axesdetect);
set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
handles.hcontrac_neurostim(id_pb) = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');
% ----

% Remove information text to guide user to press enter button.
set(handles.info_text, 'BackgroundColor', 'w', 'String', '');

% Update contraction start and end
contrac_neurostim(id_pb,i) = round(x(1)*1/(isi*10^-3));

% Update the neurostim instant and M_wave properties of three correspondent
% muscles only related to the modified neurostim.
for k=2:1:4
    [~, M_wave_ex_max] = max(data(contrac_neurostim(id_pb,k)+20 : contrac_neurostim(id_pb,k)+2000,k));
    M_wave_ex_max_I(id_pb,k) = M_wave_ex_max + contrac_neurostim(id_pb,k)+20;
    [~, M_wave_ex_min] = min(data(contrac_neurostim(id_pb,k)+20 : contrac_neurostim(id_pb,k)+2000,k));
    M_wave_ex_min_I(id_pb,k) = M_wave_ex_min + contrac_neurostim(id_pb,k)+20;
    
    % find M_wave start for neurostim during exercise
    if M_wave_ex_max_I(id_pb,k) < M_wave_ex_min_I(id_pb,k)
        j=1; diff_dat=1;
        while diff_dat>=0
            diff_dat = data(M_wave_ex_max_I(id_pb,k)-j,k) - data(M_wave_ex_max_I(id_pb,k)-j-1,k);
            j=j+1;
        end
        M_wave_ex_start_I(id_pb,k) = M_wave_ex_max_I(id_pb,k) - j;
        M_wave_ex_start(id_pb,k) = data(M_wave_ex_start_I(id_pb,k),k);
    else
        j=1; diff_dat=1;
        while diff_dat>=0
            diff_dat = data(M_wave_ex_min_I(id_pb,k)-j,k) - data(M_wave_ex_min_I(id_pb,k)-j-1,k);
            j=j+1;
        end
        M_wave_ex_start_I(id_pb,k) = M_wave_ex_min_I(id_pb,k) - j;
        M_wave_ex_start(id_pb,k) = data(M_wave_ex_start_I(id_pb,k),k);
    end
    clearvars diff_dat
    
    % find M-wave end for neurostim during exercise
    j=1;
    while data(M_wave_ex_min_I(id_pb,k) + j,k)<= 0.001 %0.05
        j = j+1;
    end
    win_after = 1000;
    if j > 10 && j < win_after
        M_wave_ex_end_I(id_pb,k) = M_wave_ex_min_I(id_pb,k)+j;
        M_wave_ex_end(id_pb,k) = data(M_wave_ex_min_I(id_pb,k),k);
    else
        [M_wave_endt, M_wave_end_It] = max(data(M_wave_ex_min_I(id_pb,k)+1:M_wave_ex_min_I(id_pb,k) + win_after,k));
        M_wave_ex_end(id_pb,k) = M_wave_endt;
        M_wave_ex_end_I(id_pb,k) = M_wave_end_It + M_wave_ex_min_I(id_pb,k) + 1;
    end
end

handles.processed.contrac_neurostim = contrac_neurostim;
handles.processed.M_wave_ex_max_I = M_wave_ex_max_I;
handles.processed.M_wave_ex_min_I = M_wave_ex_min_I;
handles.processed.M_wave_ex_start_I = M_wave_ex_start_I;
handles.processed.M_wave_ex_end_I = M_wave_ex_end_I;