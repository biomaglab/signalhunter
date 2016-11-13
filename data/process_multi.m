
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


function processed = process_multi(reader)
%PROCESS_MULTI Process and calculate MEP amplitude and latency
%   Split potentials, calculate amplitude and latency of MEP organized in
%   column-wise arrays.
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
n_instants = reader.n_instants;
n_frames = reader.n_frames;
fs = reader.fs;

xs = signal.xs;
data = signal.data;
trigger = signal.trigger;

% Potential window start after trigger onset (miliseconds)
t0 = 10;
% Potential window duration after t0 (miliseconds)
t1 = 60;
% Potential window start for peak findind (miliseconds)
tstart = 1;

% Baseline window start before trigger onset (miliseconds)
tb0 = 1;
% Baseline window duration before tb0 (miliseconds)
tb1 = 20;

% Threshold for latency calculation
thresh_lat = 0.7;

split_pots = cell(n_frames, n_instants);
average_pots = cell(n_frames, n_instants);
split_baseline = cell(n_frames, n_instants);
split_xs = cell(n_frames, n_instants);
xs_norm = cell(n_frames, n_instants);

latency_I = cell(n_frames, n_instants);
latency = cell(n_frames, n_instants);
ppamp = cell(n_frames, n_instants);
pmin = cell(n_frames, n_instants);
pmax = cell(n_frames, n_instants);

latency_av = cell(n_frames, n_instants);
ppamp_av = cell(n_frames, n_instants);
pmin_av = cell(n_frames, n_instants);
pmax_av = cell(n_frames, n_instants);

globalmin = zeros(n_frames, n_instants);
globalmax = zeros(n_frames, n_instants);

npot = zeros(n_frames, n_instants);
nmusc = zeros(n_frames, n_instants);

% Waitbar to show frames progess
% Used this instead of built-in figure progess bar to avoid need of handles
hbar = waitbar(0,'Frame 1','Name','Processing signals...');

tic

for id_cond = 1:n_frames
    for ci = 1:n_instants
               
        [split_pots{id_cond, ci}, split_baseline{id_cond, ci}] = split_potentials(data{id_cond,ci},...
            trigger{id_cond,ci}, fs{id_cond,ci}, [t0 t1], [tb0 tb1]);
        % time array in seconds and split relative to trigger
        [split_xs{id_cond, ci}, ~] = split_potentials(xs{id_cond,ci}, trigger{id_cond,ci},...
            fs{id_cond,ci}, [t0 t1], [tb0 tb1]);
        
        ppamp{id_cond,ci} = zeros(1,size(split_pots{id_cond, ci},2), size(split_pots{id_cond, ci},3));
        pmin{id_cond,ci} = zeros(2,size(split_pots{id_cond, ci},2), size(split_pots{id_cond, ci},3));
        pmax{id_cond,ci} = zeros(2,size(split_pots{id_cond, ci},2), size(split_pots{id_cond, ci},3));
        
        average_pots{id_cond,ci} = mean(split_pots{id_cond,ci},2);
        
        triggeron_aux = find(trigger{id_cond,ci}/max(trigger{id_cond,ci}) > 0.5);
        triggeron_aux = (triggeron_aux(diff([-inf;triggeron_aux])>1));
        % xs_norm in miliseconds and zero as trigger instant
        xs_norm{id_cond,ci} = (split_xs{id_cond,ci} - repmat(xs{id_cond,ci}(triggeron_aux)', [size(split_xs{id_cond,ci},1) 1]))*1000;
        
        for ri = 1:size(split_pots{id_cond, ci},3)
            
            [ppamp{id_cond,ci}(:,:,ri), pmin{id_cond,ci}(:,:,ri), pmax{id_cond,ci}(:,:,ri)] = p2p_amplitude(split_pots{id_cond,ci}(:,:,ri), fs{id_cond,ci}, [tstart t1]);
%             latency_I{id_cond,ci}(:,:,ri) = find_latency(split_pots{id_cond,ci}(:,:,ri), thresh_lat);
%             latency{i,j}(:,:,k) = latency_I{i,j}(:,:,k)/fs{i,j} + t0/1000;
            
            [ppamp_av{id_cond,ci}(:,:,ri), pmin_av{id_cond,ci}(:,:,ri), pmax_av{id_cond,ci}(:,:,ri)] = p2p_amplitude(average_pots{id_cond,ci}(:,:,ri), fs{id_cond,ci}, [tstart t1]);
%             latency_I_av{id_cond,ci}(:,:,ri) = find_latency(average_pots{id_cond,ci}(:,:,ri), thresh_lat);
            
            latency{id_cond,ci}(1,:,ri) = find_latency(split_pots{id_cond,ci}(:,:,ri), thresh_lat);
            latency{id_cond,ci}(2,:,ri) = xs_norm{id_cond,ci}(latency{id_cond,ci}(1,:,ri));
            latency_av{id_cond,ci}(1,:,ri) = find_latency(average_pots{id_cond,ci}(:,:,ri), thresh_lat);
            latency_av{id_cond,ci}(2,:,ri) = xs_norm{id_cond,ci}(latency_av{id_cond,ci}(1,:,ri));
            
        end

        globalmin(id_cond,ci) = min(min(min(pmin{id_cond,ci})));
        globalmax(id_cond,ci) = max(max(max(pmax{id_cond,ci})));

        npot(id_cond,ci) = size(ppamp{id_cond,ci},2);
        nmusc(id_cond,ci) = size(ppamp{id_cond,ci},3);
        
    end
    
    % Report current estimate in the waitbar's message field
    waitbar(id_cond/n_frames,hbar,sprintf('Frame %d',id_cond))
end

n_muscles = max(max(nmusc));
n_pots = max(max(npot));

delete(hbar)

toc

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
