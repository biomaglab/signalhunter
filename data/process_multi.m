function output = process_multi(input_reader)
%PROCESS_MULTI Summary of this function goes here
%   Detailed explanation goes here

signal = input_reader.signal;
n_instants = input_reader.n_instants;
n_frames = input_reader.n_frames;
fs = input_reader.fs;

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

latency_I_av = cell(n_frames, n_instants);
latency_av = cell(n_frames, n_instants);
ppamp_av = cell(n_frames, n_instants);
pmin_av = cell(n_frames, n_instants);
pmax_av = cell(n_frames, n_instants);

globalmin = zeros(n_frames, n_instants);
globalmax = zeros(n_frames, n_instants);

% Waitbar to show frames progess
% Used this instead of built-in figure progess bar to avoid need of handles
hbar = waitbar(0,'Frame 1','Name','Processing signals...');

tic

for i = 1:n_frames
    for j = 1:n_instants
               
        [split_pots{i, j}, split_baseline{i, j}] = split_potentials(data{i,j},...
            trigger{i,j}, fs{i,j}, [t0 t1], [tb0 tb1]);
        [split_xs{i, j}, ~] = split_potentials(xs{i,j}, trigger{i,j},...
            fs{i,j}, [t0 t1], [tb0 tb1]);
        
        ppamp{i,j} = zeros(1,size(split_pots{i, j},2), size(split_pots{i, j},3));
        pmin{i,j} = zeros(2,size(split_pots{i, j},2), size(split_pots{i, j},3));
        pmax{i,j} = zeros(2,size(split_pots{i, j},2), size(split_pots{i, j},3));
        
        average_pots{i,j} = mean(split_pots{i,j},2);
        
        triggeron_aux = find(trigger{i,j}/max(trigger{i,j}) > 0.5);
        triggeron_aux = (triggeron_aux(diff([-inf;triggeron_aux])>1));
        xs_norm{i,j} = split_xs{i,j} - repmat(xs{i,j}(triggeron_aux)', [size(split_xs{i,j},1) 1]);
        
        for k = 1:size(split_pots{i, j},3)
            
            [ppamp{i,j}(:,:,k), pmin{i,j}(:,:,k), pmax{i,j}(:,:,k)] = p2p_amplitude(split_pots{i,j}(:,:,k), fs{i,j}, [tstart t1]);
            latency_I{i,j}(:,:,k) = find_latency(split_pots{i,j}(:,:,k), thresh_lat);
%             latency{i,j}(:,:,k) = latency_I{i,j}(:,:,k)/fs{i,j} + t0/1000;
            
            [ppamp_av{i,j}(:,:,k), pmin_av{i,j}(:,:,k), pmax_av{i,j}(:,:,k)] = p2p_amplitude(average_pots{i,j}(:,:,k), fs{i,j}, [tstart t1]);
            latency_I_av{i,j}(:,:,k) = find_latency(average_pots{i,j}(:,:,k), thresh_lat);
            
            latency{i,j}(:,:,k) = xs_norm{i,j}(latency_I{i,j}(:,:,k));
            latency_av{i,j}(:,:,k) = xs_norm{i,j}(latency_I_av{i,j}(:,:,k));
            
        end
        
        globalmin(i,j) = min(min(min(pmin{i,j})));
        globalmax(i,j) = max(max(max(pmax{i,j})));
    end
    
    % Report current estimate in the waitbar's message field
    waitbar(i/n_frames,hbar,sprintf('Frame %d',i))
end

delete(hbar)

toc

output.split_pots = split_pots;
output.split_baseline = split_baseline;
output.split_xs = split_xs;
output.xs_norm = xs_norm;

output.latency = latency;
output.latency_I = latency_I;
output.ppamp = ppamp;
output.pmin = pmin;
output.pmax = pmax;

output.average_pots = average_pots;
output.latency_I_av = latency_I_av;
output.latency_av = latency_av;
output.ppamp_av = ppamp_av;
output.pmin_av = pmin_av;
output.pmax_av = pmax_av;

output.latency_I_av_bkp = latency_I_av;
output.latency_av_bkp = latency_av;
output.ppamp_av_bkp = ppamp_av;
output.pmin_av_bkp = pmin_av;
output.pmax_av_bkp = pmax_av;

output.globalmin = globalmin;
output.globalmax = globalmax;

end
