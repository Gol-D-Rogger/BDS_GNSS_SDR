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

bits = nav(1:1500);
checkStart = 1;
checkEnd = 11;
allChecked = 0;
frameInterval = 300;

xcorrResult = xcorr(bits(checkStart:checkEnd), preamble_bits,'normalized');

while max(xcorrResult == 1)
    checkStart = 1 + frameInterval;
    checkEnd = 11 + frameInterval;
    if checkStart >= length(bits)
        allChecked = 1;
        break;
    end
    xcorrResult = xcorr(bits(checkStart:checkEnd), preamble_bits,'normalized');
end

if allChecked == 1
    [eph,SOW] = ephD1(bits,eph);
end


% bits = navBin(1 + searchStartOffset : end);

% xcorrResult = xcorr(bits, preamble_bits);

% clear index
% xcorrLength = (length(xcorrResult) + 1) / 2;
% index = find(abs(xcorrResult(xcorrLength : xcorrLength * 2 - 1)) > 4)';


% for i = 1 : size(index)
%     if ((length(bit) - index(i) +1) >= 300*5)
%         temp_bits = bits(index(i):index(i)+1500-1);

%         if (~isequal(temp_bits(1:11),preamble_bits))
%             temp_bits = ~temp_bits;
%         end

        
%     end
% end


toc