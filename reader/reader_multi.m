function [output_reader, open_id] = reader_multi
%OUTPUT_READER Summary of this function goes here
%   Detailed explanation goes here

% loading signal data
% [filename, pathname] = uigetfile({'*.mat','MAT-files (*.mat)'},...
%     'Select the signal file');

% signal = load([pathname filename]);

% path_aux = uigetdir('D:\repository\signalhunter\tests\ACA');
path_aux = '.\tests\ACA2\';
file_list = struct2cell(dir(path_aux));
file_aux = file_list(1,3:end);
sort(file_aux);

n_files = size(file_aux, 2);
n_instants = 4;
n_side = 2;
muscle_id = {'M1', 'M2', 'M3'};

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
    muscle = cell(n_frames,n_instants);
    
    signal = struct;
    
    data_aux = cell(n_frames,n_instants);
    data = cell(n_frames,n_instants);
    xs = cell(n_frames,n_instants);
    trigger = cell(n_frames,n_instants);
    
    file_names = reshape(file_aux, n_instants, n_frames)';
    
    % Waitbar to show frames progess
    % Used this instead of built-in figure progess bar to avoid need of handles
    hbar = waitbar(0, 'File 1', 'Name','Reading signal...');
    
    % read file data
    for id_cond = 1:n_frames
        for ci = 1:n_instants
            
            data_aux{id_cond,ci} = importdata([path_aux file_names{id_cond,ci}]);
            file_prop{id_cond,ci} = strsplit(file_names{id_cond,ci}, {'_', '.'});
            instant(id_cond,ci) = strcat('T', file_prop{id_cond,ci}(4));
            
            xs{id_cond,ci} = data_aux{id_cond,ci}.data(:,1);
            data{id_cond,ci} = data_aux{id_cond,ci}.data(:,2:end-1);
            trigger{id_cond,ci} = data_aux{id_cond,ci}.data(:,end);
            
            fs{id_cond,ci} =  1/(xs{id_cond,ci}(3,1)-xs{id_cond,ci}(2,1));
            
            % extract sampling frequency from comments - this Fsamp does
            % not make sense
%             fs_str = data_aux{i,j}.textdata{1};
%             fsamp{i,j} = str2double(fs_str(find(fs_str == '=')+2:find((fs_str == '/'))-1));
%             chans{i,j} = str2double(fs_str(find((fs_str == '/'))+1:end));

            % Report status of reading in wait bar
            id_bar = sub2ind([n_instants n_frames], ci, id_cond);
            waitbar(id_bar/(n_frames*n_instants),hbar,sprintf('File %d',id_bar))
            
            subject(id_cond,ci) = strcat('S', file_prop{id_cond,1}(1));
            side(id_cond,ci) = file_prop{id_cond,1}(2);
            condition(id_cond,ci) = strcat('C', file_prop{id_cond,1}(3));
            
            for ri = 1:size(data{1,1}, 2);
                muscle(id_cond,ci,ri) = muscle_id(1,ri);
            end
            
        end
        fig_titles(id_cond,1) = strcat('subject: ', subject(id_cond,1), ' side: ', side(id_cond,1),...
            ' condition: ', condition(id_cond,1));
        
    end
    
    clear data_aux
    delete(hbar)
        
    signal.xs = xs;
    signal.data = data;
    signal.trigger = trigger;
    signal.filename = file_names;
    
    n_muscles = size(data{1,1}, 2);

    output_reader.signal = signal;
    output_reader.path = path_aux;
%     output_reader.filename = file_names;
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
    output_reader.n_muscles = n_muscles;
    output_reader.muscle = muscle;
    
    open_id = 1;
else
    
    output_reader = 0;
    open_id = 0;
    
end

