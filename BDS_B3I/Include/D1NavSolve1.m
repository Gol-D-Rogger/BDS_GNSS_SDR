% function eph = D1NavSolve1(filepath)
filepath = 'F:\MyProject\MatlabProject\Beidou\BDS_GNSS_SDR\navInHex.txt';

subframe_num = 100;

navFile = fopen(filepath,'rt');
navCell = textscan(navFile,'%s',subframe_num);
navBin = cell2mat(navCell{1:1});
navcat = '';
[navLineNum,~] = size(navBin);
for i = 1 : subframe_num
    navcat = append(navcat,navBin(i,:));
end


eph = D1NavRead(navcat);

% nav = (double(navcat) - '0');
% %%%%%%%%%%%%%% 计时以比较方案优劣 %%%%%%%%%%%%%
% tic
% searchStartOffset = 0;
% preamble_bits = [1 1 1 0 0 0 1 0 0 1 0];
% 
% nav = [round(rand(1,10)) nav(1:end)]; %增加不可靠数据模拟位移动流程
% 
% for i_navStart = 0 : 299
%     bits = nav(1+i_navStart : 1500+i_navStart);
%     checkStart = 1;
%     checkEnd = 11;
%     allChecked = 0;
%     frameInterval = 300;
% 
%     xcorrResult = xcorr(bits(checkStart:checkEnd), preamble_bits,'normalized');
% 
%     while max(xcorrResult == 1)
%         checkStart = checkStart + frameInterval;
%         checkEnd = checkEnd + frameInterval;
%         if checkStart >= length(bits)
%             allChecked = 1;
%             break;
%         end
%         xcorrResult = xcorr(bits(checkStart:checkEnd), preamble_bits,'normalized');
%     end
% 
%     if allChecked == 1
%         %[eph,SOW] = ephD1(bits);
%         bits = num2str(bits')';  
%         eph = D1NavRead(bits);
%         break
%     end
%     
% end



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


% toc