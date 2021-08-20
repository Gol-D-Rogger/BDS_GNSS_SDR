function code = b3iCodeGen(PRNs)
numPRNs = numel(PRNs);
reg1_ini = true(13,1);
reg2_ini = [5631;7723;6026;8187;6431;4708;8146;7677;5122;1051;...
    7536;1438;3221;3622;4489;7292;1221; 236;4439; 734;...
    1069;1418; 719;1634;1864;2345;5843;5602; 757;4095;...
    3471;5513;4779;6565;6749;8052;1383;7440;7056;6862;...
    4148;3033;3516;6769;1826;2757;5094;8008; 329;4268;...
    7756;2447;  24;4100;1702;5702;3704;1482;6646;4677;...
    3616;1602;1102];
reg2_ini = bsxfun(@bitget,reg2_ini,13:-1:1);%�õ���������λ��
code = false(10230,numPRNs);
% ���ɶ���ʽϵ��

reg1_FeedbackPos = [1,3,4,13];
reg2_FeedbackPos = [1,5,6,7,9,10,12,13];
reset_index = 8190;
for i = 1:numPRNs
    reg1 = reg1_ini;
    reg2 = reg2_ini(PRNs(i),:);
    for j = 1:10230
        code(j,i) = arrayXor([reg1(end) reg2(end)]);
        reg1(end) = arrayXor(reg1(reg1_FeedbackPos));
        reg2(end) = arrayXor(reg2(reg2_FeedbackPos));
        reg1 = circshift(reg1,1);
        reg2 = circshift(reg2,1);
        if j == reset_index
            reg1 = reg1_ini;
        end
    end
end
% % �߼���ƽ[0,1] ==> �źŵ�ƽ [1,-1]
% code = -2*code + 1;
end
%% ���   
function res = arrayXor(X)
res = false;
for ii = 1:numel(X)
    res = xor(res,X(ii));
end
end