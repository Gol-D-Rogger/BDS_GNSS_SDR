function  y = dec2twosComp(dec,bitn)

    % bitn为要转换的二进制数的位数
    length_b = length(dec2bin(abs(dec)));
    if bitn <= length_b
        bitn = length_b + 1;
    end
    
    % 补码转换
    if dec < 0
        dec = power(2,bitn) + dec;
    end
    y = dec2bin(dec,bitn);