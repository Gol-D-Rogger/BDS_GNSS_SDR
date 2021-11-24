function settings=initSettings()
% 要处理的毫秒数使用36000 +任何瞬态(见下面-在导航参数)，以确保导航子帧被提供
settings.msToProcess        = 37000;        %[ms]
 
 
% 用于信号处理的通道数
settings.numberOfChannels   = 8;
 
% 移动处理的起点，可用于在数据记录的任何点开始信号处理(例如长记录)。
% Fseek函数用于移动文件读点，因此advance仅基于字节。
settings.skipNumberOfBytes     = 0;
 
%% （原始信号文件名和其他参数） ===============================
 
% 这是在post-processing模式中使用的数据文件(信号记录)的“默认”名称
settings.fileName           = 'F:\BeidouFile\IF_Data\gnss0.bin'; 
% 用于存储一个样本的数据类型
settings.dataType           = 'int8';
 
% 中频频率，采样频率，C/A码率
settings.IF                 = 9.548e6;      %中频[Hz]
settings.samplingFreq       = 38.192e6;     %采样频率[Hz]
settings.codeFreqBasis      = 1.023e6;      %C/A码的码率[Hz]
 
% 一个码周期包含的码片长度
settings.codeLength         = 10230;         %C/A码周期为10230个码片
 
%% Acquisition settings 设置捕获参数==============================================
% 如果置1则在postProcessing.m中跳过捕获程序
settings.skipAcquisition    = 0;
% 要找的卫星列表，为了加快捕获速度，可以排除一些卫星
settings.acqSatelliteList   = 1:32;         %[PRN numbers]
% Band around IF to search for satellite signal. Depends on max Doppler
% 环绕中频搜索卫星信号。取决于最大多普勒
settings.acqSearchBand      = 14;           %[kHz]最大多普勒频移的估算过程《GPS原理与接收机设计》（以下简称：《设计》）P354
% 阈值信号的决策规则
settings.acqThreshold       = 2.5;
 
%% 跟踪回路的参数设置================================================
% C/A码跟踪回路参数
settings.dllDampingRatio         = 0.7;     %衰减率
settings.dllNoiseBandwidth       = 2;       %噪声带宽[Hz]
settings.dllCorrelatorSpacing    = 0.5;     %相关器间距[chips]
 
% 载波跟踪环路参数
settings.pllDampingRatio         = 0.7;
settings.pllNoiseBandwidth       = 25;      %[Hz]
 
%% 导航定位方式的选择===========================================
 
% 计算伪距和位置的周期
settings.navSolPeriod       = 500;          %[ms]
 
% 去除低仰角的卫星
settings.elevationMask      = 10;           %[degrees 0 - 90]
% 启用/禁用对流层校正
settings.useTropCorr        = 1;            % 0 - Off
                                            % 1 - On
 
% UTM系统（UNIVERSAL TRANSVERSE MERCARTOR GRID）中天线的真实位置(如果已知)
% 输入的所有NaN和平均位置将被用作参考。
settings.truePosition.E     = nan;
settings.truePosition.N     = nan;
settings.truePosition.U     = nan;
 
%% Plot settings ==========================================================
% 启用/禁用每个通道的跟踪结果绘图
settings.plotTracking       = 1;            % 0 - Off
                                            % 1 - On
 
%% Constants ==============================================================
 
settings.c                  = 299792458;    % The speed of light, [m/s]
settings.startOffset        = 68.802;       %[ms] Initial sign. travel time