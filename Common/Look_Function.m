function L_matrix = Look_Function(User_XYZT,sat,pho)
%多卫星定位方程函数
%XYZT(1:3)为用户位置(km)  
%XYZT(4)为用户钟差(s)
%pho为测量得到的伪距(km)
%sat为卫星位置数据
c=299792.458;  %光速
[m,n]=size(sat);
for i=1:m
    L_matrix(i)=pho(i)-norm(sat(i,:)-User_XYZT(1:3));
end 
L_matrix=L_matrix';

end

