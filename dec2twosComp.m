function  y = dec2twosComp(dec,bitn)

    % bitnΪҪת���Ķ���������λ��
    length_b = length(dec2bin(abs(dec)));
    if bitn <= length_b
        bitn = length_b + 1;
    end
    
    % ����ת��
    if dec < 0
        dec = power(2,bitn) + dec;
    end
    y = dec2bin(dec,bitn);