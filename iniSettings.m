%% ------------------ ϵͳ�������� -----------------------------------------
function    settings  = iniSettings()
%% --------------------- ���泡������ ---------------------------------------
settings.SigNum       = 1;                           % �ź���

% Number of milliseconds to be processed used 36000 + any transients (see
% below - in Nav parameters) to ensure nav subframes are provided
settings.msToProcess        = 18000;        %[ms]  %��ģ��������֡

% Number of channels to be used for signal processing
settings.numberOfChannels   = 8;
% Constants
settings.c            = 299792458;                         % ����

%% --------------------- �źŲ������� ---------------------------------------
settings.carrFreqBasis      = 1268.52e6;                   % �ز�Ƶ��
settings.lambda       = settings.c/settings.carrFreqBasis;      % �źŲ���
settings.codeFreqBasis      = 10.23e6;               % ���������chip per second
settings.codeLength   = 10230;                       % ����볤��
settings.freScA       = 1*1.023e6;                   % ���ز�A��Ƶ��
settings.freScB       = 6*1.023e6;                   % ���ز�B��Ƶ��

%% --------------------- ���ջ��������� -------------------------------------
settings.IF           = 10e6;                        % ����Ƶ��
settings.samplingFreq = 100e6;                  % ����Ƶ��
settings.ts           = 1/settings.samplingFreq;     % ��������
settings.N            = 512;                         % FFT����
settings.M            = 50;                          % �ֶ���
settings.SampleNum    = settings.N*settings.M;       % �źų��ȣ�����������
settings.NumPerCode   = ceil(settings.samplingFreq ...
                      / settings.codeFreqBasis);           % ÿ����Ƭ��������
settings.NumPerScode  = settings.codeLength ...
                      * settings.NumPerCode;         % ÿ�������������
% ������Ϊ��Ƶ�����������Ƭ����������������ͬ
%% --------------------- ����������� -------------------------------------
settings.skipAcquisition    = 0;                            %�Ƿ�����������������1����postProcessing.m�������������
settings.acqSatelliteList   = [1:29 31 32];%[1:32];         %��Ҫ���������������Ϊ�˼ӿ첶���ٶȣ������ų�һЩ����
settings.acqSearchBand      = 14;           %[kHz]��������Ƶ�ƵĹ������
settings.acqThreshold       = 2.5;          %��ֵ�źŵ�ȷ��
% No. of code periods for coherent integration (multiple of 2)
settings.acquisition.cohCodePeriods=2;%10;%
% No. of non-coherent summations
settings.acquisition.nonCohSums=4;

end