% ---------------------- ����B3I��Ƶ�ź�ģ�� ------------------------------
%--- Include folders with functions ---------------------------------------
addpath include             % The software receiver functions
addpath common        % Position calculation related functions

clear all; close all; clc;

% ȫ�ֱ���
PRN = 14;
pb3i = -163;   % -163 dBW 
global settings;
settings = iniSettings();
b3i = D1NavMsgEncode(PRN,pb3i);
[eph,SOW] = ephD1(b3i);