function L_matrix = Look_Function(User_XYZT,sat,pho)
%�����Ƕ�λ���̺���
%XYZT(1:3)Ϊ�û�λ��(km)  
%XYZT(4)Ϊ�û��Ӳ�(s)
%phoΪ�����õ���α��(km)
%satΪ����λ������
c=299792.458;  %����
[m,n]=size(sat);
for i=1:m
    L_matrix(i)=pho(i)-norm(sat(i,:)-User_XYZT(1:3));
end 
L_matrix=L_matrix';

end

