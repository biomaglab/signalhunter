
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


function handles = plot_detect(handles, id)
%PLOT_DETECT Summary of this function goes here
%   Detailed explanation goes here
fcn = 'plot_fcn';
input = '(handles)';
handles = eval([fcn int2str(id) input]);

% Plot whole set of contractions + voluntary contractions
function handles = plot_fcn1(handles)

axesdetect = handles.axesdetect;
processed = handles.processed;
id_axes = handles.id_axes - (11*(handles.id_cond-1)+handles.id_cond);

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
contrac_neurostim_min_I = processed.contrac_neurostim_min_I;
contrac_neurostim_max_I = processed.contrac_neurostim_max_I;
contrac_neurostim_min = processed.contrac_neurostim_min;
contrac_neurostim_max = processed.contrac_neurostim_max;
win_neuro = processed.win_neuro;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

del = round(1*1/(isi*10^-3));

plot(axesdetect, Time(vol_contrac_start(id_axes)-del:vol_contrac_end(id_axes)+del),...
    data(vol_contrac_start(id_axes)-del:vol_contrac_end(id_axes)+del));

yl = get(axesdetect, 'YLim');

hold on

axis(axesdetect, [(vol_contrac_start(id_axes)-del)* isi*10^-3 (vol_contrac_end(id_axes)+del)*isi*10^-3 yl(1) yl(2)]);
% plot of voluntary contraction start and end
handles.hcontrac_start = plot(axesdetect, [vol_contrac_start(id_axes)*isi*10^-3 vol_contrac_start(id_axes)*isi*10^-3],...
    [yl(1) yl(2)],'r');
handles.hcontrac_end = plot(axesdetect, [vol_contrac_end(id_axes)* isi*10^-3 vol_contrac_end(id_axes)* isi*10^-3],...
    [yl(1) yl(2)],'r');
% plot of minimum and maximum superimposed force contraction
if superimposed_B_I(id_axes) == 0
    handles.hsup_force_min = plot(axesdetect, [(stim(id_axes)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(id_axes)* isi*10^-3],...
        [superimposed_B(id_axes) superimposed_B(id_axes)],'k');
    handles.hsup_force_max = plot(axesdetect, [(stim(id_axes)-superimposed_window*1/(isi*10^-3))* isi*10^-3 stim(id_axes)* isi*10^-3],...
        [superimposed_F(id_axes) superimposed_F(id_axes)],'k');
else
    handles.hsup_force_min = plot(axesdetect, [(superimposed_B_I(id_axes)-0.25*1/(isi*10^-3))* isi*10^-3 (superimposed_B_I(id_axes)+0.25*1/(isi*10^-3))* isi*10^-3],...
        [superimposed_B(id_axes) superimposed_B(id_axes)],'k');
    handles.hsup_force_max = plot(axesdetect, [(superimposed_F_I(id_axes)-0.25*1/(isi*10^-3))* isi*10^-3 (superimposed_F_I(id_axes)+0.25*1/(isi*10^-3))* isi*10^-3],...
        [superimposed_F(id_axes) superimposed_F(id_axes)],'k');
end
% plot of basal and maximum voluntary contraction
if max_B_I(id_axes) == 0
    handles.hmax_B = plot(axesdetect, [(vol_contrac_start(id_axes)-baseline_duration_contrac*1/(isi*10^-3))* isi*10^-3 (vol_contrac_start(id_axes)-baseline_duration_contrac/3*1/(isi*10^-3))* isi*10^-3],...
        [max_B(id_axes) max_B(id_axes)],'r');
else
    handles.hmax_B = plot(axesdetect, [(max_B_I(id_axes)-0.25*1/(isi*10^-3))* isi*10^-3 (max_B_I(id_axes)+0.25*1/(isi*10^-3))* isi*10^-3],...
        [max_B(id_axes) max_B(id_axes)],'r');
end
handles.hmax_C = plot(axesdetect, [(max_C_I(id_axes)-0.25*1/(isi*10^-3))* isi*10^-3 (max_C_I(id_axes)+0.25*1/(isi*10^-3))* isi*10^-3],...
    [max_C(id_axes) max_C(id_axes)],'k');
to_plot = ['zoom on force plateau #' num2str(id_axes)];
title(to_plot);

if id_axes > 1
    % plot of minimum and maximum neurostim contraction
    if contrac_neurostim_min_I(id_axes) == 0
        handles.hneurostim_min = plot(axesdetect, [(contrac_neurostim(id_axes,2)+win_neuro)* isi*10^-3 (contrac_neurostim(id_axes,2)+2000)* isi*10^-3],...
            [contrac_neurostim_min(id_axes) contrac_neurostim_min(id_axes)],'--g');
        handles.hneurostim_max = plot(axesdetect, [(contrac_neurostim(id_axes,2)+win_neuro)* isi*10^-3 (contrac_neurostim(id_axes,2)+2000)* isi*10^-3],...
            [contrac_neurostim_max(id_axes) contrac_neurostim_max(id_axes)],'--g');
    else
        handles.hneurostim_min = plot(axesdetect, [(contrac_neurostim_min_I(id_axes)-0.25*1/(isi*10^-3))* isi*10^-3 (contrac_neurostim_min_I(id_axes)+0.25*1/(isi*10^-3))* isi*10^-3],...
            [contrac_neurostim_min(id_axes) contrac_neurostim_min(id_axes)],'--g');
        handles.hneurostim_max = plot(axesdetect, [(contrac_neurostim_max_I(id_axes)-0.25*1/(isi*10^-3))* isi*10^-3 (contrac_neurostim_max_I(id_axes)+0.25*1/(isi*10^-3))* isi*10^-3],...
            [contrac_neurostim_max(id_axes) contrac_neurostim_max(id_axes)],'--g');
    end
end

hold off

% Plot whole set of contractions + voluntary contractions
function handles = plot_fcn2(handles)

id_axes = handles.id_axes - (11*(handles.id_cond-1)+handles.id_cond);
axesdetect = handles.axesdetect;
processed = handles.processed;

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

del = round(0.3*1/(isi*10^-3));

plot(axesdetect, Time(stim_contrac_start_p(id_axes)-del:stim_contrac_end(id_axes)+del),...
    data(stim_contrac_start_p(id_axes)-del:stim_contrac_end(id_axes)+del,1))

yl = get(axesdetect, 'YLim');

% ----------

hold on

% plot of contraction start and end
handles.hstim_contrac_start = plot(axesdetect, [stim_contrac_start_p(id_axes)* isi*10^-3 stim_contrac_start_p(id_axes)* isi*10^-3],...
    [yl(1) yl(2)],'r');
handles.hstim_contrac_end = plot(axesdetect, [stim_contrac_end(id_axes)* isi*10^-3 stim_contrac_end(id_axes)* isi*10^-3],...
    [yl(1) yl(2)],'r');
% plot of maximum neurostim contraction intensity
handles.hneurostim_max = plot(axesdetect, [stim_contrac_start_p(id_axes)* isi*10^-3 stim_contrac_end(id_axes)* isi*10^-3],...
    [neurostim_max(id_axes) neurostim_max(id_axes)],'k');
% plot of baseline activity before neurostimulation
handles.hneurostim_B = plot(axesdetect, [(stim_contrac_start(id_axes) - B_before_neurostim(1)*1/(isi*10^-3))* isi*10^-3 (stim_contrac_start(id_axes) - B_before_neurostim(2)*1/(isi*10^-3))* isi*10^-3],...
    [neurostim_B(id_axes) neurostim_B(id_axes)],'g');
% plot of timeline from neurostim start to maximum neurostim activity
handles.htime_peak = plot(axesdetect, [stim_contrac_start_p(id_axes)* isi*10^-3 neurostim_max_I(id_axes)* isi*10^-3],...
    [mean(data(stim_contrac_start_p(id_axes):stim_contrac_end(id_axes),1)) mean(data(stim_contrac_start_p(id_axes):stim_contrac_end(id_axes),1))],'k');
% plot of timeline from maxium peak to half neurostim activity
handles.hHRT_abs = plot(axesdetect, [neurostim_max_I(id_axes)* isi*10^-3 HRT_abs(id_axes)* isi*10^-3],...
    [(neurostim_max(id_axes)-neurostim_B(id_axes))/2 + neurostim_B(id_axes) (neurostim_max(id_axes)-neurostim_B(id_axes))/2 + neurostim_B(id_axes)],'k');
% plot of maximum neurostim activity instant
handles.hneurostim_max_I = plot(axesdetect, [neurostim_max_I(id_axes)* isi*10^-3 neurostim_max_I(id_axes)* isi*10^-3],...
    [yl(1) neurostim_max(id_axes)],'k--');
% -------------

hold off

% Plot for neurostimulation at rest
function handles = plot_fcn3(handles)

id_axes = handles.id_axes - (11*(handles.id_cond-1)+(handles.id_cond-1));
axesdetect = handles.axesdetect;
processed = handles.processed;
k = handles.id_cond - 1;

% initialization of variables to be plotted
M_wave_start_I = processed.M_wave_start_I;
M_wave_end_I = processed.M_wave_end_I;
max_M_wave_I = processed.max_M_wave_I;
min_M_wave_I = processed.min_M_wave_I;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

del = [300, 1000];

plot(axesdetect, Time(max_M_wave_I(id_axes,k)-del(1):max_M_wave_I(id_axes,k)+del(2)), ...
    data(max_M_wave_I(id_axes,k)-del(1):max_M_wave_I(id_axes,k)+del(2),k))

yl = get(axesdetect, 'YLim');

hold on

% plot of M wave start and end
handles.hM_wave_start_I = plot(axesdetect, [M_wave_start_I(id_axes,k)* isi*10^-3 M_wave_start_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'r');
handles.hM_wave_end_I = plot(axesdetect, [M_wave_end_I(id_axes,k)* isi*10^-3 M_wave_end_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'g');
% plot of M wave minimum and maximum
handles.hmin_M_wave_I = plot(axesdetect, [min_M_wave_I(id_axes,k)* isi*10^-3 min_M_wave_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'--m');
handles.hmax_M_wave_I = plot(axesdetect, [max_M_wave_I(id_axes,k)* isi*10^-3 max_M_wave_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'--k');

legend(axesdetect, 'EMG','Start','End','Min','Max');

hold off


% Plot for neurostimulation at exercise
function handles = plot_fcn4(handles)

id_axes = handles.id_axes - (11*(handles.id_cond-1)+(handles.id_cond-1));
axesdetect = handles.axesdetect;
processed = handles.processed;
k = handles.id_cond - 4;
del = [300, 1000];

% initialization of variables to be plotted
M_wave_ex_max_I = processed.M_wave_ex_max_I;
M_wave_ex_min_I = processed.M_wave_ex_min_I;
M_wave_ex_start_I = processed.M_wave_ex_start_I;
M_wave_ex_end_I = processed.M_wave_ex_end_I;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

plot(axesdetect, Time(M_wave_ex_max_I(id_axes,k)-del(1):M_wave_ex_max_I(id_axes,k)+del(2)),...
    data(M_wave_ex_max_I(id_axes,k)-del(1):M_wave_ex_max_I(id_axes,k)+del(2),k))

yl = get(axesdetect, 'YLim');

hold on

% plot of M wave start and end at exercise
handles.hM_wave_ex_start_I = plot(axesdetect, [M_wave_ex_start_I(id_axes,k)* isi*10^-3 M_wave_ex_start_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'r');
handles.hM_wave_ex_end_I = plot(axesdetect, [M_wave_ex_end_I(id_axes,k)* isi*10^-3 M_wave_ex_end_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'g');
% plot of M wave minimum and maximum at exercise
handles.hM_wave_ex_min_I = plot(axesdetect, [M_wave_ex_min_I(id_axes,k)* isi*10^-3 M_wave_ex_min_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'--m');
handles.hM_wave_ex_max_I = plot(axesdetect, [M_wave_ex_max_I(id_axes,k)* isi*10^-3 M_wave_ex_max_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'--k');

legend(axesdetect, 'EMG','Start','End','Min','Max');

hold off


% Plot for TMS and MEP
function handles = plot_fcn5(handles)

id_axes = handles.id_axes - (11*(handles.id_cond-1)+(handles.id_cond));
axesdetect = handles.axesdetect;
processed = handles.processed;
k = handles.id_cond - 7;

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

del = [0, 5000];

plot(axesdetect, Time(TMS_stim(id_axes)-round(win_pre_stim*10^-3*1/(isi*10^-3))-del(1):EMG_recov_point(id_axes,k)+del(2)),...
    data(TMS_stim(id_axes)-round(win_pre_stim*10^-3*1/(isi*10^-3))-del(1):EMG_recov_point(id_axes,k)+del(2),k))

yl = get(axesdetect, 'YLim');

hold on

% plot of MEP start and end after TMS
handles.hM_wave_MEP_start_I = plot(axesdetect, [M_wave_MEP_start_I(id_axes,k)* isi*10^-3 M_wave_MEP_start_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'r');
handles.hM_wave_MEP_end_I = plot(axesdetect, [M_wave_MEP_end_I(id_axes,k)* isi*10^-3 M_wave_MEP_end_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'g');
% plot of MEP minimum and maximum after TMS
handles.hM_wave_MEP_min_I = plot(axesdetect, [M_wave_MEP_min_I(id_axes,k)* isi*10^-3 M_wave_MEP_min_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'--m');
handles.hM_wave_MEP_max_I = plot(axesdetect, [M_wave_MEP_max_I(id_axes,k)* isi*10^-3 M_wave_MEP_max_I(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'--k');
% plot of TMS pulse and EMG recovery point
handles.hTMS_stim = plot(axesdetect, [Time(TMS_stim(id_axes)) Time(TMS_stim(id_axes))],...
    [yl(1) yl(2)],'c');
handles.hEMG_recov_point = plot(axesdetect, [EMG_recov_point(id_axes,k)* isi*10^-3 EMG_recov_point(id_axes,k)* isi*10^-3],...
    [yl(1) yl(2)],'y');

legend(axesdetect, 'EMG','Start','End','Min','Max','TMS','Recovery');

hold off


function handles = plot_fcn6(handles)

axesdetect = handles.axesdetect;
processed = handles.processed;


contrac_start = processed.contrac_start;
contrac_end = processed.contrac_end;
Twitch_x = processed.Twitch_x;
Twitch_y = processed.Twitch_y;
HRT = processed.HRT;
baseline = processed.baseline;

signal = processed.signal;
data = signal.data;
Time = signal.time;

plot(axesdetect, Time(Twitch_x-5000:Twitch_x+5000),data(Twitch_x-5000:Twitch_x+5000,1))

yl = get(axesdetect, 'YLim');
xl = get(axesdetect, 'XLim');

hold on

handles.hTwitch = plot(axesdetect, [Time(Twitch_x-200) Time(Twitch_x+200)],[Twitch_y Twitch_y],'r');
handles.hTwitch_dashed = plot(axesdetect, [Time(Twitch_x) Time(Twitch_x)],[yl(1) yl(2)],'--k');
handles.hcontrac_start = plot(axesdetect, [Time(contrac_start(1)) Time(contrac_start(1))],[yl(1) yl(2)],'k');
handles.hcontrac_end = plot(axesdetect, [Time(contrac_end(1)) Time(contrac_end(1))],[yl(1) yl(2)],'k');
handles.hHRT = plot(axesdetect, [Time(HRT) Time(HRT)],[yl(1) yl(2)],'m');
handles.hstart_dashed = plot(axesdetect, [Time(contrac_start(1)) Time(Twitch_x)],[(yl(2)-yl(1))/2+yl(1)+5 (yl(2)-yl(1))/2+yl(1)+5],'--k');
handles.hHRT_dashed = plot(axesdetect, [Time(Twitch_x) Time(HRT)],[(yl(2)-yl(1))/2+yl(1) (yl(2)-yl(1))/2+yl(1)],'--k');
handles.hbaseline = plot(axesdetect, [xl(1) (xl(2)-xl(1))/10+xl(1)],[baseline baseline],'r');

hold off

function handles = plot_fcn7(handles)

axesdetect = handles.axesdetect;
processed = handles.processed;

k = handles.id_axes - 6;

signal = processed.signal;
data = signal.data;
Time = signal.time;

contrac_neurostim = processed.contrac_neurostim;
M_wave_ex_start_I = processed.M_wave_ex_start_I;
M_wave_ex_end_I =processed. M_wave_ex_end_I;
M_wave_ex_min_I = processed.M_wave_ex_min_I;
M_wave_ex_max_I = processed.M_wave_ex_max_I;

plot(axesdetect, Time(contrac_neurostim(k+1)-300:contrac_neurostim(k+1)+1500),data(contrac_neurostim(k+1)-300:contrac_neurostim(k+1)+1500,k+1))
hold on
x=axis;
axis([Time(contrac_neurostim(k+1)-300) Time(contrac_neurostim(k+1)+1500) x(3) x(4)])
handles.hM_wave_ex_start_I = plot(axesdetect, [Time(M_wave_ex_start_I(k+1)) Time(M_wave_ex_start_I(k+1))],[x(3) x(4)],'k');
handles.hM_wave_ex_end_I = plot(axesdetect, [Time(M_wave_ex_end_I(k+1)) Time(M_wave_ex_end_I(k+1))],[x(3) x(4)],'k');
handles.hM_wave_ex_min_I = plot(axesdetect, [Time(M_wave_ex_min_I(k+1)) Time(M_wave_ex_min_I(k+1))],[x(3) x(4)],'y');
handles.hM_wave_ex_max_I = plot(axesdetect, [Time(M_wave_ex_max_I(k+1)) Time(M_wave_ex_max_I(k+1))],[x(3) x(4)],'g');

hold off

function handles = plot_fcn10(handles)

axesdetect = handles.axesdetect;
processed = handles.processed;

contrac_start = processed.contrac_start;
contrac_end = processed.contrac_end;
contrac_max_I = processed.contrac_max_I;
contrac_max = processed.contrac_max;

signal = processed.signal;
data = signal.data;
Time = signal.time;

plot(axesdetect, Time,data(:,1));

yl = get(axesdetect, 'YLim');

hold on

handles.hcontrac_start_I = plot(axesdetect, [Time(contrac_start) Time(contrac_start)],[yl(1) yl(2)],'r');
handles.hcontrac_end_I = plot(axesdetect, [Time(contrac_end) Time(contrac_end)],[yl(1) yl(2)],'r');
for i=2:1:3
    handles.hcontrac_max(i) = plot(axesdetect, [Time(contrac_max_I(i)-10000) Time(contrac_max_I(i)+10000)],[contrac_max(i) contrac_max(i)],'k');
end
hold off


function handles = plot_fcn11(handles)

axesdetect = handles.axesdetect;
processed = handles.processed;

vol_contrac_start = processed.vol_contrac_start;
vol_contrac_end = processed.vol_contrac_end;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;


plot(axesdetect, Time,data(:,1));
yl = get(axesdetect, 'YLim');

hold on
for i=1:4
    handles.hvol_contrac_start(i) = plot(axesdetect, [vol_contrac_start(i)*isi*10^-3 vol_contrac_start(i)*isi*10^-3],...
        [yl(1) yl(2)],'r');
    handles.hvol_contrac_end(i) = plot(axesdetect, [vol_contrac_end(i)* isi*10^-3 vol_contrac_end(i)* isi*10^-3],...
        [yl(1) yl(2)],'r');
end
hold off

function handles = plot_fcn12(handles)

axesdetect = handles.axesdetect;
processed = handles.processed;

stim_contrac_start_p = processed.stim_contrac_start_p;
stim_contrac_end = processed.stim_contrac_end;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

plot(axesdetect, Time,data(:,1));
hold on
yl = get(axesdetect, 'YLim');

for i = 1:3
    handles.hstim_contrac_start_p(i) = plot(axesdetect, [stim_contrac_start_p(i)* isi*10^-3 stim_contrac_start_p(i)* isi*10^-3],...
        [yl(1) yl(2)],'r');
    handles.hstim_contrac_end(i) = plot(axesdetect, [stim_contrac_end(i)* isi*10^-3 stim_contrac_end(i)* isi*10^-3],...
        [yl(1) yl(2)],'r');
end
hold off

function handles = plot_fcn13(handles)
% This is disabled beacuse it's not necessary now

axesdetect = handles.axesdetect;
processed = handles.processed;

M_wave_start_I = processed.M_wave_start_I;
M_wave_end_I = processed.M_wave_end_I;

k = handles.id_cond - 1;

signal = processed.signal;
data = signal.data;
Time = signal.time;
isi = signal.isi;

plot(axesdetect, Time,data(:,k));
hold on
yl = get(axesdetect, 'YLim');

for i = 2:3
    handles.hM_wave_start_I(i-1) = plot(axesdetect, [M_wave_start_I(i,k)* isi*10^-3 M_wave_start_I(i,k)* isi*10^-3],...
        [yl(1) yl(2)],'r');
    handles.hM_wave_end_I(i-1) = plot(axesdetect, [M_wave_end_I(i,k)* isi*10^-3 M_wave_end_I(i,k)* isi*10^-3],...
        [yl(1) yl(2)],'r');
end
hold off

function handles = plot_fcn14(handles)

axesdetect = handles.axesdetect;
processed = handles.processed;

contrac_neurostim = processed.contrac_neurostim;
k = handles.id_cond - 4;

signal = processed.signal;
data = signal.data;
Time = signal.time;

nr = size(contrac_neurostim,1);

plot(axesdetect, Time,data(:,k));
hold on
yl = get(axesdetect, 'YLim');

for i = 1:nr
    handles.hcontrac_neurostim(i) = plot(axesdetect,...
        [Time(contrac_neurostim(i,k)) Time(contrac_neurostim(i,k))], [yl(1) yl(2)],'r');
end
hold off