function callback_data(hObject, ~, menu_id)
%CALLBACK_DATA Summary of this function goes here
%   Detailed explanation goes here

handles = guidata(hObject);
menu_id_up = [upper(menu_id(1)) menu_id(2:end)];

% message to progress log
msg = [menu_id_up ' data in progress...'];
handles = panel_textlog(handles, msg);

value = 1/2;
progbar_update(handles.progress_bar, value)

% call function to save, load or export
input = '(handles)';
[handles, filt_id] = eval(['data_' menu_id input]);

value = 1;
progbar_update(handles.progress_bar, value)

% message to progress log
if filt_id
    msg = [menu_id_up ' data finished.'];
    handles = panel_textlog(handles, msg);
else
    msg = [menu_id_up ' canceled.'];
    handles = panel_textlog(handles, msg);
end

guidata(hObject, handles)

