function hex = bin2hex(bin)%input should be a binary matrix
hex = '';
for i_index = 1 : 300/4
    datastr = num2str((bin(4*i_index-3:4*i_index))');
    dataindec = bin2dec(datastr);
    hex(i_index) = dec2hex(dataindec);
end
end

