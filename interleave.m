function dataout = interleave(datain)
%INTERLEAVE ÿ1bit��֯
    dataout = zeros(30,1);
    dataout(1:2:end) = datain(1:15);
    dataout(2:2:end) = datain(16:30);
end

