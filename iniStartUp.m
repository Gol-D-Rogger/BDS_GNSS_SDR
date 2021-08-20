% ---------------------- 北斗B3I中频信号模拟 ------------------------------
%--- Include folders with functions ---------------------------------------
addpath include             % The software receiver functions
addpath common        % Position calculation related functions

clear all; close all; clc;

% 全局变量
PRN = 14;
pb3i = -163;   % -163 dBW 
global settings;
settings = iniSettings();
b3i = D1NavMsgEncode(PRN,pb3i);
[eph,SOW] = ephD1(b3i);