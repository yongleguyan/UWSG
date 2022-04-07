function varargout = uwsg_config_target(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uwsg_config_target_OpeningFcn, ...
                   'gui_OutputFcn',  @uwsg_config_target_OutputFcn, ...
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

function uwsg_config_target_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

global global_target_num global_target_num_loop; 
global global_sim_time global_sd global_startx global_starty global_motion_mode global_speedx global_speedy global_speed_opt global_power global_power_opt global_fs global_target_fs global_signal_mode global_signal_freq global_signal_bandwidth;

if global_target_num_loop == global_target_num
    set(handles.pushbutton2, 'string', '生成接收信号');
else
    set(handles.pushbutton2, 'string', '下一步');
end

set(handles.text22, 'string', "第 " + global_target_num_loop + " 个目标的参数");
set(handles.text17, 'string', "变量为2列矩阵，第1列为信号包络，第2列为相位，行数应等于 " + global_sim_time + " * 信号采样频率。");
set(handles.text16, 'string', "注：请将信号波形存入signals.mat的tgt" + global_target_num_loop + "变量中。");

if global_target_num_loop > 1
    global_sd(global_target_num_loop) = global_sd(global_target_num_loop - 1);
    global_startx(global_target_num_loop) = global_startx(global_target_num_loop - 1);
    global_starty(global_target_num_loop) = global_starty(global_target_num_loop - 1);
    global_motion_mode(global_target_num_loop) = global_motion_mode(global_target_num_loop - 1);
    global_speedx(global_target_num_loop) = global_speedx(global_target_num_loop - 1);
    global_speedy(global_target_num_loop) = global_speedy(global_target_num_loop - 1);
    global_speed_opt(global_target_num_loop) = global_speed_opt(global_target_num_loop - 1);
    global_power(global_target_num_loop) = global_power(global_target_num_loop - 1);
    global_power_opt(global_target_num_loop) = global_power_opt(global_target_num_loop - 1);
    global_target_fs(global_target_num_loop) = global_target_fs(global_target_num_loop - 1);
    global_signal_mode(global_target_num_loop) = global_signal_mode(global_target_num_loop - 1);
    global_signal_freq(global_target_num_loop) = global_signal_freq(global_target_num_loop - 1);
    global_signal_bandwidth(global_target_num_loop) = global_signal_bandwidth(global_target_num_loop - 1);
else
    global_sd(global_target_num_loop) = 1;
    global_startx(global_target_num_loop) = 10000;
    global_starty(global_target_num_loop) = 10000;    
    global_motion_mode(global_target_num_loop) = 1;
    global_speed_opt(global_target_num_loop) = 1;
    global_power(global_target_num_loop) = 1;
    global_power_opt(global_target_num_loop) = 2;
    global_target_fs(global_target_num_loop) = global_fs;
    global_signal_mode(global_target_num_loop) = 2;
    global_signal_freq(global_target_num_loop) = 1000;
    global_signal_bandwidth(global_target_num_loop) = 20;
end
set(handles.popupmenu_set_sd,'value',global_sd(global_target_num_loop));
set(handles.popupmenu_set_motion_mode,'value',global_motion_mode(global_target_num_loop));
set(handles.popupmenu_set_speed_opt,'value',global_speed_opt(global_target_num_loop));
set(handles.popupmenu_set_power_opt,'value',global_power_opt(global_target_num_loop));
set(handles.popupmenu_set_signal_mode,'value',global_signal_mode(global_target_num_loop));

switch global_motion_mode(global_target_num_loop)
    case 1
        set(handles.edit_set_speedx, 'enable','off');
        set(handles.edit_set_speedy, 'enable','off');
        set(handles.popupmenu_set_speed_opt, 'enable','off');  
        set(handles.text6, 'enable','off');
        set(handles.text29, 'enable','off');
        set(handles.text30, 'enable','off');
        set(handles.text31, 'enable','off');
        set(handles.text32, 'enable','off');
        set(handles.text33, 'enable','off');
    case 2
        set(handles.edit_set_speedx, 'enable','on');
        set(handles.edit_set_speedy, 'enable','on');
        set(handles.popupmenu_set_speed_opt, 'enable','on');  
        set(handles.text6, 'enable','on')
        set(handles.text29, 'enable','on');
        set(handles.text30, 'enable','on');
        set(handles.text31, 'enable','on');
        set(handles.text32, 'enable','on');
        set(handles.text33, 'enable','on');
end
switch global_signal_mode(global_target_num_loop)
    case 1
        set(handles.edit_set_signal_freq, 'enable','on');
        set(handles.text18, 'enable','on');
        set(handles.text19, 'enable','on');
        set(handles.edit_set_signal_bandwidth, 'enable','off');
        set(handles.text20, 'enable','off');
        set(handles.text21, 'enable','off');
        set(handles.text16, 'visible','off');
        set(handles.text17, 'visible','off');
    case 2
        set(handles.edit_set_signal_freq, 'enable','on');
        set(handles.text18, 'enable','on');
        set(handles.text19, 'enable','on');
        set(handles.edit_set_signal_bandwidth, 'enable','on');
        set(handles.text20, 'enable','on');
        set(handles.text21, 'enable','on');
        set(handles.text16, 'visible','off');
        set(handles.text17, 'visible','off');
    case 3
        set(handles.edit_set_signal_freq, 'enable','off');
        set(handles.text18, 'enable','off');
        set(handles.text19, 'enable','off');
        set(handles.edit_set_signal_bandwidth, 'enable','off');
        set(handles.text20, 'enable','off');
        set(handles.text21, 'enable','off');
        set(handles.text16, 'visible','on');
        set(handles.text17, 'visible','on');
end
set(handles.edit_set_startx, 'string', num2str(global_startx(global_target_num_loop)));
set(handles.edit_set_starty, 'string', num2str(global_starty(global_target_num_loop)));
set(handles.edit_set_speedx, 'string', num2str(global_speedx(global_target_num_loop)));
set(handles.edit_set_speedy, 'string', num2str(global_speedy(global_target_num_loop)));
set(handles.edit_set_power, 'string', num2str(global_power(global_target_num_loop)));
set(handles.edit_set_target_fs, 'string', num2str(global_target_fs(global_target_num_loop)));
set(handles.edit_set_signal_freq, 'string', num2str(global_signal_freq(global_target_num_loop)));
set(handles.edit_set_signal_bandwidth, 'string', num2str(global_signal_bandwidth(global_target_num_loop)));

function varargout = uwsg_config_target_OutputFcn(~, ~, handles) 

varargout{1} = handles.output;

function popupmenu_set_motion_mode_Callback(~, ~, handles)
global global_target_num_loop global_motion_mode;
global_motion_mode(global_target_num_loop) = get(handles.popupmenu_set_motion_mode,'value');
switch global_motion_mode(global_target_num_loop)
    case 1
        set(handles.edit_set_speedx, 'enable','off');
        set(handles.edit_set_speedy, 'enable','off');
        set(handles.popupmenu_set_speed_opt, 'enable','off');  
        set(handles.text6, 'enable','off');
        set(handles.text29, 'enable','off');
        set(handles.text30, 'enable','off');
        set(handles.text31, 'enable','off');
        set(handles.text32, 'enable','off');
        set(handles.text33, 'enable','off');
    case 2
        set(handles.edit_set_speedx, 'enable','on');
        set(handles.edit_set_speedy, 'enable','on');
        set(handles.popupmenu_set_speed_opt, 'enable','on');  
        set(handles.text6, 'enable','on')
        set(handles.text29, 'enable','on');
        set(handles.text30, 'enable','on');
        set(handles.text31, 'enable','on');
        set(handles.text32, 'enable','on');
        set(handles.text33, 'enable','on');
end

function popupmenu_set_motion_mode_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_set_startx_Callback(~, ~, ~)

function edit_set_startx_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_set_starty_Callback(~, ~, ~)

function edit_set_starty_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_set_speedx_Callback(~, ~, ~)

function edit_set_speedx_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_set_speedy_Callback(~, ~, ~)

function edit_set_speedy_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_set_speed_opt_Callback(~, ~, handles)
global global_target_num_loop global_speed_opt;
global_speed_opt(global_target_num_loop) = get(handles.popupmenu_set_speed_opt,'value');

function popupmenu_set_speed_opt_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_set_power_Callback(~, ~, ~)

function edit_set_power_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_set_power_opt_Callback(~, ~, handles)
global global_target_num_loop global_power_opt;
global_power_opt(global_target_num_loop) = get(handles.popupmenu_set_power_opt,'value');

function popupmenu_set_power_opt_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_set_target_fs_Callback(~, ~, ~)

function edit_set_target_fs_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_set_signal_mode_Callback(~, ~, handles)
global global_target_num_loop global_signal_mode;
global_signal_mode(global_target_num_loop) = get(handles.popupmenu_set_signal_mode,'value');
switch global_signal_mode(global_target_num_loop)
    case 1
        set(handles.edit_set_signal_freq, 'enable','on');
        set(handles.text18, 'enable','on');
        set(handles.text19, 'enable','on');
        set(handles.edit_set_signal_bandwidth, 'enable','off');
        set(handles.text20, 'enable','off');
        set(handles.text21, 'enable','off');
        set(handles.text16, 'visible','off');
        set(handles.text17, 'visible','off');
    case 2
        set(handles.edit_set_signal_freq, 'enable','on');
        set(handles.text18, 'enable','on');
        set(handles.text19, 'enable','on');
        set(handles.edit_set_signal_bandwidth, 'enable','on');
        set(handles.text20, 'enable','on');
        set(handles.text21, 'enable','on');
        set(handles.text16, 'visible','off');
        set(handles.text17, 'visible','off');
    case 3
        set(handles.edit_set_signal_freq, 'enable','off');
        set(handles.text18, 'enable','off');
        set(handles.text19, 'enable','off');
        set(handles.edit_set_signal_bandwidth, 'enable','off');
        set(handles.text20, 'enable','off');
        set(handles.text21, 'enable','off');
        set(handles.text16, 'visible','on');
        set(handles.text17, 'visible','on');
end

function popupmenu_set_signal_mode_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_set_signal_freq_Callback(~, ~, ~)

function edit_set_signal_freq_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_set_signal_bandwidth_Callback(~, ~, ~)

function edit_set_signal_bandwidth_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton2_Callback(~, ~, handles)
global global_target_num global_target_num_loop;
global global_startx global_starty global_speedx global_speedy global_power global_target_fs global_signal_freq global_signal_bandwidth;

datastr = get(handles.edit_set_startx, 'string');
global_startx(global_target_num_loop) = str2double(datastr);
datastr = get(handles.edit_set_starty, 'string');
global_starty(global_target_num_loop) = str2double(datastr);
datastr = get(handles.edit_set_speedx, 'string');
global_speedx(global_target_num_loop) = str2double(datastr);
datastr = get(handles.edit_set_speedy, 'string');
global_speedy(global_target_num_loop) = str2double(datastr);
datastr = get(handles.edit_set_power, 'string');
global_power(global_target_num_loop) = str2double(datastr);
datastr = get(handles.edit_set_target_fs, 'string');
global_target_fs(global_target_num_loop) = str2double(datastr);
datastr = get(handles.edit_set_signal_freq, 'string');
global_signal_freq(global_target_num_loop) = str2double(datastr);
datastr = get(handles.edit_set_signal_bandwidth, 'string');
global_signal_bandwidth(global_target_num_loop) = str2double(datastr);

close;
if global_target_num_loop < global_target_num
    global_target_num_loop = global_target_num_loop + 1;
    uwsg_config_target;
else
    uwsg_run
end
    
function popupmenu_set_sd_Callback(~, ~, handles)

global global_target_num_loop global_sd;
global_sd(global_target_num_loop) = get(handles.popupmenu_set_sd,'value');

function popupmenu_set_sd_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
