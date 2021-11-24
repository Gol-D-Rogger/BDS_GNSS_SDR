function settings=initSettings()
% Ҫ����ĺ�����ʹ��36000 +�κ�˲̬(������-�ڵ�������)����ȷ��������֡���ṩ
settings.msToProcess        = 37000;        %[ms]
 
 
% �����źŴ����ͨ����
settings.numberOfChannels   = 8;
 
% �ƶ��������㣬�����������ݼ�¼���κε㿪ʼ�źŴ���(���糤��¼)��
% Fseek���������ƶ��ļ����㣬���advance�������ֽڡ�
settings.skipNumberOfBytes     = 0;
 
%% ��ԭʼ�ź��ļ��������������� ===============================
 
% ������post-processingģʽ��ʹ�õ������ļ�(�źż�¼)�ġ�Ĭ�ϡ�����
settings.fileName           = 'F:\BeidouFile\IF_Data\gnss0.bin'; 
% ���ڴ洢һ����������������
settings.dataType           = 'int8';
 
% ��ƵƵ�ʣ�����Ƶ�ʣ�C/A����
settings.IF                 = 9.548e6;      %��Ƶ[Hz]
settings.samplingFreq       = 38.192e6;     %����Ƶ��[Hz]
settings.codeFreqBasis      = 1.023e6;      %C/A�������[Hz]
 
% һ�������ڰ�������Ƭ����
settings.codeLength         = 10230;         %C/A������Ϊ10230����Ƭ
 
%% Acquisition settings ���ò������==============================================
% �����1����postProcessing.m�������������
settings.skipAcquisition    = 0;
% Ҫ�ҵ������б�Ϊ�˼ӿ첶���ٶȣ������ų�һЩ����
settings.acqSatelliteList   = 1:32;         %[PRN numbers]
% Band around IF to search for satellite signal. Depends on max Doppler
% ������Ƶ���������źš�ȡ������������
settings.acqSearchBand      = 14;           %[kHz]��������Ƶ�ƵĹ�����̡�GPSԭ������ջ���ơ������¼�ƣ�����ơ���P354
% ��ֵ�źŵľ��߹���
settings.acqThreshold       = 2.5;
 
%% ���ٻ�·�Ĳ�������================================================
% C/A����ٻ�·����
settings.dllDampingRatio         = 0.7;     %˥����
settings.dllNoiseBandwidth       = 2;       %��������[Hz]
settings.dllCorrelatorSpacing    = 0.5;     %��������[chips]
 
% �ز����ٻ�·����
settings.pllDampingRatio         = 0.7;
settings.pllNoiseBandwidth       = 25;      %[Hz]
 
%% ������λ��ʽ��ѡ��===========================================
 
% ����α���λ�õ�����
settings.navSolPeriod       = 500;          %[ms]
 
% ȥ�������ǵ�����
settings.elevationMask      = 10;           %[degrees 0 - 90]
% ����/���ö�����У��
settings.useTropCorr        = 1;            % 0 - Off
                                            % 1 - On
 
% UTMϵͳ��UNIVERSAL TRANSVERSE MERCARTOR GRID�������ߵ���ʵλ��(�����֪)
% ���������NaN��ƽ��λ�ý��������ο���
settings.truePosition.E     = nan;
settings.truePosition.N     = nan;
settings.truePosition.U     = nan;
 
%% Plot settings ==========================================================
% ����/����ÿ��ͨ���ĸ��ٽ����ͼ
settings.plotTracking       = 1;            % 0 - Off
                                            % 1 - On
 
%% Constants ==============================================================
 
settings.c                  = 299792458;    % The speed of light, [m/s]
settings.startOffset        = 68.802;       %[ms] Initial sign. travel time