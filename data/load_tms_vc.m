function [reader, processed] = load_tms_vc(reader)
%LOAD_TMS_VC Summary of this function goes here
%   Detailed explanation goes here

sub_name = reader.sub_name;
leg = reader.leg;
series_nb = reader.series_nb;

filename = [sub_name '_' leg '_' num2str(series_nb) '.mat'];

[load_file, load_path] = uigetfile({'*.mat','MATLAB File (*.mat)'},...
    'Select the saved processed file', filename);

data_load = load([load_path load_file]);

reader = data_load.reader;
processed = data_load.processed;

