function output_reader = reader_tms_vc

% loading signal and configuration data
[filename, pathname, ~] = uigetfile({'*.mat','MAT-files (*.mat)'},...
    'Select the signal file');

% signal = load(filename);
signal = load([pathname filename]);

% find subject name
temp = find(pathname=='\');
temp2 = find(pathname=='_');
sub_name = pathname(temp(end-1)+1:temp2(end)-1);

% find dominant or non dominant leg
if temp(end) - temp2(end) == 2
    leg = 'D';
else
    leg = 'ND';
end

clearvars temp temp2

% Load threshold values
% [filename_xls, pathname_xls, ~] = uigetfile({'*.xls','Excel Files (*.xls)'},...
%     'Select the threshold file');

% the filename must be 'threshold.xlsx'
% [num_T, txt_T, ~] = xlsread([pathname_xls, filename_xls]);
[num_T, txt_T, tab_T] = xlsread('thresholds.xls');
txt_T = txt_T(2:end,:);
find_name = strfind(txt_T,sub_name);
emptyIndex = cellfun(@isempty,find_name);  %# Find indices of empty cells
find_name(emptyIndex) = {0};               %# Fill empty cells with 0
find_name = logical(cell2mat(find_name));  %# Convert the cell array
line_to_read = find(find_name==1,1);
series_nb = str2double(filename(end-4));   % get series_nb 
line_to_read = line_to_read + series_nb - 1;

% Load sequence TMS neurostim
% [filename_xlsx, pathname_xlsx, ~] = uigetfile({'*.xlsx','Excel Files (*.xlsx)'},...
%     'Select the TMS sequence file');
% the filename must be 'SeqTMSandENS.xlsx'
% [num_S, txt_S, ~] = xlsread([pathname_xlsx, filename_xlsx]);
[num_S, txt_S, ~] = xlsread('SeqTMSandENS.xlsx');
find_name = strfind(txt_S,sub_name);
emptyIndex = cellfun(@isempty,find_name);  %# Find indices of empty cells
find_name(emptyIndex) = {0};               %# Fill empty cells with 0
find_name = logical(cell2mat(find_name));  %# Convert the cell array
line_to_read_2 = find(find_name==1,1);
line_to_read_2 = line_to_read_2 - 2;
order_TMS = num_S(line_to_read_2,1);

fig_titles = {'Whole set of contractions + voluntary contractions characteristics',...
    'Whole set of contractions + neurostim while @ rest',...
    strcat('Neurostim @ rest ', signal.labels(2,:)),...
    strcat('Neurostim @ rest ', signal.labels(3,:)),...
    strcat('Neurostim @ rest ', signal.labels(4,:)),...
    strcat('Neurostim @ exercise ', signal.labels(2,:)),...
    strcat('Neurostim @ exercise ', signal.labels(3,:)),...
    strcat('Neurostim @ exercise ', signal.labels(4,:)),...
    strcat('TMS & MEP ', signal.labels(2,:)),...
    strcat('TMS & MEP ', signal.labels(3,:)),...
    strcat('TMS & MEP ', signal.labels(4,:))};

output_reader.filename = filename;
output_reader.pathname = pathname;
output_reader.sub_name = sub_name;
output_reader.leg = leg;
output_reader.num_T = num_T;
output_reader.line_to_read = line_to_read;
output_reader.series_nb = series_nb;
output_reader.order_TMS = order_TMS;
output_reader.signal = signal;
output_reader.fig_titles = fig_titles;
