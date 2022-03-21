function eph = D1NavSolveAPP(filepath)
%filepath = 'F:\MyProject\MatlabProject\Beidou\BDS_GNSS_SDR\navInHex.txt';

subframe_num = 1000;

navFile = fopen(filepath,'rt');
navCell = textscan(navFile,'%s',subframe_num);
navBin = cell2mat(navCell{1:1});
navcat = '';
[navLineNum,~] = size(navBin);
for i = 1 : subframe_num
    navcat = append(navcat,navBin(i,:));
end


eph = D1NavRead(navcat);
end