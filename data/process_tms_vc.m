
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


function processed = process_tms_vc(reader)

% channel 1 = force
% channel 2 = EMG
% channel 3 = EMG
% channel 4 = EMG
% channel 5 = EMG
% channel 6 = RMS
% channel 7 = RMS
% channel 8 = RMS
% channel 9 = RMS
% channel 10 = TMS stim

filename = reader.filename;
process_id = reader.process_id;
pathname = reader.pathname;
sub_name = reader.sub_name;
num_T = reader.num_T;
line_to_read = reader.line_to_read;
series_nb = reader.series_nb;
order_TMS = reader.order_TMS;
signal = reader.signal;

data = signal.data;
isi = signal.isi;

Time = 1:1:length(data); Time = Time' * isi*10^-3;
signal.time = Time;

%% parameters of sensitivity to adjust detections throughout the file
baseline_duration = 1; % seconds, @ start of file
baseline_duration_contrac = 0.3; % seconds to take right before each contraction
superimposed_window = 0.10; % seconds
neurostim_p = 1; % set precision for detection of neurostim default = 5
% EMG_p = 100; % set precision for detection of EMG activity
B_before_neurostim = [2/10;1/10]; % seconds. start and end points of baseline taken before neurostim
% B_before_EMG = [10/10;8/10]; % seconds. start and end points of baseline taken before EMG activity

%clearvars find_name emptyIndex num_T txt_T tab_T line_to_read line_to_read_2

%% WORK ON FILES CALLED 'SERIE...'

if process_id == 1
    
    vert_sensitiv = num_T(line_to_read,1); % A.U. Modifies threshold detection (default = 100, cf. Excel file called thresholds, root folder)
    temp_sensitiv = num_T(line_to_read,2); % seconds. No 2nd contraction possible in this lap of time (default = 0.3 cf. Excel file called thresholds, root folder)

    
    serie_num = str2double(filename(6));
    
    
    %% DETECT CONTRACTIONS
    
    % determine threshold of detection (black horizontal line on plot)
    baseline = mean(data(1:baseline_duration * 1/(isi*10^-3),1));
    baseline_std = std(data(1:1000,1));
    baseline_threshold = baseline + baseline_std*vert_sensitiv;
    
    %detect contractions (red vertical lines on figure "whole set of...")
    contrac = data(:,1) - baseline_threshold;
    contrac = find(contrac > 0);
    sensib_temp = temp_sensitiv*1/(isi*10^-3); % 1/(isi*10^-3) = sample rate
    contrac1 = [0;contrac];
    contrac2 = [contrac;0];
    contrac3 = contrac2 - contrac1;
    to_keep_start = find(contrac3 > sensib_temp);
%     to_keep_end = contrac(to_keep_start(2:end)-1);
    
    contrac_start = contrac(to_keep_start);
    contrac_end = [contrac(to_keep_start(2:end)-1);contrac(end)];
    
    clearvars contrac1 contrac2 contrac3 to_keep_start to_keep_end
    

    %% DETECT UNWANTED OR FALSE CONTRACTIONS
    remove = NaN(length(contrac_start),1);
    for i=1:1:length(contrac_start)
        if contrac_end(i)+1/(isi*10^-3) > size(data,1)
            stim_channel_9 = find(data(contrac_start(i)-1/(isi*10^-3):size(data,1),9)>1);
            stim_channel_10 = find(data(contrac_start(i)-1/(isi*10^-3):size(data,1),10)>1);
        else
            if contrac_start(i)-1/(isi*10^-3)<=0
                stim_channel_9 = find(data(1:contrac_end(i)+1/(isi*10^-3),9)>1);
                stim_channel_10 = find(data(1:contrac_end(i)+1/(isi*10^-3),10)>1);
            else
                stim_channel_9 = find(data(contrac_start(i)-1/(isi*10^-3):contrac_end(i)+1/(isi*10^-3),9)>1);
                stim_channel_10 = find(data(contrac_start(i)-1/(isi*10^-3):contrac_end(i)+1/(isi*10^-3),10)>1);
            end
        end
        if isempty(stim_channel_9)
            if isempty(stim_channel_10)
                remove(i) = i;
            end
        end
    end
    remove = isnan(remove); remove = find(remove == 0);
    contrac_start(remove)=[];
    contrac_end(remove)=[];
    
    clearvars remove stim_channel_9 stim_channel_10
    
    if length(contrac_start) < 7
        figure('Name', 'Contraction visualization');
        plot(data(:,1))
        x=axis;
        hold on
        plot([x(1) x(2)],[baseline_threshold baseline_threshold],'k')
        legend('force','threshold')
        
        txt = ['only ' num2str(length(contrac_start)) ' contractions found, please adjust thresholds to increase precision for detection'];
        msgbox(['Only ' num2str(length(contrac_start)) ' contractions found, please adjust thresholds to increase precision for detection.'])
        error(txt)
    end
    clearvars txt
    
    % Sort contractions, voluntary different from neurostim while at rest
    vol_contrac_start = [contrac_start(1);contrac_start(4);contrac_start(6:7)];
    vol_contrac_end = [contrac_end(1);contrac_end(4);contrac_end(6:7)];
    stim_contrac_start = [contrac_start(2);contrac_start(3);contrac_start(5)];
    stim_contrac_end = [contrac_end(2);contrac_end(3);contrac_end(5)];
    
    
    
    
    %% WORK ON VOLUNTARY CONTRACTIONS
    
    
    C_mean = NaN(4,1); work_zone = NaN(4,1); % preallocating for speed
    work_zone_start = NaN(4,1); work_zone_end = NaN(4,1); stim = NaN(4,1);
    superimposed_F = NaN(4,1); superimposed_B = NaN(4,1); superimposed_V = NaN(4,1);
    max_C = NaN(4,1); max_C_I = NaN(4,1); max_B = NaN(4,1); max_V = NaN(4,1);
    
    for i=1:1:4
        
        C_mean(i) = mean(data(round(vol_contrac_start(i)):round(vol_contrac_end(i)),1));
        
        %detect stim artefacts on force channel during contraction
        work_zone(i) = (vol_contrac_end(i) - vol_contrac_start(i)) * 50/100;
        work_zone_start(i) = vol_contrac_start(i)+work_zone(i)/2;
        work_zone_end(i) = vol_contrac_end(i)-work_zone(i)/2;
        if isempty(find(data(round(work_zone_start(i)):round(work_zone_end(i)),1)<C_mean(i),1))
            stim(i) = work_zone_start(i);
            msgbox('Please, find the superimposed by hand, MATLAB is too confused.')
            break
        else
            stim(i) = find(data(round(work_zone_start(i)):round(work_zone_end(i)),1)<C_mean(i),1);
            stim(i) = stim(i) + work_zone_start(i);
        end
        
        
        clearvars work_zone
        
        % scan for superimposed force immediately before stim
        [superimposed_Ft, superimposed_F_It] = max(data(round(stim(i) - superimposed_window * 1/(isi*10^-3)):round(stim(i)),1));
        superimposed_Bt = min(data(round(stim(i)-superimposed_window*1/(isi*10^-3)):round(stim(i) - superimposed_window * 1/(isi*10^-3) + superimposed_F_It),1));
        superimposed_Vt = superimposed_Ft - superimposed_Bt;
        superimposed_F(i) = superimposed_Ft;
        superimposed_B(i) = superimposed_Bt;
        superimposed_V(i) = superimposed_Vt;
        clearvars superimposed_Ft superimposed_F_It superimposed_Bt superimposed_Vt
        
        % scan for max away from stim
        [max_before_stim, max_before_stim_I] = max(data(round(vol_contrac_start(i)):round(stim(i) - superimposed_window * 1/(isi*10^-3)),1));
        [max_after_stim, max_after_stim_I] = max(data(round(stim(i)):round(vol_contrac_end(i))));
        if max_before_stim > max_after_stim
            max_C(i) = max_before_stim;
            max_C_I(i) = max_before_stim_I + vol_contrac_start(i);
        else
            max_C(i) = max_after_stim;
            max_C_I(i) = max_after_stim_I + stim(i);
        end
        
        max_B(i) = mean(data(round(vol_contrac_start(i) - baseline_duration_contrac * 1/(isi*10^-3)):round(vol_contrac_start(i) - baseline_duration_contrac/3 * 1/(isi*10^-3)),1));
        max_V(i) = max_C(i) - max_B(i);
        
    end
    
    
    % RMS during 500ms around max
    [~, neurostim_contrac_max_I] = max(data(vol_contrac_start(1):vol_contrac_end(1),6));
    neurostim_contrac_max_I = neurostim_contrac_max_I + vol_contrac_start(1);
    RMS_max_start_I = max_C_I(1) -  0.25* 1/(isi*10^-3);
    RMS_max_end_I = max_C_I(1) +  0.25* 1/(isi*10^-3);
    
    if (neurostim_contrac_max_I<RMS_max_start_I || neurostim_contrac_max_I>RMS_max_end_I)
        
    else
        RMS_max_start_I =  neurostim_contrac_max_I - 0.510*1/(isi*10^-3);
        RMS_max_end_I = RMS_max_start_I + 0.500*1/(isi*10^-3);
    end
    
    RMS_max_contrac1 = NaN(8,1);
    for k=6:1:8
        RMS_max_contrac1(k) = mean(data(round(RMS_max_start_I):round(RMS_max_end_I),k));
    end
%     RMS_max_contrac1(1:5) = [];
    
    
        
        
    %% WORK ON NEUROSTIM WHILE AT REST
    
    % amplitude, contraction time and HRT for the 3 neurostim while at rest
    
    neurostim_max = NaN(3,1); neurostim_B = NaN(3,1); std_neurostim_B = NaN(3,1);
    stim_contrac_start_p = NaN(3,1); contrac_time = NaN(3,1); HRT = NaN(3,1); HRT_abs = NaN(3,1);
    neurostim_max_I = NaN(3,1);
    search_contrac_start_p = NaN(3,300); search_contrac_start_p2 = NaN(3,300);
    
    for i=1:1:3
        
        [neurostim_maxt, neurostim_max_It] = max(data(stim_contrac_start(i):stim_contrac_end(i),1));
        neurostim_max_I(i) = stim_contrac_start(i) + neurostim_max_It;
        neurostim_max(i) = neurostim_maxt;
        clearvars neurostim_maxt neurostim_max_It
        
        % more precision on contraction start for neurostim
        neurostim_B(i) = mean(data(stim_contrac_start(i) - B_before_neurostim(1)*1/(isi*10^-3):stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3),1));
        std_neurostim_B(i) = std(data(stim_contrac_start(i) - B_before_neurostim(1)*1/(isi*10^-3):stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3),1));
        if length(find(data(stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3):stim_contrac_start(i),1) > neurostim_B(i) + neurostim_p*std_neurostim_B(i),300,'first')) < 300
            temp = find(data(stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3):stim_contrac_start(i),1) > neurostim_B(i) + neurostim_p*std_neurostim_B(i),300,'first');
            temp = [temp;NaN(300-length(temp),1)];
            search_contrac_start_p(i,:) = temp;
        else
            search_contrac_start_p(i,:) = find(data(stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3):stim_contrac_start(i),1) > neurostim_B(i) + neurostim_p*std_neurostim_B(i),300,'first');    
        end
        search_contrac_start_p2(i,:) = [0 search_contrac_start_p(i,1:end-1)];
        substrac = search_contrac_start_p(i,2:end) - search_contrac_start_p2(i,2:end);
        if sum(substrac) == length(search_contrac_start_p)-1
            stim_contrac_start_p(i) = stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3) + search_contrac_start_p(i,1);
        else
            k = 1;
            while sum(substrac) ~= length(search_contrac_start_p)-k
                substrac= substrac (2:end);
                k = k+1;
            end
            if isnan(search_contrac_start_p(i,k)) ~= 1
                stim_contrac_start_p(i) = stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3) + search_contrac_start_p(i,k);
            else
                [~, temp] = max(search_contrac_start_p(i,:));
                stim_contrac_start_p(i) = stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3) + search_contrac_start_p(i,temp);
            end
        end
        contrac_time(i) = (neurostim_max_I(i) - stim_contrac_start_p(i)) * 1/(isi*10^-3);
        HRT(i) = find(data(neurostim_max_I(i):stim_contrac_end(i) + 1/(isi*10^-3),1) < (neurostim_max(i)-neurostim_B(i))/2 + neurostim_B(i),1);
        HRT_abs(i) = HRT(i) + neurostim_max_I(i);
        HRT(i) = (HRT_abs(i) - neurostim_max_I(i)) * 1/(isi*10^-3);
    end
    
    
    
    % M wave amplitude, time peak to peak and area under curve for neurostim @
    % rest #2 & #3, on channels 2, 3 and 4
    max_M_wave = NaN(3,3); max_M_wave_I = NaN(3,3);
    min_M_wave = NaN(3,3); min_M_wave_I = NaN(3,3);
    M_wave_start = NaN(3,3); M_wave_start_I = NaN(3,3);
    M_wave_end = NaN(3,3); M_wave_end_I = NaN(3,3);
    integr_val = NaN(3,3); integr_val2 = NaN(3,3);
    for k=2:1:4
        for i=2:1:3
            if strcmp(pathname(end-8:end-1),'Mickey_D') == 1
                potent_max = find(data(stim_contrac_start(i)-1/(isi*10^-3):stim_contrac_end(i),k) > 0.05);
            elseif strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 4
                potent_max = find(data(stim_contrac_start(i)-1/(isi*10^-3):stim_contrac_end(i),k) > 2*10^-3);
            elseif strcmp(pathname(end-10:end-1),'Thibault_D') == 1 && series_nb == 8
                potent_max = find(data(stim_contrac_start(i)-1/(isi*10^-3):stim_contrac_end(i),k) > 0.5);
            else
                potent_max = find(data(stim_contrac_start(i)-1/(isi*10^-3):stim_contrac_end(i),k) > 1); 
            end
            potent_max_diff = diff(potent_max);
            break_point = find(potent_max_diff ~= 1);
            if isempty(break_point)
                [max_M_wavet, max_M_wave_It] = max(data(stim_contrac_start(i)-1/(isi*10^-3) : stim_contrac_start(i)-1/(isi*10^-3) + potent_max(end),k));
                max_M_wave(i,k) = max_M_wavet;
                max_M_wave_I(i,k) = max_M_wave_It + stim_contrac_start(i)-1/(isi*10^-3);
            else
                [max_M_wavet, max_M_wave_It] = max(data(stim_contrac_start(i)-1/(isi*10^-3) + potent_max(break_point(1)+1) : stim_contrac_start(i)-1/(isi*10^-3) + potent_max(end),k));
                max_M_wave(i,k) = max_M_wavet;
                max_M_wave_I(i,k) = max_M_wave_It + stim_contrac_start(i)-1/(isi*10^-3) + potent_max(break_point(1)+1);
            end
            
            if strcmp(pathname(end-8:end-1),'Mickey_D') == 1
                potent_min = find(data(stim_contrac_start(i)-1/(isi*10^-3):stim_contrac_end(i),k) < -0.05);
            elseif strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 4
                potent_min = find(data(stim_contrac_start(i)-1/(isi*10^-3):stim_contrac_end(i),k) < 0.05);
            elseif strcmp(pathname(end-10:end-1),'Thibault_D') == 1 && series_nb == 8
                potent_min = find(data(stim_contrac_start(i)-1/(isi*10^-3):stim_contrac_end(i),k) < -0.5);
            else
                potent_min = find(data(stim_contrac_start(i)-1/(isi*10^-3):stim_contrac_end(i),k) < -1);
            end
            potent_min_diff = diff(potent_min);
            break_point = find(potent_min_diff ~= 1);
            if isempty(break_point)
                [min_M_wavet, min_M_wave_It] = min(data(stim_contrac_start(i)-1/(isi*10^-3) : stim_contrac_start(i)-1/(isi*10^-3) + potent_min(end),k));
                min_M_wave(i,k) = min_M_wavet;
                min_M_wave_I(i,k) = min_M_wave_It + stim_contrac_start(i)-1/(isi*10^-3);
            else
                [min_M_wavet, min_M_wave_It] = min(data(stim_contrac_start(i)-1/(isi*10^-3) + potent_min(break_point(1)+1) : stim_contrac_start(i)-1/(isi*10^-3) + potent_min(end),k));
                min_M_wave(i,k) = min_M_wavet;
                min_M_wave_I(i,k) = min_M_wave_It + stim_contrac_start(i)-1/(isi*10^-3) + potent_min(break_point(1)+1);
            end
            
            clearvars min_M_wavet min_M_wave_It
            
            j=1; win_before = 100;
            while data(max_M_wave_I(i,k)-j+1,k) - data(max_M_wave_I(i,k)-j,k) >= 0
                j = j+1;
            end
            if j > 10 && j < win_before
                M_wave_start_I(i,k) = max_M_wave_I(i,k)-j;
                M_wave_start(i,k) = data(M_wave_start_I(i,k),k);
            else
                [M_wave_startt, M_wave_start_It] = min(data(max_M_wave_I(i,k)-win_before:max_M_wave_I(i,k) - 1,k));
                M_wave_start(i,k) = M_wave_startt;
                M_wave_start_I(i,k) = M_wave_start_It + max_M_wave_I(i,k)-win_before;
            end
            
            j=1; win_after = 1000;
            while data(min_M_wave_I(i,k) + j,k)<= 0.05
                j = j+1;
            end
            if j > 10 && j < win_after
                M_wave_end_I(i,k) = min_M_wave_I(i,k)+j;
                M_wave_end(i,k) = data(M_wave_end_I(i,k),2);
            else
                [M_wave_endt, M_wave_end_It] = max(data(min_M_wave_I(i,k)+1:min_M_wave_I(i,k) + win_after,k));
                M_wave_end(i,k) = M_wave_endt;
                M_wave_end_I(i,k) = M_wave_end_It + min_M_wave_I(i,k) + 1;
            end
            
            integr_val(i,k) = sum (abs (data(M_wave_start_I(i,k):M_wave_end_I(i,k),k))) * (isi*10^-3);
            integr_val2(i,k) = sum (abs (data(max_M_wave_I(i,k):min_M_wave_I(i,k),k))) * (isi*10^-3);
        end
        
    end
    
    clearvars potent_diff potent_min_diff break_point M_wave_startt M_wave_start_It M_wave_endt M_wave_end_It
    
    
    
    
    %% WORK ON NEUROSTIM WHILE CONTRACTING
    
    % Find neurostim during exercise using EMG channels
    % determine thresholds for detection
%     EMG_VL_mean = mean(data(:,2));
%     EMG_VL_std_alt = 10*std(data(:,2)); % LATER MAKE IT AN INPUT FOR USERS
%     EMG_VL_threshold = EMG_VL_mean + EMG_VL_std_alt;
%     EMG_VM_mean = mean(data(:,3));
%     EMG_VM_std_alt = 10*std(data(:,3));
%     EMG_VM_threshold = EMG_VM_mean + EMG_VM_std_alt;
%     EMG_RF_mean = mean(data(:,4));
%     EMG_RF_std_alt = 10*std(data(:,4));
%     EMG_RF_threshold = EMG_RF_mean + EMG_RF_std_alt;
    
    clearvars EMG_VL_mean EMG_VL_std_alt EMG_VM_mean EMG_VM_std_alt
    clearvars EMG_RF_mean EMG_RF_std_alt
    
    
    % find artefact of neurostim during voluntary contractions #1, 2, 3 & 4
    contrac_neurostim = NaN(4,4);
    if order_TMS == 1
        if strcmp(sub_name, 'Gabriele') == 1 || strcmp(sub_name, 'Andrea') == 1 || strcmp(sub_name, 'Diana') == 1
            xthr = 1/2;
        else
            xthr = 2/3;
        end
        for k=2:1:4
            for i=1:1:4
                if i==1
                    work_zone = data(vol_contrac_start(i):vol_contrac_end(i),k);
                    [~, contrac_neurostim_I]=max(abs(work_zone));
                    contrac_neurostim(i,k) = contrac_neurostim_I + vol_contrac_start(i);
                else
                    work_zone = data(vol_contrac_start(i)+(round(xthr*(vol_contrac_end(i)-vol_contrac_start(i)))):vol_contrac_end(i),k);
                    [~, contrac_neurostim_I]=max(abs(work_zone));
                    contrac_neurostim(i,k) = contrac_neurostim_I + vol_contrac_start(i) + (round(xthr*(vol_contrac_end(i)-vol_contrac_start(i))));
                end
            end
            
            % Make sure artefact has been picked-up, not the M-wave
            for i=1:1:4
                work_zone = data(contrac_neurostim(i,k)-1000:contrac_neurostim(i,k)-50,k);
                potent = find(abs(work_zone)>abs(data(contrac_neurostim(i,k),k))/2, 1);
                if isempty(potent)
                    
                else
                    [~, real_contrac_I] = max(abs(work_zone));
                    contrac_neurostim(i,k) = real_contrac_I + contrac_neurostim(i,k)-1000;
                end
            end
        end
        
    else % In case neurostim comes before TMS

        xthr = 1/3;

        for k=2:1:4
            for i=1:1:4
                if i==1
                    work_zone = data(vol_contrac_start(i):vol_contrac_end(i),k);
                    [~, contrac_neurostim_I]=max(abs(work_zone));
                    contrac_neurostim(i,k) = contrac_neurostim_I + vol_contrac_start(i);
                else
                    if vol_contrac_end(i)-round(xthr*(vol_contrac_end(i)-vol_contrac_start(i))) > size(data,1)
                        work_zone = data(vol_contrac_start(i):end,k);
                        [~, contrac_neurostim_I]=max(abs(work_zone));
                        contrac_neurostim(i,k) = contrac_neurostim_I + vol_contrac_start(i);
                    else
                        work_zone = data(vol_contrac_start(i):vol_contrac_end(i)-round(xthr*(vol_contrac_end(i)-vol_contrac_start(i))),k);
                        [~, contrac_neurostim_I]=max(abs(work_zone));
                        contrac_neurostim(i,k) = contrac_neurostim_I + vol_contrac_start(i);
                    end
                end
            end
            
            % Make sure artefact has been picked-up, not the M-wave
            for i=1:1:4
                work_zone = data(contrac_neurostim(i,k)-1000:contrac_neurostim(i,k)-50,k);
                potent = find(abs(work_zone)>abs(data(contrac_neurostim(i,k),k))/2, 1);
                if isempty(potent)
                    
                else
                    [~, real_contrac_I] = max(abs(work_zone));
                    contrac_neurostim(i,k) = real_contrac_I + contrac_neurostim(i,k)-1000;
                end
            end
        end
    end
    
    
    
    % M wave amplitude, time peak to peak and area under curve for neurostim
    % during contraction #2 #3 & #4, on channels 2, 3 and 4
    M_wave_ex_max_I = NaN(4,4);
    M_wave_ex_min_I = NaN(4,4);
    M_wave_ex_start_I = NaN(4,4); M_wave_ex_start = NaN(4,4);
    M_wave_ex_end_I = NaN(4,4); M_wave_ex_end = NaN(4,4);
    for k=2:1:4
        for i=1:1:4
            [~, M_wave_ex_max] = max(data(contrac_neurostim(i,k)+20 : contrac_neurostim(i,k)+2000,k));
            M_wave_ex_max_I(i,k) = M_wave_ex_max + contrac_neurostim(i,k)+20;
            [~, M_wave_ex_min] = min(data(contrac_neurostim(i,k)+20 : contrac_neurostim(i,k)+2000,k));
            M_wave_ex_min_I(i,k) = M_wave_ex_min + contrac_neurostim(i,k)+20;
            
            % find M_wave start for neurostim during exercise
            if M_wave_ex_max_I(i,k) < M_wave_ex_min_I(i,k)
                j=1; diff_dat=1;
                while diff_dat>=0
                    diff_dat = data(M_wave_ex_max_I(i,k)-j,k) - data(M_wave_ex_max_I(i,k)-j-1,k);
                    j=j+1;
                end
                M_wave_ex_start_I(i,k) = M_wave_ex_max_I(i,k) - j;
                M_wave_ex_start(i,k) = data(M_wave_ex_start_I(i,k),k);
            else
                j=1; diff_dat=1;
                while diff_dat>=0
                    diff_dat = data(M_wave_ex_min_I(i,k)-j,k) - data(M_wave_ex_min_I(i,k)-j-1,k);
                    j=j+1;
                end
                M_wave_ex_start_I(i,k) = M_wave_ex_min_I(i,k) - j;
                M_wave_ex_start(i,k) = data(M_wave_ex_start_I(i,k),k);
            end
            clearvars diff_dat
            
            % find M-wave end for neurostim during exercise
            j=1;
            while data(M_wave_ex_min_I(i,k) + j,k)<= 0.001 %0.05
                j = j+1;
            end
            if j > 10 && j < win_after
                M_wave_ex_end_I(i,k) = M_wave_ex_min_I(i,k)+j;
                M_wave_ex_end(i,k) = data(M_wave_ex_min_I(i,k),k);
            else
                [M_wave_endt, M_wave_end_It] = max(data(M_wave_ex_min_I(i,k)+1:M_wave_ex_min_I(i,k) + win_after,k));
                M_wave_ex_end(i,k) = M_wave_endt;
                M_wave_ex_end_I(i,k) = M_wave_end_It + M_wave_ex_min_I(i,k) + 1;
            end
        end
    end
    
    
    
    clearvars work_zone temp contrac_neurostim_I potent real_contrac_I
    clearvars M_wave_ex_max M_wave_ex_min diff_dat
    
    
    
    
    
    %% WORK ON FORCE CHANNEL TO FIND SUPERIMPOSED FORCE @ NEUROSTIM
    
    contrac_neurostim_max = NaN(3,1);
    contrac_neurostim_max_I = NaN(3,1);
    contrac_neurostim_min = NaN(3,1);
    contrac_neurostim_min_I = NaN(3,1);
    win_neuro=60;
    for i=2:1:4
        [contrac_neurostim_maxt, contrac_neurostim_max_It] = max(data(contrac_neurostim(i,2)+win_neuro:contrac_neurostim(i,2)+2000,1));
        contrac_neurostim_max(i) = contrac_neurostim_maxt;
        contrac_neurostim_max_I(i) = contrac_neurostim_max_It + contrac_neurostim(i,2)+win_neuro;
        
        [contrac_neurostim_mint, contrac_neurostim_min_It] = min(data(contrac_neurostim(i,2)+win_neuro:contrac_neurostim_max_I(i),1));
        contrac_neurostim_min(i) = contrac_neurostim_mint;
        contrac_neurostim_min_I(i) = contrac_neurostim_min_It + contrac_neurostim(i,2)+win_neuro;
    end
    clearvars contrac_neurostim_maxt contrac_neurostim_max_It
    clearvars contrac_neurostim_mint contrac_neurostim_min_It
    
    
    
    
    
    %% MEP & SILENT PERIOD ON CHANNELS 2, 3 and 4, AFTER TMS
    
    
    % find position of TMS artefact on channel 10
    temp = find(data(:,10)==5);
    temp_diff = diff(temp);
    temp2 = find(temp_diff>1);
    row_to_pick = [1;temp2+1];
    TMS_stim = temp(row_to_pick);
    if TMS_stim(1) == 1
        TMS_stim = TMS_stim(2:end);
    end
    clearvars temp temp_diff temp2 row_to_pick
    
    
    % find M-Wave immediately following TMS_stim
    M_wave_MEP_max = NaN(3,4); M_wave_MEP_min = NaN(3,4);
    M_wave_MEP_max_I = NaN(3,4); M_wave_MEP_min_I = NaN(3,4);
    M_wave_MEP_start_I = NaN(3,4);
    M_wave_MEP_start = NaN(3,4);
    M_wave_MEP_end_I = NaN(3,4);
    M_wave_MEP_end = NaN(3,4);
    for k=2:1:4
        for i=1:1:3
            [M_wave_MEP_maxt, M_wave_MEP_max_It] = max(data(TMS_stim(i)+100:TMS_stim(i)+2000,k));
            M_wave_MEP_max(i,k) = M_wave_MEP_maxt;
            M_wave_MEP_max_I(i,k) = M_wave_MEP_max_It + TMS_stim(i)+100;
            
            [M_wave_MEP_mint, M_wave_MEP_min_It] = min(data(TMS_stim(i)+100:TMS_stim(i)+2000,k));
            M_wave_MEP_min(i,k) = M_wave_MEP_mint;
            M_wave_MEP_min_I(i,k) = M_wave_MEP_min_It + TMS_stim(i)+100;
            
            % find M_wave start for TMS during exercise
            if M_wave_MEP_max_I(i,k) < M_wave_MEP_min_I(i,k)
                j=1; diff_dat=1;
                while diff_dat>=0
                    diff_dat = data(M_wave_MEP_max_I(i,k)-j,k) - data(M_wave_MEP_max_I(i,k)-j-1,k);
                    j=j+1;
                end
                M_wave_MEP_start_I(i,k) = M_wave_MEP_max_I(i,k) - j;
                M_wave_MEP_start(i,k) = data(M_wave_MEP_start_I(i,k),k);
                
            else
                j=1; diff_dat=1;
                while diff_dat>=0
                    diff_dat = data(M_wave_MEP_min_I(i,k)-j,k) - data(M_wave_MEP_min_I(i,k)-j-1,k);
                    j=j+1;
                end
                M_wave_MEP_start_I(i,k) = M_wave_MEP_min_I(i,k) - j;
                M_wave_MEP_start(i,k) = data(M_wave_MEP_start_I(i,k),k);
            end
            clearvars diff_dat
            
            % find M-wave end for TMS during exercise
            j=1;
            while data(M_wave_MEP_min_I(i,k) + j,k)<= 0.05
                j = j+1;
            end
            if j > 10 && j < win_after
                M_wave_MEP_end_I(i,k) = M_wave_MEP_min_I(i,k)+j;
                M_wave_MEP_end(i,k) = data(M_wave_MEP_min_I(i,k),k);
            else
                [M_wave_endt, M_wave_end_It] = max(data(M_wave_MEP_min_I(i,k)+1:M_wave_MEP_min_I(i,k) + win_after,k));
                M_wave_MEP_end(i,k) = M_wave_endt;
                M_wave_MEP_end_I(i,k) = M_wave_end_It + M_wave_MEP_min_I(i,k) + 1;
            end
        end
    end
    clearvars M_wave_MEP_maxt M_wave_MEP_max_It M_wave_MEP_mint M_wave_MEP_min_It
    clearvars M_wave_endt M_wave_end_It
    
    
    
    % Work on silent period
    
    % Stu's methods
    win_pre_stim = 50; %in ms, according to Stu's email
    EMG_recov_point = NaN(3,4);
    for k=2:1:4 %channel loop
        for i=1:1:3 %TMS loop
            pre_stim_EMG_std = std(data(TMS_stim(i)-round(win_pre_stim*10^-3*1/(isi*10^-3)):TMS_stim(i),k));
            if strcmp(pathname(end-9:end-1),'Jerome_ND') == 1 && series_nb == 3
                EMG_recov_point_t = find(abs((data(M_wave_MEP_end_I(i,k)+(1/(isi*10^-3))/100*5:M_wave_MEP_end_I(i,k)+ 1/(isi*10^-3),k)))>pre_stim_EMG_std-pre_stim_EMG_std/10,1);
%             elseif strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 7
%                 EMG_recov_point_t = M_wave_MEP_end_I(i,k)+ 1/(isi*10^-3);
%             elseif strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 8
%                 EMG_recov_point_t = M_wave_MEP_end_I(i,k)+ 1/(isi*10^-3);
            elseif strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 4
                EMG_recov_point_t = find(abs((data(M_wave_MEP_end_I(i,k)+(1/(isi*10^-3))/100*5:M_wave_MEP_end_I(i,k)+ 1/(isi*10^-3),k)))>pre_stim_EMG_std-pre_stim_EMG_std/1.1,1);
            else
                EMG_recov_point_t = find(abs((data(M_wave_MEP_end_I(i,k)+(1/(isi*10^-3))/100*5:M_wave_MEP_end_I(i,k)+ 1/(isi*10^-3),k)))>pre_stim_EMG_std,1);
            end
            
            if strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 6
                EMG_recov_point_t = M_wave_MEP_end_I(i,k);
                EMG_recov_point(i,k) = EMG_recov_point_t;
            elseif strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 7
                EMG_recov_point_t = M_wave_MEP_end_I(i,k);
                EMG_recov_point(i,k) = EMG_recov_point_t;
            elseif strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 8
                EMG_recov_point_t = M_wave_MEP_end_I(i,k);
                EMG_recov_point(i,k) = EMG_recov_point_t;
            else
                EMG_recov_point(i,k) = EMG_recov_point_t + M_wave_MEP_end_I(i,k)+(1/(isi*10^-3))/100*5;
            end
        end
    end
    clearvars EMG_recov_point_t

    
    %% WORK ON RMS CHANNELS
    
    % mean RMS 0.5s around force pike
    
    work_zone = NaN(length(max_C_I));
    work_zone(:,1) = max_C_I-(1/(isi*10^-3))/4;
    work_zone(:,2) = max_C_I+(1/(isi*10^-3))/4;
    
    RMS = NaN(4,4);
    for k=2:1:4
        for i=1:1:4
            RMS(i,k) = mean(data(round(work_zone(i,1)):round(work_zone(i,2)),k+4));
        end
    end
    
    % variables used in model 1 - whole set of contractions with voluntary
    % contraction
    processed.vol_contrac_start = vol_contrac_start;
    processed.vol_contrac_end = vol_contrac_end;
    processed.stim = stim;
    processed.superimposed_window = superimposed_window;
    processed.superimposed_F = superimposed_F;
    processed.superimposed_F_I = zeros(size(superimposed_F,1), size(superimposed_F,2));
    processed.superimposed_B = superimposed_B;
    processed.superimposed_B_I = zeros(size(superimposed_B,1), size(superimposed_B,2));
    processed.max_C = max_C;
    processed.max_C_I = max_C_I;
    processed.max_B = max_B;
    processed.max_B_I = zeros(size(max_B,1), size(max_B,2));
    processed.baseline_duration_contrac = baseline_duration_contrac;
    processed.contrac_neurostim = contrac_neurostim;
    processed.win_neuro = win_neuro;
    processed.contrac_neurostim_min = contrac_neurostim_min;
    processed.contrac_neurostim_min_I = zeros(size(contrac_neurostim_min,1), size(contrac_neurostim_min,2));
    processed.contrac_neurostim_max = contrac_neurostim_max;
    processed.contrac_neurostim_max_I = zeros(size(contrac_neurostim_max,1), size(contrac_neurostim_max,2));
    processed.signal = signal;
    
    % variables used in model 2 - whole set of contractions with
    % neurostimulation
    processed.stim_contrac_start_p = stim_contrac_start_p;
    processed.stim_contrac_end = stim_contrac_end;
    processed.stim_contrac_start = stim_contrac_start;
    processed.neurostim_max = neurostim_max;
    processed.B_before_neurostim = B_before_neurostim;
    processed.neurostim_B = neurostim_B;
    processed.neurostim_max_I = neurostim_max_I;
    processed.HRT_abs = HRT_abs;
    
    % variables used in model 3 - neurostimulation at rest
    processed.M_wave_start_I = M_wave_start_I;
    processed.M_wave_end_I = M_wave_end_I;
    processed.max_M_wave_I = max_M_wave_I;
    processed.min_M_wave_I = min_M_wave_I;
    
    % variables used in model 4 - neurostimulation at exercise
    processed.M_wave_ex_max_I = M_wave_ex_max_I;
    processed.M_wave_ex_min_I = M_wave_ex_min_I;
    processed.M_wave_ex_start_I = M_wave_ex_start_I;
    processed.M_wave_ex_end_I = M_wave_ex_end_I;
    
    % variables used in model 5 - TMS and MEP
    processed.TMS_stim = TMS_stim;
    processed.win_pre_stim = win_pre_stim;
    processed.EMG_recov_point = EMG_recov_point;
    processed.M_wave_MEP_max_I = M_wave_MEP_max_I;
    processed.M_wave_MEP_min_I = M_wave_MEP_min_I;
    processed.M_wave_MEP_start_I = M_wave_MEP_start_I;
    processed.M_wave_MEP_end_I = M_wave_MEP_end_I;
    
    % variables used only in output function
    processed.M_wave_MEP_max = M_wave_MEP_max;
    processed.M_wave_MEP_min = M_wave_MEP_min;
    processed.RMS = RMS;
    processed.serie_num = serie_num;

elseif process_id == 2
    
    serie_num = 0;
    
    vert_sensitiv = 100; % A.U. Modifies threshold detection (default = 100, cf. Excel file called thresholds, root folder)
    temp_sensitiv = 0.3; % seconds. No 2nd contraction possible in this lap of time (default = 0.3 cf. Excel file called thresholds, root folder)
    
    % sampling frequency
    fs = 1/(isi*10^-3);

    %% DETECT CONTRACTIONS
    
    baseline_duration = baseline_duration/100;
    % determine threshold of detection (black horizontal line on plot)
    baseline = mean(data(1:baseline_duration *1/(isi*10^-3),1));
    baseline_std = std(data(1:baseline_duration *1/(isi*10^-3),1));
    baseline_threshold = baseline + baseline_std*vert_sensitiv;
    
    % detect contractions
    contrac = data(:,1) - baseline_threshold;
    contrac = find(contrac > 0);
    sensib_temp = temp_sensitiv*1/(isi*10^-3); % 1/(isi*10^-3) = sample rate
    contrac1 = [0;contrac];
    contrac2 = [contrac;0];
    contrac3 = contrac2 - contrac1;
    if strcmp(sub_name, 'Gabriele') == 1 || strcmp(sub_name, 'Coralie') == 1
        to_keep_start = find(contrac3 > sensib_temp-5000);
    else
        to_keep_start = find(contrac3 > sensib_temp);
    end
%     to_keep_end = contrac(to_keep_start(2:end)-1);
    
    contrac_start = contrac(to_keep_start);
    contrac_end = [contrac(to_keep_start(2:end)-1);contrac(end)];
    
    
    % Make the twitch contraction detection more sensitive
    differ = 1; k = 0;
    while differ > 0
        differ = data(contrac_start(1)-k) - data(contrac_start(1)-k-200);
        k = k+1;
    end
    contrac_start(1) = contrac_start(1)-k;
    
    differ = 1; k = 0;
    while differ > 0
        differ = data(contrac_end(1)+k) - data(contrac_end(1)+k+100);
        k = k+1;
    end
    contrac_end(1) = contrac_end(1)+k;
    
    clearvars differ k 
    
    [Twitch_y, Twitch_x] = max(data(contrac_start(1):contrac_end(1)));
    Twitch_x = Twitch_x + contrac_start(1);
%     force(1) = Twitch_y - baseline;
%     force(2) = (Twitch_x - contrac_start(1))* isi;
    HRT = find(data(Twitch_x:contrac_end(1)) < (Twitch_y-baseline)/2+baseline ,1);
    HRT = HRT + Twitch_x;
%     force(3) = (HRT - Twitch_x) * isi;
    
    %% WORK ON MAX
    
    % find max
    contrac_max = NaN(3,1); contrac_max_I = NaN(3,1);
    for i=2:1:3
        [maxt, max_It] = max(data(contrac_start(i):contrac_end(i),1));
        contrac_max(i) = maxt;
        contrac_max_I(i) = max_It + contrac_start(i);
    end
    
    % compute RMS on 0.5s window around max
    RMS_max = NaN(2,4);
    for k=2:1:5
        for i=2:1:3
            work_zone = contrac_max_I(i)-0.5*1/(isi*10^-3):contrac_max_I(i)+0.5*1/(isi*10^-3);
            RMS_max(i,k) = mean(data(work_zone,k+4));
        end
    end
    
%     force(4:5) = contrac_max(2:3) - baseline;
    
    %% WORK ON NEUROSTIM @ BEGINNING OF FILE
    
    % find artefact of neurostim @ beginning of file
    contrac_neurostim = NaN(4,1);
    for k=2:1:4
        work_zone = data(1:round(size(data,1)/10),k);
        [~, contrac_neurostim_I]=max(abs(work_zone));
        contrac_neurostim(k) = contrac_neurostim_I;
        
        % Make sure artefact has been picked-up, not the M-wave
        work_zone = data(contrac_neurostim(k)-1000:contrac_neurostim(k)-50,k);
        potent = find(abs(work_zone)>abs(data(contrac_neurostim(k),2))/2, 1);
        if isempty(potent)
            
        else
            [~, real_contrac_I] = max(abs(work_zone));
            contrac_neurostim(k) = real_contrac_I + contrac_neurostim(k)-1000;
        end
    end
    
    
    % M wave amplitude, time peak to peak and area under curve for neurostim
    % @ beginning of file, on channels 2, 3 and 4
    M_wave_ex_max_I = NaN(4,1); M_wave_max = NaN(4,1);
    M_wave_ex_min_I = NaN(4,1); M_wave_min = NaN(4,1);
    M_wave_ex_start_I = NaN(4,1); M_wave_ex_start = NaN(4,1);
    M_wave_ex_end_I = NaN(4,1); M_wave_ex_end = NaN(4,1);
    win_after = 1000;
    for k=2:1:4
        [M_wave_max_t, M_wave_ex_max] = max(data(contrac_neurostim(k)+20 : contrac_neurostim(k)+2000,k));
        M_wave_max(k) = M_wave_max_t;
        M_wave_ex_max_I(k) = M_wave_ex_max + contrac_neurostim(k)+20;
        [M_wave_min_t, M_wave_ex_min] = min(data(contrac_neurostim(k)+20 : contrac_neurostim(k)+2000,k));
        M_wave_min(k) = M_wave_min_t;
        M_wave_ex_min_I(k) = M_wave_ex_min + contrac_neurostim(k)+20;
        
        % find M_wave start
        if M_wave_ex_max_I(k) < M_wave_ex_min_I(k)
            j=1; differ=1;
            while differ>=0
                differ = data(M_wave_ex_max_I(k)-j,k) - data(M_wave_ex_max_I(k)-j-1,k);
                j=j+1;
            end
            M_wave_ex_start_I(k) = M_wave_ex_max_I(k) - j;
            M_wave_ex_start(k) = data(M_wave_ex_start_I(k),k);
        else
            j=1; differ=1;
            while differ>=0
                differ = data(M_wave_ex_min_I(k)-j,k) - data(M_wave_ex_min_I(k)-j-1,k);
                j=j+1;
            end
            M_wave_ex_start_I(k) = M_wave_ex_min_I(k) - j;
            M_wave_ex_start(k) = data(M_wave_ex_start_I(k),k);
        end
        clearvars differ
        
        % find M-wave end
        j=1;
        while data(M_wave_ex_min_I(k) + j,k)<= 0.05
            j = j+1;
        end
        if j > 10 && j < win_after
            M_wave_ex_end_I(k) = M_wave_ex_min_I(k)+j;
            M_wave_ex_end(k) = data(M_wave_ex_min_I(k),k);
        else
            [M_wave_endt, M_wave_end_It] = max(data(M_wave_ex_min_I(k)+1:M_wave_ex_min_I(k) + win_after,k));
            M_wave_ex_end(k) = M_wave_endt;
            M_wave_ex_end_I(k) = M_wave_end_It + M_wave_ex_min_I(k) + 1;
        end
    end
    
    M_wave_amp = M_wave_max-M_wave_min;
    M_wave_duration = abs(M_wave_ex_min_I-M_wave_ex_max_I);
    M_wave_area = NaN(3,1);
    M_wave_area_2 = NaN(3,1);
    for k=1:1:3
        M_wave_area(k) = trapz_perso(abs(data(M_wave_ex_max_I(k+1):M_wave_ex_min_I(k+1),k+1)), fs);
        M_wave_area_2(k) = trapz_perso(abs(data(M_wave_ex_start_I(k+1):M_wave_ex_end_I(k+1),k+1)), fs);
    end
    
    clearvars work_zone temp contrac_neurostim_I potent real_contrac_I
    clearvars M_wave_ex_max M_wave_ex_min diff
    
    processed.serie_num = serie_num;
    processed.signal = signal;
    
    processed.contrac_start = contrac_start;
    processed.contrac_end = contrac_end;
    processed.contrac_max_I = contrac_max_I;
    processed.contrac_max = contrac_max;
    processed.Twitch_x = Twitch_x;
    processed.Twitch_y = Twitch_y;
    processed.HRT = HRT;
    processed.baseline = baseline;
    processed.contrac_neurostim = contrac_neurostim;
    processed.M_wave_ex_min_I = M_wave_ex_min_I;
    processed.M_wave_ex_max_I = M_wave_ex_max_I;
    processed.M_wave_ex_start_I = M_wave_ex_start_I;
    processed.M_wave_ex_end_I = M_wave_ex_end_I;
    processed.M_wave_max = M_wave_max;
    processed.M_wave_min = M_wave_min;
    processed.M_wave_area = M_wave_area;
    processed.M_wave_area_2 = M_wave_area_2;
    processed.M_wave_amp = M_wave_amp;
    processed.M_wave_duration = M_wave_duration;
    
    
elseif process_id == 3
    
    serie_num = 0;
    baseline = data(3,1);
    data(:,1) = data(:,1)-baseline;
    
    % find max
    [max_force, max_force_I] = max(data(:,1));
    
    
    % find beginning of exercise
    force_f = lowpass(data(:,1),1/(isi*10^-3)/1000,1/(isi*10^-3));
    work_zone = find(data(1:round(size(data,1)/10),1)>50);
    differ=1; j=1;
    if strcmp(pathname(end-11:end-1),'Gabriele_ND') == 1
        force_start = 4.5 * 1/(isi*10^-3);
    else
        while differ >= 0
            differ = force_f(work_zone(j+1)) - force_f(work_zone(j));
            j=j+1;
        end
        force_start = work_zone(j);
    end
    
    
    % find cessation of exercise
    if strcmp(pathname(end-9:end-1), 'Nicolas_D') == 1 || strcmp(sub_name, 'Diana') == 1
        force_end = find(force_f(round(size(data,1)/2):end,1)<1,1);
        force_end = force_end + round(size(data,1)/2);
    elseif strcmp(sub_name, 'Coralie') == 1
        force_end = size(data,1);
    elseif strcmp(pathname(end-10:end-1), 'Thibault_D') == 1
        force_end = find(data(round(120*1/(isi*10^-3)):end,1)<5,1);
        force_end = force_end + round(120*1/(isi*10^-3));
    else
        force_end = find(force_f(round(size(data,1)/2):end,1)<5,1);
        force_end = force_end + round(size(data,1)/2);
    end   
    
    % Windows wide of 10% of exercise time and mean, SD and CV in each window
    ten_percent = floor(force_end-force_start)/10;
    win_start = NaN(10,1); force_mean = NaN(10,1);
    force_SD = NaN(10,1); force_CV = NaN(10,1);
    for i=1:1:10
        win_start(i) = force_start+ten_percent*(i-1);
        force_mean(i) = mean(data(int64(win_start(i)):int64(win_start(i)+ten_percent),1));
        force_SD(i) = std(data(int64(win_start(i)):int64(win_start(i)+ten_percent),1));
        force_CV(i) = force_SD(i)/force_mean(i);
    end
    
    % mean RMS over the 10% windows
    RMS_mean = NaN(10,3);
    for k=2:1:4
        for i=1:1:10
            RMS_mean(i,k) = mean(data(int64(win_start(i)):int64(win_start(i)+ten_percent),k+4));
        end
    end
    
    signal.data = data;
    processed.force_mean = force_mean;
    processed.RMS_mean = RMS_mean;
    processed.serie_num = serie_num;
    processed.signal = signal;
    
    processed.max_force = max_force;
    processed.max_force_I = max_force_I;
    processed.win_start = win_start;
    processed.ten_percent = ten_percent;
    processed.force_start = force_start;
    processed.force_end = force_end;    
    
end