%伪距定位算法 
clear all;
close all ;
clc;
c=299792.458;  %光速，单位km
%通过星历参数解算到所在地可见卫星的坐标位置
sat1=[15524471.175, -16649826.222,13512272.387];
sat2=[-2304058.534, -23287906.465, 11917038.105];
sat3=[16680243.357, -3069625.561, 20378551.047];
sat4=[-14799931.395, -21425358.240, 6069947.224];
sat5=[-18946721.395, -21397489.240, 6782641.224];
sat=[sat1; sat2; sat3; sat4; sat5];%多卫星位置矩阵
%所在地实际大地坐标，用来与定位结果作比较
User_location_true=[-730000, -5440000, 3230000];
%卫星数量
num_sat=5;
pho0 = zeros(num_sat,1);
%理想伪距测量值
for i_Nter = 1:num_sat
    pho0(i_Nter,1)=norm(sat(i_Nter,:)-User_location_true);
end
%加入零均值，方差为80的随机高斯分布，模拟含有误差的伪距pho
%Delta_T_I这个可以用来表示电离层和对流层修正后的剩余误差
Delta_T_I=sqrt(80)*randn(size(pho0))*1e-3;%这个是假定的误差
pho = pho0 + Delta_T_I;
%迭代初始位置/时钟误差
User_XYZT=[0,0,0,0];
Nter=16; %最大迭代次数设为16次
for i_Nter = 1:Nter  
    L_matrix = Look_Function(User_XYZT,sat,pho);
    A_matrix  = Partial_Diff_Function( User_XYZT,sat );
    %最小二乘解
    delta=inv(A_matrix.'*A_matrix)*A_matrix.'*L_matrix; 
    User_XYZT(1)=User_XYZT(1)+delta(1);
    User_XYZT(2)=User_XYZT(2)+delta(2);
    User_XYZT(3)=User_XYZT(3)+delta(3);
    User_XYZT(4)=User_XYZT(4)+delta(4); 
    error_X(i_Nter)=abs(User_XYZT(1)-User_location_true(1));
    error_Y(i_Nter)=abs(User_XYZT(2)-User_location_true(2));
    error_Z(i_Nter)=abs(User_XYZT(3)-User_location_true(3));
    p=norm(delta);   %定位精度
    if (p<1e-5)
        break;
    end
end
figure(1)
subplot(2,2,1)
plot(1:1:length(error_X),error_X,'r-o');
xlabel('迭代次数')
ylabel('X方向坐标误差')
hold on
subplot(2,2,2)
plot(1:1:length(error_Y),error_Y,'r-o');
xlabel('迭代次数')
ylabel('Y方向坐标误差')
hold on
subplot(2,2,3)
plot(1:1:length(error_Z),error_Z,'r-o');
xlabel('迭代次数')
ylabel('Z方向坐标误差')
hold on
