% 提取仿真电文中的电文并转换为二进制比特流

% function navBin = D1NavTrans(filepath)
filepath = 'F:\BeidouFile\导航电文\导航电文D1\仿真电文-BD-B1-中国-北京\仿真电文-BD-B1-中国-北京.TXT';
navFile = fopen(filepath,'rt');
if (navFile == -1)
	msgbox('输入的文件或者路径不正确,无法正确打开文件','警告信息');
	return;
end

% A = textscan(navFile,'%xu16');
% fclose(navFile);
% A=[A{:}];
% [iLine,~] = size(A);

% navBin = [];
% for i_index = 1 : iLine
% 	navBin = [navBin dec2bin(A(i_index,1),16)];
% end
% navBin = (double(navBin) - '0');

lineIndex = 0;
lineInterval = 5;
navExtract = fopen('navInHex.txt','wt');
while ~feof(navFile)
	line = fgetl(navFile);
	lineSplit = strsplit(line);
	if mod(lineIndex,10) == 0
		navFrameHex = cell2mat(lineSplit(end));
        navFrameBin = hexstr2bin(navFrameHex(1:75));
		fprintf(navExtract, "%s\n", navFrameBin);
	end
	lineIndex = lineIndex + 1;
end
fclose(navExtract);

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