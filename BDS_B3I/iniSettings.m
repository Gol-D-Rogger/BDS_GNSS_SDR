%% ------------------ 系统参数设置 -----------------------------------------
function    settings  = iniSettings()
%% --------------------- 仿真场景设置 ---------------------------------------
settings.SigNum       = 1;                           % 信号数

% Number of milliseconds to be processed used 36000 + any transients (see
% below - in Nav parameters) to ensure nav subframes are provided
settings.msToProcess        = 18000;        %[ms]  %先模拟三个子帧

% Number of channels to be used for signal processing
settings.numberOfChannels   = 8;
% Constants
settings.c            = 299792458;                         % 光速

%% --------------------- 信号参数设置 ---------------------------------------
settings.carrFreqBasis      = 1268.52e6;                   % 载波频率
settings.lambda       = settings.c/settings.carrFreqBasis;      % 信号波长
settings.codeFreqBasis      = 10.23e6;               % 测距码速率chip per second
settings.codeLength   = 10230;                       % 测距码长度
settings.freScA       = 1*1.023e6;                   % 子载波A的频率
settings.freScB       = 6*1.023e6;                   % 子载波B的频率

%% --------------------- 接收机参数设置 -------------------------------------
settings.IF           = 10e6;                        % 中心频率
settings.samplingFreq = 100e6;                  % 采样频率
settings.ts           = 1/settings.samplingFreq;     % 采样周期
settings.N            = 512;                         % FFT点数
settings.M            = 50;                          % 分段数
settings.SampleNum    = settings.N*settings.M;       % 信号长度（采样点数）
settings.NumPerCode   = ceil(settings.samplingFreq ...
                      / settings.codeFreqBasis);           % 每个码片采样点数
settings.NumPerScode  = settings.codeLength ...
                      * settings.NumPerCode;         % 每个子码采样点数
% 这是因为导频分量子码的码片宽度与主码的周期相同
%% --------------------- 捕获参数设置 -------------------------------------
settings.skipAcquisition    = 0;                            %是否跳过捕获程序，如果置1则在postProcessing.m中跳过捕获程序
settings.acqSatelliteList   = [1:29 31 32];%[1:32];         %需要捕获的卫星名单，为了加快捕获速度，可以排除一些卫星
settings.acqSearchBand      = 14;           %[kHz]最大多普勒频移的估算过程
settings.acqThreshold       = 2.5;          %阈值信号的确定
% No. of code periods for coherent integration (multiple of 2)
settings.acquisition.cohCodePeriods=2;%10;%
% No. of non-coherent summations
settings.acquisition.nonCohSums=4;

end