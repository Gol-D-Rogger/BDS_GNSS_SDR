% ---------------------- ����B3I��Ƶ�ź�ģ�� ------------------------------
%--- Include folders with functions ---------------------------------------
addpath include             % The software receiver functions
addpath ('../Common')        % Position calculation related functions

clear all; close all; clc;

% ȫ�ֱ���
PRN = 14;
pb3i = -163;   % -163 dBW 
global settings;
settings = iniSettings();
b3i = D1NavMsgEncode(PRN,pb3i);
% tice
% recvSignal = basicChannel(b3i);
% toc
eph = ephD1_structure_init();
[eph,SOW] = ephD1(b3i,eph);