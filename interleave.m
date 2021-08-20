function dataout = interleave(datain)
%INTERLEAVE Ã¿1bit½»Ö¯
    dataout = zeros(30,1);
    dataout(1:2:end) = datain(1:15);
    dataout(2:2:end) = datain(16:30);
end

