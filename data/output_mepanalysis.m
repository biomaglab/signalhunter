function tf = output_mepanalysis(reader)
%MEPANALYSIS_OUTPUT Function to standardize the output for MEP ANALYSIS processing

tic
previous_data = [];

amp = reader.mep_amp;
lat = reader.mep_lat;
dur = reader.mep_dur;
states = reader.states;
frames = reader.fig_titles;

[filename, pathname, filterindex] = uiputfile({'*.xls;*.xlsx','MS Excel Files (*.xls,*.xlsx)'},...
    'Export data', 'processed_data.xlsx');

export_data = [states frames num2cell(amp) num2cell(lat) num2cell(dur)];

headers = [{'states'} {'frames'} {'amplitude (mV)'} {'latency (s)'} {'duration (s)'}];

switch filterindex
    case 1
        try
            [~, ~, previous_data] = xlsread([pathname filename]);
        end
        if isempty(previous_data)
            xlswrite([pathname filename], [headers; export_data])
        else
            xlswrite([pathname filename], [previous_data; export_data])
        end
        
    case 2
        fid = fopen([pathname filename]);
        try
            previous_data = fgets(fid);
        end
        the_format = '\n%d %s %d %d %d';
        if isempty(previous_data)
            fid = fopen([pathname filename], 'w');
            fprintf(fid, '%s %s %s %s %s', headers{1,:});
            fprintf(fid, the_format, export_data{1,:});
            fclose(fid);
        else
            fid = fopen([pathname filename], 'a');
            fprintf(fid, the_format, export_data{1,:});
            fclose(fid);
        end
end
tf = toc;

