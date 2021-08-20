% % function [encodedData] = D1NavMsgBCHEncoder(navmsg)
% clear all;
% N = 15;
% K = 11;
% msglen = 224;
% encodedData1 =[];encodedData2=[];
% % navmsg = randi([0 1],msglen,1);
navmsg0 = '11100010010000000100111111010010000000000100000000000000110000100001111110100100000000000000000000000000000000000010110101010101101110111011010101010110111011101101010101011011101110110101010101101110111011010101010110111011';
% navmsg1 = '11100010010000000100111111010010000000000000000000001100001000011111101001000000000000000000000000111111110011001000000001001100110100001111111101000000000111000000000000001100000000000000000000000000000000000000000000000000';
% navmsg = (double(navmsg) - '0')';
% Pre = navmsg(1:15);
% FraID_SOW = navmsg(16:26);
% navmsg(1:26) = [];
% % navmsg = 2*randi(2,[msglen,1])-3;
% mtx = reshape(navmsg,11,[]);
% 
% navmsg1 = mtx(:,1:2:end);
% navmsg2 = mtx(:,2:2:end);
% % genpoly = bchgenpoly(N,K,'D^4 + D^3 + 1');
% % bchEncoder = comm.BCHEncoder(N,K,genpoly);
% FraID_SOW_bch = bchencoder(FraID_SOW);
% for i_col = 1 : size(navmsg1,2)
%     encodedData1 = [encodedData1; bchencoder(navmsg1(:,i_col))];
% end
% for i_col = 1 : size(navmsg2,2)
%     encodedData2 = [encodedData2; bchencoder(navmsg2(:,i_col))];
% end
% 
% encodedData = zeros(300,1);
% encodedData(1:30) = [Pre FraID_SOW_bch];
% encodedData(31:2:end) = encodedData1;
% encodedData(32:2:end) = encodedData2;
for i_index = 1 : 300/4
    datastr = num2str((encodedData(4*i_index-3:4*i_index))');
    dataindec = bin2dec(datastr);
    datainhex(i_index) = dec2hex(dataindec);
end

% intext = 'E2404FC8820008800F55BA6080002A45555C3AABA50A25FECA854A8000A000000000000000000000';
% navinbin = hex2bin(intext);
% 
% function navinbin = hex2bin(intext)
%     navinbin = [];
%     for i = 1 : length(intext)
%         temptext = intext(i);
%         navinbin = [navinbin bitget((hex2dec(intext(i))),4:-1:1)];
%     end
% end

navmsg = [0 0 1 0 0 1 1 1 1 1 1];
bchcode = bchencoder(navmsg');

%% BCH±àÂë
function bchcode = bchencoder(indata)
    D3=0;D2=0;D1=0;D0=0;
    for i = 1 : 11
            tempbit = xor(indata(i), D3);
            D3 = D2;
            D2 = D1;
            D1 = xor(D0,tempbit);
            D0 = tempbit;
    end
    bchcode = [indata;D3;D2;D1;D0]
end