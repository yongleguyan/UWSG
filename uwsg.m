function varargout = uwsg(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uwsg_OpeningFcn, ...
                   'gui_OutputFcn',  @uwsg_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function uwsg_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);

global global_fs global_target_num global_sim_time global_array_mode global_rd global_rays_mode global_ssp global_plot_rays;
global global_target_num_loop;

global_fs = 5555;
global_target_num = 1;
global_sim_time = 200;
global_array_mode = 'H';
global_rd = 4000;
global_rays_mode = 2;
global_ssp = 1;
global_plot_rays = 1; % 0 -- not plot the eigenrays; 1 -- plot the eigenrays
global_target_num_loop = 1;

set(handles.edit_set_fs, 'string', num2str(global_fs));
set(handles.edit_set_target_num, 'string', num2str(global_target_num));
set(handles.edit_set_sim_time, 'string', num2str(global_sim_time));
set(handles.edit_set_rd, 'string', num2str(global_rd));

set(handles.popupmenu_set_array_mode,'value',2);
set(handles.popupmenu_set_ssp,'value',global_ssp);
set(handles.edit_set_rd, 'visible','off');
set(handles.text7, 'visible','off');
set(handles.text8, 'visible','off');
set(handles.text10, 'visible','on');

function varargout = uwsg_OutputFcn(~, ~, handles) 

varargout{1} = handles.output;

function edit_set_fs_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_set_target_num_Callback(~, ~, ~)

function edit_set_target_num_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton1_Callback(~, ~, handles)
global global_fs global_target_num global_sim_time global_rd;
global_fs = str2double(get(handles.edit_set_fs, 'string'));
global_target_num = str2double(get(handles.edit_set_target_num, 'string'));
global_sim_time = str2double(get(handles.edit_set_sim_time, 'string'));
global_rd = str2double(get(handles.edit_set_rd, 'string'));
close;
global global_sd global_startx global_starty global_motion_mode global_speedx global_speedy global_speed_opt global_power global_power_opt global_target_fs global_signal_mode global_signal_freq global_signal_bandwidth;
global_sd = zeros(global_target_num,1);
global_startx = zeros(global_target_num,1);
global_starty = zeros(global_target_num,1);
global_motion_mode = zeros(global_target_num,1);

global_speedx = zeros(global_target_num,1);
global_speedy = zeros(global_target_num,1);
global_speed_opt = zeros(global_target_num,1);
global_power = zeros(global_target_num,1);
global_power_opt = zeros(global_target_num,1);
global_target_fs = zeros(global_target_num,1);
global_signal_mode = zeros(global_target_num,1);
global_signal_freq = zeros(global_target_num,1);
global_signal_bandwidth = zeros(global_target_num,1);
uwsg_config_target;

function edit_set_sim_time_Callback(~, ~, ~)

function edit_set_sim_time_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_set_array_mode_Callback(~, ~, handles)

global global_array_mode;
val = get(handles.popupmenu_set_array_mode,'value');
switch val
    case 1
        set(handles.edit_set_rd, 'visible','on');
        set(handles.text7, 'visible','on');
        set(handles.text8, 'visible','on');
        set(handles.text10, 'visible','off');
        global_array_mode = 'S';
    case 2
        set(handles.edit_set_rd, 'visible','off');
        set(handles.text7, 'visible','off');
        set(handles.text8, 'visible','off');
        set(handles.text10, 'visible','on');
        global_array_mode = 'A';
end

function popupmenu_set_array_mode_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_set_rd_Callback(~, ~, ~)

function edit_set_rd_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_set_rays_mode_Callback(~, ~, handles)

global global_rays_mode;
val = get(handles.popupmenu_set_rays_mode,'value');
switch val
    case 1
        global_rays_mode = 2;
    case 2
        global_rays_mode = 1;
end

function popupmenu_set_rays_mode_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_set_ssp_Callback(~, ~, handles)
global global_ssp;
global_ssp = get(handles.popupmenu_set_ssp,'value');

function popupmenu_set_ssp_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
