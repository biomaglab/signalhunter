function output_reader = reader_multi
%OUTPUT_READER Summary of this function goes here
%   Detailed explanation goes here

% loading signal data
% [filename, pathname] = uigetfile({'*.mat','MAT-files (*.mat)'},...
%     'Select the signal file');

% signal = load([pathname filename]);

% works for CSV file
[A, dlmout, hdrout] = importdata(f1); 

%get sampling frequency
fs_str = A7.textdata{1};
a1 = find(fs_str == '=');
b1 = find (fs_str == '/');
fs = str2double(fs_str(a1+2:b1-1));
chans = str2double(fs_str(b1+1:end-1));

fs = A7.textdata{1};

signal.Time = linspace(0,2*pi,100);
% y = sin(signal.Time)';
% signal.data = repmat(y, 1, 15, 2);

for j = 1:2
    for i = 1:15
        y(:, i, j) = sin(signal.Time)'/(i*j);
    end
end
signal.data = y;

% output_reader.filename = filename;
% output_reader.process_id = process_id;
% output_reader.pathname = pathname;
% output_reader.sub_name = sub_name;
% output_reader.leg = leg;
% output_reader.num_T = num_T;
% output_reader.line_to_read = line_to_read;
% output_reader.series_nb = series_nb;
% output_reader.order_TMS = order_TMS;
output_reader.signal = signal;
% output_reader.fig_titles = fig_titles;

