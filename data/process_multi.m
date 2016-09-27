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

% MEP window start after trigger onset (miliseconds)
t0 = 10;
% MEP window duration after t0 (miliseconds)
t1 = 60;

% Baseline window start before trigger onset (miliseconds)
tb0 = 1;
% Baseline window duration before tb0 (miliseconds)
tb1 = 20;

split_pots = cell(n_frames, n_instants);
split_baseline = cell(n_frames, n_instants);
split_xs = cell(n_frames, n_instants);

for i = 1:n_frames
    for j = 1:n_instants
        
        [split_pots{i, j}, split_baseline{i, j}] = split_potentials(data{i,j},...
            trigger{i,j}, fs{i,j}, [t0 t1], [tb0 tb1]);
        [split_xs{i, j}, ~] = split_potentials(xs{i,j}, trigger{i,j},...
            fs{i,j}, [t0 t1], [tb0 tb1]);
        
    end
end



end

