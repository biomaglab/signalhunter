function save_tms_vc(reader, processed)
%SAVE_TMS_VC Summary of this function goes here
%   Detailed explanation goes here

sub_name = reader.sub_name;
leg = reader.leg;
series_nb = reader.series_nb;

filename = [sub_name '_' leg '_' num2str(series_nb) '.mat'];

% loading output template
[output_file, ouput_path] = uiputfile({'*.mat','MATLAB File (*.mat)'},...
    'Save processed data', filename);

save([ouput_path output_file], 'processed', 'reader');