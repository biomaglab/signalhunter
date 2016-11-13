
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


function handles = callback_processing_emf(handles, id_pb)
%BUTTONS_CALLBACK_EMF Summary of this function goes here
%   Detailed explanation goes here

handles = pb_detect_callback(handles, id_pb);

function handles = pb_detect_callback(handles, id_pb)

axesdetect = handles.axesdetect;
%id = handles.id_cond;
info_text = handles.info_text;
yl = get(axesdetect, 'YLim');
xl = get(axesdetect, 'XLim');


switch id_pb
    case 1
        
        %hstr = handles.hstr(id_pb, :);
        
        % ---- Delete previous plots
%         if isfield(handles,'hpzero')
%             if ishandle(handles.hpzero)
%                 delete(handles.hpzero)
%                 delete(handles.hpmax)
%             end
%         end
        % ----
        
        % ---- Window
        hold on
        
        % Show information text to guide user to press enter button.
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select inicial window point and click ENTER');
        [x(1), y(1)] = getpts(axesdetect);
        
        [value index]  = min(abs(handles.time - x(1)));
 
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select final window point and click ENTER');
        [x(2), y(2)] = getpts(axesdetect);
       
        [value index2]  = min(abs(handles.time - x(2)));
        hold off
        
        % Remove information text to guide user to press enter button.
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        % Update Pulse window
        handles.time = handles.time(index:index2);
        handles.raw = handles.raw(index:index2);
        
         
       %handles.raw = handles.raw(x(1):x(2));
         plot(handles.time,handles.raw,'.');
         
         clear value index index2 x
        
    case 2
        
        % ---- Invert handles.signal
        
        handles.raw = handles.raw*(-1);
        plot(handles.time,handles.raw,'.');

        
        
    case 3
        
        % ---- Peak Detection (Standard Desviation Method) 
        
         set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'Select threshold and press Enter.');
        [x, y] = ginput(1);
        
        
        pulse_position = find(handles.raw > y);
        if isempty(pulse_position) == 1
             set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'No Peak Detected. Press Enter to continue.');
            waitforbuttonpress
        else
        
        %split in pulse groups
        j = 1;
        i = 1;
        
        
        
        for k = 1:(length(pulse_position)-1)
            
            aux(i) = pulse_position(k+1) - pulse_position(k);
            
            if aux(i)<4000
                pulse_groups{i,j} = pulse_position(k);
                i = i + 1;
            else
                j = j+1;
                i = 1;
                pulse_groups{i,j} = pulse_position(k);
                i = i + 1;
            end
        end
        
        clear aux j i
        
        for j = 1:length(pulse_groups(1,:))
            
            [~, aux] = max(handles.raw(cell2mat(pulse_groups(:,j))));
            aux3_pos = cell2mat(pulse_groups(aux,j));
            
            smooth_amp = smooth(handles.raw((aux3_pos-4):(aux3_pos+4)));
            
            aux2_pos = dsearchn(handles.raw(cell2mat(pulse_groups(:,j))),max(smooth_amp));
            
            aux_pos = cell2mat(pulse_groups(aux2_pos,j));
            handles.pmax(j) = handles.raw(cell2mat(pulse_groups(aux2_pos,j)));
            handles.pmax_t(j) = handles.time(cell2mat(pulse_groups(aux2_pos,j)));
            
            
            teste = handles.raw((aux_pos-300):(aux_pos+500));
            media = mean(handles.raw((aux_pos-300):(aux_pos-5)));
            desv = std(handles.raw((aux_pos-300):(aux_pos-5)));
            mmax = media + 3.5*desv;
            mmin = media - 3.5*desv;
            
            for u = 1:length(teste)
                if teste(u) <= mmax && teste(u) >= mmin
                    teste2(u) = media;
                else
                    teste2(u) = teste(u);
                end
            end
            
            teste3 = diff(teste2);
            [~, max_pos] = max(teste3);
            [~, min_pos] = min(teste3);
            
            max_pos = max_pos + aux_pos - 300-1;
            min_pos = min_pos + aux_pos - 300+1;
            
            handles.tonset(j) = handles.time(max_pos);
            handles.pzero(j) = handles.raw(max_pos);
            
            handles.tduration(j) = handles.time(min_pos+1);
            handles.pduration(j) = handles.raw(min_pos+1);
                      
            handles.signal{:,j} = handles.raw((max_pos):(min_pos+1));
            handles.xs{:,j} = handles.time((max_pos):(min_pos+1));
            handles.id(j) = j;
                        
            clear  aux3_pos aux2_pos smooth_amp aux_pos teste media desv...
                mmax mmin max_pos min_pos teste2 teste3

        end
        
       hold on
        
        handles.hpmax = plot(handles.pmax_t(:),handles.pmax(:),'.','color','r');
        handles.hponset = plot(handles.tonset,...
        handles.pzero,'.','color','r');
        handles.hduration = plot(handles.tduration,...
        handles.pduration ,'.','color','r');
       
        
        hold off
        
        clear conv aux_pos aux_amp aux
        
        
        n = num2str(length(handles.pmax));
        txt = strcat(n,' Peaks where detected');
        
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', txt);
            waitforbuttonpress
            
        handles.n_pulses = str2num(n);
        set(handles.info_text, 'BackgroundColor', 'w', 'String', '');
        
        end
        
      
        
        

              
        
    case 4
        
         % ---- Delete previous plots
        if isfield(handles,'hpmax')
            if ishandle(handles.hpmax)
                delete(handles.hpmax)
                
            end
        end
        
        % ---- Peak Detection (convolution method)
        
        [filename, pathname] = uigetfile('.mat','Select pulse shape for convolution');
        caux = importdata(horzcat(pathname, filename));
        
        convol = conv(handles.raw,caux);    
        
        pulse_position = find(convol > 20*std(convol));
        
        pulse_position = pulse_position - length(caux);

        if isempty(pulse_position) == 1
             set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', 'No Peak Detected. Press Enter to continue.');
            waitforbuttonpress
        else
            n = [];
            set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', n);

         %split in pulse groups
        j = 1;
        i = 1;
        
        
        
        for k = 1:(length(pulse_position)-1)
            
            aux(i) = pulse_position(k+1) - pulse_position(k);
            
            if aux(i)<4000
                pulse_groups{i,j} = pulse_position(k);
                i = i + 1;
            else
                j = j+1;
                i = 1;
                pulse_groups{i,j} = pulse_position(k);
                i = i + 1;
            end
        end
        
        clear aux j
        
        for j = 1:length(pulse_groups(1,:))
            
            [~, aux] = max(handles.raw(cell2mat(pulse_groups(:,j))));
            aux3_pos = cell2mat(pulse_groups(aux,j));
            
            smooth_amp = smooth(handles.raw((aux3_pos-4):(aux3_pos+4)));
            
            aux2_pos = dsearchn(handles.raw(cell2mat(pulse_groups(:,j))),max(smooth_amp));
            
            aux_pos = cell2mat(pulse_groups(aux2_pos,j));
            handles.pmax(j) = handles.raw(cell2mat(pulse_groups(aux2_pos,j)));
            handles.pmax_t(j) = handles.time(cell2mat(pulse_groups(aux2_pos,j)));
            
            
            teste = handles.raw((aux_pos-300):(aux_pos+500));
            media = mean(handles.raw((aux_pos-300):aux_pos-5));
            desv = std(handles.raw((aux_pos-300):aux_pos-5));
            mmax = media + 3.5*desv;
            mmin = media - 3.5*desv;
            
            for u = 1:length(teste)
                if teste(u) <= mmax && teste(u) >= mmin
                    teste2(u) = media;
                else
                    teste2(u) = teste(u);
                end
            end
            
            teste3 = diff(teste2);
            [~, max_pos] = max(teste3);
            [~, min_pos] = min(teste3);
            
            max_pos = max_pos + aux_pos - 300-1;
            min_pos = min_pos + aux_pos - 300+1;
            
            handles.tonset(j) = handles.time(max_pos);
            handles.pzero(j) = handles.raw(max_pos);
            
            handles.tduration(j) = handles.time(min_pos+1);
            handles.pduration(j) = handles.raw(min_pos+1);
                      
            handles.signal{:,j} = handles.raw((max_pos):(min_pos+1));
            handles.xs{:,j} = handles.time((max_pos):(min_pos+1));
            handles.id(j) = j;
                        
            clear  aux3_pos aux2_pos smooth_amp aux_pos teste media desv...
                mmax mmin max_pos min_pos teste2 teste3
        end

       hold on
        
        handles.hpmax = plot(handles.pmax_t(:),handles.pmax(:),'.','color','r');
        handles.hponset = plot(handles.tonset,...
        handles.pzero,'.','color','r');
        handles.hduration = plot(handles.tduration,...
        handles.pduration ,'.','color','r');
       
        
        hold off
        
        clear conv aux_pos aux_amp aux
        
        
        n = num2str(length(handles.pmax));
        txt = strcat(n,' Peaks where detected');
        
        set(info_text, 'BackgroundColor', [1 1 0.5], ...
            'String', txt);
            waitforbuttonpress
            
        handles.n_pulses = str2num(n);
        
        end
        
        
    case 5
        
        
        
        % ---- Initial Values
        % ---- Delete previous plots
       
        
        if isfield(handles,'pmax')
            handles = rmfield(handles,'pmax');
        end
        if isfield(handles,'pmax_t')
            handles = rmfield(handles,'pmax_t');
        end
        if isfield(handles,'tonset')
            handles = rmfield(handles,'tonset');
        end
        if isfield(handles,'pzero')
            handles = rmfield(handles,'pzero');
        end
        if isfield(handles,'tduration')
            handles = rmfield(handles,'tduration');
        end
        if isfield(handles,'pduration')
            handles = rmfield(handles,'pduration');
        end
        if isfield(handles,'signal')
            handles = rmfield(handles,'signal');
        end
        if isfield(handles,'xs')
            handles = rmfield(handles,'xs');
        end
        if isfield(handles,'id')
            handles = rmfield(handles,'id');
        end
        if isfield(handles,'hpmax')
            handles = rmfield(handles,'hpmax');
        end
        if isfield(handles,'hponset')
            handles = rmfield(handles,'hponset');
        end
        if isfield(handles,'hduration')
            handles = rmfield(handles,'hduration');
        end
        if isfield(handles,'n_pulses')
            handles = rmfield(handles,'n_pulses');
        end
     
        handles.raw = handles.raw_backup;
        handles.time = handles.time_backup;
        
        plot(handles.time, handles.raw,'.')

end

