function output_reader = reader_multi
%OUTPUT_READER Summary of this function goes here
%   Detailed explanation goes here

% loading signal data
% [filename, pathname] = uigetfile({'*.mat','MAT-files (*.mat)'},...
%     'Select the signal file');

% signal = load([pathname filename]);

[file_aux, path_aux, id] = uigetfile({'*.csv', 'Comma Separated Values'},...
    'Import multiple files', 'MultiSelect', 'on');

n_files = size(file_aux, 2);
file_aux = sort(file_aux);
file_prop = cell(1, size(file_aux, 2));

signal_par = struct;
configuration_par = struct;
data_aux = cell(1, size(file_aux,2));
delimit_aux = cell(1, size(file_aux,2));
hdr_aux = cell(1, size(file_aux,2));

% read file data
for i = 1:n_files
    
    [data_aux{1,i}, delimit_aux{1,i}, hdr_aux{1,i}] = importdata([path_aux file_aux{i}]); 
    file_prop{1,i} = strsplit(file_aux{i}, {'_', '.'});
    
    % extract sampling frequency from comments
    fs_str = data_aux{i}.textdata{1};
    fs{i} = str2double(fs_str(find(fs_str == '=')+2:find((fs_str == '/'))-1));
    chans{i} = str2double(fs_str(find((fs_str == '/'))+1:end));
       
end

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

