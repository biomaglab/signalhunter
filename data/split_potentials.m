function [split_pots, split_baseline] = split_potentials(data, trigger, fs, tpot, tbase)
%SPLIT_POTENTIALS Split signal into potentials using trigger channel
% 
% INPUT:
% 
% data: m x n array (m is signal length and n is number of channels)
% trigger: m x 1 array (m is length of trigger equal to data
% fs: sampling frequency in Hz
% tpot: [a b] (a is window start after trigger onset and b is window
% duration after a - miliseconds)
% tbase: [c d] (c is window end before trigger onset and d is window
% duration before c - miliseconds)
% 
% OUTPUT:
%
% split_pots: i x j x k array (i is potential signal, j is potentials and k
% is channels
% split_baseline: i x j x k array (i is baseline signal, j is potentials
% and k is channels
%

% find trigger instants
triggeron_aux = find(trigger/max(trigger) > 0.5);
triggeron_aux = (triggeron_aux(diff([-inf;triggeron_aux])>1));

% define epoch over which MEPs will be averaged
samples_to_offset = ceil((tpot(1)/1000)*fs);
samples_after_trigger = ceil((tpot(2)/1000)*fs);

samples_triggeron = ([triggeron_aux+samples_to_offset ones(numel(triggeron_aux),1)]*[ones(1,samples_after_trigger);1:samples_after_trigger])';

% define baseline activity before trigger
samples_up_offset = ceil((tbase(1)/1000)*fs);
samples_before_trigger = ceil((tbase(2)/1000)*fs);

samples_baseline = ([triggeron_aux-samples_up_offset ones(numel(triggeron_aux),1)]*[ones(1,samples_before_trigger);-samples_before_trigger:-1])';

pots = data(samples_triggeron(:),:);
split_pots = reshape(pots,size(samples_triggeron,1),size(samples_triggeron,2),size(pots,2));

baseline = data(samples_baseline(:),:);
split_baseline = reshape(baseline,size(samples_baseline,1),size(samples_baseline,2),size(baseline,2));

