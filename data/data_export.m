function [handles, filt_id] = data_export(handles)
%EXPORT_DATA Summary of this function goes here
%   Detailed explanation goes here

switch handles.data_id
        
    case 'tms + vc'
        filt_id = export_tms_vc(handles.reader, handles.processed);
        
    case 'mepanalysis'
        filt_id = export_mepanalysis(handles.reader);
        
    case 'multi channels'
        filt_id = export_multi(handles.reader, handles.processed);
        
end

end



function filt_id = export_mepanalysis(reader)
%EXPORT_MULTI Function to standardize the output for single MEP processing
%   This function exports to Excel and ASCII file with data written in rows
%   and variables in columns


tic

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
        if  exist([pathname filename], 'file')
            [~, ~, previous_data] = xlsread([pathname filename]);
            xlswrite([pathname filename], [previous_data; export_data])
        else
            xlswrite([pathname filename], [headers; export_data])
        end
                
    case 2
        fid = fopen([pathname filename]);
        try
            previous_data = fgets(fid);
        catch
            error('File could not be read.');
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
filt_id = toc;

end


function filt_id = export_multi(reader, processed)
%EXPORT_MULTI Function to standardize the output for multiple files processing
%   This function exports to Excel and ASCII file with data written in rows
%   and variables in columns

sub = reader.subject;
sid = reader.side;
cond = reader.condition;
inst = reader.instant;
musc = reader.muscle;

n_muscles = processed.n_muscles;
n_pots = processed.n_pots;

ppamp_av = processed.ppamp_av;
latency_av = processed.latency_av;

[ppamp_av_arr, idlabel_av] = arrange_table(ppamp_av);
[latency_av_arr, ~] = arrange_table(latency_av);

ppamp = processed.ppamp;
latency = processed.latency;

[ppamp_arr, idlabel] = arrange_table(ppamp);
[latency_arr, ~] = arrange_table(latency);

ntot_av = length(ppamp_av_arr);
ntot = length(ppamp_arr);

nrep = [1,1,n_muscles,n_pots];
reorder = [4,3,2,1];

nrep_av = [1,1,n_muscles];
reorder_av = [3,2,1];

subject = reshape(permute(repmat(sub, nrep), reorder), [ntot,1]);
side = reshape(permute(repmat(sid, nrep), reorder), [ntot,1]);
condition = reshape(permute(repmat(cond, nrep), reorder), [ntot,1]);
instant = reshape(permute(repmat(inst, nrep), reorder), [ntot,1]);
muscle = reshape(permute(repmat(musc, [1,1,1,n_pots]), reorder), [ntot,1]);

subject_av = reshape(permute(repmat(sub, nrep_av), reorder_av), [ntot_av,1]);
side_av = reshape(permute(repmat(sid, nrep_av), reorder_av), [ntot_av,1]);
condition_av = reshape(permute(repmat(cond, nrep_av), reorder_av), [ntot_av,1]);
instant_av = reshape(permute(repmat(inst, nrep_av), reorder_av), [ntot_av,1]);
muscle_av = reshape(permute(musc, reorder_av), [ntot_av,1]);

export_data_av = [subject_av side_av condition_av instant_av muscle_av idlabel_av ppamp_av_arr latency_av_arr];
export_data = [subject side condition instant muscle idlabel ppamp_arr latency_arr];
headers = [{'subject'} {'hemisphere'} {'condition'} {'instant'} {'muscle'} {'label'} {'amplitude (uV)'} {'latency (ms)'}];

[filename, pathname, filt_id] = uiputfile({'*.xls;*.xlsx','MS Excel Files (*.xls,*.xlsx)';...
    '*.txt', 'ASCII format (*.txt)'}, 'Export data', 'processed_data.xlsx');

[filename_av, pathname_av, ~] = uiputfile({'*.xls;*.xlsx','MS Excel Files (*.xls,*.xlsx)';...
    '*.txt', 'ASCII format (*.txt)'}, 'Export data averaged', 'processed_data_av.xlsx');

switch filt_id
    case 1
        if  exist([pathname filename], 'file')
            [~, ~, previous_data] = xlsread([pathname filename]);
            xlswrite([pathname filename], [previous_data; export_data])
        else
            xlswrite([pathname filename], [headers; export_data])
        end

        if  exist([pathname_av filename_av], 'file')
            [~, ~, previous_data_av] = xlsread([pathname_av filename_av]);
            xlswrite([pathname_av filename_av], [previous_data_av; export_data_av])
        else
            xlswrite([pathname_av filename_av], [headers; export_data_av])
        end
        
    case 2
        fid = fopen([pathname filename]);
        the_format = '\n%s %s %s %s %s %s %.4f %.4f';
        try
            previous_data = fgets(fid);
        catch
            error('File could not be read.');
        end
        
        if isempty(previous_data)
            fid = fopen([pathname filename], 'w');
            fprintf(fid, '%s %s %s %s %s %s %s %s', headers{1,:});
            for ri = 1:ntot
                fprintf(fid, the_format, export_data{ri,:});
            end
            fclose(fid);
        else
            fid = fopen([pathname filename], 'a');
            fprintf(fid, the_format, export_data{1,:});
            fclose(fid);
        end

        fid_av = fopen([pathname_av filename_av]);
        try
            previous_data_av = fgets(fid_av);
        catch
            error('File could not be read.');
        end
        
        if isempty(previous_data_av)
            fid_av = fopen([pathname_av filename_av], 'w');
            fprintf(fid_av, '%s %s %s %s %s %s %s %s', headers{1,:});
            for ri = 1:ntot_av
                fprintf(fid_av, the_format, export_data_av{ri,:});
            end
            fclose(fid_av);
        else
            fid_av = fopen([pathname_av filename_av], 'a');
            fprintf(fid_av, the_format, export_data_av{1,:});
            fclose(fid_av);
        end
end

end


function filt_id = export_tms_vc(reader, processed)
%EXPORT_TMS_VC Function to standardize the output for TMS + VC processing
%   This function uses an Excel template file to wrie the output variables

sub_name = reader.sub_name;
leg = reader.leg;
process_id = reader.process_id;

filename = [sub_name '_' leg '.xlsx'];
% loading output template
[output_file, output_path, filt_id] = uiputfile({'*.xls;*.xlsx','MS Excel Files (*.xls,*.xlsx)'},...
    'Export data', filename);

if filt_id
    
    file_output = [output_path output_file];
    
    if process_id == 1
        % initialization of variables to be plotted
        % vol_contrac_start = processed.vol_contrac_start;
        % vol_contrac_end = processed.vol_contrac_end;
        % stim = processed.stim;
        % superimposed_window = processed.superimposed_window;
        superimposed_F = processed.superimposed_F;
        superimposed_B = processed.superimposed_B;
        % max_C_I = processed.max_C_I;
        max_C = processed.max_C;
        max_B = processed.max_B;
        % baseline_duration_contrac = processed.baseline_duration_contrac;
        % contrac_neurostim = processed.contrac_neurostim;
        % win_neuro = processed.win_neuro;
        contrac_neurostim_max = processed.contrac_neurostim_max;
        contrac_neurostim_min = processed.contrac_neurostim_min;
        
        stim_contrac_start_p = processed.stim_contrac_start_p;
        % stim_contrac_end = processed.stim_contrac_end;
        % stim_contrac_start = processed.stim_contrac_start;
        neurostim_max = processed.neurostim_max;
        % B_before_neurostim = processed.B_before_neurostim;
        neurostim_B = processed.neurostim_B;
        neurostim_max_I = processed.neurostim_max_I;
        HRT_abs = processed.HRT_abs;
        
        M_wave_start_I = processed.M_wave_start_I;
        M_wave_end_I = processed.M_wave_end_I;
        max_M_wave_I = processed.max_M_wave_I;
        min_M_wave_I = processed.min_M_wave_I;
        
        % contrac_neurostim = processed.contrac_neurostim;
        M_wave_ex_max_I = processed.M_wave_ex_max_I;
        M_wave_ex_min_I = processed.M_wave_ex_min_I;
        M_wave_ex_start_I = processed.M_wave_ex_start_I;
        M_wave_ex_end_I = processed.M_wave_ex_end_I;
        
        TMS_stim = processed.TMS_stim;
        % win_pre_stim = processed.win_pre_stim;
        EMG_recov_point = processed.EMG_recov_point;
        M_wave_MEP_max_I = processed.M_wave_MEP_max_I;
        M_wave_MEP_min_I = processed.M_wave_MEP_min_I;
        M_wave_MEP_start_I = processed.M_wave_MEP_start_I;
        M_wave_MEP_end_I = processed.M_wave_MEP_end_I;
        
        M_wave_MEP_max = processed.M_wave_MEP_max;
        M_wave_MEP_min = processed.M_wave_MEP_min;
        RMS = processed.RMS;
        serie_num = processed.serie_num;
        
        signal = processed.signal;
        data = signal.data;
        % Time = signal.time;
        isi = signal.isi;
        % sampling frequency
        fs = 1/(isi*10^-3);
        
        if exist(file_output, 'file') == 0
            
            [output_tempfile, output_temppath] = uigetfile({'*.xls;*.xlsx','MS Excel Files-files (*.xls,*.xlsx)'},...
                'Select the output file template', 'template.xlsx');
            
            template_output = [output_temppath output_tempfile];
            copyfile(template_output, file_output, 'f');
            output_txt = cell(948,2);
            output_txt(:,1) = {sub_name};
            output_txt(:,2) = {leg};
            xlswrite(file_output,output_txt,'Force Values','A2')
            xlswrite(file_output,output_txt,'M_wave MEP RMS','A2')
            xlswrite(file_output,output_txt,'MVC_2min','A2')
            
        end
        
        % for excel sheet 'force value'
        output_1 = [max_C(1) - max_B(1) ; superimposed_F(1) - superimposed_B(1) ; ...
            superimposed_B(1) - max_B(1) ; neurostim_max(1) - neurostim_B(1) ; ...
            (neurostim_max_I(1) - stim_contrac_start_p(1))* isi ; (HRT_abs(1) - neurostim_max_I(1))* isi ; ...
            neurostim_max(2) - neurostim_B(2) ; (neurostim_max_I(2) - stim_contrac_start_p(2))* isi ; ...
            (HRT_abs(2) - neurostim_max_I(2))* isi];
        
        % Os comandos feitos originalmente pelo Nicolas tentam diferir a
        % ordem de aplicação TMS e Neurostim. No entanto na planilha quando
        % a order_TMS == 2 ele está colocando no lugar do SI_TMS o valor
        % referente ao neurostim. Além disso no output_3 e output_4 o
        % indice das variaveis contrac_neurostim estão um valor a menos, o
        % que faz os valores do 75% (output_3) serem iguais ao do output_2
        % (MVC). Nesse bloco abaixo eu corrigi esses problemas.
        
        % Victor Souza - modified 30/06/2016
        output_2 = [max_C(2) - max_B(2) ; superimposed_F(2) - superimposed_B(2) ; ...
            superimposed_B(2) - max_B(2) ; contrac_neurostim_max(2) - contrac_neurostim_min(2) ; ...
            contrac_neurostim_min(2) - max_B(2) ; neurostim_max(3) - neurostim_B(3) ; ...
            (neurostim_max_I(3) - stim_contrac_start_p(3))* isi ; (HRT_abs(3) - neurostim_max_I(3))* isi];
        output_3 = [max_C(3) - max_B(3) ; superimposed_F(3) - superimposed_B(3) ; ...
            superimposed_B(3) - max_B(3) ; contrac_neurostim_max(3) - contrac_neurostim_min(3) ; ...
            contrac_neurostim_min(3) - max_B(3)];
        output_4 = [max_C(4) - max_B(4) ; superimposed_F(4) - superimposed_B(4) ; ...
            superimposed_B(4) - max_B(4) ; contrac_neurostim_max(4) - contrac_neurostim_min(4) ; ...
            contrac_neurostim_min(4) - max_B(4)];
        % ---

        
        % for excel sheet 'M-wave MEP RMS'
        output_13 = [data(max_M_wave_I(2,2),2) - data(min_M_wave_I(2,2),2) ; ...
            abs(min_M_wave_I(2,2) - max_M_wave_I(2,2)) * isi ; ...
            trapz_perso(abs(data(max_M_wave_I(2,2):min_M_wave_I(2,2),2)), fs) ; ...
            trapz_perso(abs(data(M_wave_start_I(2,2):M_wave_end_I(2,2),2)), fs) ; ...
            data(max_M_wave_I(2,3),3) - data(min_M_wave_I(2,3),3) ; ...
            abs(min_M_wave_I(2,3) - max_M_wave_I(2,3)) * isi ; ...
            trapz_perso(abs(data(max_M_wave_I(2,3):min_M_wave_I(2,3),3)), fs) ; ...
            trapz_perso(abs(data(M_wave_start_I(2,3):M_wave_end_I(2,3),3)), fs) ; ...
            data(max_M_wave_I(2,4),4) - data(min_M_wave_I(2,4),4) ; ...
            abs(min_M_wave_I(2,4) - max_M_wave_I(2,4)) * isi ; ...
            trapz_perso(abs(data(max_M_wave_I(2,4):min_M_wave_I(2,4),4)), fs) ; ...
            trapz_perso(abs(data(M_wave_start_I(2,4):M_wave_end_I(2,4),4)), fs) ];
        output_5 = [RMS(1,2) ; RMS(1,3) ; RMS(1,4)];
        output_6 = [data(M_wave_ex_max_I(2,2),2)-data(M_wave_ex_min_I(2,2),2) ; ...
            abs(M_wave_ex_max_I(2,2) - M_wave_ex_min_I(2,2)) * isi ; ...
            trapz_perso(abs(data(M_wave_ex_max_I(2,2):M_wave_ex_min_I(2,2),2)), fs) ; ...
            trapz_perso(abs(data(M_wave_ex_start_I(2,2):M_wave_ex_end_I(2,2),2)), fs) ; ...
            data(M_wave_ex_max_I(2,3),3)-data(M_wave_ex_min_I(2,3),3) ; ...
            abs(M_wave_ex_max_I(2,3) - M_wave_ex_min_I(2,3)) ; ...
            trapz_perso(abs(data(M_wave_ex_max_I(2,3):M_wave_ex_min_I(2,3),3)), fs) ; ...
            trapz_perso(abs(data(M_wave_ex_start_I(2,3):M_wave_ex_end_I(2,3),3)), fs) ; ...
            data(M_wave_ex_max_I(2,4),4)-data(M_wave_ex_min_I(2,4),4) ; ...
            abs(M_wave_ex_max_I(2,4) - M_wave_ex_min_I(2,4)) ; ...
            trapz_perso(abs(data(M_wave_ex_max_I(2,4):M_wave_ex_min_I(2,4),4)), fs) ; ...
            trapz_perso(abs(data(M_wave_ex_start_I(2,4):M_wave_ex_end_I(2,4),4)), fs)];
        output_7 = [M_wave_MEP_max(1,2) - M_wave_MEP_min(1,2) ; ...
            abs(M_wave_MEP_min_I(1,2) - M_wave_MEP_max_I(1,2)) * isi ; ...
            trapz_perso(abs(data(M_wave_MEP_max_I(1,2):M_wave_MEP_min_I(1,2),2)), fs); ...
            trapz_perso(abs(data(M_wave_MEP_start_I(1,2):M_wave_MEP_end_I(1,2),2)), fs); ...
            (EMG_recov_point(1,2) - TMS_stim (1)) * isi ; ...
            NaN ; ...
            M_wave_MEP_max(1,3) - M_wave_MEP_min(1,3) ; ...
            abs(M_wave_MEP_min_I(1,3) - M_wave_MEP_max_I(1,3)) * isi ; ...
            trapz_perso(abs(data(M_wave_MEP_max_I(1,3):M_wave_MEP_min_I(1,3),3)), fs); ...
            trapz_perso(abs(data(M_wave_MEP_start_I(1,3):M_wave_MEP_end_I(1,2),3)), fs); ...
            (EMG_recov_point(1,3) - TMS_stim (1)) * isi ; ...
            NaN ; ...
            M_wave_MEP_max(1,4) - M_wave_MEP_min(1,4) ; ...
            abs(M_wave_MEP_min_I(1,4) - M_wave_MEP_max_I(1,4)) * isi ; ...
            trapz_perso(abs(data(M_wave_MEP_max_I(1,4):M_wave_MEP_min_I(1,4),4)), fs); ...
            trapz_perso(abs(data(M_wave_MEP_start_I(1,4):M_wave_MEP_end_I(1,4),4)), fs); ...
            (EMG_recov_point(1,4) - TMS_stim (1)) * isi ; ...
            NaN ];
        output_8 = [data(max_M_wave_I(3,2),2) - data(min_M_wave_I(3,2),2) ; ...
            abs(min_M_wave_I(3,2) - max_M_wave_I(3,2)) * isi ; ...
            trapz_perso(abs(data(max_M_wave_I(3,2):min_M_wave_I(3,2),2)), fs) ; ...
            trapz_perso(abs(data(M_wave_start_I(3,2):M_wave_end_I(3,2),2)), fs) ; ...
            data(max_M_wave_I(3,3),3) - data(min_M_wave_I(3,3),3) ; ...
            abs(min_M_wave_I(3,3) - max_M_wave_I(3,3)) * isi ; ...
            trapz_perso(abs(data(max_M_wave_I(3,3):min_M_wave_I(3,3),3)), fs) ; ...
            trapz_perso(abs(data(M_wave_start_I(3,3):M_wave_end_I(3,3),3)), fs) ; ...
            data(max_M_wave_I(3,4),4) - data(min_M_wave_I(3,4),4) ; ...
            abs(min_M_wave_I(3,4) - max_M_wave_I(3,4)) * isi ; ...
            trapz_perso(abs(data(max_M_wave_I(3,4):min_M_wave_I(3,4),4)), fs) ; ...
            trapz_perso(abs(data(M_wave_start_I(3,4):M_wave_end_I(3,4),4)), fs) ];
        output_9 = [data(M_wave_ex_max_I(3,2),2)-data(M_wave_ex_min_I(3,2),2) ; ...
            abs(M_wave_ex_max_I(3,2) - M_wave_ex_min_I(3,2)) * isi ; ...
            trapz_perso(abs(data(M_wave_ex_max_I(3,2):M_wave_ex_min_I(3,2),2)), fs) ; ...
            trapz_perso(abs(data(M_wave_ex_start_I(3,2):M_wave_ex_end_I(3,2),2)), fs) ; ...
            data(M_wave_ex_max_I(3,3),3)-data(M_wave_ex_min_I(3,3),3) ; ...
            abs(M_wave_ex_max_I(3,3) - M_wave_ex_min_I(3,3)) ; ...
            trapz_perso(abs(data(M_wave_ex_max_I(3,3):M_wave_ex_min_I(3,3),3)), fs) ; ...
            trapz_perso(abs(data(M_wave_ex_start_I(3,3):M_wave_ex_end_I(3,3),3)), fs) ; ...
            data(M_wave_ex_max_I(3,4),4)-data(M_wave_ex_min_I(3,4),4) ; ...
            abs(M_wave_ex_max_I(3,4) - M_wave_ex_min_I(3,4)) ; ...
            trapz_perso(abs(data(M_wave_ex_max_I(3,4):M_wave_ex_min_I(3,4),4)), fs) ; ...
            trapz_perso(abs(data(M_wave_ex_start_I(3,4):M_wave_ex_end_I(3,4),4)), fs)];
        output_10 = [M_wave_MEP_max(2,2) - M_wave_MEP_min(2,2) ; ...
            abs(M_wave_MEP_min_I(2,2) - M_wave_MEP_max_I(2,2)) * isi ; ...
            trapz_perso(abs(data(M_wave_MEP_max_I(2,2):M_wave_MEP_min_I(2,2),2)), fs); ...
            trapz_perso(abs(data(M_wave_MEP_start_I(2,2):M_wave_MEP_end_I(2,2),2)), fs); ...
            (EMG_recov_point(2,2) - TMS_stim (2)) * isi ; ...
            NaN ; ...
            M_wave_MEP_max(2,3) - M_wave_MEP_min(2,3) ; ...
            abs(M_wave_MEP_min_I(2,3) - M_wave_MEP_max_I(2,3)) * isi ; ...
            trapz_perso(abs(data(M_wave_MEP_max_I(2,3):M_wave_MEP_min_I(2,3),3)), fs); ...
            trapz_perso(abs(data(M_wave_MEP_start_I(2,3):M_wave_MEP_end_I(2,2),3)), fs); ...
            (EMG_recov_point(2,3) - TMS_stim (2)) * isi ; ...
            NaN ; ...
            M_wave_MEP_max(2,4) - M_wave_MEP_min(2,4) ; ...
            abs(M_wave_MEP_min_I(2,4) - M_wave_MEP_max_I(2,4)) * isi ; ...
            trapz_perso(abs(data(M_wave_MEP_max_I(2,4):M_wave_MEP_min_I(2,4),4)), fs); ...
            trapz_perso(abs(data(M_wave_MEP_start_I(2,4):M_wave_MEP_end_I(2,4),4)), fs); ...
            (EMG_recov_point(2,4) - TMS_stim (2)) * isi ; ...
            NaN ];
        output_11 = [data(M_wave_ex_max_I(4,2),2)-data(M_wave_ex_min_I(4,2),2) ; ...
            abs(M_wave_ex_max_I(4,2) - M_wave_ex_min_I(4,2)) * isi ; ...
            trapz_perso(abs(data(M_wave_ex_max_I(4,2):M_wave_ex_min_I(4,2),2)), fs) ; ...
            trapz_perso(abs(data(M_wave_ex_start_I(4,2):M_wave_ex_end_I(4,2),2)), fs) ; ...
            data(M_wave_ex_max_I(4,3),3)-data(M_wave_ex_min_I(4,3),3) ; ...
            abs(M_wave_ex_max_I(4,3) - M_wave_ex_min_I(4,3)) ; ...
            trapz_perso(abs(data(M_wave_ex_max_I(4,3):M_wave_ex_min_I(4,3),3)), fs) ; ...
            trapz_perso(abs(data(M_wave_ex_start_I(4,3):M_wave_ex_end_I(4,3),3)), fs) ; ...
            data(M_wave_ex_max_I(4,4),4)-data(M_wave_ex_min_I(4,4),4) ; ...
            abs(M_wave_ex_max_I(4,4) - M_wave_ex_min_I(4,4)) ; ...
            trapz_perso(abs(data(M_wave_ex_max_I(4,4):M_wave_ex_min_I(4,4),4)), fs) ; ...
            trapz_perso(abs(data(M_wave_ex_start_I(4,4):M_wave_ex_end_I(4,4),4)), fs)];
        output_12 = [M_wave_MEP_max(3,2) - M_wave_MEP_min(3,2) ; ...
            abs(M_wave_MEP_min_I(3,2) - M_wave_MEP_max_I(3,2)) * isi ; ...
            trapz_perso(abs(data(M_wave_MEP_max_I(3,2):M_wave_MEP_min_I(3,2),2)), fs); ...
            trapz_perso(abs(data(M_wave_MEP_start_I(3,2):M_wave_MEP_end_I(3,2),2)), fs); ...
            (EMG_recov_point(3,2) - TMS_stim (3)) * isi ; ...
            NaN ; ...
            M_wave_MEP_max(3,3) - M_wave_MEP_min(3,3) ; ...
            abs(M_wave_MEP_min_I(3,3) - M_wave_MEP_max_I(3,3)) * isi ; ...
            trapz_perso(abs(data(M_wave_MEP_max_I(3,3):M_wave_MEP_min_I(3,3),3)), fs); ...
            trapz_perso(abs(data(M_wave_MEP_start_I(3,3):M_wave_MEP_end_I(3,2),3)), fs); ...
            (EMG_recov_point(3,3) - TMS_stim (3)) * isi ; ...
            NaN ; ...
            M_wave_MEP_max(3,4) - M_wave_MEP_min(3,4) ; ...
            abs(M_wave_MEP_min_I(3,4) - M_wave_MEP_max_I(3,4)) * isi ; ...
            trapz_perso(abs(data(M_wave_MEP_max_I(3,4):M_wave_MEP_min_I(3,4),4)), fs); ...
            trapz_perso(abs(data(M_wave_MEP_start_I(3,4):M_wave_MEP_end_I(3,4),4)), fs); ...
            (EMG_recov_point(3,4) - TMS_stim (3)) * isi ; ...
            NaN ];
        
        switch serie_num
            case 1
                cell_to_write = {'H7';'H16';'H24';'H29'};
                cell_to_write_2 = {'I14';'I26';'I29';'I41';'I59';'I71';'I83';'I101';'I113'};
            case 2
                cell_to_write = {'H34';'H43';'H51';'H56'};
                cell_to_write_2 = {'I131';'I143';'I146';'I158';'I176';'I188';'I200';'I218';'I230'};
            case 3
                cell_to_write = {'H61';'H70';'H78';'H83'};
                cell_to_write_2 = {'I248';'I260';'I263';'I275';'I293';'I305';'I317';'I335';'I347'};
            case 4
                cell_to_write = {'H88';'H97';'H105';'H110'};
                cell_to_write_2 = {'I365';'I377';'I380';'I392';'I410';'I422';'I434';'I452';'I464'};
            case 5
                cell_to_write = {'H115';'H124';'H132';'H137'};
                cell_to_write_2 = {'I482';'I494';'I497';'I509';'I527';'I539';'I551';'I569';'I581'};
            case 6
                cell_to_write = {'H142';'H151';'H159';'H164'};
                cell_to_write_2 = {'I599';'I611';'I614';'I626';'I644';'I656';'I668';'I686';'I698'};
            case 7
                cell_to_write = {'H169';'H178';'H186';'H191'};
                cell_to_write_2 = {'I716';'I728';'I731';'I743';'I761';'I773';'I785';'I803';'I815'};
            case 8
                cell_to_write = {'H196';'H205';'H213';'H218'};
                cell_to_write_2 = {'I833';'I845';'I848';'I860';'I878';'I890';'I902';'I920';'I932'};
        end
        
        xlswrite(file_output,output_1,'Force Values',cell_to_write{1})
        xlswrite(file_output,output_2,'Force Values',cell_to_write{2})
        xlswrite(file_output,output_3,'Force Values',cell_to_write{3})
        xlswrite(file_output,output_4,'Force Values',cell_to_write{4})
        xlswrite(file_output,output_13,'M_wave MEP RMS',cell_to_write_2{1})
        xlswrite(file_output,output_5,'M_wave MEP RMS',cell_to_write_2{2})
        xlswrite(file_output,output_6,'M_wave MEP RMS',cell_to_write_2{3})
        xlswrite(file_output,output_7,'M_wave MEP RMS',cell_to_write_2{4})
        xlswrite(file_output,output_8,'M_wave MEP RMS',cell_to_write_2{5})
        xlswrite(file_output,output_9,'M_wave MEP RMS',cell_to_write_2{6})
        xlswrite(file_output,output_10,'M_wave MEP RMS',cell_to_write_2{7})
        xlswrite(file_output,output_11,'M_wave MEP RMS',cell_to_write_2{8})
        xlswrite(file_output,output_12,'M_wave MEP RMS',cell_to_write_2{9})
        
        
    elseif process_id == 2
        
%         force = processed.force';
%         descriptors = processed.descriptors;
        
        Twitch_y = processed.Twitch_y;
        Twitch_x = processed.Twitch_x;
        baseline = processed.baseline;
        contrac_start = processed.contrac_start;
        contrac_max = processed.contrac_max;
        HRT = processed.HRT;
        M_wave_amp = processed.M_wave_amp;
        M_wave_duration = processed.M_wave_duration;
        M_wave_area = processed.M_wave_area;
        M_wave_area_2 = processed.M_wave_area_2;
        
        isi = processed.signal.isi;
        
        force(1) = Twitch_y - baseline;
        force(2) = (Twitch_x - contrac_start(1))*isi;
        force(3) = (HRT - Twitch_x) * isi;
        force(4:5) = contrac_max(2:3) - baseline;
        force = force';
        
        descriptors(1:4,1) = [M_wave_amp(2);M_wave_duration(2);M_wave_area(1);M_wave_area_2(1)];
        descriptors(5:8,1) = [M_wave_amp(3);M_wave_duration(3);M_wave_area(2);M_wave_area_2(2)];
        descriptors(9:12,1) = [M_wave_amp(4);M_wave_duration(4);M_wave_area(3);M_wave_area_2(3)];
        
        if exist(file_output, 'file') == 0
            
            [output_tempfile, output_temppath] = uigetfile({'*.xls;*.xlsx','MS Excel Files-files (*.xls,*.xlsx)'},...
                'Select the output file template', 'template.xlsx');
            
            template_output = [output_temppath output_tempfile];
            copyfile(template_output, file_output, 'f');
            output_txt = cell(221,2);
            output_txt(:,1) = {sub_name};
            output_txt(:,2) = {leg};
            xlswrite(file_output,output_txt,'Force Values','A2')
            xlswrite(file_output,output_txt,'M_wave MEP RMS','A2')
            xlswrite(file_output,output_txt,'MVC_2min','A2')
            
        end
        
        xlswrite(file_output,force,'Force Values','H2')
        xlswrite(file_output,descriptors,'M_wave MEP RMS','I2')
        
        
    elseif process_id == 3
        
        max_force = processed.max_force;
        force_mean = processed.force_mean;
        RMS_mean = processed.RMS_mean;
        
        if exist(file_output,'file') == 0
            
            [output_tempfile, output_temppath] = uigetfile({'*.xls;*.xlsx','MS Excel Files-files (*.xls,*.xlsx)'},...
                'Select the output file template', 'template.xlsx');
            
            template_output = [output_temppath output_tempfile];
            copyfile(template_output, file_output, 'f');
            output_txt = cell(948,2);
            output_txt(:,1) = {sub_name};
            output_txt(:,2) = {leg};
            xlswrite(file_output,output_txt,'Force Values','A2')
            xlswrite(file_output,output_txt,'M_wave MEP RMS','A2')
            xlswrite(file_output,output_txt,'MVC_2min','A2')
            
        end
        
        xlswrite(file_output,max_force,'MVC_2min','E2')
        xlswrite(file_output,force_mean,'MVC_2min','E8')
        output = NaN(size(RMS_mean,1)*(size(RMS_mean,2)-1),1);
        j=1;
        for i=1:1:10
            output(j:j+2) = [RMS_mean(i,2);RMS_mean(i,3);RMS_mean(i,4)];
            j=j+3;
        end
        xlswrite(file_output,output,'MVC_2min','E18')
        
    end
    
end

end