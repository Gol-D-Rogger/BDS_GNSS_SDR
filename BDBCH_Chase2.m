function codeout = BDBCH_Chase2(x)
N = 15;
k = 11;
qnumber = 2;
% Chase2 decoding
for i_qnumber=1:length(qnumber)
    qnum = qnumber(i_qnumber);
    y1 = abs(x);%判断不可靠位
    y2 = (1-sign(x))./2;%硬判决
    leastReliablePos = zeros(1,qnum); %不可靠位的位置
    for i = 1 : qnum
        leastReliablePos(i) = find(y1 == min(y1));
        y1(leastReliablePos(i)) = 10;
    end
    
    tq=zeros(2^qnum,N);%构造测试序列
    for i = 1 : 2^qnum
        tq(i,:) = y2;
        for u = 1 : qnum
            tiu = mod(floor((i-1)/(2^(u-1))),2);
            tq(i,leastReliablePos(u)) = bitxor(tq(i,leastReliablePos(u)),tiu);
        end
    end
    
    testSeq = zeros(2^qnum,k);%bch码测试序列
    d_eu = zeros(2^qnum,1);%计算欧式距离
    
    for i=1:2^qnum
        err=0;
        [y,err_bit] = bchdec(gf(tq(i,:)),N,k);
        testSeq(i,:) = double(y.x);
        if err_bit>1 || err_bit==-1%译码失败
            testSeq(i,:)=y2;%硬译码
            err=1;
        end
        %判断译码是否合法
        if err==1
            testSeq(i,:)=zeros(1,k);
        end
        d_eu(i,1) = sum(sqrt((testSeq(i,:) - y2(1:k)').^2));
    end
    
    if sum(sum(testSeq))~=0 %若译码合法
        lc = find(d_eu==min(d_eu));
        codeout = testSeq(lc(1),:);%译码结果为欧式距离最小的序列
    else
        codeout = BCH15_4Decode(y2);
    end
end
end
