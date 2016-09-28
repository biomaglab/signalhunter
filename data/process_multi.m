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

split_pots = cell(n_frames, n_instants);
split_baseline = cell(n_frames, n_instants);
split_xs = cell(n_frames, n_instants);

ppamp = cell(n_frames, n_instants);
pmin = cell(n_frames, n_instants);
pmax = cell(n_frames, n_instants);

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
        
        for k = 1:size(split_pots{i, j},3)
            [ppamp{i,j}(:,:,k), pmin{i,j}(:,:,k), pmax{i,j}(:,:,k)] = p2p_amplitude(split_pots{i,j}(:,:,k), fs{i,j}, [tstart t1]);
        end
        
    end
end

toc

i

end

