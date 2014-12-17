
function handles = plot_signals(handles, processed, id_cond)

fcn = 'plot_fcn';
input = '(handles, processed, id_cond)';
handles = eval([fcn int2str(handles.id_mod) input]);


% Plot whole set of contractions + voluntary contractions
function handles = plot_fcn1(handles, processed, id_cond)
% progress bar update
value = 1/13;
progbar_update(handles.progress_bar, value)

% initialization of variables to be plotted
vol_contrac_start = processed.vol_contrac_start;
vol_contrac_end = processed.vol_contrac_end;
stim = processed.stim;
superimposed_window = processed.superimposed_window;
superimposed_F = processed.superimposed_F;
superimposed_B = processed.superimposed_B;
max_C_I = processed.max_C_I;
max_C = processed.max_C;
max_B = processed.max_B;
baseline_duration_contrac = processed.baseline_duration_contrac;
contrac_neurostim = processed.contrac_neurostim;
win_neuro = processed.win_neuro;
contrac_neurostim_max = processed.contrac_neurostim_max;
contrac_neurostim_min = processed.contrac_neurostim_min;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

axes(handles.haxes(1, id_cond));
plot(Time,data(:,1));
hold on
x=axis;
for i=1:1:4
    plot([vol_contrac_start(i)* isi*10^-3 vol_contrac_start(i)* isi*10^-3],...
        [x(3) x(4)],'r');
    plot([vol_contrac_end* isi*10^-3 vol_contrac_end* isi*10^-3],...
        [x(3) x(4)],'r');
    plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],...
        [superimposed_F(i) superimposed_F(i)],'k');
    plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],...
        [superimposed_B(i) superimposed_B(i)],'k');
    plot([(max_C_I(i)-0.5*1/(isi*10^-3))* isi*10^-3 (max_C_I(i)+0.5*1/(isi*10^-3))* isi*10^-3],...
        [max_C(i) max_C(i)],'k');
    plot([(vol_contrac_start(i)-baseline_duration_contrac*1/(isi*10^-3))* isi*10^-3 (vol_contrac_start(i)-baseline_duration_contrac/3*1/(isi*10^-3))* isi*10^-3],...
        [max_B(i) max_B(i)],'r');
end
hold off

% progress bar update
value = 2/13;
progbar_update(handles.progress_bar, value)

% loop for second row of graphs
for j=1:4
    axes(handles.haxes(j+1, id_cond));
    plot(Time(vol_contrac_start(j):vol_contrac_end(j)),...
        data(vol_contrac_start(j):vol_contrac_end(j),1))
    hold on
    x=axis;
    axis([vol_contrac_start(j)* isi*10^-3 vol_contrac_end(j)* isi*10^-3 x(3) x(4)]);
    plot([vol_contrac_start(j)* isi*10^-3 vol_contrac_start(j)]* isi*10^-3,...
        [x(3) x(4)],'r');
    plot([vol_contrac_end(j)* isi*10^-3 vol_contrac_end(j)* isi*10^-3],...
        [x(3) x(4)],'r');
    plot([(stim(j)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(j)* isi*10^-3],...
        [superimposed_F(j) superimposed_F(j)],'k');
    plot([(stim(j)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(j)* isi*10^-3],...
        [superimposed_B(j) superimposed_B(j)],'k');
    plot([(max_C_I(j)-0.25*1/(isi*10^-3))* isi*10^-3 (max_C_I(j)+0.25*1/(isi*10^-3))* isi*10^-3],...
        [max_C(j) max_C(j)],'k')
    to_plot = ['zoom on force plateau #' num2str(j)];
    title(to_plot);
    hold off
end

% progress bar update
value = 6/13;
progbar_update(handles.progress_bar, value)

% loop for third row of graphs
k=0;i=0;
for j=15:1:21
    axes(handles.haxes(j-9, id_cond));
    switch j
        case {15,16,18,20}
            i=i+1;
            plot(Time(round(stim(i)-superimposed_window*1/(isi*10^-3)-1000):round(stim(i))),...
                data(round(stim(i)-superimposed_window*1/(isi*10^-3)-1000):round(stim(i)),1))
            x=axis;
            axis([(stim(i)-superimposed_window*1/(isi*10^-3)-1000)* isi*10^-3 stim(i)* isi*10^-3 x(3) x(4)]);
            hold on
            plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],...
                [superimposed_F(i) superimposed_F(i)],'k');
            plot([(stim(i)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(i)* isi*10^-3],...
                [superimposed_B(i) superimposed_B(i)],'k');
        case {17,19,21}
            k=k+1;
            plot(Time(contrac_neurostim(k+1,2):contrac_neurostim(k+1,2)+2000),...
                data(contrac_neurostim(k+1,2):contrac_neurostim(k+1,2)+2000,1))
            x=axis;
            axis([contrac_neurostim(k+1,2)* isi*10^-3 (contrac_neurostim(k+1,2)+2000)* isi*10^-3 x(3) x(4)]);
            hold on
            plot([(contrac_neurostim(k+1,2)+win_neuro)* isi*10^-3 (contrac_neurostim(k+1,2)+2000)* isi*10^-3],...
                [contrac_neurostim_max(k+1) contrac_neurostim_max(k+1)],'k')
            plot([(contrac_neurostim(k+1,2)+win_neuro)* isi*10^-3 (contrac_neurostim(k+1,2)+2000)* isi*10^-3],...
            [contrac_neurostim_min(k+1) contrac_neurostim_min(k+1)],'k')
    end
    to_plot = ['superimposed #' num2str(j-14)];
    title(to_plot);
    hold off
end

% progress bar update
value = 1;
progbar_update(handles.progress_bar, value)

% Plot whole set of contractions + neurostimulation
function handles = plot_fcn2(handles, processed, id_cond)
% progress bar update
value = 1/4;
progbar_update(handles.progress_bar, value)

% initialization of variables to be plotted
stim_contrac_start_p = processed.stim_contrac_start_p;
stim_contrac_end = processed.stim_contrac_end;
stim_contrac_start = processed.stim_contrac_start;
neurostim_max = processed.neurostim_max;
B_before_neurostim = processed.B_before_neurostim;
neurostim_B = processed.neurostim_B;
neurostim_max_I = processed.neurostim_max_I;
HRT_abs = processed.HRT_abs;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

axes(handles.haxes(1, id_cond));
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
    plot([(stim_contrac_start(i) - B_before_neurostim(1)*1/(isi*10^-3))* isi*10^-3 (stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3))* isi*10^-3],...
        [neurostim_B(i) neurostim_B(i)],'k')
    plot([stim_contrac_start_p(i)* isi*10^-3 neurostim_max_I(i)* isi*10^-3],...
        [mean(data(stim_contrac_start_p(i):stim_contrac_end(i),1)) mean(data(stim_contrac_start_p(i):stim_contrac_end(i),1))],'k')
    plot([neurostim_max_I(i)* isi*10^-3 HRT_abs(i)* isi*10^-3],...
        [(neurostim_max(i)-neurostim_B(i))/2 + neurostim_B(i) (neurostim_max(i)-neurostim_B(i))/2 + neurostim_B(i)],'k')
end
hold off

% progress bar update
value = 2/4;
progbar_update(handles.progress_bar, value)

% loop for second row of graphs
for j=4:1:6
    i=j-3;
    axes(handles.haxes(j-2, id_cond));
    plot(Time(stim_contrac_start(i) - B_before_neurostim(1)*1/(isi*10^-3):HRT_abs(i)+10000),...
        data(stim_contrac_start(i) - B_before_neurostim(1)*1/(isi*10^-3):HRT_abs(i)+10000,1))
    hold on
    x=axis;
    plot([stim_contrac_start_p(i)* isi*10^-3 stim_contrac_start_p(i)* isi*10^-3],...
        [x(3) x(4)],'r')
        plot([stim_contrac_end(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3],...
            [x(3) x(4)],'r')
        plot([stim_contrac_start_p(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3],...
            [neurostim_max(i) neurostim_max(i)],'k')
        plot([(stim_contrac_start(i) - B_before_neurostim(1)*1/(isi*10^-3))* isi*10^-3 (stim_contrac_start(i) - B_before_neurostim(2)*1/(isi*10^-3))* isi*10^-3],...
            [neurostim_B(i) neurostim_B(i)],'g')
        plot([stim_contrac_start_p(i)* isi*10^-3 neurostim_max_I(i)* isi*10^-3],...
            [mean(data(stim_contrac_start_p(i):stim_contrac_end(i),1)) mean(data(stim_contrac_start_p(i):stim_contrac_end(i),1))],'k')
        plot([neurostim_max_I(i)* isi*10^-3 HRT_abs(i)* isi*10^-3],...
            [(neurostim_max(i)-neurostim_B(i))/2 + neurostim_B(i) (neurostim_max(i)-neurostim_B(i))/2 + neurostim_B(i)],'k')
        plot([neurostim_max_I(i)* isi*10^-3 neurostim_max_I(i)* isi*10^-3],...
            [x(3) neurostim_max(i)],'k--')
        to_plot = ['zoom on neurostim while @ rest #' num2str(i)];
        title(to_plot);
    hold off
end

% progress bar update
value = 1;
progbar_update(handles.progress_bar, value)

% Plot for neurostimulation at rest
function handles = plot_fcn3(handles, processed, id_cond)
% progress bar update
value = 1/7;
progbar_update(handles.progress_bar, value)

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

axes(handles.haxes(1, id_cond));
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
hold off

% progress bar update
value = 2/7;
progbar_update(handles.progress_bar, value)

% loop for second row of graphs
for i=6:7
    axes(handles.haxes(i-4, id_cond));
    plot(Time(max_M_wave_I(i-4,k)-300:max_M_wave_I(i-4,k)+1000), ...
        data(max_M_wave_I(i-4,k)-300:max_M_wave_I(i-4,k)+1000,k))
    hold on
    x=axis;
    plot([max_M_wave_I(i-4,k)* isi*10^-3 max_M_wave_I(i-4,k)* isi*10^-3],...
        [x(3) x(4)],'g')
    plot([min_M_wave_I(i-4,k)* isi*10^-3 min_M_wave_I(i-4,k)* isi*10^-3],...
        [x(3) x(4)],'y')
    plot([M_wave_start_I(i-4,k)* isi*10^-3 M_wave_start_I(i-4,k)* isi*10^-3],...
        [x(3) x(4)],'k')
    plot([M_wave_end_I(i-4,k)* isi*10^-3 M_wave_end_I(i-4,k)* isi*10^-3],...
        [x(3) x(4)],'k')
    to_plot = ['zoom on neurostim M-wave while @ rest #' num2str(i-4)];
    title(to_plot);
    legend('EMG','Max','Min','Start','End')
    hold off
end

% progress bar update
value = 4/7;
progbar_update(handles.progress_bar, value)

% loop for third row of graphs
for i=8:9
    j=(i-5)*2-1;
    axes(handles.haxes(j-1, id_cond));
    area(Time(M_wave_start_I(i-6,k):M_wave_end_I(i-6,k)),...
        data(M_wave_start_I(i-6,k):M_wave_end_I(i-6,k),k));
    to_plot = ['zoom on neurostim M-wave while @ rest #' num2str(i-6)];
    title(to_plot);
    
    axes(handles.haxes(j, id_cond));
    area(Time(max_M_wave_I(i-6,k):min_M_wave_I(i-6,k)),...
        data(max_M_wave_I(i-6,k):min_M_wave_I(i-6,k),k));
    to_plot = ['zoom on neurostim M-wave while @ rest #' num2str(i-6)];
    title(to_plot);
end

% progress bar update
value = 1;
progbar_update(handles.progress_bar, value)

% Plot for neurostimulation at exercise
function handles = plot_fcn4(handles, processed, id_cond)
% progress bar update
value = 1/7;
progbar_update(handles.progress_bar, value)

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

axes(handles.haxes(1, id_cond));
plot(Time,data(:,k));
hold on
x=axis;
plot([Time(contrac_neurostim(:,k)) Time(contrac_neurostim(:,k))],...
    [x(3) x(4)],'r')
legend('EMG','neurostim')
hold off

% progress bar update
value = 2/7;
progbar_update(handles.progress_bar, value)

% loop for second row of graphs
for l=2:4
    axes(handles.haxes(l, id_cond));
    plot(Time(M_wave_ex_max_I(l,k)-300:M_wave_ex_max_I(l,k)+1000),...
        data(M_wave_ex_max_I(l,k)-300:M_wave_ex_max_I(l,k)+1000,k))
    x=axis;
    hold on
    plot([M_wave_ex_max_I(l,k)* isi*10^-3 M_wave_ex_max_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'g')
    plot([M_wave_ex_min_I(l,k)* isi*10^-3 M_wave_ex_min_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'y')
    plot([M_wave_ex_start_I(l,k)* isi*10^-3 M_wave_ex_start_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'k')
    plot([M_wave_ex_end_I(l,k)* isi*10^-3 M_wave_ex_end_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'k')
    to_plot = ['zoom on neurostim M-wave during exercise #' num2str(l)];
    title(to_plot);
    legend('EMG','Max','Min','Start','End')
    hold off
end

% progress bar update
value = 5/7;
progbar_update(handles.progress_bar, value)

% loop for third row of graphs
for i=7:9
    axes(handles.haxes(i-2, id_cond));
    area(Time(M_wave_ex_start_I(i-5,k):M_wave_ex_end_I(i-5,k)),...
        data(M_wave_ex_start_I(i-5,k):M_wave_ex_end_I(i-5,k),k));
    to_plot = ['Neurostim exercise #' num2str(i-5)];
    title(to_plot);
end

% progress bar update
value = 1;
progbar_update(handles.progress_bar, value)

% Plot for TMS and MEP
function handles = plot_fcn5(handles, processed, id_cond)
% progress bar update
value = 1/10;
progbar_update(handles.progress_bar, value)

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

axes(handles.haxes(1, id_cond));
plot(Time,data(:,k));
hold on
x=axis;
plot([Time(TMS_stim) Time(TMS_stim)],[x(3) x(4)],'r')
legend('EMG','TMS')
hold off

% progress bar update
value = 2/10;
progbar_update(handles.progress_bar, value)

% loop for second row of graphs
l=1;
for i=7:2:12
    axes(handles.haxes(l+1, id_cond));
    plot(Time(TMS_stim(l)-round(win_pre_stim*10^-3*1/(isi*10^-3)):EMG_recov_point(l,k)+5000),...
        data(TMS_stim(l)-round(win_pre_stim*10^-3*1/(isi*10^-3)):EMG_recov_point(l,k)+5000,k))
    hold on
    x=axis;
    plot([M_wave_MEP_max_I(l,k)* isi*10^-3 M_wave_MEP_max_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'g')
    plot([M_wave_MEP_min_I(l,k)* isi*10^-3 M_wave_MEP_min_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'y')
    plot([M_wave_MEP_start_I(l,k)* isi*10^-3 M_wave_MEP_start_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'k')
    plot([M_wave_MEP_end_I(l,k)* isi*10^-3 M_wave_MEP_end_I(l,k)* isi*10^-3],...
        [x(3) x(4)],'k')
    plot([EMG_recov_point(l,k)* isi*10^-3 EMG_recov_point(l,k)* isi*10^-3],...
        [x(3) x(4)],'--r')
    to_plot = ['zoom on TMS M-wave during exercise #' num2str(l)];
    title(to_plot);
    hold off
    l=l+1;
end

% progress bar update
value = 5/10;
progbar_update(handles.progress_bar, value)

% loop for third row of graphs
for i=8:10
    j=(i-5)*2-1;
    axes(handles.haxes(j, id_cond));
    area(Time(M_wave_MEP_start_I(i-7,k):M_wave_MEP_end_I(i-7,k)),...
        data(M_wave_MEP_start_I(i-7,k):M_wave_MEP_end_I(i-7,k),k));
    to_plot = ['TMS during exercise #' num2str(i-7)];
    title(to_plot);
    
    axes(handles.haxes(j+1, id_cond));
    area(Time(M_wave_MEP_max_I(i-7,k):M_wave_MEP_min_I(i-7,k)),...
        data(M_wave_MEP_max_I(i-7,k):M_wave_MEP_min_I(i-7,k),k));
    to_plot = ['TMS during exercise #' num2str(i-7)];
    title(to_plot);
    
end

% progress bar update
value = 1;
progbar_update(handles.progress_bar, value)
