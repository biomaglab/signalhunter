
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


function plot_tms_vc(ax, processed, id_mod, process_id, id_cond)

if process_id == 1
    fcn = 'plot_fcn';
    input = '(ax, processed, id_cond)';
    eval([fcn int2str(id_mod) input]);
elseif process_id == 2
    fcn = 'plot_fcn';
    input = '(ax, processed, id_cond)';
    eval([fcn int2str(id_mod) input]);
elseif process_id == 3
    fcn = 'plot_fcn';
    input = '(ax, processed, id_cond)';
    eval([fcn int2str(id_mod) input]);
end


% Plot whole set of contractions + voluntary contractions
function plot_fcn1(ax, processed, id_cond)

% initialization of variables to be plotted
vol_contrac_start = processed.vol_contrac_start;
vol_contrac_end = processed.vol_contrac_end;
stim = processed.stim;
superimposed_window = processed.superimposed_window;
superimposed_B_I = processed.superimposed_B_I;
superimposed_F_I = processed.superimposed_F_I;
superimposed_B = processed.superimposed_B;
superimposed_F = processed.superimposed_F;
max_B_I = processed.max_B_I;
max_C_I = processed.max_C_I;
max_B = processed.max_B;
max_C = processed.max_C;
baseline_duration_contrac = processed.baseline_duration_contrac;
contrac_neurostim = processed.contrac_neurostim;
win_neuro = processed.win_neuro;
contrac_neurostim_min = processed.contrac_neurostim_min;
contrac_neurostim_max = processed.contrac_neurostim_max;
contrac_neurostim_min_I = processed.contrac_neurostim_min_I;
contrac_neurostim_max_I = processed.contrac_neurostim_max_I;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

del = round(1/(isi*10^-3));

axes(ax(1, id_cond));
plot(Time,data(:,1));
xlabel('Time (s)')
ylabel('Force (N)')
hold on
x=axis;
for i=1:4
    plot([vol_contrac_start(i)*isi*10^-3 vol_contrac_start(i)*isi*10^-3],...
        [x(3) x(4)],'r');
    plot([vol_contrac_end(i)* isi*10^-3 vol_contrac_end(i)* isi*10^-3],...
        [x(3) x(4)],'r');
end
hold off

% loop for second row of graphs
for j=1:4
    axes(ax(j+1, id_cond));
    
    % This block check if del does point to indice out of data and time
    % limits, if so, vector is set to first indice or end
    try
        aux_time = Time(vol_contrac_start(j)-del:vol_contrac_end(j)+del);
        aux_data = data(vol_contrac_start(j)-del:vol_contrac_end(j)+del, 1);
    catch
        if j == 1
            aux_time = Time(1:vol_contrac_end(j)+del);
            aux_data = data(1:vol_contrac_end(j)+del, 1);
        elseif j == 4
            aux_time = Time(vol_contrac_start(j)-del:end);
            aux_data = data(vol_contrac_start(j)-del:end, 1);
        end
    end
    % end of block
    
    plot(aux_time, aux_data)
    hold on
    x=axis;
    axis([aux_time(1) aux_time(end) x(3) x(4)]);
    plot([vol_contrac_start(j)*isi*10^-3 vol_contrac_start(j)*isi*10^-3],...
        [x(3) x(4)],'r');
    plot([vol_contrac_end(j)*isi*10^-3 vol_contrac_end(j)*isi*10^-3],...
        [x(3) x(4)],'r');
    % plot of minimum and maximum superimposed force contraction
    if superimposed_B_I(j) == 0
        plot([(stim(j)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(j)* isi*10^-3],...
            [superimposed_B(j) superimposed_B(j)],'k');
        plot([(stim(j)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(j)* isi*10^-3],...
            [superimposed_F(j) superimposed_F(j)],'k');
    else
        plot([(superimposed_B_I(j)-0.25*1/(isi*10^-3))* isi*10^-3 (superimposed_B_I(j)+0.25*1/(isi*10^-3))* isi*10^-3],...
            [superimposed_B(j) superimposed_B(j)],'k');
        plot([(superimposed_F_I(j)-0.25*1/(isi*10^-3))* isi*10^-3 (superimposed_F_I(j)+0.25*1/(isi*10^-3))* isi*10^-3],...
            [superimposed_F(j) superimposed_F(j)],'k');
    end
    % plot of basal and maximum voluntary contraction
    if max_B_I(j) == 0
        plot([(vol_contrac_start(j)-baseline_duration_contrac*1/(isi*10^-3))* isi*10^-3 (vol_contrac_start(j)-baseline_duration_contrac/3*1/(isi*10^-3))* isi*10^-3],...
            [max_B(j) max_B(j)],'r');
    else
        plot([(max_B_I(j)-0.25*1/(isi*10^-3))* isi*10^-3 (max_B_I(j)+0.25*1/(isi*10^-3))* isi*10^-3],...
            [max_B(j) max_B(j)],'r');
    end
    plot([(max_C_I(j)-0.25*1/(isi*10^-3))* isi*10^-3 (max_C_I(j)+0.25*1/(isi*10^-3))* isi*10^-3],...
        [max_C(j) max_C(j)],'k')
    to_plot = ['zoom on force plateau #' num2str(j)];
    title(to_plot);
    xlabel('Time (s)')
    ylabel('Force (N)')
    
    if j > 1
        % plot of minimum and maximum neurostim contraction
        if contrac_neurostim_min_I(j) == 0
            plot([(contrac_neurostim(j,2)+win_neuro)* isi*10^-3 (contrac_neurostim(j,2)+2000)* isi*10^-3],...
                [contrac_neurostim_min(j) contrac_neurostim_min(j)],'--g')
            plot([(contrac_neurostim(j,2)+win_neuro)* isi*10^-3 (contrac_neurostim(j,2)+2000)* isi*10^-3],...
                [contrac_neurostim_max(j) contrac_neurostim_max(j)],'--g')
        else
            plot([(contrac_neurostim_min_I(j)-0.25*1/(isi*10^-3))* isi*10^-3 (contrac_neurostim_min_I(j)+0.25*1/(isi*10^-3))* isi*10^-3],...
                [contrac_neurostim_min(j) contrac_neurostim_min(j)],'--g');
            plot([(contrac_neurostim_max_I(j)-0.25*1/(isi*10^-3))* isi*10^-3 (contrac_neurostim_max_I(j)+0.25*1/(isi*10^-3))* isi*10^-3],...
                [contrac_neurostim_max(j) contrac_neurostim_max(j)],'--g');
        end
    end
    hold off
end

% loop for third row of graphs
k=0;i=0;
for j=15:1:21
    axes(ax(j-9, id_cond));
    switch j
        case {15,16,18,20}
            i=i+1;
            plot(Time(round(stim(i)-superimposed_window*1/(isi*10^-3)-1000):round(stim(i))),...
                data(round(stim(i)-superimposed_window*1/(isi*10^-3)-1000):round(stim(i)),1))
            x=axis;
            axis([(stim(i)-superimposed_window*1/(isi*10^-3)-1000)* isi*10^-3 stim(i)* isi*10^-3 x(3) x(4)]);
            hold on
            if superimposed_B_I(i) == 0
                plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],...
                    [superimposed_F(i) superimposed_F(i)],'k');
                plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],...
                    [superimposed_B(i) superimposed_B(i)],'k');
            else
                plot([(superimposed_B_I(i)-0.1*1/(isi*10^-3))* isi*10^-3 (superimposed_B_I(i)+0.1*1/(isi*10^-3))* isi*10^-3],...
                    [superimposed_B(i) superimposed_B(i)],'k');
                plot([(superimposed_F_I(i)-0.1*1/(isi*10^-3))* isi*10^-3 (superimposed_F_I(i)+0.1*1/(isi*10^-3))* isi*10^-3],...
                    [superimposed_F(i) superimposed_F(i)],'k');
            end
        case {17,19,21}
            k=k+1;
            plot(Time(contrac_neurostim(k+1,2):contrac_neurostim(k+1,2)+2000),...
                data(contrac_neurostim(k+1,2):contrac_neurostim(k+1,2)+2000,1))
            x=axis;
            axis([contrac_neurostim(k+1,2)* isi*10^-3 (contrac_neurostim(k+1,2)+2000)* isi*10^-3 x(3) x(4)]);
            hold on
            if contrac_neurostim_min_I(k+1) == 0
                plot([(contrac_neurostim(k+1,2)+win_neuro)* isi*10^-3 (contrac_neurostim(k+1,2)+2000)* isi*10^-3],...
                    [contrac_neurostim_max(k+1) contrac_neurostim_max(k+1)],'--g')
                plot([(contrac_neurostim(k+1,2)+win_neuro)* isi*10^-3 (contrac_neurostim(k+1,2)+2000)* isi*10^-3],...
                    [contrac_neurostim_min(k+1) contrac_neurostim_min(k+1)],'--g')
            else
                plot([(contrac_neurostim_min_I(k+1)-0.25*1/(isi*10^-3))* isi*10^-3 (contrac_neurostim_min_I(k+1)+0.25*1/(isi*10^-3))* isi*10^-3],...
                    [contrac_neurostim_min(k+1) contrac_neurostim_min(k+1)],'--g');
                plot([(contrac_neurostim_max_I(k+1)-0.25*1/(isi*10^-3))* isi*10^-3 (contrac_neurostim_max_I(k+1)+0.25*1/(isi*10^-3))* isi*10^-3],...
                    [contrac_neurostim_max(k+1) contrac_neurostim_max(k+1)],'--g');
            end
    end
    to_plot = ['superimposed #' num2str(j-14)];
    title(to_plot);
    xlabel('Time (s)')
    ylabel('Force (N)')
    hold off
end

% Plot whole set of contractions + neurostimulation
function plot_fcn2(ax, processed, id_cond)

% initialization of variables to be plotted
stim_contrac_start_p = processed.stim_contrac_start_p;
stim_contrac_end = processed.stim_contrac_end;
% stim_contrac_start = processed.stim_contrac_start;
neurostim_max = processed.neurostim_max;
B_before_neurostim = processed.B_before_neurostim;
neurostim_B = processed.neurostim_B;
neurostim_max_I = processed.neurostim_max_I;
HRT_abs = processed.HRT_abs;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

del = round(0.3*1/(isi*10^-3));
HRT_y = zeros(length(neurostim_max), 1);
mean_contrac = zeros(length(neurostim_max), 1);

for i = 1:3
    HRT_y(i) = (neurostim_max(i)-neurostim_B(i))/2 + neurostim_B(i);
    mean_contrac(i) = mean(data(stim_contrac_start_p(i):stim_contrac_end(i),1));
    if mean_contrac(i) > neurostim_max(i)
        mean_contrac(i) = HRT_y(i);
    end
end

axes(ax(1, id_cond));
plot(Time,data(:,1));
hold on
x=axis;
for i=1:1:3
    plot([stim_contrac_start_p(i)* isi*10^-3 stim_contrac_start_p(i)* isi*10^-3],...
        [x(3) x(4)],'r');
    plot([stim_contrac_end(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3],...
        [x(3) x(4)],'r');
    plot([stim_contrac_start_p(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3], ...
        [neurostim_max(i) neurostim_max(i)],'k')
    plot([(stim_contrac_start_p(i) - B_before_neurostim(1)*1/(isi*10^-3))* isi*10^-3 (stim_contrac_start_p(i) - B_before_neurostim(2)*1/(isi*10^-3))* isi*10^-3],...
        [neurostim_B(i) neurostim_B(i)],'k')
    plot([stim_contrac_start_p(i)* isi*10^-3 neurostim_max_I(i)* isi*10^-3],...
        [mean_contrac(i) mean_contrac(i)],'k')
    plot([neurostim_max_I(i)* isi*10^-3 HRT_abs(i)* isi*10^-3],...
        [HRT_y(i) HRT_y(i)],'k')
    plot([neurostim_max_I(i)* isi*10^-3 neurostim_max_I(i)* isi*10^-3],...
        [x(3) neurostim_max(i)],'k--');
end
xlabel('Time (s)')
ylabel('Force (N)')
hold off

% loop for second row of graphs
for j=4:1:6
    i=j-3;
    axes(ax(j-2, id_cond));
    
    % This block check if del does point to indice out of data and time
    % limits, if so, vector is set to first indice or end
    
    try
        aux_time = Time(stim_contrac_start_p(i)-del:stim_contrac_end(i)+del);
        aux_data = data(stim_contrac_start_p(i)-del:stim_contrac_end(i)+del,1);
    catch
        if i == 1
            aux_time = Time(1:stim_contrac_end(i)+del);
            aux_data = data(1:stim_contrac_end(i)+del,1);
        elseif i == 3
            aux_time = Time(stim_contrac_start_p(i)-del:end);
            aux_data = data(stim_contrac_start_p(i)-del:end,1);
        end
    end
    % end of block
    
    
    plot(aux_time, aux_data)
    hold on
    x=axis;
    axis([aux_time(1) aux_time(end) x(3) x(4)]);
    
    
    % here I started to substitute the B_before_neurostim pelo del
    hold on
    x=axis;
    plot([stim_contrac_start_p(i)* isi*10^-3 stim_contrac_start_p(i)* isi*10^-3],...
        [x(3) x(4)],'r')
    plot([stim_contrac_end(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3],...
        [x(3) x(4)],'r')
    plot([stim_contrac_start_p(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3],...
        [neurostim_max(i) neurostim_max(i)],'k')
    plot([(stim_contrac_start_p(i) - B_before_neurostim(1)*1/(isi*10^-3))* isi*10^-3 (stim_contrac_start_p(i) - B_before_neurostim(2)*1/(isi*10^-3))* isi*10^-3],...
        [neurostim_B(i) neurostim_B(i)],'g')
    plot([stim_contrac_start_p(i)* isi*10^-3 neurostim_max_I(i)* isi*10^-3],...
        [mean_contrac(i) mean_contrac(i)],'k')
    plot([neurostim_max_I(i)* isi*10^-3 HRT_abs(i)* isi*10^-3],...
        [HRT_y(i) HRT_y(i)],'k')
    plot([neurostim_max_I(i)* isi*10^-3 neurostim_max_I(i)* isi*10^-3],...
        [x(3) neurostim_max(i)],'k--')
    to_plot = ['zoom on neurostim while @ rest #' num2str(i)];
    title(to_plot);
    xlabel('Time (s)')
    ylabel('Force (N)')
    hold off
    
end

% Plot for neurostimulation at rest
function plot_fcn3(ax, processed, id_cond)

% initialization of variables to be plotted
M_wave_start_I = processed.M_wave_start_I;
M_wave_end_I = processed.M_wave_end_I;
max_M_wave_I = processed.max_M_wave_I;
min_M_wave_I = processed.min_M_wave_I;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

k = id_cond - 1;
del = [300, 1000];

axes(ax(1, id_cond));
plot(Time,data(:,k));
hold on
x=axis;
for i=2:3
    plot([M_wave_start_I(i,k)* isi*10^-3 M_wave_start_I(i,k)* isi*10^-3],...
        [x(3) x(4)],'r');
    plot([M_wave_end_I(i,k)* isi*10^-3 M_wave_end_I(i,k)* isi*10^-3],...
        [x(3) x(4)],'r');
end
legend('EMG','neurostim')
xlabel('Time (s)')
ylabel('EMG (V)')
hold off

% loop for second row of graphs
for i=6:7
    axes(ax(i-4, id_cond));
    
    % This block check if del does point to indice out of data and time
    % limits, if so, vector is set to first indice or end
    try
        aux_time = Time(max_M_wave_I(i-4,k)-del(1):max_M_wave_I(i-4,k)+del(2));
        aux_data = data(max_M_wave_I(i-4,k)-del(1):max_M_wave_I(i-4,k)+del(2),k);
    catch
        if i == 6
            aux_time = Time(1:max_M_wave_I(i-4,k)+del(2));
            aux_data = data(1:max_M_wave_I(i-4,k)+del(2),k);
        elseif i == 7
            aux_time = Time(max_M_wave_I(i-4,k)-del(1):end);
            aux_data = data(max_M_wave_I(i-4,k)-del(1):end,k);
        end
    end
    % end of block
    
    %     plot(Time(max_M_wave_I(i-4,k)-del(1):max_M_wave_I(i-4,k)+del(2)), ...
    %         data(max_M_wave_I(i-4,k)-del(1):max_M_wave_I(i-4,k)+del(2),k))
    
    plot(aux_time, aux_data)
    hold on
    x=axis;
    axis([aux_time(1) aux_time(end) x(3) x(4)]);

    % plot of M wave start and end
    plot([M_wave_start_I(i-4,k)* isi*10^-3 M_wave_start_I(i-4,k)* isi*10^-3],...
        [x(3) x(4)],'r')
    plot([M_wave_end_I(i-4,k)* isi*10^-3 M_wave_end_I(i-4,k)* isi*10^-3],...
        [x(3) x(4)],'g')
    % plot of M wave minimum and maximum
    plot([min_M_wave_I(i-4,k)* isi*10^-3 min_M_wave_I(i-4,k)* isi*10^-3],...
        [x(3) x(4)],'--m')
    plot([max_M_wave_I(i-4,k)* isi*10^-3 max_M_wave_I(i-4,k)* isi*10^-3],...
        [x(3) x(4)],'--k')
    to_plot = ['zoom on neurostim M-wave while @ rest #' num2str(i-4)];
    title(to_plot);
    legend('EMG','Start','End','Min','Max')
    xlabel('Time (s)')
    ylabel('EMG (V)')
    hold off
end

% loop for third row of graphs
for i=8:9
    j=(i-5)*2-1;
    axes(ax(j-1, id_cond));
    
    if M_wave_start_I(i-6,k) < M_wave_end_I(i-6,k)
        t1 = M_wave_start_I(i-6,k);
        t2 = M_wave_end_I(i-6,k);
    else
        t1 = M_wave_end_I(i-6,k);
        t2 = M_wave_start_I(i-6,k);
    end
    
    area(Time(t1:t2), data(t1:t2,k));
    to_plot = ['zoom on neurostim M-wave while @ rest #' num2str(i-6)];
    xlabel('Time (s)')
    ylabel('EMG (V)')
    title(to_plot);
    
    axes(ax(j, id_cond));
    
    if max_M_wave_I(i-6,k) < min_M_wave_I(i-6,k)
        t1 = max_M_wave_I(i-6,k);
        t2 = min_M_wave_I(i-6,k);
    else
        t1 = min_M_wave_I(i-6,k);
        t2 = max_M_wave_I(i-6,k);
    end
    
    area(Time(t1:t2), data(t1:t2,k));
    to_plot = ['zoom on neurostim M-wave while @ rest #' num2str(i-6)];
    title(to_plot);
    xlabel('Time (s)')
    ylabel('EMG (V)')
end

% Plot for neurostimulation at exercise
function plot_fcn4(ax, processed, id_cond)

% initialization of variables to be plotted
contrac_neurostim = processed.contrac_neurostim;
M_wave_ex_max_I = processed.M_wave_ex_max_I;
M_wave_ex_min_I = processed.M_wave_ex_min_I;
M_wave_ex_start_I = processed.M_wave_ex_start_I;
M_wave_ex_end_I = processed.M_wave_ex_end_I;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

k = id_cond - 4;
del = [300, 1000];

axes(ax(1, id_cond));
plot(Time,data(:,k));
hold on
x=axis;
plot([Time(contrac_neurostim(:,k)) Time(contrac_neurostim(:,k))],...
    [x(3) x(4)],'r')
legend('EMG','neurostim')
xlabel('Time (s)')
ylabel('EMG (V)')
hold off

% loop for second row of graphs
for l=2:4
    axes(ax(l, id_cond));
    
    % This block check if del does point to indice out of data and time
    % limits, if so, vector is set to first indice or end
    try
        aux_time = Time(M_wave_ex_max_I(l,k)-del(1):M_wave_ex_max_I(l,k)+del(2));
        aux_data = data(M_wave_ex_max_I(l,k)-del(1):M_wave_ex_max_I(l,k)+del(2),k);
    catch
        if l == 2
            aux_time = Time(1:M_wave_ex_max_I(l,k)+del(2));
            aux_data = data(1:M_wave_ex_max_I(l,k)+del(2),k);
        elseif l == 4
            aux_time = Time(M_wave_ex_max_I(l,k)-del(1):end);
            aux_data = data(M_wave_ex_max_I(l,k)-del(1):end,k);
        end
    end
    % end of block
    
%     plot(Time(M_wave_ex_max_I(l,k)-del(1):M_wave_ex_max_I(l,k)+del(2)),...
%         data(M_wave_ex_max_I(l,k)-del(1):M_wave_ex_max_I(l,k)+del(2),k))  
    plot(aux_time, aux_data)
    hold on
    x=axis;
    axis([aux_time(1) aux_time(end) x(3) x(4)]);
    
    % plot of M wave start and end at exercise
    plot([M_wave_ex_start_I(l,k)* isi*10^-3 M_wave_ex_start_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'r')
    plot([M_wave_ex_end_I(l,k)* isi*10^-3 M_wave_ex_end_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'g')
    % plot of M wave minimum and maximum at exercise
    plot([M_wave_ex_min_I(l,k)* isi*10^-3 M_wave_ex_min_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'--m')
    plot([M_wave_ex_max_I(l,k)* isi*10^-3 M_wave_ex_max_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'--k')
    to_plot = ['zoom on neurostim M-wave during exercise #' num2str(l)];
    title(to_plot);
    xlabel('Time (s)')
    ylabel('EMG (V)')
    legend('EMG','Start','End','Min','Max')
    hold off
end

% loop for third row of graphs
for i=7:9
    axes(ax(i-2, id_cond));
    area(Time(M_wave_ex_start_I(i-5,k):M_wave_ex_end_I(i-5,k)),...
        data(M_wave_ex_start_I(i-5,k):M_wave_ex_end_I(i-5,k),k));
    to_plot = ['Neurostim exercise #' num2str(i-5)];
    title(to_plot);
    xlabel('Time (s)')
    ylabel('EMG (V)')
end

% Plot for TMS and MEP
function plot_fcn5(ax, processed, id_cond)

% initialization of variables to be plotted
TMS_stim = processed.TMS_stim;
win_pre_stim = processed.win_pre_stim;
EMG_recov_point = processed.EMG_recov_point;
M_wave_MEP_max_I = processed.M_wave_MEP_max_I;
M_wave_MEP_min_I = processed.M_wave_MEP_min_I;
M_wave_MEP_start_I = processed.M_wave_MEP_start_I;
M_wave_MEP_end_I = processed.M_wave_MEP_end_I;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

k = id_cond - 7;
del = [0, 5000];

axes(ax(1, id_cond));
plot(Time,data(:,k));
hold on
x=axis;
plot([Time(TMS_stim) Time(TMS_stim)],[x(3) x(4)],'r')
legend('EMG','TMS')
xlabel('Time (s)')
ylabel('EMG (V)')
hold off

% loop for second row of graphs
l=1;
for i=7:2:12
    axes(ax(l+1, id_cond));
    
    % This block check if del does point to indice out of data and time
    % limits, if so, vector is set to first indice or end
    try
        aux_time = Time(TMS_stim(l)-round(win_pre_stim*10^-3*1/(isi*10^-3))-del(1):EMG_recov_point(l,k)+del(2));
        aux_data = data(TMS_stim(l)-round(win_pre_stim*10^-3*1/(isi*10^-3))-del(1):EMG_recov_point(l,k)+del(2),k);
    catch
        if l == 1
            aux_time = Time(1:EMG_recov_point(l,k)+del(2));
            aux_data = data(1:EMG_recov_point(l,k)+del(2),k);
        elseif l == 4
            aux_time = Time(TMS_stim(l)-round(win_pre_stim*10^-3*1/(isi*10^-3))-del(1):end);
            aux_data = data(TMS_stim(l)-round(win_pre_stim*10^-3*1/(isi*10^-3))-del(1):end,k);
        end
    end
    % end of block
    
%     plot(Time(TMS_stim(l)-round(win_pre_stim*10^-3*1/(isi*10^-3))-del(1):EMG_recov_point(l,k)+del(2)),...
%         data(TMS_stim(l)-round(win_pre_stim*10^-3*1/(isi*10^-3))-del(1):EMG_recov_point(l,k)+del(2),k))

    plot(aux_time, aux_data)
    hold on
    x=axis;
    axis([aux_time(1) aux_time(end) x(3) x(4)]);
    
    % plot of MEP start and end after TMS
    plot([M_wave_MEP_start_I(l,k)* isi*10^-3 M_wave_MEP_start_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'r')
    plot([M_wave_MEP_end_I(l,k)* isi*10^-3 M_wave_MEP_end_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'g')
    % plot of MEP minimum and maximum after TMS
    plot([M_wave_MEP_min_I(l,k)* isi*10^-3 M_wave_MEP_min_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'--m')
    plot([M_wave_MEP_max_I(l,k)* isi*10^-3 M_wave_MEP_max_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'--k')
    % plot of TMS pulse and EMG recovery point
    plot([Time(TMS_stim(l)) Time(TMS_stim(l))], [x(3) x(4)],'c');
    plot([EMG_recov_point(l,k)* isi*10^-3 EMG_recov_point(l,k)* isi*10^-3],...
        [x(3) x(4)],'y')
    to_plot = ['zoom on TMS M-wave during exercise #' num2str(l)];
    title(to_plot);
    xlabel('Time (s)')
    ylabel('EMG (V)')
    legend('EMG','Start','End','Min','Max','TMS','Recovery');
    hold off
    l=l+1;
end

% loop for third row of graphs
for i=8:10
    j=(i-5)*2-1;
    axes(ax(j, id_cond));
    
    if M_wave_MEP_start_I(i-7,k) < M_wave_MEP_end_I(i-7,k)
        t1 = M_wave_MEP_start_I(i-7,k);
        t2 = M_wave_MEP_end_I(i-7,k);
    else
        t1 = M_wave_MEP_end_I(i-7,k);
        t2 = M_wave_MEP_start_I(i-7,k);
    end
    
    area(Time(t1:t2), data(t1:t2,k));
    to_plot = ['TMS during exercise #' num2str(i-7)];
    title(to_plot);
    xlabel('Time (s)')
    ylabel('EMG (V)')
    
    axes(ax(j+1, id_cond));
    
    if M_wave_MEP_max_I(i-7,k) < M_wave_MEP_min_I(i-7,k)
        t1 = M_wave_MEP_max_I(i-7,k);
        t2 = M_wave_MEP_min_I(i-7,k);
    else
        t1 = M_wave_MEP_min_I(i-7,k);
        t2 = M_wave_MEP_max_I(i-7,k);
    end
    
    area(Time(t1:t2), data(t1:t2,k));
    to_plot = ['TMS during exercise #' num2str(i-7)];
    title(to_plot);
    xlabel('Time (s)')
    ylabel('EMG (V)')    
end

function plot_fcn6(ax, processed, id_cond)

signal = processed.signal;
data = signal.data;
Time = signal.time;

contrac_start = processed.contrac_start;
contrac_end = processed.contrac_end;
contrac_max_I = processed.contrac_max_I;
contrac_max = processed.contrac_max;
Twitch_x = processed.Twitch_x;
Twitch_y = processed.Twitch_y;
HRT = processed.HRT;
baseline = processed.baseline;

axes(ax(1, id_cond));
plot(Time,data(:,1))
hold on
x=axis;
plot([Time(contrac_start) Time(contrac_start)],[x(3) x(4)],'r')
plot([Time(contrac_end) Time(contrac_end)],[x(3) x(4)],'r')
for i=2:1:3
    plot([Time(contrac_max_I(i)-10000) Time(contrac_max_I(i)+10000)],[contrac_max(i) contrac_max(i)],'k')
end
hold off

axes(ax(2, id_cond));
plot(Time(Twitch_x-5000:Twitch_x+5000),data(Twitch_x-5000:Twitch_x+5000,1))
hold on
x=axis;
plot([Time(Twitch_x-200) Time(Twitch_x+200)],[Twitch_y Twitch_y],'r')
plot([Time(Twitch_x) Time(Twitch_x)],[x(3) x(4)],'--k')
plot([Time(contrac_start(1)) Time(contrac_start(1))],[x(3) x(4)],'k')
plot([Time(contrac_end(1)) Time(contrac_end(1))],[x(3) x(4)],'r')
plot([Time(HRT) Time(HRT)],[x(3) x(4)],'k')
plot([Time(contrac_start(1)) Time(Twitch_x)],[(x(4)-x(3))/2+x(3)+5 (x(4)-x(3))/2+x(3)+5],'--k')
plot([Time(Twitch_x) Time(HRT)],[(x(4)-x(3))/2+x(3) (x(4)-x(3))/2+x(3)],'--k')
plot([x(1)+2*(x(2)-x(1))/10 3*(x(2)-x(1))/10+x(1)],[baseline baseline],'r')
hold off


function plot_fcn7(ax, processed, id_cond)

signal = processed.signal;
data = signal.data;
Time = signal.time;

contrac_neurostim = processed.contrac_neurostim;
M_wave_ex_min_I = processed.M_wave_ex_min_I;
M_wave_ex_max_I = processed.M_wave_ex_max_I;
M_wave_ex_start_I = processed.M_wave_ex_start_I;
M_wave_ex_end_I =processed. M_wave_ex_end_I;

for k=1:1:3
    axes(ax(k, id_cond));
    plot(Time(contrac_neurostim(k+1)-300:contrac_neurostim(k+1)+1500),data(contrac_neurostim(k+1)-300:contrac_neurostim(k+1)+1500,k+1))
    hold on
    x=axis;
    axis([Time(contrac_neurostim(k+1)-300) Time(contrac_neurostim(k+1)+1500) x(3) x(4)])
    %plot([Time(contrac_neurostim(k+1)) Time(contrac_neurostim(k+1))],[x(3) x(4)],'r')
    plot([Time(M_wave_ex_max_I(k+1)) Time(M_wave_ex_max_I(k+1))],[x(3) x(4)],'g')
    plot([Time(M_wave_ex_min_I(k+1)) Time(M_wave_ex_min_I(k+1))],[x(3) x(4)],'y')
    plot([Time(M_wave_ex_start_I(k+1)) Time(M_wave_ex_start_I(k+1))],[x(3) x(4)],'k')
    plot([Time(M_wave_ex_end_I(k+1)) Time(M_wave_ex_end_I(k+1))],[x(3) x(4)],'k')
    
    tMEP_ex_start = zeros(size(M_wave_ex_start_I));
    tMEP_ex_end = zeros(size(M_wave_ex_start_I));
    
    if M_wave_ex_start_I(k+1) < M_wave_ex_end_I(k+1)
        tMEP_ex_start(k+1) = M_wave_ex_start_I(k+1);
        tMEP_ex_end(k+1) = M_wave_ex_end_I(k+1);
    else
        tMEP_ex_start(k+1) = M_wave_ex_end_I(k+1);
        tMEP_ex_end(k+1) = M_wave_ex_start_I(k+1);
    end

    axes(ax(k+3, id_cond));
    area(Time(tMEP_ex_start(k+1):tMEP_ex_end(k+1)),data(tMEP_ex_start(k+1):tMEP_ex_end(k+1),k+1))
end

function plot_fcn8(ax, processed, id_cond)

signal = processed.signal;
data = signal.data;
Time = signal.time;

force_mean = processed.force_mean;
force_start = processed.force_start;
force_end = processed.force_end;
max_force = processed.max_force;
max_force_I = processed.max_force_I;
ten_percent = processed.ten_percent;
win_start = processed.win_start;

if max_force_I > 50000
    plotstart = 50000;
else
    plotstart = max_force_I - 1;
end

axes(ax(1, id_cond));
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
hold off

function plot_fcn9(ax, processed, id_cond)

signal = processed.signal;
data = signal.data;
Time = signal.time;

RMS_mean = processed.RMS_mean;
win_start = processed.win_start;
ten_percent = processed.ten_percent;
force_start = processed.force_start;
force_end = processed.force_end;

for i=1:1:3
    axes(ax(i, id_cond));
    plot(Time,data(:,i+5))
    hold on
    x=axis;
    for j=1:1:length(win_start)
        plot(Time(round(win_start(j)+ten_percent/2)),RMS_mean(j,i+1),'rs','MarkerEdgeColor','none','MarkerFaceColor','r')
        plot([Time(round(win_start(j))) Time(round(win_start(j)))],[x(3) x(4)],'g')
    end
    plot([Time(round(force_end)) Time(round(force_end))],[x(3) x(4)],'r')
    plot([Time(round(force_start)) Time(round(force_start))],[x(3) x(4)],'r')
    xlabel('Time (s)')
    ylabel('EMG (V)')
    hold off
end