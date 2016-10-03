function handles = callback_detect_multi(hObject, id_pb)
%CALLBACK_DETECT_MULTI Summary of this function goes here
%   Detailed explanation goes here

handles = pb_detect_callback(hObject, id_pb);

function handles = pb_detect_callback(hObject, id_pb)

handles = guidata(hObject);

axesdetect = handles.axesdetect;
% id = handles.id_cond;
id = handles.id_axes;
info_text = handles.info_text;

yl = get(axesdetect, 'YLim');

switch id_pb
    case 1
        
        hstr = handles.hstr(id_pb, :);
        
        % ---- Delete previous plots
        if isfield(handles,'hpeaks')
            if ishandle(handles.hpeaks)
                delete(handles.hpeaks)
            end
        end
        % ----
        
        hold on
        
        % ---- Potential minimum peak
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the minimum peak and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(y(1),'%.2f'));
        handles.hpeaks(1) = plot(axesdetect, x(1), y(1), '+m',...
            'MarkerSize', 10);
        
        % ---- Potential maximum peak
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the maximum peak and click ENTER');
        [x(2), y(2)] = getpts(axesdetect);
        set(hstr(1,2), 'String', num2str(y(2),'%.2f'));
        handles.hpeaks(2) = plot(axesdetect, x(2), y(2), '+m',...
            'MarkerSize', 10);
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update potential amplitudes, minimum and maximum peaks
        handles.processed.ppamp_av{id(3),id(2)}(:,:,id(1)) = y(2) - y(1);
        handles.processed.pmin_av{id(3),id(2)}(:,:,id(1)) = [x(1), y(1)];
        handles.processed.pmax_av{id(3),id(2)}(:,:,id(1)) = [x(1), y(1)];
        
    case 2
        
        hstr = handles.hstr(id_pb, :);
        
        % ---- Delete previous plots
        if isfield(handles,'hlat')
            if ishandle(handles.hlat)
                delete(handles.hlat)
            end
        end
        % ----
        
        % ---- MEP start
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select the potential start and click ENTER');
        [x(1), ~] = getpts(axesdetect);
        set(hstr(1,1), 'String', num2str(x(1),'%.2f'));
        handles.hlat = plot(axesdetect, [x(1) x(1)], [yl(1) yl(2)], 'c',...
            'LineWidth', 2);
        
        hold off
        % ----
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update MEPs duration, start and end instants
        handles.processed.latency_av{id(3),id(2)}(:,:,id(1)) = x(1)/1000;
        handles.processed.latency_I_av{id(3),id(2)}(:,:,id(1)) = x(1);
        
    case 3
        
        % ---- Delete previous plots
        if isfield(handles,'hpeaks')
            if ishandle(handles.hpeaks)
                delete(handles.hpeaks)
            end
        end
        
        if isfield(handles,'hlat')
            if ishandle(handles.hlat)
                delete(handles.hlat)
            end
        end
        
        % Update potential amplitude, minimum and maximum peaks form backup
        handles.processed.ppamp_av{id(3),id(2)}(:,:,id(1)) = 0;
        handles.processed.pmin_av{id(3),id(2)}(:,:,id(1)) = [0, 0];
        handles.processed.pmax_av{id(3),id(2)}(:,:,id(1)) = [0, 0];
        
        % Update potential latency from backup
        handles.processed.latency_av{id(3),id(2)}(:,:,id(1)) = 0;
        handles.processed.latency_I_av{id(3),id(2)}(:,:,id(1)) = 1;
        
        % Update strings
        hstr = handles.hstr(1, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.2f'));
        set(hstr(1,2), 'String', num2str(0.00,'%.2f'));
        
        hstr = handles.hstr(2, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.2f'));
        set(hstr(1,2), 'String', num2str(0.00,'%.2f'));
        
    case 4
        
        % ---- Delete previous plots
        if isfield(handles,'hpeaks')
            if ishandle(handles.hpeaks)
                delete(handles.hpeaks)
            end
        end
        
        if isfield(handles,'hlat')
            if ishandle(handles.hlat)
                delete(handles.hlat)
            end
        end
        
        % Update potential amplitude, minimum and maximum peaks form backup
        handles.processed.ppamp_av{id(3),id(2)}(:,:,id(1)) = handles.processed.ppamp_av_bkp{id(3),id(2)}(:,:,id(1));
        handles.processed.pmin_av{id(3),id(2)}(:,:,id(1)) = handles.processed.pmin_av_bkp{id(3),id(2)}(:,:,id(1));
        handles.processed.pmax_av{id(3),id(2)}(:,:,id(1)) = handles.processed.pmax_av_bkp{id(3),id(2)}(:,:,id(1));
        
        % Update potential latency from backup
        handles.processed.latency_av{id(3),id(2)}(:,:,id(1)) = handles.processed.latency_av_bkp{id(3),id(2)}(:,:,id(1));
        handles.processed.latency_I_av{id(3),id(2)}(:,:,id(1)) = handles.processed.latency_I_av_bkp{id(3),id(2)}(:,:,id(1));
        
        % Update amplitude  and latency plots
        hold on
        handles.hpmin = plot(axesdetect, handles.reader.mep_pmin(id,1),...
            handles.reader.mep_pmin(id,2), '+r', 'MarkerSize', 10);
        handles.hpmax = plot(axesdetect, handles.reader.mep_pmax(id,1),...
            handles.reader.mep_pmax(id,2), '+r', 'MarkerSize', 10);
        handles.hlat = plot(axesdetect, handles.reader.latency_av(id,1),...
            handles.reader.mep_pmax(id,2), 'g', 'LineWidth', 2);
        hold off
        
        % Update strings
        hstr = handles.hstr(1, :);
        set(hstr(1,1), 'String', num2str(handles.reader.mep_pmin(id,2),'%.2f'));
        set(hstr(1,2), 'String', num2str(handles.reader.mep_pmax(id,2),'%.2f'));
        
        hstr = handles.hstr(2, :);
        set(hstr(1,1), 'String', num2str(0.00,'%.2f'));
        set(hstr(1,2), 'String', num2str(0.00,'%.2f'));

end
        