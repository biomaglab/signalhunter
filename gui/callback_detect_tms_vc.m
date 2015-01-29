function handles = callback_detect_tms_vc(handles, id_pb)
%BUTTONS_CALLBACK_TMS_VC Summary of this function goes here
%   Detailed explanation goes here
input = '(handles, id_pb)';
handles = eval(['pb_mod' int2str(handles.id_mod(handles.id_cond)) input]);

function handles = pb_mod1(handles, id_pb)

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
        handles.hcontract_start = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'r');
        
        % ---- Contraction end
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hcontract_end = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'g');
        
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
        handles.hsup_force_min = plot(axesdetect, [x(1)-dt x(1)+dt], [y(1) y(1)],'r');
        
        % ---- Maximum superimposed force
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
        handles.hsup_force_max = plot(axesdetect, [x(2)-dt x(2)+dt], [y(2) y(2)],'g');
        
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
            handles.hneurostim_min = plot(axesdetect, [x(1)-dt x(1)+dt], [y(1) y(1)],'--k');
            
            % ---- Maximum neurostimulation force
            set(info_text, 'BackgroundColor', [1 1 0.5], ...
                'String', ['Select the maximum ' pb_name ' and click ENTER']);
            [x(2), y(2)] = getpts(axesdetect);
            set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
            handles.hneurostim_max = plot(axesdetect, [x(2)-dt x(2)+dt], [y(2) y(2)],'--m');
            
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

function handles = pb_mod2(handles, id_pb)

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
        handles.htime_peak = plot(axesdetect, [stim_contrac_start_p(id_axes)* isi*10^-3 x(2)],...
            [mean(data(stim_contrac_start_p(id_axes):stim_contrac_end(id_axes),1)) mean(data(stim_contrac_start_p(id_axes):stim_contrac_end(id_axes),1))],'k');
        
        hold off
end

function handles = pb_mod3(handles, id_pb)

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
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hmin_M_wave_I = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'--m');
        
        % ---- Maximum voluntary contraction
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hmax_M_wave_I = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'--k');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum M-wave contraction force
        handles.processed.min_M_wave_I(id_axes,k) = round(x(1)*1/(isi*10^-3));
        handles.processed.max_M_wave_I(id_axes,k) = round(x(2)*1/(isi*10^-3));
        
end

function handles = pb_mod4(handles, id_pb)

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
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hM_wave_ex_min_I = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)],'--m');
        
        % ---- Maximum voluntary contraction
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', ['Select the maximum ' pb_name ' and click ENTER']);
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(x(2),'%.2f'));
        handles.hM_wave_ex_max_I = plot(axesdetect, [x(2) x(2)], [yl(1) yl(2)],'--k');
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update minimum and maximum M-wave exercise contraction force
        handles.processed.M_wave_ex_min_I(id_axes,k) = round(x(1)*1/(isi*10^-3));
        handles.processed.M_wave_ex_max_I(id_axes,k) = round(x(2)*1/(isi*10^-3));
        
end

function handles = pb_mod5(handles, id_pb)

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

