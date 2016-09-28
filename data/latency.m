function [duration, lat] = latency(data, fs, twin)
%LATENCY Calculate potentials latency
% Use differential signal and then calculate the standard deviation of all
% diff values, then get the location where diff value is 2 times the mean
% standard deviation of all values
%
% INPUT:
% 
% data: m x n array (m is signal length and n is number of potentials)
% fs: sampling frequency in Hz
% twin: [a b] (a is window start and b is window end for latency
% calculation - milisenconds)
% 
% OUTPUT:
%
% duration: 1 x n row vector of latency values
% latency: 2 x n array (1st row is latency instants and 2nd row is latency
% intensity
%


end

