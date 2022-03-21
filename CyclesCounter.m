function [Nbcycles] = CyclesCounter(HSEED, MaxLength, DEBUG_FLAG)
% HSEED：校验矩阵
% MaxLength：查找的最大环长，小于的都可以找到
% DEBUG_FLAG：是否显示运行文字

% global Nbcycles;
global tbl_col;
global tbl_row;
global pair_col;
global pair_row;
N = length(HSEED(1,:));  % 列数
M = length(HSEED(:,1));  % 行数

Nbcycles = zeros(MaxLength,1);
if MaxLength >= 4
    for n = 2:N           % 按列遍历
        for ni = 2:M      % 按行遍历
            if HSEED(ni,n) == 1   % 认为是右下角的1
                ir_n = find(HSEED(1:ni-1,n)~=0);  % 列上方的1，行
                vic_c = find(HSEED(ni,1:n-1)~=0); % 行左方的1，列
                for i1 = 1:length(vic_c)
                    ic_c = vic_c(i1);  % 列，认为是左下角的1
                    vir_ic_c = find(HSEED(:,ic_c)~=0); % 整个列的1，行
                    vir_ic_c = setdiff(vir_ic_c,ni);   % 整个列的1，行，去掉本行/左下角的1
                    intersect_4 = intersect(vir_ic_c,ir_n);% 返回交集，左边与右边的交集，确定有几条上边--4环
                    if ~isempty(intersect_4)
                        num=length(intersect_4);
                        
                        tbl_col(1,n)=tbl_col(1,n)+num;  pair_col=[pair_col;n];
                        tbl_col(1,ic_c)=tbl_col(1,ic_c)+num; pair_col=[pair_col;ic_c];
                        
                        tbl_row(1,ni)=tbl_row(1,ni)+num; pair_row=[pair_row;ni];
                        tbl_row(1,intersect_4)=tbl_row(1,intersect_4)+1; pair_row=[pair_row;intersect_4];
                        
                        Nbcycles(4) = Nbcycles(4) + length(intersect_4); % 找到了四环的数量
                        if DEBUG_FLAG
                            disp([num2str(length(intersect_4)),' cycle(s) in (',num2str(ni),',',num2str(n),')']);
                        end
                    end
                    if MaxLength>=6
                        if n>=3 && ni>=3 % otherwise no cycles of length 6
                            for i2 = 1:length(vir_ic_c)
                                ir_ic_c = vir_ic_c(i2);  % 认为是左上\下角的1，行
                                vic_ir_ic_c = find(HSEED(ir_ic_c,1:n-1)~=0); % 行上的1，列
                                vic_ir_ic_c = setdiff(vic_ir_ic_c,[n,ic_c]); % 行上的1，除去两个端点1，列
                                for i3 = 1:length(vic_ir_ic_c)
                                    ic_ir_ic_c = vic_ir_ic_c(i3);
                                    vir6 = find(HSEED(:,ic_ir_ic_c)~=0); % 列上的1，行
                                    vir6 = setdiff(vir6,[ni,ir_ic_c]);   % 列上的1，除去两个边上的1，行 tentative indices for cycles of length 6
                                    intersect_6 = intersect(vir6,ir_n);  % 交集，中间的边，和右边交集
                                    if ~isempty(intersect_6)
                                        num=length(intersect_6);
                                        
                                        tbl_col(2,n)=tbl_col(2,n)+num;            pair_col=[pair_col;n];
                                        tbl_col(2,ic_c)=tbl_col(2,ic_c)+num;      pair_col=[pair_col;ic_c];
                                        tbl_col(2,ic_ir_ic_c)=tbl_col(2,ic_ir_ic_c)+num;pair_col=[pair_col;ic_ir_ic_c];
                                        
                                        tbl_row(2,ni)=tbl_row(2,ni)+num;pair_row=[pair_row;ni];
                                        tbl_row(2,ir_ic_c)=tbl_row(2,ir_ic_c)+num;pair_row=[pair_row;ir_ic_c];
                                        tbl_row(2,intersect_6)=tbl_row(2,intersect_6)+1;pair_row=[pair_row;intersect_6];
                                        
                                        Nbcycles(6) = Nbcycles(6) + length(intersect_6);
                                        if DEBUG_FLAG
                                            disp([num2str(length(intersect_6)),' cycle(s) in (',num2str(ni),',',num2str(n),')']);
                                        end
                                    end
                                    if MaxLength>=8
                                        if n>=4 && ni>=4 % otherwise no cycles of length 8
                                            for i81 = 1:length(vir6)
                                                ir_ic_ir_ic_c = vir6(i81); % 列上的1，行
                                                vic_ir_ic_ir_ic_c = find(HSEED(ir_ic_ir_ic_c,1:n-1)~=0); % 行上的1，列
                                                vic_ir_ic_ir_ic_c = setdiff(vic_ir_ic_ir_ic_c,[n,ic_c,ic_ir_ic_c]);
                                                for i82 = 1:length(vic_ir_ic_ir_ic_c)
                                                    ic_ir_ic_ir_ic_c = vic_ir_ic_ir_ic_c(i82);  % 行上的1，列
                                                    vir8 = find(HSEED(:,ic_ir_ic_ir_ic_c)~=0);  % 列上的1，行
                                                    vir8 = setdiff(vir8,[ni,ir_ic_c,ir_ic_ir_ic_c]);% tentative indices for cycles of length 8
                                                    intersect_8 = intersect(vir8,ir_n);
                                                    if ~isempty(intersect_8)
                                                        num=length(intersect_8);
                                                        tbl_col(3,n)=tbl_col(3,n)+num;
                                                        tbl_col(3,ic_c)=tbl_col(3,ic_c)+num;
                                                        tbl_col(3,ic_ir_ic_c)=tbl_col(3,ic_ir_ic_c)+num;
                                                        tbl_col(3,ic_ir_ic_ir_ic_c)=tbl_col(3,ic_ir_ic_ir_ic_c)+num;
                                                        Nbcycles(8) = Nbcycles(8) + length(intersect_8);
                                                        if DEBUG_FLAG
                                                            disp([num2str(length(intersect_8)),' cycle(s) in (',num2str(ni),',',num2str(n),')']);
                                                        end
                                                    end
                                                    if MaxLength>=10
                                                        if n>=5 && ni>=5 % otherwise no cycles of length 10
                                                            for i101 = 1:length(vir8)
                                                                ir_ic_ir_ic_ir_ic_c = vir8(i101);  % 列上的1，行
                                                                vic_ir_ic_ir_ic_ir_ic_c = find(HSEED(ir_ic_ir_ic_ir_ic_c,1:n-1)~=0); % 行上的1，列
                                                                vic_ir_ic_ir_ic_ir_ic_c = setdiff(vic_ir_ic_ir_ic_ir_ic_c,[n,ic_c,ic_ir_ic_c,ic_ir_ic_ir_ic_c]);
                                                                for i102 = 1:length(vic_ir_ic_ir_ic_ir_ic_c)
                                                                    ic_ir_ic_ir_ic_ir_ic_c = vic_ir_ic_ir_ic_ir_ic_c(i102);
                                                                    vir10 = find(HSEED(:,ic_ir_ic_ir_ic_ir_ic_c)~=0);
                                                                    vir10 = setdiff(vir10,[ni,ir_ic_c,ir_ic_ir_ic_c,ir_ic_ir_ic_ir_ic_c]);% tentative indices for cycles of length 10
                                                                    intersect_10 = intersect(vir10,ir_n);
                                                                    if ~isempty(intersect_10)
                                                                        Nbcycles(10) = Nbcycles(10) + length(intersect_10);
                                                                        if DEBUG_FLAG
                                                                            disp([num2str(length(intersect_10)),' cycle(s) in (',num2str(ni),',',num2str(n),')']);
                                                                        end
                                                                    end
                                                                    if MaxLength>=12
                                                                        if n>=6 && ni>=6 % otherwise no cycles of length 12
                                                                            for i121 = 1:length(vir10)
                                                                                ir_ic_ir_ic_ir_ic_ir_ic_c = vir10(i121);
                                                                                vic_ir_ic_ir_ic_ir_ic_ir_ic_c = find(HSEED(ir_ic_ir_ic_ir_ic_ir_ic_c,1:n-1)~=0);
                                                                                vic_ir_ic_ir_ic_ir_ic_ir_ic_c = setdiff(vic_ir_ic_ir_ic_ir_ic_ir_ic_c,[n,ic_c,ic_ir_ic_c,ic_ir_ic_ir_ic_c,ic_ir_ic_ir_ic_ir_ic_c]);
                                                                                for i122 = 1:length(vic_ir_ic_ir_ic_ir_ic_ir_ic_c)
                                                                                    ic_ir_ic_ir_ic_ir_ic_ir_ic_c = vic_ir_ic_ir_ic_ir_ic_ir_ic_c(i122);
                                                                                    vir12 = find(HSEED(:,ic_ir_ic_ir_ic_ir_ic_ir_ic_c)~=0);
                                                                                    vir12 = setdiff(vir12,[ni,ir_ic_c,ir_ic_ir_ic_c,ir_ic_ir_ic_ir_ic_c,ir_ic_ir_ic_ir_ic_ir_ic_c]);% tentative indices for cycles of length 12
                                                                                    intersect_12 = intersect(vir12,ir_n);
                                                                                    if ~isempty(intersect_12)
                                                                                        Nbcycles(12) = Nbcycles(12) + length(intersect_12);
                                                                                        if DEBUG_FLAG
                                                                                            disp([num2str(length(intersect_12)),' cycle(s) in (',num2str(ni),',',num2str(n),')']);
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
