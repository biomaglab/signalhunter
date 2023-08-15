
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
% Date: 30.03.2019


function processed = process_mepanalysis(reader)
%PROCESS_MEPANALYSIS Process and calculate MEP amplitude and latency
%   Split potentials, calculate amplitude and latency of MEP organized in
%   column-wise arrays for a single CSV file.
% 
% INPUT:
% 
% reader: structure with read variables
% 
% OUTPUT:
%
% processed: structure with data processed
% 

signal = reader.signal;
n_frames = reader.n_frames;
fs = reader.fs;

xs = signal.xs;
data = signal.data;
trigger = signal.trigger;

epoched = false;

% Potential window start after trigger onset (miliseconds)
t0 = 10;
% Potential window duration after t0 (miliseconds)
t1 = 60;
% Potential window start for peak findind (miliseconds)
tstart = 5;

% Baseline window start before trigger onset (miliseconds)
tb0 = 1;
% Baseline window duration before tb0 (miliseconds)
tb1 = 20;

% Threshold for latency calculation
thresh_lat = 0.7;

split_pots = cell(n_frames, 1);
average_pots = cell(n_frames, 1);
split_baseline = cell(n_frames, 1);
split_xs = cell(n_frames, 1);
xs_norm = cell(n_frames, 1);

latency_I = cell(n_frames, 1);
latency = cell(n_frames, 1);
ppamp = cell(n_frames, 1);
pmin = cell(n_frames, 1);
pmax = cell(n_frames, 1);

latency_av = cell(n_frames, 1);
ppamp_av = cell(n_frames, 1);
pmin_av = cell(n_frames, 1);
pmax_av = cell(n_frames, 1);

globalmin = zeros(n_frames, 1);
globalmax = zeros(n_frames, 1);

npot = zeros(n_frames, 1);
nmusc = zeros(n_frames, 1);

try
    if trigger
        check_trigger(trigger, fs, [t0 t1], [tb0 tb1])
    else
        epoched = true;
    end
catch
    msg = 'Problem detecting triggers, be sure that triggers are valid.';
    herror = errordlg(msg, 'Error');
    error(msg)
end

% Waitbar to show frames progess
% Used this instead of built-in figure progess bar to avoid need of handles
hbar = waitbar(0,'Frame 1','Name','Processing signals...');

for id_f = 1:n_frames
    
    if epoched
        split_pots{id_f, 1} = data(:,id_f);
        split_xs{id_f, 1} = xs;
        xs_norm{id_f,1} = xs*1000;
    else
        [split_pots{id_f, 1}, split_baseline{id_f, 1}] = split_potentials(data(:,id_f),...
            trigger, fs, [t0 t1], [tb0 tb1]);
        % time array in seconds and split relative to trigger
        [split_xs{id_f, 1}, ~] = split_potentials(xs, trigger, fs,...
            [t0 t1], [tb0 tb1]);

        samples_up_offset = ceil((tb0/1000)*fs);
        samples_before_trigger = ceil((tb1/1000)*fs);
        triggeron_aux = find(trigger/max(trigger) > 0.5);
        triggeron_aux = (triggeron_aux(diff([-inf;triggeron_aux])>1));
        % Remove the potentials without enough baseline, check for possible
        % negative or zero indices in trigger. Look inside split_potentials
        % function for more information
        triggeron_aux = triggeron_aux((triggeron_aux - samples_up_offset - samples_before_trigger) > 0);
        % xs_norm in miliseconds and zero as trigger instant
        xs_norm{id_f,1} = (split_xs{id_f,1} - repmat(xs(triggeron_aux)', [size(split_xs{id_f,1},1) 1]))*1000;
    end
    
    ppamp{id_f,1} = zeros(1,size(split_pots{id_f, 1},2), size(split_pots{id_f, 1},3));
    pmin{id_f,1} = zeros(2,size(split_pots{id_f, 1},2), size(split_pots{id_f, 1},3));
    pmax{id_f,1} = zeros(2,size(split_pots{id_f, 1},2), size(split_pots{id_f, 1},3));
    
    average_pots{id_f,1} = mean(split_pots{id_f,1},2);
    
    
    for ri = 1:size(split_pots{id_f, 1},3)
        
        [ppamp{id_f,1}(:,:,ri), pmin{id_f,1}(:,:,ri), pmax{id_f,1}(:,:,ri)] = p2p_amplitude(split_pots{id_f,1}(:,:,ri), fs, [tstart t1]);
        %             latency_I{id_cond,1}(:,:,ri) = find_latency(split_pots{id_cond,1}(:,:,ri), thresh_lat);
        %             latency{i,j}(:,:,k) = latency_I{i,j}(:,:,k)/fs{i,j} + t0/1000;
        
        [ppamp_av{id_f,1}(:,:,ri), pmin_av{id_f,1}(:,:,ri), pmax_av{id_f,1}(:,:,ri)] = p2p_amplitude(average_pots{id_f,1}(:,:,ri), fs, [tstart t1]);
        %             latency_I_av{id_cond,1}(:,:,ri) = find_latency(average_pots{id_cond,1}(:,:,ri), thresh_lat);
        
        latency{id_f,1}(1,:,ri) = find_latency(split_pots{id_f,1}(:,:,ri), thresh_lat, fs, [tstart t1]);
        latency{id_f,1}(2,:,ri) = xs_norm{id_f,1}(latency{id_f,1}(1,:,ri));
        latency_av{id_f,1}(1,:,ri) = find_latency(average_pots{id_f,1}(:,:,ri), thresh_lat, fs, [tstart t1]);
        latency_av{id_f,1}(2,:,ri) = xs_norm{id_f,1}(latency_av{id_f,1}(1,:,ri));
        
    end

    if epoched
        globalmin(id_f,1) = pmin{id_f,1}(2);
        globalmax(id_f,1) = pmax{id_f,1}(2);
    else
        globalmin(id_f,1) = min(min(min(pmin{id_f,1}(2,:))));
        globalmax(id_f,1) = max(max(max(pmax{id_f,1}(2,:))));
    end
    
    npot(id_f,1) = size(ppamp{id_f,1},2);
    nmusc(id_f,1) = size(ppamp{id_f,1},3);
    
    % Report current estimate in the waitbar's message field
    waitbar(id_f/n_frames,hbar,sprintf('Frame %d',id_f))
end

n_muscles = max(max(nmusc));
n_pots = max(max(npot));

delete(hbar)

processed.split_pots = split_pots;
processed.split_baseline = split_baseline;
processed.split_xs = split_xs;
processed.xs_norm = xs_norm;

processed.latency = latency;
processed.latency_I = latency_I;
processed.ppamp = ppamp;
processed.pmin = pmin;
processed.pmax = pmax;

processed.average_pots = average_pots;
processed.latency_av = latency_av;
processed.ppamp_av = ppamp_av;
processed.pmin_av = pmin_av;
processed.pmax_av = pmax_av;

% output.latency_I_av_bkp = latency_I_av;
processed.latency_av_bkp = latency_av;
processed.ppamp_av_bkp = ppamp_av;
processed.pmin_av_bkp = pmin_av;
processed.pmax_av_bkp = pmax_av;

processed.globalmin = globalmin;
processed.globalmax = globalmax;

processed.n_muscles = n_muscles;
processed.n_pots = n_pots;

end


function check_trigger(trigger, fs, tpot, tbase)

% define epoch over which potentials will be split
samples_to_offset = ceil((tpot(1)/1000)*fs);
samples_after_trigger = ceil((tpot(2)/1000)*fs);

% define baseline activity before trigger
samples_up_offset = ceil((tbase(1)/1000)*fs);
samples_before_trigger = ceil((tbase(2)/1000)*fs);


% find trigger instants
triggeron_aux = find(trigger/max(trigger) > 0.5);
triggeron_aux = (triggeron_aux(diff([-inf;triggeron_aux])>1));
% Alternative 3 (read 1 and 2 below) to remove the potentials without
% enough baseline, check for possible negative or zero indices in trigger
triggeron_aux = triggeron_aux((triggeron_aux - samples_up_offset - samples_before_trigger) > 0);

samples_triggeron = ([triggeron_aux+samples_to_offset ones(numel(triggeron_aux),1)]*[ones(1,samples_after_trigger);1:samples_after_trigger])';

samples_baseline = ([triggeron_aux-samples_up_offset ones(numel(triggeron_aux),1)]*[ones(1,samples_before_trigger);-samples_before_trigger:-1])';

end