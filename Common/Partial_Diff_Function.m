function [ A_matrix ] = Partial_Diff_Function( User_XYZT,sat )
%������Ƕ�λ��ƫ��������
%xyztΪ�û�λ�ü��Ӳ�
%satΪ��������
c=299792.458;  %����
[m,n]=size(sat);
XYZ=User_XYZT(1:3);
for i=1:m
    for j=1:3   
        A_matrix(i,j)=(XYZ(j)-sat(i,j))/norm(sat(i,:)-XYZ);
    end
end
A_matrix(:,4)=c;
end

