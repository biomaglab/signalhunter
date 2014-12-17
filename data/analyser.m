% analyse signal manip EMG Nico P
tic

clear all
close all

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


%% LOAD
[filename,pathname,filterindex] = uigetfile('*.mat');
cd(pathname)
load(filename)
si = 8848;
cd ../..


% find subject name
temp = find(pathname=='\');
temp2 = find(pathname=='_');
sub_name = pathname(temp(end-1)+1:temp2(end)-1);


% find dominant or non dominant leg
if temp(end) - temp2(end) == 2
    leg = 'D';
else
    leg = 'ND';
end

clearvars temp temp2


% Load threshold values
[num_T, txt_T, tab_T] = xlsread('thresholds.xls');
txt_T = txt_T(2:end,:);
find_name = strfind(txt_T,sub_name);
emptyIndex = cellfun(@isempty,find_name);  %# Find indices of empty cells
find_name(emptyIndex) = {0};               %# Fill empty cells with 0
find_name = logical(cell2mat(find_name));  %# Convert the cell array
line_to_read = find(find_name==1,1);
series_nb = str2double(filename(end-4));   % get series_nb 
line_to_read = line_to_read + series_nb - 1;

% Load sequence TMS neurostim
[num_S, txt_S, tab_S] = xlsread('SeqTMSandENS.xlsx');
find_name = strfind(txt_S,sub_name);
emptyIndex = cellfun(@isempty,find_name);  %# Find indices of empty cells
find_name(emptyIndex) = {0};               %# Fill empty cells with 0
find_name = logical(cell2mat(find_name));  %# Convert the cell array
line_to_read_2 = find(find_name==1,1);
line_to_read_2 = line_to_read_2 - 2;
order_TMS = num_S(line_to_read_2,1);

% switch sub_name
%     case{'Diana'}
%         order_TMS = 3;
%     case{'Jerome'}
%         order_TMS = 4;
% end



%% parameters of sensitivity to adjust detections throughout the file
baseline_duration = 1; % seconds, @ start of file
baseline_duration_contrac = 0.3; % seconds to take right before each contraction
superimposed_window = 0.10; % seconds
neurostim_p = 1; % set precision for detection of neurostim default = 5
EMG_p = 100; % set precision for detection of EMG activity
B_before_neurostim = [2/10;1/10]; % seconds. start and end points of baseline taken before neurostim
B_before_EMG = [10/10;8/10]; % seconds. start and end points of baseline taken before EMG activity

%clearvars find_name emptyIndex num_T txt_T tab_T line_to_read line_to_read_2

    
%% WORK ON FILES CALLED 'SERIE...'

if strcmp(filename(1:5),'Serie') == 1
    si = 0;
    
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
    to_keep_end = contrac(to_keep_start(2:end)-1);
    
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
        figure(1)
        plot(data(:,1))
        x=axis;
        hold on
        plot([x(1) x(2)],[baseline_threshold baseline_threshold],'k')
        legend('force','threshold')
        
        txt = ['only ' num2str(length(contrac_start)) ' contractions found, please ajust thresholds to increase precision for detection'];
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
        if isempty(find(data(work_zone_start(i):work_zone_end(i),1)<C_mean(i),1))
            stim(i) = work_zone_start(i);
            msgbox('please find the superimposed by hand, MATLAB is too confused')
        else
            stim(i) = find(data(work_zone_start(i):work_zone_end(i),1)<C_mean(i),1);
            stim(i) = stim(i) + work_zone_start(i);
        end
        
        
        clearvars work_zone
        
        % scan for superimposed force immediately before stim
        [superimposed_Ft superimposed_F_It] = max(data(round(stim(i) - superimposed_window * 1/(isi*10^-3)):round(stim(i)),1));
        superimposed_Bt = min(data(round(stim(i)-superimposed_window*1/(isi*10^-3)):round(stim(i) - superimposed_window * 1/(isi*10^-3) + superimposed_F_It),1));
        superimposed_Vt = superimposed_Ft - superimposed_Bt;
        superimposed_F(i) = superimposed_Ft;
        superimposed_B(i) = superimposed_Bt;
        superimposed_V(i) = superimposed_Vt;
        clearvars superimposed_Ft superimposed_F_It superimposed_Bt superimposed_Vt
        
        % scan for max away from stim
        [max_before_stim max_before_stim_I] = max(data(round(vol_contrac_start(i)):round(stim(i) - superimposed_window * 1/(isi*10^-3)),1));
        [max_after_stim max_after_stim_I] = max(data(stim(i):vol_contrac_end(i)));
        if max_before_stim > max_after_stim
            max_C(i) = max_before_stim;
            max_C_I(i) = max_before_stim_I + vol_contrac_start(i);
        else
            max_C(i) = max_after_stim;
            max_C_I(i) = max_after_stim_I + stim(i);
        end
        
        max_B(i) = mean(data(vol_contrac_start(i) - baseline_duration_contrac * 1/(isi*10^-3):vol_contrac_start(i) - baseline_duration_contrac/3 * 1/(isi*10^-3),1));
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
        RMS_max_contrac1(k) = mean(data(RMS_max_start_I:RMS_max_end_I,k));
    end
    RMS_max_contrac1(1:5) = [];
    
    
        
        
    %% WORK ON NEUROSTIM WHILE AT REST
    
    % amplitude, contraction time and HRT for the 3 neurostim while at rest
    
    neurostim_max = NaN(3,1); neurostim_B = NaN(3,1); std_neurostim_B = NaN(3,1);
    stim_contrac_start_p = NaN(3,1); contrac_time = NaN(3,1); HRT = NaN(3,1); HRT_abs = NaN(3,1);
    neurostim_max_I = NaN(3,1);
    search_contrac_start_p = NaN(3,300); search_contrac_start_p2 = NaN(3,300);
    
    for i=1:1:3
        
        [neurostim_maxt neurostim_max_It] = max(data(stim_contrac_start(i):stim_contrac_end(i),1));
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
                [max_M_wavet max_M_wave_It] = max(data(stim_contrac_start(i)-1/(isi*10^-3) : stim_contrac_start(i)-1/(isi*10^-3) + potent_max(end),k));
                max_M_wave(i,k) = max_M_wavet;
                max_M_wave_I(i,k) = max_M_wave_It + stim_contrac_start(i)-1/(isi*10^-3);
            else
                [max_M_wavet max_M_wave_It] = max(data(stim_contrac_start(i)-1/(isi*10^-3) + potent_max(break_point(1)+1) : stim_contrac_start(i)-1/(isi*10^-3) + potent_max(end),k));
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
                [min_M_wavet min_M_wave_It] = min(data(stim_contrac_start(i)-1/(isi*10^-3) : stim_contrac_start(i)-1/(isi*10^-3) + potent_min(end),k));
                min_M_wave(i,k) = min_M_wavet;
                min_M_wave_I(i,k) = min_M_wave_It + stim_contrac_start(i)-1/(isi*10^-3);
            else
                [min_M_wavet min_M_wave_It] = min(data(stim_contrac_start(i)-1/(isi*10^-3) + potent_min(break_point(1)+1) : stim_contrac_start(i)-1/(isi*10^-3) + potent_min(end),k));
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
                [M_wave_startt M_wave_start_It] = min(data(max_M_wave_I(i,k)-win_before:max_M_wave_I(i,k) - 1,k));
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
                [M_wave_endt M_wave_end_It] = max(data(min_M_wave_I(i,k)+1:min_M_wave_I(i,k) + win_after,k));
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
    EMG_VL_mean = mean(data(:,2));
    EMG_VL_std_alt = 10*std(data(:,2)); % LATER MAKE IT AN INPUT FOR USERS
    EMG_VL_threshold = EMG_VL_mean + EMG_VL_std_alt;
    EMG_VM_mean = mean(data(:,3));
    EMG_VM_std_alt = 10*std(data(:,3));
    EMG_VM_threshold = EMG_VM_mean + EMG_VM_std_alt;
    EMG_RF_mean = mean(data(:,4));
    EMG_RF_std_alt = 10*std(data(:,4));
    EMG_RF_threshold = EMG_RF_mean + EMG_RF_std_alt;
    
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
                potent = find(abs(work_zone)>abs(data(contrac_neurostim(i,k),k))/2);
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
                potent = find(abs(work_zone)>abs(data(contrac_neurostim(i,k),k))/2);
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
                j=1; diff=1;
                while diff>=0
                    diff = data(M_wave_ex_max_I(i,k)-j,k) - data(M_wave_ex_max_I(i,k)-j-1,k);
                    j=j+1;
                end
                M_wave_ex_start_I(i,k) = M_wave_ex_max_I(i,k) - j;
                M_wave_ex_start(i,k) = data(M_wave_ex_start_I(i,k),k);
            else
                j=1; diff=1;
                while diff>=0
                    diff = data(M_wave_ex_min_I(i,k)-j,k) - data(M_wave_ex_min_I(i,k)-j-1,k);
                    j=j+1;
                end
                M_wave_ex_start_I(i,k) = M_wave_ex_min_I(i,k) - j;
                M_wave_ex_start(i,k) = data(M_wave_ex_start_I(i,k),k);
            end
            clearvars diff
            
            % find M-wave end for neurostim during exercise
            j=1;
            while data(M_wave_ex_min_I(i,k) + j,k)<= 0.001 %0.05
                j = j+1;
            end
            if j > 10 && j < win_after
                M_wave_ex_end_I(i,k) = M_wave_ex_min_I(i,k)+j;
                M_wave_ex_end(i,k) = data(M_wave_ex_min_I(i,k),k);
            else
                [M_wave_endt M_wave_end_It] = max(data(M_wave_ex_min_I(i,k)+1:M_wave_ex_min_I(i,k) + win_after,k));
                M_wave_ex_end(i,k) = M_wave_endt;
                M_wave_ex_end_I(i,k) = M_wave_end_It + M_wave_ex_min_I(i,k) + 1;
            end
        end
    end
    
    
    
    clearvars work_zone temp contrac_neurostim_I potent real_contrac_I
    clearvars M_wave_ex_max M_wave_ex_min diff
    
    
    
    
    
    %% WORK ON FORCE CHANNEL TO FIND SUPERIMPOSED FORCE @ NEUROSTIM
    
    contrac_neurostim_max = NaN(3,1);
    contrac_neurostim_max_I = NaN(3,1);
    contrac_neurostim_min = NaN(3,1);
    contrac_neurostim_min_I = NaN(3,1);
    win_neuro=60;
    for i=2:1:4
        [contrac_neurostim_maxt contrac_neurostim_max_It] = max(data(contrac_neurostim(i,2)+win_neuro:contrac_neurostim(i,2)+2000,1));
        contrac_neurostim_max(i) = contrac_neurostim_maxt;
        contrac_neurostim_max_I(i) = contrac_neurostim_max_It + contrac_neurostim(i,2)+win_neuro;
        
        [contrac_neurostim_mint contrac_neurostim_min_It] = min(data(contrac_neurostim(i,2)+win_neuro:contrac_neurostim_max_I(i),1));
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
            [M_wave_MEP_maxt M_wave_MEP_max_It] = max(data(TMS_stim(i)+100:TMS_stim(i)+2000,k));
            M_wave_MEP_max(i,k) = M_wave_MEP_maxt;
            M_wave_MEP_max_I(i,k) = M_wave_MEP_max_It + TMS_stim(i)+100;
            
            [M_wave_MEP_mint M_wave_MEP_min_It] = min(data(TMS_stim(i)+100:TMS_stim(i)+2000,k));
            M_wave_MEP_min(i,k) = M_wave_MEP_mint;
            M_wave_MEP_min_I(i,k) = M_wave_MEP_min_It + TMS_stim(i)+100;
            
            % find M_wave start for TMS during exercise
            if M_wave_MEP_max_I(i,k) < M_wave_MEP_min_I(i,k)
                j=1; diff=1;
                while diff>=0
                    diff = data(M_wave_MEP_max_I(i,k)-j,k) - data(M_wave_MEP_max_I(i,k)-j-1,k);
                    j=j+1;
                end
                M_wave_MEP_start_I(i,k) = M_wave_MEP_max_I(i,k) - j;
                M_wave_MEP_start(i,k) = data(M_wave_MEP_start_I(i,k),k);
            else
                j=1; diff=1;
                while diff>=0
                    diff = data(M_wave_MEP_min_I(i,k)-j,k) - data(M_wave_MEP_min_I(i,k)-j-1,k);
                    j=j+1;
                end
                M_wave_MEP_start_I(i,k) = M_wave_MEP_min_I(i,k) - j;
                M_wave_MEP_start(i,k) = data(M_wave_MEP_start_I(i,k),k);
            end
            clearvars diff
            
            % find M-wave end for TMS during exercise
            j=1;
            while data(M_wave_MEP_min_I(i,k) + j,k)<= 0.05
                j = j+1;
            end
            if j > 10 && j < win_after
                M_wave_MEP_end_I(i,k) = M_wave_MEP_min_I(i,k)+j;
                M_wave_MEP_end(i,k) = data(M_wave_MEP_min_I(i,k),k);
            else
                [M_wave_endt M_wave_end_It] = max(data(M_wave_MEP_min_I(i,k)+1:M_wave_MEP_min_I(i,k) + win_after,k));
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
            elseif strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 7
                EMG_recov_point_t = M_wave_MEP_end_I(i,k)+ 1/(isi*10^-3);
            elseif strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 8
                EMG_recov_point_t = M_wave_MEP_end_I(i,k)+ 1/(isi*10^-3);
            elseif strcmp(pathname(end-8:end-1),'Jerome_D') == 1 && series_nb == 4
                EMG_recov_point_t = find(abs((data(M_wave_MEP_end_I(i,k)+(1/(isi*10^-3))/100*5:M_wave_MEP_end_I(i,k)+ 1/(isi*10^-3),k)))>pre_stim_EMG_std-pre_stim_EMG_std/1.1,1);
            else
                EMG_recov_point_t = find(abs((data(M_wave_MEP_end_I(i,k)+(1/(isi*10^-3))/100*5:M_wave_MEP_end_I(i,k)+ 1/(isi*10^-3),k)))>pre_stim_EMG_std,1);
            end
            EMG_recov_point(i,k) = EMG_recov_point_t + M_wave_MEP_end_I(i,k)+(1/(isi*10^-3))/100*5;
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
            RMS(i,k) = mean(data(work_zone(i,1):work_zone(i,2),k+4));
        end
    end
    
    
    
    %% FIGURES
    
    Time = 1:1:length(data); Time = Time' * isi*10^-3;
    
    % Figure with detected contractions
    figure('Name','Whole set of contractions + voluntary contractions characteristics','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
    subplot(3,4,1:4)
    plot(Time,data(:,1))
    hold on
    x=axis;
    % whole set of contractions
    %loop for voluntary contraction plots
    for i=1:1:4
        plot([vol_contrac_start(i)* isi*10^-3 vol_contrac_start(i)* isi*10^-3],[x(3) x(4)],'r');
        plot([vol_contrac_end* isi*10^-3 vol_contrac_end* isi*10^-3],[x(3) x(4)],'r');
        plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],[superimposed_F(i) superimposed_F(i)],'k');
        plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],[superimposed_B(i) superimposed_B(i)],'k');
        plot([(max_C_I(i)-0.5*1/(isi*10^-3))* isi*10^-3 (max_C_I(i)+0.5*1/(isi*10^-3))* isi*10^-3],[max_C(i) max_C(i)],'k')
        plot([(vol_contrac_start(i)-baseline_duration_contrac*1/(isi*10^-3))* isi*10^-3 (vol_contrac_start(i)-baseline_duration_contrac/3*1/(isi*10^-3))* isi*10^-3],[max_B(i) max_B(i)],'r')
    end
    title('detection of force production');
    xlabel('Time (s)')
    ylabel('Force (N)')
    hold off
    
    % loop for second row of graphs
    for j=5:1:8
        i=j-4;
        subplot(3,4,j)
        plot(Time(vol_contrac_start(i):vol_contrac_end(i)),data(vol_contrac_start(i):vol_contrac_end(i),1))
        hold on
        x=axis;
        axis([vol_contrac_start(i)* isi*10^-3 vol_contrac_end(i)* isi*10^-3 x(3) x(4)]);
        plot([vol_contrac_start(i)* isi*10^-3 vol_contrac_start(i)]* isi*10^-3,[x(3) x(4)],'r');
        plot([vol_contrac_end(i)* isi*10^-3 vol_contrac_end(i)* isi*10^-3],[x(3) x(4)],'r');
        plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],[superimposed_F(i) superimposed_F(i)],'k');
        plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],[superimposed_B(i) superimposed_B(i)],'k');
        plot([(max_C_I(i)-0.25*1/(isi*10^-3))* isi*10^-3 (max_C_I(i)+0.25*1/(isi*10^-3))* isi*10^-3],[max_C(i) max_C(i)],'k')
        to_plot = ['zoom on force plateau #' num2str(i)];
        title(to_plot);
        xlabel('Time (s)')
        ylabel('Force (N)')
        hold off
    end
    clearvars RMS_max_end_I RMS_max_start_I
    
    % loop for third row of graphs
    k=0;i=0;
    for j=15:1:21
        subplot(3,7,j)
        switch j
            case {15,16,18,20}
                i=i+1;
                plot(Time(round(stim(i)-superimposed_window*1/(isi*10^-3)-1000):round(stim(i))),data(round(stim(i)-superimposed_window*1/(isi*10^-3)-1000):round(stim(i)),1))
                x=axis;
                axis([(stim(i)-superimposed_window*1/(isi*10^-3)-1000)* isi*10^-3 stim(i)* isi*10^-3 x(3) x(4)]);
                hold on
                plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],[superimposed_F(i) superimposed_F(i)],'k');
                plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],[superimposed_B(i) superimposed_B(i)],'k');
            case {17,19,21}
                k=k+1;
                plot(Time(contrac_neurostim(k+1,2):contrac_neurostim(k+1,2)+2000),data(contrac_neurostim(k+1,2):contrac_neurostim(k+1,2)+2000,1))
                x=axis;
                axis([contrac_neurostim(k+1,2)* isi*10^-3 (contrac_neurostim(k+1,2)+2000)* isi*10^-3 x(3) x(4)]);
                hold on
                plot([(contrac_neurostim(k+1,2)+win_neuro)* isi*10^-3 (contrac_neurostim(k+1,2)+2000)* isi*10^-3],[contrac_neurostim_max(k+1) contrac_neurostim_max(k+1)],'k')
                plot([(contrac_neurostim(k+1,2)+win_neuro)* isi*10^-3 (contrac_neurostim(k+1,2)+2000)* isi*10^-3],[contrac_neurostim_min(k+1) contrac_neurostim_min(k+1)],'k')
        end
        to_plot = ['superimposed #' num2str(j-14)];
        title(to_plot);
        xlabel('Time (s)')
        ylabel('Force (N)')
        hold off
    end
    
    
    
    figure('Name','Whole set of contractions + neurostim while @ rest','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
    subplot(2,3,1:3)
    plot(Time,data(:,1))
    hold on
    x=axis;
    % whole set of contractions
    %loop for neurostim while at rest
    for i=1:1:3
        plot([stim_contrac_start_p(i)* isi*10^-3 stim_contrac_start_p(i)* isi*10^-3],[x(3) x(4)],'r')
        plot([stim_contrac_end(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3],[x(3) x(4)],'r')
        plot([stim_contrac_start_p(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3],[neurostim_max(i) neurostim_max(i)],'k')
        plot([(stim_contrac_start(i) - B_before_neurostim(1)*1/(isi*10^-3))* isi*10^-3 (stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3))* isi*10^-3],[neurostim_B(i) neurostim_B(i)],'k')
        plot([stim_contrac_start_p(i)* isi*10^-3 neurostim_max_I(i)* isi*10^-3],[mean(data(stim_contrac_start_p(i):stim_contrac_end(i),1)) mean(data(stim_contrac_start_p(i):stim_contrac_end(i),1))],'k')
        plot([neurostim_max_I(i)* isi*10^-3 HRT_abs(i)* isi*10^-3],[(neurostim_max(i)-neurostim_B(i))/2 + neurostim_B(i) (neurostim_max(i)-neurostim_B(i))/2 + neurostim_B(i)],'k')
    end
    title('detection of force production');
    xlabel('Time (s)')
    ylabel('Force (N)')
    hold off
    
    % loop for second row of graphs
    for j=4:1:6
        i=j-3;
        subplot(2,3,j)
        hold on
        plot(Time(stim_contrac_start(i) - B_before_neurostim(1)*1/(isi*10^-3):HRT_abs(i)+10000),data(stim_contrac_start(i) - B_before_neurostim(1)*1/(isi*10^-3):HRT_abs(i)+10000,1))
        x=axis;
        plot([stim_contrac_start_p(i)* isi*10^-3 stim_contrac_start_p(i)* isi*10^-3],[x(3) x(4)],'r')
        plot([stim_contrac_end(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3],[x(3) x(4)],'r')
        plot([stim_contrac_start_p(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3],[neurostim_max(i) neurostim_max(i)],'k')
        plot([(stim_contrac_start(i) - B_before_neurostim(1)*1/(isi*10^-3))* isi*10^-3 (stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3))* isi*10^-3],[neurostim_B(i) neurostim_B(i)],'g')
        plot([stim_contrac_start_p(i)* isi*10^-3 neurostim_max_I(i)* isi*10^-3],[mean(data(stim_contrac_start_p(i):stim_contrac_end(i),1)) mean(data(stim_contrac_start_p(i):stim_contrac_end(i),1))],'k')
        plot([neurostim_max_I(i)* isi*10^-3 HRT_abs(i)* isi*10^-3],[(neurostim_max(i)-neurostim_B(i))/2 + neurostim_B(i) (neurostim_max(i)-neurostim_B(i))/2 + neurostim_B(i)],'k')
        plot([neurostim_max_I(i)* isi*10^-3 neurostim_max_I(i)* isi*10^-3],[x(3) neurostim_max(i)],'k--')
        to_plot = ['zoom on neurostim while @ rest #' num2str(i)];
        title(to_plot);
        xlabel('Time (s)')
        ylabel('Force (N)')
        hold off
    end
    
    
    for k=2:1:4
        to_plot = ['Neurostim @ rest ' labels(k,:)];
        figure('Name',to_plot,'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        subplot(3,4,1:4)
        plot(Time,data(:,k))
        hold on
        to_plot = ['detection of EMG signal, ch' num2str(k) ': ' labels(k,:)];
        title(to_plot);
        xlabel('Time (s)')
        ylabel('EMG (Volts)')
        x=axis;
        %plot(Time(contrac_neurostim),data(contrac_neurostim,k),'ro')
        for i=2:1:3
            plot([M_wave_start_I(i,k)* isi*10^-3 M_wave_start_I(i,k)* isi*10^-3],[x(3) x(4)],'r')
            plot([M_wave_end_I(i,k)* isi*10^-3 M_wave_end_I(i,k)* isi*10^-3],[x(3) x(4)],'r')
        end
        legend('EMG','neurostim')
        hold off
        
        for i=6:1:7
            j=(i-5)*2-1;
            subplot(3,4,j+4:j+5)
            plot(Time(max_M_wave_I(i-4,k)-300:max_M_wave_I(i-4,k)+1000),data(max_M_wave_I(i-4,k)-300:max_M_wave_I(i-4,k)+1000,k))
            x=axis;
            hold on
            plot([max_M_wave_I(i-4,k)* isi*10^-3 max_M_wave_I(i-4,k)* isi*10^-3],[x(3) x(4)],'g')
            plot([min_M_wave_I(i-4,k)* isi*10^-3 min_M_wave_I(i-4,k)* isi*10^-3],[x(3) x(4)],'y')
            plot([M_wave_start_I(i-4,k)* isi*10^-3 M_wave_start_I(i-4,k)* isi*10^-3],[x(3) x(4)],'k')
            plot([M_wave_end_I(i-4,k)* isi*10^-3 M_wave_end_I(i-4,k)* isi*10^-3],[x(3) x(4)],'k')
            to_plot = ['zoom on neurostim M-wave while @ rest #' num2str(i-4)];
            title(to_plot);
            xlabel('Time (s)')
            ylabel('EMG (Volts)')
            legend('EMG','Max','Min','Start','End')
            hold off
        end
        
        for i=8:1:9
            j=(i-5)*2-1;
            subplot(3,4,j+4)
            area(Time(M_wave_start_I(i-6,k):M_wave_end_I(i-6,k)),data(M_wave_start_I(i-6,k):M_wave_end_I(i-6,k),k));
            to_plot = ['zoom on neurostim M-wave while @ rest #' num2str(i-6)];
            title(to_plot);
            xlabel('Time (s)')
            ylabel('EMG (Volts)')
            
            j=(i-5)*2-1;
            subplot(3,4,j+5)
            area(Time(max_M_wave_I(i-6,k):min_M_wave_I(i-6,k)),data(max_M_wave_I(i-6,k):min_M_wave_I(i-6,k),k));
            to_plot = ['zoom on neurostim M-wave while @ rest #' num2str(i-6)];
            title(to_plot);
            xlabel('Time (s)')
            ylabel('EMG (Volts)')
        end
    end
    
    
    
    for k=2:1:4
        to_plot = ['Neurostim @ exercise ' labels(k,:)];
        figure('Name',to_plot,'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        subplot(3,3,1:3)
        plot(Time,data(:,k))
        hold on
        to_plot = ['detection of EMG signal, ch' num2str(k) ': ' labels(k,:)];
        title(to_plot);
        xlabel('Time (s)')
        ylabel('EMG (Volts)')
        x=axis;
        plot([Time(contrac_neurostim(:,k)) Time(contrac_neurostim(:,k))],[x(3) x(4)],'r')
        legend('EMG','neurostim')
        hold off
        
        % loop for second row graphs
        l=2;
        for i=4:1:6
            subplot(3,3,i)
            plot(Time(M_wave_ex_max_I(l,k)-300:M_wave_ex_max_I(l,k)+1000),data(M_wave_ex_max_I(l,k)-300:M_wave_ex_max_I(l,k)+1000,k))
            x=axis;
            hold on
            plot([M_wave_ex_max_I(l,k)* isi*10^-3 M_wave_ex_max_I(l,k)* isi*10^-3],[x(3) x(4)],'g')
            plot([M_wave_ex_min_I(l,k)* isi*10^-3 M_wave_ex_min_I(l,k)* isi*10^-3],[x(3) x(4)],'y')
            plot([M_wave_ex_start_I(l,k)* isi*10^-3 M_wave_ex_start_I(l,k)* isi*10^-3],[x(3) x(4)],'k')
            plot([M_wave_ex_end_I(l,k)* isi*10^-3 M_wave_ex_end_I(l,k)* isi*10^-3],[x(3) x(4)],'k')
            to_plot = ['zoom on neurostim M-wave during exercise #' num2str(l)];
            title(to_plot);
            xlabel('Time (s)')
            ylabel('EMG (Volts)')
            legend('EMG','Max','Min','Start','End')
            hold off
            l=l+1;
        end
        
        % loop for third row graphs
        for i=7:1:9
            subplot(3,3,i)
            area(Time(M_wave_ex_start_I(i-5,k):M_wave_ex_end_I(i-5,k)),data(M_wave_ex_start_I(i-5,k):M_wave_ex_end_I(i-5,k),k));
            to_plot = ['Neurostim exercise #' num2str(i-5)];
            title(to_plot);
            xlabel('Time (s)')
            ylabel('EMG (Volts)')
        end
    end
    
    
    
    for k=2:1:4
        to_plot = ['TMS & MEP ' labels(k,:)];
        figure('Name',to_plot,'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
        subplot(3,6,1:6)
        plot(Time,data(:,k))
        hold on
        to_plot = ['detection of EMG signal, ch' num2str(k) ': ' labels(k,:)];
        title(to_plot);
        xlabel('Time (s)')
        ylabel('EMG (Volts)')
        x=axis;
        plot([Time(TMS_stim) Time(TMS_stim)],[x(3) x(4)],'r')
        legend('EMG','TMS')
        hold off
        
        % loop for second row graphs
        l=1;
        for i=7:2:12
            subplot(3,6,i:i+1)
            plot(Time(TMS_stim(l)-round(win_pre_stim*10^-3*1/(isi*10^-3)):EMG_recov_point(l,k)+5000),data(TMS_stim(l)-round(win_pre_stim*10^-3*1/(isi*10^-3)):EMG_recov_point(l,k)+5000,k))
            x=axis;
            hold on
            plot([M_wave_MEP_max_I(l,k)* isi*10^-3 M_wave_MEP_max_I(l,k)* isi*10^-3],[x(3) x(4)],'g')
            plot([M_wave_MEP_min_I(l,k)* isi*10^-3 M_wave_MEP_min_I(l,k)* isi*10^-3],[x(3) x(4)],'y')
            plot([M_wave_MEP_start_I(l,k)* isi*10^-3 M_wave_MEP_start_I(l,k)* isi*10^-3],[x(3) x(4)],'k')
            plot([M_wave_MEP_end_I(l,k)* isi*10^-3 M_wave_MEP_end_I(l,k)* isi*10^-3],[x(3) x(4)],'k')
            plot([EMG_recov_point(l,k)* isi*10^-3 EMG_recov_point(l,k)* isi*10^-3],[x(3) x(4)],'--r')
            to_plot = ['zoom on TMS M-wave during exercise #' num2str(l)];
            title(to_plot);
            xlabel('Time (s)')
            ylabel('EMG (Volts)')
            %legend('EMG','Max','Min','Start','End')
            hold off
            l=l+1;
        end
        
        % loop for third row graphs
        for i=8:1:10
            j=(i-5)*2-1;
            subplot(3,6,j+8)
            area(Time(M_wave_MEP_start_I(i-7,k):M_wave_MEP_end_I(i-7,k)),data(M_wave_MEP_start_I(i-7,k):M_wave_MEP_end_I(i-7,k),k));
            to_plot = ['TMS during exercise #' num2str(i-7)];
            title(to_plot);
            xlabel('Time (s)')
            ylabel('EMG (Volts)')
            
            subplot(3,6,j+9)
            area(Time(M_wave_MEP_max_I(i-7,k):M_wave_MEP_min_I(i-7,k)),data(M_wave_MEP_max_I(i-7,k):M_wave_MEP_min_I(i-7,k),k));
            to_plot = ['TMS during exercise #' num2str(i-7)];
            title(to_plot);
            xlabel('Time (s)')
            ylabel('EMG (Volts)')
        end
    end
    
    
    
    
    clearvars h i j k l potent_max potent_max_diff potent_min search_contrac_start_p
    clearvars search_contrac_start_p2 start_sample substrac x to_plot
    clearvars win_after win_before work_zone work_zone_start work_zone_end win_neuro
  

    
    %% OUTPUT
    
    % for excel sheet 'force value'
    output_1 = [max_C(1) - max_B(1) ; superimposed_F(1) - superimposed_B(1) ; ...
        superimposed_B(1) - max_B(1) ; neurostim_max(1) - neurostim_B(1) ; ...
        (neurostim_max_I(1) - stim_contrac_start_p(1))* isi ; (HRT_abs(1) - neurostim_max_I(1))* isi ; ...
        neurostim_max(2) - neurostim_B(2) ; (neurostim_max_I(2) - stim_contrac_start_p(2))* isi ; ...
        (HRT_abs(2) - neurostim_max_I(2))* isi];
    if order_TMS == 1;
        output_2 = [max_C(2) - max_B(2) ; superimposed_F(2) - superimposed_B(2) ; ...
            superimposed_B(2) - max_B(2) ; contrac_neurostim_max(2) - contrac_neurostim_min(2) ; ...
            contrac_neurostim_min(2) - max_B(2) ; neurostim_max(3) - neurostim_B(3) ; ...
            (neurostim_max_I(3) - stim_contrac_start_p(3))* isi ; (HRT_abs(3) - neurostim_max_I(3))* isi];
        output_3 = [max_C(3) - max_B(3) ; superimposed_F(3) - superimposed_B(3) ; ...
            superimposed_B(3) - max_B(3) ; contrac_neurostim_max(3) - contrac_neurostim_min(3) ; ...
            contrac_neurostim_min(3) - max_B(3)];
        output_4 = [max_C(4) - max_B(4) ; superimposed_F(4) - superimposed_B(4) ; ...
            superimposed_B(4) - max_B(4) ; contrac_neurostim_max(4) - contrac_neurostim_min(4) ; ...
            contrac_neurostim_min(4) - max_B(4)];
    else
        output_2 = [max_C(2) - max_B(2) ; contrac_neurostim_max(1) - contrac_neurostim_min(1) ; ...
            contrac_neurostim_min(1) - max_B(2) ; superimposed_F(2) - superimposed_B(2) ; ...
            superimposed_B(2) - max_B(2) ; neurostim_max(3) - neurostim_B(3) ; ...
            (neurostim_max_I(3) - stim_contrac_start_p(3))* isi ; (HRT_abs(3) - neurostim_max_I(3))* isi];
        output_3 = [max_C(3) - max_B(3) ; contrac_neurostim_max(2) - contrac_neurostim_min(2) ; ...
            contrac_neurostim_min(2) - max_B(3) ; superimposed_F(3) - superimposed_B(3) ; ...
            superimposed_B(3) - max_B(3) ];
        output_4 = [max_C(4) - max_B(4) ; contrac_neurostim_max(3) - contrac_neurostim_min(3) ; ...
            contrac_neurostim_min(3) - max_B(4) ; superimposed_F(4) - superimposed_B(4) ; ...
            superimposed_B(4) - max_B(4) ];
    end
    
    
    % for excel sheet 'M-wave MEP RMS'
    output_13 = [data(max_M_wave_I(2,2),2) - data(min_M_wave_I(2,2),2) ; ...
        abs(min_M_wave_I(2,2) - max_M_wave_I(2,2)) * isi ; ...
        trapz(abs(data(max_M_wave_I(2,2):min_M_wave_I(2,2),2))) ; ...
        trapz(abs(data(M_wave_start_I(2,2):M_wave_end_I(2,2),2))) ; ...
        data(max_M_wave_I(2,3),3) - data(min_M_wave_I(2,3),3) ; ...
        abs(min_M_wave_I(2,3) - max_M_wave_I(2,3)) * isi ; ...
        trapz(abs(data(max_M_wave_I(2,3):min_M_wave_I(2,3),3))) ; ...
        trapz(abs(data(M_wave_start_I(2,3):M_wave_end_I(2,3),3))) ; ...
        data(max_M_wave_I(2,4),4) - data(min_M_wave_I(2,4),4) ; ...
        abs(min_M_wave_I(2,4) - max_M_wave_I(2,4)) * isi ; ...
        trapz(abs(data(max_M_wave_I(2,4):min_M_wave_I(2,4),4))) ; ...
        trapz(abs(data(M_wave_start_I(2,4):M_wave_end_I(2,4),4))) ];
    output_5 = [RMS(1,2) ; RMS(1,3) ; RMS(1,4)];
    output_6 = [data(M_wave_ex_max_I(2,2),2)-data(M_wave_ex_min_I(2,2),2) ; ...
        abs(M_wave_ex_max_I(2,2) - M_wave_ex_min_I(2,2)) * isi ; ...
        trapz(abs(data(M_wave_ex_max_I(2,2):M_wave_ex_min_I(2,2),2))) ; ...
        trapz(abs(data(M_wave_ex_start_I(2,2):M_wave_ex_end_I(2,2),2))) ; ...
        data(M_wave_ex_max_I(2,3),3)-data(M_wave_ex_min_I(2,3),3) ; ...
        abs(M_wave_ex_max_I(2,3) - M_wave_ex_min_I(2,3)) ; ...
        trapz(abs(data(M_wave_ex_max_I(2,3):M_wave_ex_min_I(2,3),3))) ; ...
        trapz(abs(data(M_wave_ex_start_I(2,3):M_wave_ex_end_I(2,3),3))) ; ...
        data(M_wave_ex_max_I(2,4),4)-data(M_wave_ex_min_I(2,4),4) ; ...
        abs(M_wave_ex_max_I(2,4) - M_wave_ex_min_I(2,4)) ; ...
        trapz(abs(data(M_wave_ex_max_I(2,4):M_wave_ex_min_I(2,4),4))) ; ...
        trapz(abs(data(M_wave_ex_start_I(2,4):M_wave_ex_end_I(2,4),4)))];
    output_7 = [M_wave_MEP_max(1,2) - M_wave_MEP_min(1,2) ; ...
        abs(M_wave_MEP_min_I(1,2) - M_wave_MEP_max_I(1,2)) * isi ; ...
        trapz(abs(data(M_wave_MEP_max_I(1,2):M_wave_MEP_min_I(1,2),2))); ...
        trapz(abs(data(M_wave_MEP_start_I(1,2):M_wave_MEP_end_I(1,2),2))); ... 
        (EMG_recov_point(1,2) - TMS_stim (1)) * isi ; ...
        NaN ; ...
        M_wave_MEP_max(1,3) - M_wave_MEP_min(1,3) ; ...
        abs(M_wave_MEP_min_I(1,3) - M_wave_MEP_max_I(1,3)) * isi ; ...
        trapz(abs(data(M_wave_MEP_max_I(1,3):M_wave_MEP_min_I(1,3),3))); ...
        trapz(abs(data(M_wave_MEP_start_I(1,3):M_wave_MEP_end_I(1,2),3))); ... 
        (EMG_recov_point(1,3) - TMS_stim (1)) * isi ; ...
        NaN ; ...
        M_wave_MEP_max(1,4) - M_wave_MEP_min(1,4) ; ...
        abs(M_wave_MEP_min_I(1,4) - M_wave_MEP_max_I(1,4)) * isi ; ...
        trapz(abs(data(M_wave_MEP_max_I(1,4):M_wave_MEP_min_I(1,4),4))); ...
        trapz(abs(data(M_wave_MEP_start_I(1,4):M_wave_MEP_end_I(1,4),4))); ... 
        (EMG_recov_point(1,4) - TMS_stim (1)) * isi ; ...
        NaN ];
    output_8 = [data(max_M_wave_I(3,2),2) - data(min_M_wave_I(3,2),2) ; ...
        abs(min_M_wave_I(3,2) - max_M_wave_I(3,2)) * isi ; ...
        trapz(abs(data(max_M_wave_I(3,2):min_M_wave_I(3,2),2))) ; ...
        trapz(abs(data(M_wave_start_I(3,2):M_wave_end_I(3,2),2))) ; ...
        data(max_M_wave_I(3,3),3) - data(min_M_wave_I(3,3),3) ; ...
        abs(min_M_wave_I(3,3) - max_M_wave_I(3,3)) * isi ; ...
        trapz(abs(data(max_M_wave_I(3,3):min_M_wave_I(3,3),3))) ; ...
        trapz(abs(data(M_wave_start_I(3,3):M_wave_end_I(3,3),3))) ; ...
        data(max_M_wave_I(3,4),4) - data(min_M_wave_I(3,4),4) ; ...
        abs(min_M_wave_I(3,4) - max_M_wave_I(3,4)) * isi ; ...
        trapz(abs(data(max_M_wave_I(3,4):min_M_wave_I(3,4),4))) ; ...
        trapz(abs(data(M_wave_start_I(3,4):M_wave_end_I(3,4),4))) ];
    output_9 = [data(M_wave_ex_max_I(3,2),2)-data(M_wave_ex_min_I(3,2),2) ; ...
        abs(M_wave_ex_max_I(3,2) - M_wave_ex_min_I(3,2)) * isi ; ...
        trapz(abs(data(M_wave_ex_max_I(3,2):M_wave_ex_min_I(3,2),2))) ; ...
        trapz(abs(data(M_wave_ex_start_I(3,2):M_wave_ex_end_I(3,2),2))) ; ...
        data(M_wave_ex_max_I(3,3),3)-data(M_wave_ex_min_I(3,3),3) ; ...
        abs(M_wave_ex_max_I(3,3) - M_wave_ex_min_I(3,3)) ; ...
        trapz(abs(data(M_wave_ex_max_I(3,3):M_wave_ex_min_I(3,3),3))) ; ...
        trapz(abs(data(M_wave_ex_start_I(3,3):M_wave_ex_end_I(3,3),3))) ; ...
        data(M_wave_ex_max_I(3,4),4)-data(M_wave_ex_min_I(3,4),4) ; ...
        abs(M_wave_ex_max_I(3,4) - M_wave_ex_min_I(3,4)) ; ...
        trapz(abs(data(M_wave_ex_max_I(3,4):M_wave_ex_min_I(3,4),4))) ; ...
        trapz(abs(data(M_wave_ex_start_I(3,4):M_wave_ex_end_I(3,4),4)))];
    output_10 = [M_wave_MEP_max(2,2) - M_wave_MEP_min(2,2) ; ...
        abs(M_wave_MEP_min_I(2,2) - M_wave_MEP_max_I(2,2)) * isi ; ...
        trapz(abs(data(M_wave_MEP_max_I(2,2):M_wave_MEP_min_I(2,2),2))); ...
        trapz(abs(data(M_wave_MEP_start_I(2,2):M_wave_MEP_end_I(2,2),2))); ... 
        (EMG_recov_point(2,2) - TMS_stim (2)) * isi ; ...
        NaN ; ...
        M_wave_MEP_max(2,3) - M_wave_MEP_min(2,3) ; ...
        abs(M_wave_MEP_min_I(2,3) - M_wave_MEP_max_I(2,3)) * isi ; ...
        trapz(abs(data(M_wave_MEP_max_I(2,3):M_wave_MEP_min_I(2,3),3))); ...
        trapz(abs(data(M_wave_MEP_start_I(2,3):M_wave_MEP_end_I(2,2),3))); ... 
        (EMG_recov_point(2,3) - TMS_stim (2)) * isi ; ...
        NaN ; ...
        M_wave_MEP_max(2,4) - M_wave_MEP_min(2,4) ; ...
        abs(M_wave_MEP_min_I(2,4) - M_wave_MEP_max_I(2,4)) * isi ; ...
        trapz(abs(data(M_wave_MEP_max_I(2,4):M_wave_MEP_min_I(2,4),4))); ...
        trapz(abs(data(M_wave_MEP_start_I(2,4):M_wave_MEP_end_I(2,4),4))); ... 
        (EMG_recov_point(2,4) - TMS_stim (2)) * isi ; ...
        NaN ];
    output_11 = [data(M_wave_ex_max_I(4,2),2)-data(M_wave_ex_min_I(4,2),2) ; ...
        abs(M_wave_ex_max_I(4,2) - M_wave_ex_min_I(4,2)) * isi ; ...
        trapz(abs(data(M_wave_ex_max_I(4,2):M_wave_ex_min_I(4,2),2))) ; ...
        trapz(abs(data(M_wave_ex_start_I(4,2):M_wave_ex_end_I(4,2),2))) ; ...
        data(M_wave_ex_max_I(4,3),3)-data(M_wave_ex_min_I(4,3),3) ; ...
        abs(M_wave_ex_max_I(4,3) - M_wave_ex_min_I(4,3)) ; ...
        trapz(abs(data(M_wave_ex_max_I(4,3):M_wave_ex_min_I(4,3),3))) ; ...
        trapz(abs(data(M_wave_ex_start_I(4,3):M_wave_ex_end_I(4,3),3))) ; ...
        data(M_wave_ex_max_I(4,4),4)-data(M_wave_ex_min_I(4,4),4) ; ...
        abs(M_wave_ex_max_I(4,4) - M_wave_ex_min_I(4,4)) ; ...
        trapz(abs(data(M_wave_ex_max_I(4,4):M_wave_ex_min_I(4,4),4))) ; ...
        trapz(abs(data(M_wave_ex_start_I(4,4):M_wave_ex_end_I(4,4),4)))];
    output_12 = [M_wave_MEP_max(3,2) - M_wave_MEP_min(3,2) ; ...
        abs(M_wave_MEP_min_I(3,2) - M_wave_MEP_max_I(3,2)) * isi ; ...
        trapz(abs(data(M_wave_MEP_max_I(3,2):M_wave_MEP_min_I(3,2),2))); ...
        trapz(abs(data(M_wave_MEP_start_I(3,2):M_wave_MEP_end_I(3,2),2))); ... 
        (EMG_recov_point(3,2) - TMS_stim (3)) * isi ; ...
        NaN ; ...
        M_wave_MEP_max(3,3) - M_wave_MEP_min(3,3) ; ...
        abs(M_wave_MEP_min_I(3,3) - M_wave_MEP_max_I(3,3)) * isi ; ...
        trapz(abs(data(M_wave_MEP_max_I(3,3):M_wave_MEP_min_I(3,3),3))); ...
        trapz(abs(data(M_wave_MEP_start_I(3,3):M_wave_MEP_end_I(3,2),3))); ... 
        (EMG_recov_point(3,3) - TMS_stim (3)) * isi ; ...
        NaN ; ...
        M_wave_MEP_max(3,4) - M_wave_MEP_min(3,4) ; ...
        abs(M_wave_MEP_min_I(3,4) - M_wave_MEP_max_I(3,4)) * isi ; ...
        trapz(abs(data(M_wave_MEP_max_I(3,4):M_wave_MEP_min_I(3,4),4))); ...
        trapz(abs(data(M_wave_MEP_start_I(3,4):M_wave_MEP_end_I(3,4),4))); ... 
        (EMG_recov_point(3,4) - TMS_stim (3)) * isi ; ...
        NaN ];
    
    switch serie_num
        case 1
            cell_to_write = {'H7';'H16';'H24';'H29'};
            cell_to_write_2 = {'I14';'I26';'I29';'I41';'I59';'I71';'I83';'I101';'I113'};
        case 2
            cell_to_write = {'H34';'H43';'H51';'H56'};
            cell_to_write_2 = {'I131';'I143';'I146';'I158';'I176';'I188';'I200';'I218';'I230'};
        case 3
            cell_to_write = {'H61';'H70';'H78';'H83'};
            cell_to_write_2 = {'I248';'I260';'I263';'I275';'I293';'I305';'I317';'I335';'I347'};
        case 4
            cell_to_write = {'H88';'H97';'H105';'H110'};
            cell_to_write_2 = {'I365';'I377';'I380';'I392';'I410';'I422';'I434';'I452';'I464'};
        case 5
            cell_to_write = {'H115';'H124';'H132';'H137'};
            cell_to_write_2 = {'I482';'I494';'I497';'I509';'I527';'I539';'I551';'I569';'I581'};
        case 6
            cell_to_write = {'H142';'H151';'H159';'H164'};
            cell_to_write_2 = {'I599';'I611';'I614';'I626';'I644';'I656';'I668';'I686';'I698'};
        case 7
            cell_to_write = {'H169';'H178';'H186';'H191'};
            cell_to_write_2 = {'I716';'I728';'I731';'I743';'I761';'I773';'I785';'I803';'I815'};
        case 8
            cell_to_write = {'H196';'H205';'H213';'H218'};
            cell_to_write_2 = {'I833';'I845';'I848';'I860';'I878';'I890';'I902';'I920';'I932'};
    end
    
    output_filename = [sub_name '_' leg '.xlsx'];
    cd('Output')
    if exist(output_filename,'file') == 2
        
    else
        cd ..\
        copyfile('template.xlsx','Output')
        cd('Output')
        movefile('template.xlsx',output_filename)
        output_txt = cell(948,2);
        output_txt(:,1) = {sub_name};
        output_txt(:,2) = {leg};
        xlswrite(output_filename,output_txt,'Force Values','A2')
        xlswrite(output_filename,output_txt,'M_wave MEP RMS','A2')
        xlswrite(output_filename,output_txt,'MVC_2min','A2')
    end
    
    xlswrite(output_filename,output_1,'Force Values',cell_to_write{1})
    xlswrite(output_filename,output_2,'Force Values',cell_to_write{2})
    xlswrite(output_filename,output_3,'Force Values',cell_to_write{3})
    xlswrite(output_filename,output_4,'Force Values',cell_to_write{4})
    xlswrite(output_filename,output_13,'M_wave MEP RMS',cell_to_write_2{1})
    xlswrite(output_filename,output_5,'M_wave MEP RMS',cell_to_write_2{2})
    xlswrite(output_filename,output_6,'M_wave MEP RMS',cell_to_write_2{3})
    xlswrite(output_filename,output_7,'M_wave MEP RMS',cell_to_write_2{4})
    xlswrite(output_filename,output_8,'M_wave MEP RMS',cell_to_write_2{5})
    xlswrite(output_filename,output_9,'M_wave MEP RMS',cell_to_write_2{6})
    xlswrite(output_filename,output_10,'M_wave MEP RMS',cell_to_write_2{7})
    xlswrite(output_filename,output_11,'M_wave MEP RMS',cell_to_write_2{8})
    xlswrite(output_filename,output_12,'M_wave MEP RMS',cell_to_write_2{9})
    
    cd ..\
    
    clearvars cell_to_write

    
    
elseif strcmp(filename(1:6),'MVCpre') == 1
    si=0;

    vert_sensitiv = 100; % A.U. Modifies threshold detection (default = 100, cf. Excel file called thresholds, root folder)
    temp_sensitiv = 0.3; % seconds. No 2nd contraction possible in this lap of time (default = 0.3 cf. Excel file called thresholds, root folder)

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
    to_keep_end = contrac(to_keep_start(2:end)-1);
    
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
    
    [Twitch_y Twitch_x] = max(data(contrac_start(1):contrac_end(1)));
    Twitch_x = Twitch_x + contrac_start(1);
    output(1) = Twitch_y - baseline;
    output(2) = (Twitch_x - contrac_start(1))* isi;
    HRT = find(data(Twitch_x:contrac_end(1)) < (Twitch_y-baseline)/2+baseline ,1);
    HRT = HRT + Twitch_x;
    output(3) = (HRT - Twitch_x) * isi;
    
    
    
    %% WORK ON MAX
    
    % find max
    contrac_max = NaN(3,1); contrac_max_I = NaN(3,1);
    for i=2:1:3
        [maxt max_It] = max(data(contrac_start(i):contrac_end(i),1));
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
    
    output(4:5) = contrac_max(2:3) - baseline;
    
    
    
    %% WORK ON NEUROSTIM @ BEGINNING OF FILE
    
    % find artefact of neurostim @ beginning of file
    contrac_neurostim = NaN(4,1);
    for k=2:1:4
        work_zone = data(1:round(size(data,1)/10),k);
        [~, contrac_neurostim_I]=max(abs(work_zone));
        contrac_neurostim(k) = contrac_neurostim_I;
        
        % Make sure artefact has been picked-up, not the M-wave
        work_zone = data(contrac_neurostim(k)-1000:contrac_neurostim(k)-50,k);
        potent = find(abs(work_zone)>abs(data(contrac_neurostim(k),2))/2);
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
            j=1; diff=1;
            while diff>=0
                diff = data(M_wave_ex_max_I(k)-j,k) - data(M_wave_ex_max_I(k)-j-1,k);
                j=j+1;
            end
            M_wave_ex_start_I(k) = M_wave_ex_max_I(k) - j;
            M_wave_ex_start(k) = data(M_wave_ex_start_I(k),k);
        else
            j=1; diff=1;
            while diff>=0
                diff = data(M_wave_ex_min_I(k)-j,k) - data(M_wave_ex_min_I(k)-j-1,k);
                j=j+1;
            end
            M_wave_ex_start_I(k) = M_wave_ex_min_I(k) - j;
            M_wave_ex_start(k) = data(M_wave_ex_start_I(k),k);
        end
        clearvars diff
        
        % find M-wave end
        j=1;
        while data(M_wave_ex_min_I(k) + j,k)<= 0.05
            j = j+1;
        end
        if j > 10 && j < win_after
            M_wave_ex_end_I(k) = M_wave_ex_min_I(k)+j;
            M_wave_ex_end(k) = data(M_wave_ex_min_I(k),k);
        else
            [M_wave_endt M_wave_end_It] = max(data(M_wave_ex_min_I(k)+1:M_wave_ex_min_I(k) + win_after,k));
            M_wave_ex_end(k) = M_wave_endt;
            M_wave_ex_end_I(k) = M_wave_end_It + M_wave_ex_min_I(k) + 1;
        end
    end
    
    M_wave_amp = M_wave_max-M_wave_min;
    M_wave_duration = abs(M_wave_ex_min_I-M_wave_ex_max_I);
    M_wave_area = NaN(3,1);
    M_wave_area_2 = NaN(3,1);
    output_3 = NaN(12,1);
    for k=1:1:3
        M_wave_area(k) = trapz(abs(data(M_wave_ex_max_I(k+1):M_wave_ex_min_I(k+1),k+1)));
        M_wave_area_2(k) = trapz(abs(data(M_wave_ex_start_I(k+1):M_wave_ex_end_I(k+1),k+1)));
    end
    
    output_3(1:4,1) = [M_wave_amp(2);M_wave_duration(2);M_wave_area(1);M_wave_area_2(1)];
    output_3(5:8,1) = [M_wave_amp(3);M_wave_duration(3);M_wave_area(2);M_wave_area_2(2)];
    output_3(9:12,1) = [M_wave_amp(4);M_wave_duration(4);M_wave_area(3);M_wave_area_2(3)];
    
    
    clearvars work_zone temp contrac_neurostim_I potent real_contrac_I
    clearvars M_wave_ex_max M_wave_ex_min diff
    
    output = output';
    
    
    %% FIGURES
    
    Time = 1:1:length(data); Time = Time' * isi*10^-3;
    
    figure('Name','Force channel MVC pre','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
    subplot(2,4,1:4)
    plot(Time,data(:,1))
    hold on
    x=axis;
    plot([Time(contrac_start) Time(contrac_start)],[x(3) x(4)],'r')
    plot([Time(contrac_end) Time(contrac_end)],[x(3) x(4)],'r')
    for i=2:1:3
        plot([Time(contrac_max_I(i)-10000) Time(contrac_max_I(i)+10000)],[contrac_max(i) contrac_max(i)],'k')
    end
    
    subplot(2,4,5:6)
    plot(Time(Twitch_x-5000:Twitch_x+5000),data(Twitch_x-5000:Twitch_x+5000,1))
    hold on
    x=axis;
    plot([Time(Twitch_x-200) Time(Twitch_x+200)],[Twitch_y Twitch_y],'r')
    plot([Time(Twitch_x) Time(Twitch_x)],[x(3) x(4)],'--k')
    plot([Time(contrac_start(1)) Time(contrac_start(1))],[x(3) x(4)],'k')
    plot([Time(HRT) Time(HRT)],[x(3) x(4)],'k')
    plot([Time(contrac_start(1)) Time(Twitch_x)],[(x(4)-x(3))/2+x(3)+5 (x(4)-x(3))/2+x(3)+5],'--k')
    plot([Time(Twitch_x) Time(HRT)],[(x(4)-x(3))/2+x(3) (x(4)-x(3))/2+x(3)],'--k')
    plot([x(1) (x(2)-x(1))/10+x(1)],[baseline baseline],'r')
    
    figure('Name','EMG channels MVC pre','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
    for k=1:1:3
        subplot(2,3,k)
        plot(Time(contrac_neurostim(k+1)-300:contrac_neurostim(k+1)+1500),data(contrac_neurostim(k+1)-300:contrac_neurostim(k+1)+1500,k+1))
        hold on
        x=axis;
        axis([Time(contrac_neurostim(k+1)-300) Time(contrac_neurostim(k+1)+1500) x(3) x(4)])
        %plot([Time(contrac_neurostim(k+1)) Time(contrac_neurostim(k+1))],[x(3) x(4)],'r')
        plot([Time(M_wave_ex_max_I(k+1)) Time(M_wave_ex_max_I(k+1))],[x(3) x(4)],'g')
        plot([Time(M_wave_ex_min_I(k+1)) Time(M_wave_ex_min_I(k+1))],[x(3) x(4)],'y')
        plot([Time(M_wave_ex_start_I(k+1)) Time(M_wave_ex_start_I(k+1))],[x(3) x(4)],'k')
        plot([Time(M_wave_ex_end_I(k+1)) Time(M_wave_ex_end_I(k+1))],[x(3) x(4)],'k')
        to_plot = ['M-wave for ' labels(k+1,:)];
        title(to_plot)
        xlabel('time (s)')
        ylabel('EMG (V)')
        subplot(2,3,k+3)
        area(Time(M_wave_ex_start_I(k+1):M_wave_ex_end_I(k+1)),data(M_wave_ex_start_I(k+1):M_wave_ex_end_I(k+1),k+1))
    end
    clearvars to_plot
    
    
    %% OUTPUT
    
    output_filename = [sub_name '_' leg '.xlsx'];
    cd('Output')
    if exist(output_filename,'file') == 2
        xlswrite(output_filename,output,'Force Values','H2')
        xlswrite(output_filename,output_3,'M_wave MEP RMS','I2')
    else
        cd ..\
        copyfile('template.xlsx','Output')
        cd('Output')
        movefile('template.xlsx',output_filename)
        xlswrite(output_filename,output,'Force Values','H2')
        xlswrite(output_filename,output_3,'M_wave MEP RMS','I2')
        output_2 = cell(221,2);
        output_2(:,1) = {sub_name};
        output_2(:,2) = {leg};
        xlswrite(output_filename,output_2,'Force Values','A2')
        xlswrite(output_filename,output_2,'M_wave MEP RMS','A2')
        xlswrite(output_filename,output_2,'MVC_2min','A2')
    end
    cd ..\
    
    clearvars i j k num_S txt_S tab_S x filterindex order_TMS output_2

elseif strcmp(filename(1:7),'MVC2min') == 1
    si=0;
    
    baseline = data(3,1);
    data(:,1) = data(:,1)-baseline;
    
    % find max
    [max_force max_force_I] = max(data(:,1));
    
    
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
        force_mean(i) = mean(data(win_start(i):win_start(i)+ten_percent,1));
        force_SD(i) = std(data(win_start(i):win_start(i)+ten_percent,1));
        force_CV(i) = force_SD(i)/force_mean(i);
    end
    
    
    % mean RMS over the 10% windows
    RMS_mean = NaN(10,3);
    for k=2:1:4
        for i=1:1:10
            RMS_mean(i,k) = mean(data(win_start(i):win_start(i)+ten_percent,k+4));
        end
    end
    
    Time = 1:1:length(data); Time = Time' * isi*10^-3;
    
    if max_force_I > 50000
        plotstart = 50000;
    else
        plotstart = max_force_I - 1;
    end
    figure('Name','MVC 2min force analysis','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
    plot(Time,data(:,1))
    hold on
    x=axis;
    plot([Time(max_force_I-plotstart) Time(max_force_I+50000)],[max_force max_force],'k')
    for i=1:1:length(win_start)
        plot(Time(round(win_start(i)+ten_percent/2)),force_mean(i),'rs','MarkerEdgeColor','none','MarkerFaceColor','r')
        plot([Time(round(win_start(i))) Time(round(win_start(i)))],[x(3) x(4)],'g')
    end
    plot([Time(force_end) Time(force_end)],[x(3) x(4)],'r')
    plot([Time(force_start) Time(force_start)],[x(3) x(4)],'r')
    xlabel('Time (s)')
    ylabel('Force (N)')
    
    figure('Name','MVC 2min, RMS channels','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
    for i=1:1:3
        subplot(3,1,i)
        plot(Time,data(:,i+5))
        hold on
        x=axis;
        for j=1:1:length(win_start)
            plot(Time(round(win_start(j)+ten_percent/2)),RMS_mean(j,i+1),'rs','MarkerEdgeColor','none','MarkerFaceColor','r')
            plot([Time(round(win_start(j))) Time(round(win_start(j)))],[x(3) x(4)],'g')
        end
        plot([Time(round(force_end)) Time(round(force_end))],[x(3) x(4)],'r')
        plot([Time(round(force_start)) Time(round(force_start))],[x(3) x(4)],'r')
        to_plot = ['Channel : ' labels(i+5,:)];
        title(to_plot)
        xlabel('Time (s)')
        ylabel('RMS (V)')
    end
    clearvars to_plot
    
    %% OUTPUT
    

     output_filename = [sub_name '_' leg '.xlsx'];
    cd('Output')
    if exist(output_filename,'file') == 2
        
    else
        cd ..\
        copyfile('template.xlsx','Output')
        cd('Output')
        movefile('template.xlsx',output_filename)
        output_txt = cell(948,2);
        output_txt(:,1) = {sub_name};
        output_txt(:,2) = {leg};
        xlswrite(output_filename,output_txt,'Force Values','A2')
        xlswrite(output_filename,output_txt,'M_wave MEP RMS','A2')
        xlswrite(output_filename,output_txt,'MVC_2min','A2')
    end
    
    
    xlswrite(output_filename,max_force,'MVC_2min','E2')
    xlswrite(output_filename,force_mean,'MVC_2min','E8')
    output = NaN(size(RMS_mean,1)*(size(RMS_mean,2)-1),1);
    j=1;
    for i=1:1:10
        output(j:j+2) = [RMS_mean(i,2);RMS_mean(i,3);RMS_mean(i,4)];
        j=j+3;
    end
    xlswrite(output_filename,output,'MVC_2min','E18')
    
    
elseif si == 8848
    
    error('please check filename')

end

toc