%α�ඨλ�㷨 
clear all;
close all ;
clc;
c=299792.458;  %���٣���λkm
%ͨ�������������㵽���ڵؿɼ����ǵ�����λ��
sat1=[15524471.175, -16649826.222,13512272.387];
sat2=[-2304058.534, -23287906.465, 11917038.105];
sat3=[16680243.357, -3069625.561, 20378551.047];
sat4=[-14799931.395, -21425358.240, 6069947.224];
sat5=[-18946721.395, -21397489.240, 6782641.224];
sat=[sat1; sat2; sat3; sat4; sat5];%������λ�þ���
%���ڵ�ʵ�ʴ�����꣬�����붨λ������Ƚ�
User_location_true=[-730000, -5440000, 3230000];
%��������
num_sat=5;
pho0 = zeros(num_sat,1);
%����α�����ֵ
for i_Nter = 1:num_sat
    pho0(i_Nter,1)=norm(sat(i_Nter,:)-User_location_true);
end
%�������ֵ������Ϊ80�������˹�ֲ���ģ�⺬������α��pho
%Delta_T_I�������������ʾ�����Ͷ������������ʣ�����
Delta_T_I=sqrt(80)*randn(size(pho0))*1e-3;%����Ǽٶ������
pho = pho0 + Delta_T_I;
%������ʼλ��/ʱ�����
User_XYZT=[0,0,0,0];
Nter=16; %������������Ϊ16��
for i_Nter = 1:Nter  
    L_matrix = Look_Function(User_XYZT,sat,pho);
    A_matrix  = Partial_Diff_Function( User_XYZT,sat );
    %��С���˽�
    delta=inv(A_matrix.'*A_matrix)*A_matrix.'*L_matrix; 
    User_XYZT(1)=User_XYZT(1)+delta(1);
    User_XYZT(2)=User_XYZT(2)+delta(2);
    User_XYZT(3)=User_XYZT(3)+delta(3);
    User_XYZT(4)=User_XYZT(4)+delta(4); 
    error_X(i_Nter)=abs(User_XYZT(1)-User_location_true(1));
    error_Y(i_Nter)=abs(User_XYZT(2)-User_location_true(2));
    error_Z(i_Nter)=abs(User_XYZT(3)-User_location_true(3));
    p=norm(delta);   %��λ����
    if (p<1e-5)
        break;
    end
end
figure(1)
subplot(2,2,1)
plot(1:1:length(error_X),error_X,'r-o');
xlabel('��������')
ylabel('X�����������')
hold on
subplot(2,2,2)
plot(1:1:length(error_Y),error_Y,'r-o');
xlabel('��������')
ylabel('Y�����������')
hold on
subplot(2,2,3)
plot(1:1:length(error_Z),error_Z,'r-o');
xlabel('��������')
ylabel('Z�����������')
hold on
