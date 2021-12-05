% function eph = D1NavSolve1(filepath)
filepath = 'F:\MyProject\MatlabProject\Beidou\BDS_GNSS_SDR\navInHex.txt';

navFile = fopen(filepath,'rt');
navCell = textscan(navFile,'%s',100);
navBin = cell2mat(navCell{1:1});
navcat = '';
[navLineNum,~] = size(navBin);
for i = 1 : 100
    navcat = append(navcat,navBin(i,:));
end
nav = (double(navcat) - '0');
%%%%%%%%%%%%%% 计时以比较方案优劣 %%%%%%%%%%%%%
tic
searchStartOffset = 0;
preamble_bits = [1 1 1 0 0 0 1 0 0 1 0];

nav = [round(rand(1,10)) nav(1:end)]; %增加不可靠数据模拟位移动流程

for i_navStart = 0 : 299
    bits = nav(1+i_navStart : 1500+i_navStart);
    checkStart = 1;
    checkEnd = 11;
    allChecked = 0;
    frameInterval = 300;

    xcorrResult = xcorr(bits(checkStart:checkEnd), preamble_bits,'normalized');

    if max(xcorrResult == 1)
        checkStart = checkStart + frameInterval;
        checkEnd = checkEnd + frameInterval;
        
        xcorrResult = xcorr(bits(checkStart:checkEnd), preamble_bits,'normalized');
        
        
        if max(xcorrResult == 1)
            word1 = bits(1:60);
            word2 = bits(1:60);
            subframeID1 = bin2dec(word1(16:18));
            subframeID2 = bin2dec(word2(16:18));
            SOW1        = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            SOW2        = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            
            if checkStart >= length(bits)
                allChecked = 1;
                break;
            end
        end
    end

    if allChecked == 1
        [eph,SOW] = ephD1(bits);
        break
    end
    
    
end


toc