function [output_reader, open_id] = reader_multi
%OUTPUT_READER Summary of this function goes here
%   Detailed explanation goes here

% loading signal data
% [filename, pathname] = uigetfile({'*.mat','MAT-files (*.mat)'},...
%     'Select the signal file');

% signal = load([pathname filename]);

% path_aux = uigetdir('D:\repository\signalhunter\tests\ACA');
path_aux = '.\tests\ACA\';
file_list = struct2cell(dir(path_aux));
file_aux = file_list(1,3:end);
sort(file_aux);

n_files = size(file_aux, 2);
n_instants = 4;
n_side = 2;

if n_files == 40
    n_conditions = 5;
    
elseif n_files == 24
    n_conditions = 3;
    
else
    path_aux = 0;
    
end

if path_aux
    n_frames = n_side*n_conditions;
    file_prop = cell(n_frames,n_instants);
    
    fig_titles = cell(n_frames, 1);
    subject = cell(n_frames,1);
    side = cell(n_frames,1);
    condition = cell(n_frames,1);
    instant = cell(n_frames,n_instants);
    fs = cell(n_frames,n_instants);
%     chans = cell(n_frames,n_instants);
    
    signal = struct;
    
    data_aux = cell(n_frames,n_instants);
    data = cell(n_frames,n_instants);
    xs = cell(n_frames,n_instants);
    trigger = cell(n_frames,n_instants);
    
    file_names = reshape(file_aux, n_instants, n_frames)';
    
    % read file data
    for i = 1:n_frames
        for j = 1:n_instants
            
            data_aux{i,j} = importdata([path_aux file_names{i,j}]);
            file_prop{i,j} = strsplit(file_names{i,j}, {'_', '.'});
            instant{i,j} = file_prop{i,j}(4);
            
            xs{i,j} = data_aux{i,j}.data(:,1);
            data{i,j} = data_aux{i,j}.data(:,2:end-1);
            trigger{i,j} = data_aux{i,j}.data(:,end);
            
            fs{i,j} =  1/(xs{i,j}(3,1)-xs{i,j}(2,1));
                        
            % extract sampling frequency from comments - this Fsamp does
            % not make sense
%             fs_str = data_aux{i,j}.textdata{1};
%             fsamp{i,j} = str2double(fs_str(find(fs_str == '=')+2:find((fs_str == '/'))-1));
%             chans{i,j} = str2double(fs_str(find((fs_str == '/'))+1:end));
            
        end
        subject(i,1) = file_prop{i,1}(1);
        side(i,1) = file_prop{i,1}(2);
        condition(i,1) = file_prop{i,1}(3);
        fig_titles(i,1) = strcat('subject: ', subject(i,1), ' side: ', side(i,1),...
            ' condition: ', condition(i,1));
    end
    clear data_aux
        
    signal.xs = xs;
    signal.data = data;
    signal.trigger = trigger;
    
    output_reader.signal = signal;
    
    output_reader.path = path_aux;
    output_reader.filename = file_names;
    output_reader.subject = subject;
    output_reader.side = side;
    output_reader.condition = condition;
    output_reader.instant = instant;
    output_reader.fig_titles = fig_titles;
    output_reader.fs = fs;
    output_reader.n_files = n_files;
    output_reader.n_conditions = n_conditions;
    output_reader.n_side = n_side;
    output_reader.n_instants = n_instants;
    output_reader.n_frames = n_frames;
    
    open_id = 1;
else
    
    output_reader = 0;
    open_id = 0;
    
end

% for j = 1:2
%     for i = 1:15
%         y(:, i, j) = sin(signal.Time)'/(i*j);
%     end
% end
% signal.data = y;