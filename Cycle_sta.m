% tbl��ͳ��ÿ�����أ��У����ֲ�ͬ���ȶ̻��Ĵ���
% Nbcycles����ͬ���ȶ̻�������
clc
clear 
close all
global Nbcycles;
global tbl_col;
global tbl_row;
global pair_col;
global pair_row;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load('H_648_34') % �����ֶ��滻������������Ϊ��H
Hbd = [1 1 1 1 0 1 0 1 1 0 0 1 0 0 0;...
       0 1 1 1 1 0 1 0 1 1 0 0 1 0 0;...
       0 0 1 1 1 1 0 1 0 1 1 0 0 1 0;...
       1 1 1 0 1 0 1 1 0 0 1 0 0 0 1];
%    
% H74 = [1 1 1 0 1 0 0;...
%         0 1 1 1 0 1 0;...
%         0 0 1 1 1 0 1];
pol = cyclpoly(15,11);
[H74,genmat,k] = cyclgen(15,pol);
%%%%%%%%%%%%%% ȷ��number of shift %%%%%%%%%%%%%%

% pol = cyclpoly(31,21);
% [H74,genmat,k] = cyclgen(31,pol);
H74 = [1 0 0 0 1 0 0 1;...
      0 0 0 1 0 1 0 1;...
      0 0 1 1 1 0 1 0;...
      0 1 1 0 0 0 0 1];
  
HM = [1 0 0 0 1 0 0 1 0;...
      0 0 0 1 0 1 0 1 0;...
      0 0 1 1 1 0 1 0 0;...
      0 1 1 0 0 0 0 1 0;
      0 1 0 0 1 0 0 0 1;...
      1 0 1 0 0 0 0 0 1;...
      1 1 0 1 0 0 1 0 0;...
      0 0 0 0 0 1 1 0 1];
numberOfOverlapping = zeros(length(H74) - 1,1);
for i_shift = 1 : length(H74) - 1
    B = circshift(H74,i_shift,2);
    comp = (H74 == B);
    numberOfOverlapping(i_shift) = sum(comp,'all');
end



H = g2rref(H74);
[row,col]=size(H);
tbl_col=zeros(2,col); % 4��6��8��
tbl_row=zeros(2,row); % 4��6��8��
pair_col=[];
pair_row=[];
Nbcycles = CyclesCounter(H,4,1);

tbl_col=tbl_col';
sum(tbl_col(:,1))


