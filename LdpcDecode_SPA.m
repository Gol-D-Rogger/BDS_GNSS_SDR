
function Dec_out = LdpcDecode_SPA(in,H,MaxIter)
%%% in为解调后的的对数似然比信息，为N维行向量
%%% H为校验矩阵,MaxIter为最大迭代次数
[M,N] = size(H);
%% 初始化
V_n = in;                       %似然概率
V_mn = repmat(V_n,M,1);         %m代表校验节点索引，n代表变量节点索引
V_mn(H == 0) = 0;
U_mn = zeros(M,N);
%% 译码
for i = 1:MaxIter
    % 校验节点更新
    for m = 1:M
        Nm = find(H(m,:)==1);    %校验节点m相邻的变量节点
        for n = 1:length(Nm)
            aa = Nm;
            aa(n) = [];
            % MSA: U_mn(m,Nm(n)) = prod(sign(V_mn(m,aa)))*min(abs(V_mn(m,aa)));
            U_mn(m,Nm(n)) = 2*atanh(prod(tanh(V_mn(m,aa)/2)));
        end
    end
    
    %变量节点更新
    for n = 1:N
        Mn = find(H(:,n)==1);       %变量节点n相邻的校验节点
        for m = 1:length(Mn)
            bb = Mn;
            bb(m) = [];
            V_mn(Mn(m),n) = in(n) + sum(U_mn(bb,n));
        end
        V_n(n) = in(n) + sum(U_mn(Mn,n));%似然概率更新
    end
    
end
%% 硬判决
decBits = zeros(1,N);
decBits(V_n <= 0) = 1;          %信息位+校验位的译码输出
Dec_out = decBits;
% Dec_out = decBits(1:N-M);       %仅含信息位的译码输出

