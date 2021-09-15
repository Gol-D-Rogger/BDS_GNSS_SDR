clear all
intext = 'E2404FC8830009D0100F676A20802A0000000333333CFCCCCCF3F33333CFCCCCCF3F33333CFE2408FC0824158DFFFFFFFEAA000080000000000000009090902424242939090902430ED08EE240CFFC970019908B0EE6E424240909090A4E4242409480C3BBAC3B41B5A42407A50909026';
%subframe 123
navinbintext = hexstr2bin(intext);

% navinbin = '11100010010000000100111111010010000000000100000000000000110000100001111110100100000000000000000000000000000000000010110101010101101110111011010101010110111011101101010101011011101110110101010101101110111011010101010110111011';
% bits = (double(bits) - '0')';
eph = ephD1_structure_init();
[eph,SOW] = ephD1(navinbintext,eph);
function bin = hexstr2bin(hex)
    navinbin = [];
    for i = 1 : length(hex)
        navinbin = [navinbin bitget((hex2dec(hex(i))),4:-1:1)];
    end
    bin = [];
    for i = 1 : length(navinbin)
       bin = [bin num2str(navinbin(i))]; 
    end
end
%test in 9.15