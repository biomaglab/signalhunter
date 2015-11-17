function output_reader = reader_mepanalysis

% loading signal and configuration data
[filename, pathname] = uigetfile({'*.mat','MAT-files (*.mat)'},...
    'Select the signal file');
data_aux = load([pathname filename]);
var_name = fieldnames(data_aux);
eval(['data = data_aux.' var_name{1} ';']);

% load header information
output_reader.xunits = data.xunits;
output_reader.start = data.start;
output_reader.interval = data.interval;
output_reader.fs = double(data.points);
output_reader.chans = data.chans;
output_reader.n_meps = data.frames;
output_reader.chaninfo = data.chaninfo;
output_reader.frameinfo = data.frameinfo;

signal = squeeze(data.values);
% duration of mep signal set to 200 ms
duration = 0.2*output_reader.fs;
output_reader.signal = signal(1:duration,:);
output_reader.xs = (0:output_reader.interval:(double((duration-1))/double(output_reader.fs)))';

% figure titles with states
fig_titles = cell(output_reader.n_meps,1);
states = cell(output_reader.n_meps,1);
frame_start = cell(output_reader.n_meps,1);
mep_amp = zeros(output_reader.n_meps,1);
mep_pmin = zeros(output_reader.n_meps,2);
mep_pmax = zeros(output_reader.n_meps,2);
for i = 1:output_reader.n_meps
    fig_titles{i,1} = data.frameinfo(i).label;
    states{i,1} = data.frameinfo(i).state;
    frame_start{i,1} = data.frameinfo(i).start;
    [mep_amp(i), mep_pmin(i,:), mep_pmax(i,:)] = peak2peak_amplitude(output_reader.xs,...
        output_reader.signal(:,i), output_reader.fs);
end
output_reader.fig_titles = fig_titles;
output_reader.states = states;
output_reader.frame_start = frame_start;

output_reader.mep_amp = mep_amp;
output_reader.mep_pmin = mep_pmin;
output_reader.mep_pmax = mep_pmax;
output_reader.mep_lat = zeros(output_reader.n_meps,1);
output_reader.mep_end = zeros(output_reader.n_meps,1);
output_reader.mep_dur = zeros(output_reader.n_meps,1);
output_reader.mep_amp_bkp = mep_amp;
output_reader.mep_pmin_bkp = mep_pmin;
output_reader.mep_pmax_bkp = mep_pmax;
output_reader.mep_lat_bkp = zeros(output_reader.n_meps,1);
output_reader.mep_end_bkp = zeros(output_reader.n_meps,1);
output_reader.mep_dur_bkp = zeros(output_reader.n_meps,1);



