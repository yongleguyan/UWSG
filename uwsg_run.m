function varargout = uwsg_run(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uwsg_run_OpeningFcn, ...
                   'gui_OutputFcn',  @uwsg_run_OutputFcn, ...
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

function uwsg_run_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);
global global_fs global_target_num global_sim_time global_array_mode global_rd global_rays_mode global_ssp;
global global_sd global_startx global_starty global_motion_mode global_speedx global_speedy global_speed_opt global_power global_power_opt global_target_fs global_signal_mode global_signal_freq global_signal_bandwidth;
global array_loc_org thanks;
global plot_rd;
rd_error = 0;
plot_rd = 4000;
if global_array_mode ~= 'S'
    try
        array_loc = load('array_loc.mat','array_loc');
        array_loc = array_loc.array_loc;
    catch
        error('没有找到阵形文件array_loc，请确认已经将变量存入MAT文件中。');
    end
    if size(array_loc,2) ~= 3
        error('没有找到阵形文件array_loc，请确认已经将变量存入MAT文件中。');
    end
    array_loc_org = array_loc;
    r_num = size(array_loc,1);
else
    r_num = 1;
    if global_rd > 4100 || global_rd < 3900
        global_rd = 4000;
    end
    plot_rd = global_rd;
end
sample_points = r_num * global_fs * global_sim_time;
size_expect = sample_points * 7.75e-6;
size_expect = round(size_expect * 10) / 10;
if global_array_mode ~= 'S'
    rd_min = min(array_loc(:,3));
    rd_max = max(array_loc(:,3));
    if rd_max - rd_min > 100
        rd_error = 1;
    end
end
sd_transfer = [5,20,50,100,150,200];
motion_mode_transfer = [0,1];
speed_opt_transfer = [0,1];
signal_mode_transfer = [0,2,3];
sd = sd_transfer(global_sd);
motion_mode = motion_mode_transfer(global_motion_mode);
speed_opt = speed_opt_transfer(global_speed_opt);
powers = zeros(1,global_target_num);
for i_target_num = 1:global_target_num
    if global_power_opt(i_target_num) == 2
        powers(i_target_num) = global_power(i_target_num);
    else
        powers(i_target_num) = 10 ^ (global_power(i_target_num) / 20);
    end
end
signal_mode = signal_mode_transfer(global_signal_mode);
cfgmain = Config_main;
cfgmain.target_num = global_target_num;
cfgmain.array_mode = global_array_mode;
cfgmain.rd = global_rd;
cfgmain.fs = global_fs; 
cfgmain.sim_time = global_sim_time;
cfgmain.rays_mode = global_rays_mode;
switch global_ssp
    case 2
        cfgmain.ssp = 'MI';
    case 3
        cfgmain.ssp = 'MP';
    case 4
        cfgmain.ssp = 'ISO';       
end
cfgmain.write_config; 
for i_target_num = 1:global_target_num
    tgt = Target(i_target_num);
    tgt.sd = sd(i_target_num);
    tgt.motion_mode = motion_mode(i_target_num);
    tgt.startx = global_startx(i_target_num);
    tgt.starty = global_starty(i_target_num);             
    tgt.speedx = global_speedx(i_target_num);
    tgt.speedy = global_speedy(i_target_num);
    tgt.speed_opt = speed_opt(i_target_num);
    tgt.power = powers(i_target_num);
    tgt.fs = global_target_fs(i_target_num);
    tgt.signal_mode = signal_mode(i_target_num);
    tgt.signal_freq = global_signal_freq(i_target_num);
    tgt.signal_bandwidth = global_signal_bandwidth(i_target_num);
    tgt.write_config();
end
size_hint = "生成信号将写入 data.mat 中，预计文件大小 " + size_expect + "Mb。";
if size_expect > 20000
    size_hint = [size_hint , '该文件过大，建议您减小仿真规模，分段执行程序，以免出现卡机。'];
else
    if size_expect > 8000
        size_hint = [size_hint , '建议您确保计算机拥有32GB内存，以免出现卡机。'];
    else
        if size_expect > 4000
            size_hint = [size_hint , '建议您确保计算机拥有16GB内存，以免出现卡机。'];
        end
    end
end
if rd_error == 1
    array_hint = '您设置的阵列垂直长度过大。请注意本软件支持接收阵列位于 4000±50m 范围内，暂不支持更大尺度的阵列。';
    set(handles.text3,'string', array_hint);
    set(handles.pushbutton1, 'visible','on');
    set(handles.pushbutton3, 'visible','off');
    set(handles.pushbutton4, 'visible','off');
    set(handles.pushbutton5, 'visible','off');
    files = dir('*.cfg');
    for i_files = 1:length(files)
        file_name = files(i_files).name;
        delete(file_name);
    end
else
    thanks = '感谢您使用本信号生成软件！';
    set(handles.text3,'string', {thanks ; size_hint});
    set(handles.pushbutton1, 'visible','off');
    if size_expect <= 4000
        set(handles.pushbutton3, 'visible','on');
        set(handles.pushbutton4, 'visible','off');
        set(handles.pushbutton5, 'visible','off');
    else
        set(handles.pushbutton3, 'visible','off');
        set(handles.pushbutton4, 'visible','on');
        set(handles.pushbutton5, 'visible','on');
    end
end

function varargout = uwsg_run_OutputFcn(~, ~, handles) 

varargout{1} = handles.output;

function pushbutton1_Callback(~, ~, ~)
close;
files = dir('*.cfg');
for i_files = 1:length(files)
    file_name = files(i_files).name;
    delete(file_name);
end

function pushbutton3_Callback(~, ~, handles)
global array_loc_org array_loc global_array_mode thanks plot_rd;
if global_array_mode ~= 'S'    
    array_loc = load('array_loc.mat','array_loc');
    array_loc = array_loc.array_loc;
    rd_min = min(array_loc(:,3));
    rd_max = max(array_loc(:,3));
    if rd_max > 4100 || rd_min < 3900
        array_loc(:,3) = array_loc(:,3) - mean(array_loc(:,3)) + 4000;
    end
    plot_rd = array_loc(1,3);
    save('array_loc.mat','array_loc');
end
set(handles.pushbutton3, 'enable','off');
set(handles.text3,'string', {thanks ; '信号正在生成中！生成完成后，本页面将关闭。'});
system('bin.exe');
if global_array_mode ~= 'S'
    array_loc = array_loc_org;
    save('array_loc.mat','array_loc');
end
close;
uwsg_plot;

function pushbutton4_Callback(~, ~, ~)
close;
files = dir('*.cfg');
for i_files = 1:length(files)
    file_name = files(i_files).name;
    delete(file_name);
end

function pushbutton5_Callback(~, ~, handles)
global array_loc_org array_loc global_array_mode thanks plot_rd;
if global_array_mode ~= 'S'    
    array_loc = load('array_loc.mat','array_loc');
    array_loc = array_loc.array_loc;
    rd_min = min(array_loc(:,3));
    rd_max = max(array_loc(:,3));
    if rd_max > 4010 || rd_min < 3990
        array_loc(:,3) = array_loc(:,3) - mean(array_loc(:,3)) + 4000;
    end
    plot_rd = array_loc(1,3);
    save('array_loc.mat','array_loc');
end
set(handles.pushbutton5, 'enable','off');
set(handles.text3,'string', {thanks ; '信号正在生成中！生成完成后，本页面将关闭。'});
system('bin.exe');
if global_array_mode ~= 'S'
    array_loc = array_loc_org;
    save('array_loc.mat','array_loc');
end
close;
uwsg_plot;
